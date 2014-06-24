//
//  CKTHomeViewController.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/16/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTDinner.h"
#import "CKTDinnerViewController.h"
#import "CKTHomeViewController.h"
#import "CKTHomeViewCell.h"

@interface CKTHomeViewController ()
@property (nonatomic, retain) NSMutableArray *dinnersArray;
@end

@implementation CKTHomeViewController

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorColor = [UIColor clearColor];

    self.dinnersArray = [[NSMutableArray alloc] init];

    NSArray *dinner1Ingredients = @[@"Chicken", @"Long beans", @"Coconut milk", @"Red pepper flakes",
                                 @"Garlic", @"Yellow squash", @"Onion", @"Chicken stock", @"Fish sauce",
                                 @"Lemongrass"];
    NSString *dinner1Description = @"Curried chicken simmered in coconut milk and tomatoes makes for a \
                                 mouthwatering hint of the tropics! Goes great with rice and vegetables.";
    self.dinnersArray[0] = [[CKTDinner alloc] initWithName:@"Szechuan chicken" subtitle:@"Chef Chu"
                                    imageFilename:@"chinese1.jpg" profileImageFilename:@"profile1.jpg"
                                            ingredients:dinner1Ingredients description:dinner1Description];
    
    NSArray *dinner2Ingredients = @[@"Red pepper", @"Zucchini", @"Squash", @"Cherry tomatoes",
                                  @"Onion", @"Green pepper", @"Button mushroom", @"Salt", @"Black pepper"];
    NSString *dinner2Description = @"Fresh summer vegetables like zucchini, summer squash, and cherry \
                                  tomatoes don't need a lot of seasoning to highlight their flavors. \
                                  Just a few minutes on the grill!";
    self.dinnersArray[1] = [[CKTDinner alloc] initWithName:@"Skewered veggies, animal style" subtitle:@"Chef Crazy Horse"
                                    imageFilename:@"grill1.jpg" profileImageFilename:@"profile2.jpg"
                                    ingredients:dinner2Ingredients description:dinner2Description];
    
    NSString *dinner3Description = @"A rancid, shriveled hot dog in a moldy bun. Quite a stomach-turning experience.";
    NSArray *dinner3Ingredients = @[@"Reconstituted pork products", @"Reclaimed meat", @"White bread",
                                  @"Mustard", @"Some mold"];
    self.dinnersArray[2] = [[CKTDinner alloc] initWithName:@"Hot dog" subtitle:@"Chef Chandra"
                                          imageFilename:@"hd4.png" profileImageFilename:@"cra.png"
                                          ingredients:dinner3Ingredients description:dinner3Description];
    
    self.dinnersArray[3] = [[CKTDinner alloc] initWithName:@"Banana leaf plate" subtitle:@"Chef Raj"
                                    imageFilename:@"indian1.jpg" profileImageFilename:@"profile3.jpg"];

    NSArray *dinner5Ingredients = @[@"Hot dog", @"Relish", @"Ketchup", @"Mustard", @"Chopped onion", @"Bun"];
    NSString *dinner5Description = @"An american classic!!  Cooked by the best!!";
    self.dinnersArray[4] = [[CKTDinner alloc] initWithName:@"Hot dog" subtitle:@"Chef Chandra"
                                          imageFilename:@"hd5.png" profileImageFilename:@"cra.png"
                                          ingredients:dinner5Ingredients description:dinner5Description];
    
    NSArray *dinner6Ingredients = @[@"Chicken", @"Tomato", @"Garlic", @"Cardamom", @"Coriander", @"Black pepper",
                                  @"Onion", @"Ginger", @"Cumin", @"Yogurt", @"Tomato paste", @"Cayenne pepper",
                                  @"Ghee", @"Cilantro"];
    NSString *dinner6Description = @"Chicken pieces coated with many fragrant spices like turmeric, cardamom \
                                  and cloves, then simmered in a tomato sauce. This dinner is a family \
                                  favorite. I have also taken it to potlucks and served it to guests in my home.";
    self.dinnersArray[5] = [[CKTDinner alloc] initWithName:@"Tomato chicken" subtitle:@"Chef Meera"
                                    imageFilename:@"indian2.jpg" profileImageFilename:@"profile4.jpg"
                                    ingredients:dinner6Ingredients description:dinner6Description];
    
    self.dinnersArray[6] = [[CKTDinner alloc] initWithName:@"Hot dog" subtitle:@"Chef Chandra"
                                          imageFilename:@"hd1.png" profileImageFilename:@"cra.png"];
    self.dinnersArray[7] = [[CKTDinner alloc] initWithName:@"Poached guinea pig" subtitle:@"Chef Vamanos"
                                    imageFilename:@"peruvian1.jpg" profileImageFilename:@"profile5.jpg"];

    NSArray *dinner9Ingredients = @[@"Hot dog", @"Tomato", @"Lettuce", @"Mustard", @"Chopped onion", @"Bun"];
    NSString *dinner9Description = @"What do you get when you mix an American classic with sandwich basics? \
                                  A new twist on modern cuisine.  Chef Chandra has done it again!";
    self.dinnersArray[8] = [[CKTDinner alloc] initWithName:@"Hot dog" subtitle:@"Chef Chandra"
                                          imageFilename:@"hd3.png" profileImageFilename:@"cra.png"
                                          ingredients:dinner9Ingredients description:dinner9Description];
    
    self.dinnersArray[9] = [[CKTDinner alloc] initWithName:@"Teriyaki chicken" subtitle:@"Chef Li"
                                    imageFilename:@"thai.jpg" profileImageFilename:@"profile1.jpg"];
    
    NSArray *dinner11Ingredients = @[@"Hot dog", @"Bun", @"Bacon"];
    NSString *dinner11Description = @"Did you wake up this morning saying, Oh good, another day I can be \
        completely fucking average.  NO!!  You woke up and wanted to be awesome.  And this is your hot dog. \
        It has no fucking compromises.  It's hot dog, bun, and fucking bacon.  You are the man \
        because you act like a man, by eating only the fucking manliest hot dogs man could \
        ever fucking invent.  Eat up and conquer.";
    self.dinnersArray[10] = [[CKTDinner alloc] initWithName:@"Hot dog" subtitle:@"Chef Chandra"
                                          imageFilename:@"hd2.png" profileImageFilename:@"cra.png"
                                          ingredients:dinner11Ingredients description:dinner11Description];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dinnersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"homeViewCell";
    CKTHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"CKTHomeViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    [cell populate:self.dinnersArray[indexPath.row]];
    
    //cell.textLabel.text = [self.booksArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKTDinnerViewController *dinnerViewController =
    [[CKTDinnerViewController alloc] init];
    
    CKTDinner *selectedDinner = self.dinnersArray[indexPath.row];
    dinnerViewController.dinner = selectedDinner;
    
    [self.navigationController pushViewController:dinnerViewController animated:YES];
}

@end
