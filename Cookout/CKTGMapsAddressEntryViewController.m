//
//  CKTGMapsAddressEntryViewController.m
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/7/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTGMapsAddressEntryViewController.h"
#import "CKTServerCommunicator.h"
#import "CKTDataModel.h"

@interface CKTGMapsAddressEntryViewController ()
@property (weak, nonatomic) IBOutlet UITextField * addressField;
@property (weak, nonatomic) IBOutlet UITableView * autoCompleteOptions;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

-(IBAction) cancelAddressEntry:(id) sender;

@property (nonatomic) NSMutableArray * addresses;

@end

@implementation CKTGMapsAddressEntryViewController

- (id) initWithNibName:nibNameOrNil bundle:nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Enter delivery address";
        self.addressContainer = [[CKTAddress alloc]init];
//        [self.addressField setLeftViewMode:UITextFieldViewModeAlways];
    }
    return self;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"Text view did change %@", self.addressField.text);
    
    // User started typing - remove the suggestions section
    self.showRecent = false;
    [self.autoCompleteOptions reloadData];
    
    if(self.addressField.text.length == 0)
        self.autoCompleteOptions.hidden = true;
    // Fire off a request to Gmaps with this substring
    [CKTServerCommunicator gmapsAutoComplete:self.addressField.text delegate:self];
    return true;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Check if there are valid addresses in local data model
    return 1;
}

- (NSInteger)tableView: (UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.showRecent)
    {
        return [[CKTCurrentUser sharedInstance].addresses count];
    }   
    return self.addresses.count;
}

-(void) autoCompleteSuggestions: (NSDictionary *) response
{
    // Google Maps autocomplete suggestions came back
    NSArray * predictions = [response valueForKey:@"predictions"];
    NSMutableDictionary * prediction;
    
    // Make the table visible
    self.autoCompleteOptions.hidden = false;
    
    [self.addresses removeAllObjects];
    
    for(prediction in predictions)
    {
        [self.addresses addObject:prediction];
    }
    [self.autoCompleteOptions reloadData];
}


- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:@"UITableViewCell"];
    
    cell.alpha = self.view.alpha;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:14]];

    
    if(self.showRecent)
    {

        cell.textLabel.text = [[CKTCurrentUser sharedInstance].addresses[indexPath.row] description];
        return cell;
    }
    else
    {
        cell.textLabel.text = [self.addresses[indexPath.row] valueForKey:@"description"];
        return cell;
    }
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if(!self.showRecent)
    {
         NSString * placeReference = [self.addresses[indexPath.row] valueForKey:@"reference"];
        // The user has selected a new address
        dispatch_async(dispatch_get_main_queue(), ^{
            // Dispatch a call to get place details
            [CKTServerCommunicator getPlaceDetails:placeReference delegate:self];
        });
    }
    else {
        self.selectedIndex = indexPath.row;
        [self dismissViewControllerAnimated:TRUE completion:^(void){
            // Communicate which address was selected to the previous view
            [(id<CKTAddressUpdateHandler>)self.delegate addressUpdated:self.selectedIndex];
        }];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.showRecent)
        return 32.0f;
    return 0.1f;
}

- (NSString*) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.showRecent) {
        return @"Recent";
    }
    else {
        // return some string here ...
        return @"";
    }
}

