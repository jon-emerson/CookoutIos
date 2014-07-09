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
    }
    return self;
}

- (NSInteger)tableView: (UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addresses count];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"Text view did change %@", self.addressField.text);
    if(self.addressField.text.length == 0)
        self.autoCompleteOptions.hidden = true;
    // Fire off a request to Gmaps with this substring
    [CKTServerCommunicator gmapsAutoComplete:self.addressField.text delegate:self];
    return true;
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
    
    cell.textLabel.text = [self.addresses[indexPath.row] valueForKey:@"description"];
    return cell;
}

- (void) tableView: (UITableView *) tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSString * placeId = [self.addresses[indexPath.row] valueForKey:@"place_id"];
    // Dispatch a call to get place details
    [CKTServerCommunicator getPlaceDetails:placeId delegate:self];
}

- (void)placeDetailsReceived:(NSDictionary *)response
{
    // Once an address is selected, save the address to local data model
    // and sync it to the cloud.
    CKTDataModel *sharedModel = [CKTDataModel sharedDataModel];
    CKTAddress *address = [[CKTAddress alloc] init];
    
    NSArray * results = [[response valueForKey:@"result"] valueForKey:@"address_components"];
    NSObject * result;
    
    for(result in results)
    {
       
    }

    address.addressLine1 = [response valueForKeyPath:@"street_number"];
    address.addressLine2 = [response valueForKeyPath:@"route"];
    address.city = [response valueForKeyPath:@"locality"];
    address.state = [response valueForKeyPath:@"administrative_area_level_1"];
    address.country = [response valueForKeyPath:@"country"];
    address.zipCode = [response valueForKeyPath:@"postal_code"];

    NSLog(@"%@", address);

    // Figure out UX for inputing unit number

    [sharedModel addAddress:address];
    NSLog(@"Dispatching save address call");

    // Save address to the server.
    [CKTServerCommunicator setUserAddress:address
                          currentUser:sharedModel.currentUser
                             delegate:self];
}

- (void)addressSaved:(NSDictionary *)responseObject
{
    // The user's address was saved succesfully.
    // This means the user has a cookout session and a delivery address
    // Pop this view of the stack and go back to the checkout screen
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];

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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _addresses = [[NSMutableArray alloc]init];
    
    [self.view addSubview:_addressField];
    [self.view addSubview:_autoCompleteOptions];
    
    self.autoCompleteOptions.delegate = self;
    self.autoCompleteOptions.dataSource = self;
    self.autoCompleteOptions.scrollEnabled = true;
    self.autoCompleteOptions.hidden = true;
    self.addressField.delegate = self;
    self.navigationItem.backBarButtonItem.title=@"";
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@" "
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