- (void)placeDetailsReceived:(NSDictionary *)response
{
    // Once an address is selected, save the address to local data model
    // and sync it to the cloud.
    CKTDataModel *sharedModel = [CKTDataModel sharedDataModel];
    NSArray * results = [[response valueForKey:@"result"] valueForKey:@"address_components"];
    NSDictionary * result;
    NSString * type;
    BOOL streetNumberFound = NO;
    
    // Check if the address component is a street number. If not, this is not a valid address
    for(type in [results[0] valueForKey:@"types"])
    {
        if([type isEqualToString:@"street_number"])
        {
            streetNumberFound = YES;
        }
    }
    
    if(!streetNumberFound)
    {
        NSLog(@"Invalid address, no street number");
        UIAlertView * newAlert = [[UIAlertView alloc]init];
        newAlert.message = @"Please include the house number we should deliver to :)";
        [newAlert addButtonWithTitle:@"Ok"];
        [newAlert show];
        return;
    }
    
    for(result in results)
    {
        // Get the address component type
        [result valueForKey:@"types"];
        
        for(type in [result valueForKey:@"types"])
        {
            if([type isEqualToString:@"street_number"])
            {
                self.addressContainer.addressLine1 = [result valueForKey:@"short_name"];
            }
            
            if([type isEqualToString:@"route"])
            {
                self.addressContainer.addressLine1 = [self.addressContainer.addressLine1 stringByAppendingString:@" "];
                self.addressContainer.addressLine1 = [self.addressContainer.addressLine1 stringByAppendingString:[result valueForKey:@"short_name"]];
                self.addressContainer.addressLine2 = @"";
            }
            
            if([type isEqualToString:@"locality"])
            {
               self.addressContainer.city = [result valueForKey:@"short_name"];
            }
            
            if([type isEqualToString:@"administrative_area_level_1"])
            {
                self.addressContainer.state = [result valueForKey:@"short_name"];
            }
            
            if([type isEqualToString:@"country"])
            {
                self.addressContainer.country = [result valueForKey:@"short_name"];
            }
            
            if([type isEqualToString:@"postal_code"])
            {
                self.addressContainer.zipCode = [result valueForKey:@"short_name"];
            }
        }
    }

    NSLog(@"%@", self.addressContainer);
    
    NSLog(@"Dispatching save address call");

    // Save address to the server.
    [CKTServerCommunicator setUserAddress:self.addressContainer
                          currentUser:sharedModel.currentUser
                             delegate:self];
}

- (void)addressSaved:(NSDictionary *)responseObject
{
    // The user's address was saved succesfully.
    // This means the user has a cookout session and a delivery address
    // Pop this view of the stack and go back to the checkout screen
    
    self.addressContainer.addressId = [[responseObject valueForKey:@"address"] valueForKey:@"id"];
    [[CKTCurrentUser sharedInstance] addAddress:self.addressContainer];
    
    [self dismissViewControllerAnimated:TRUE completion:^(void){
        // Communicate which address was selected to the previous view
        if(!self.showRecent) self.selectedIndex = [[CKTCurrentUser sharedInstance].addresses count]-1;
        [(id<CKTAddressUpdateHandler>)self.delegate addressUpdated:self.selectedIndex];
    }];
}
- (void)addressSaveFailed:(NSError *)error operation:(AFHTTPRequestOperation *)operation
{
    // The address save did not succeed due to server error. Display an error message and
    // keep the user on the address entry view.
    NSLog(@"%@", operation.responseObject);
    UIAlertView * newAlert = [[UIAlertView alloc]init];
    newAlert.message = @"There was a problem saving your address. Please try again.";
    [newAlert addButtonWithTitle:@"Ok"];
    [newAlert show];
}

-(IBAction) cancelAddressEntry:(id) sender
{
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self dismissViewControllerAnimated:TRUE completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _addresses = [[NSMutableArray alloc]init];
    

    //self.autoCompleteOptions.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);

    [self.view addSubview:_addressField];
    [self.view addSubview:_autoCompleteOptions];
    
    if([[CKTCurrentUser sharedInstance].addresses count]>0)
    {
        self.autoCompleteOptions.hidden = false;
        _showRecent = true;
    }
    else
    {
        self.autoCompleteOptions.hidden = true;
        _showRecent = false;
    }
    self.autoCompleteOptions.delegate = self;
    self.autoCompleteOptions.dataSource = self;
    self.autoCompleteOptions.scrollEnabled = true;
    
    self.addressField.delegate = self;
    self.navigationItem.backBarButtonItem.title=@"";
    self.autoCompleteOptions.alpha = self.view.alpha;
    self.autoCompleteOptions.backgroundColor = [UIColor clearColor];
    
    
    // Populate the first section of the address bar

    
    /*UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@" "
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
