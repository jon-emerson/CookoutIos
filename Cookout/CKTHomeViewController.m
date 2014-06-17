//
//  CKTHomeViewController.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/16/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTDish.h"
#import "CKTHomeViewController.h"
#import "CKTHomeViewCell.h"

@interface CKTHomeViewController ()
@property (nonatomic, retain) NSMutableArray *dishesArray;
@end

@implementation CKTHomeViewController

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorColor = [UIColor clearColor];

    self.dishesArray = [[NSMutableArray alloc] init];

    NSArray *dish1Ingredients = @[@"Chicken", @"Long beans", @"Coconut milk", @"Red pepper flakes",
                                 @"Garlic", @"Yellow squash", @"Onion", @"Chicken stock", @"Fish sauce",
                                 @"Lemongrass"];
    NSString *dish1Description = @"Curried chicken simmered in coconut milk and tomatoes makes for a \
                                 mouthwatering hint of the tropics! Goes great with rice and vegetables.";
    self.dishesArray[0] = [[CKTDish alloc] initWithName:@"Szechuan chicken" subtitle:@"Chef Chu"
                                    imageFilename:@"chinese1.jpg" profileImageFilename:@"profile1.jpg"
                                            ingredients:dish1Ingredients description:dish1Description];
    
    NSArray *dish2Ingredients = @[@"Red pepper", @"Zucchini", @"Squash", @"Cherry tomatoes",
                                  @"Onion", @"Green pepper", @"Button mushroom", @"Salt", @"Black pepper"];
    NSString *dish2Description = @"Fresh summer vegetables like zucchini, summer squash, and cherry \
                                  tomatoes don't need a lot of seasoning to highlight their flavors. \
                                  Just a few minutes on the grill!";
    self.dishesArray[1] = [[CKTDish alloc] initWithName:@"Skewered veggies, animal style" subtitle:@"Chef Crazy Horse"
                                    imageFilename:@"grill1.jpg" profileImageFilename:@"profile2.jpg"
                                    ingredients:dish2Ingredients description:dish2Description];
    
    NSString *dish3Description = @"A rancid, shriveled hot dog in a moldy bun. Quite a stomach-turning experience.";
    NSArray *dish3Ingredients = @[@"Reconstituted pork products", @"Reclaimed meat", @"White bread",
                                  @"Mustard", @"Some mold"];
    self.dishesArray[2] = [[CKTDish alloc] initWithName:@"Hot dog" subtitle:@"Chef Chandra"
                                          imageFilename:@"hd4.png" profileImageFilename:@"cra.png"
                                          ingredients:dish3Ingredients description:dish3Description];
    
    self.dishesArray[3] = [[CKTDish alloc] initWithName:@"Banana leaf plate" subtitle:@"Chef Raj"
                                    imageFilename:@"indian1.jpg" profileImageFilename:@"profile3.jpg"];

    NSArray *dish5Ingredients = @[@"Hot dog", @"Relish", @"Ketchup", @"Mustard", @"Chopped onion", @"Bun"];
    NSString *dish5Description = @"An american classic!!  Cooked by the best!!";
    self.dishesArray[4] = [[CKTDish alloc] initWithName:@"Hot dog" subtitle:@"Chef Chandra"
                                          imageFilename:@"hd5.png" profileImageFilename:@"cra.png"
                                          ingredients:dish5Ingredients description:dish5Description];
    
    NSArray *dish6Ingredients = @[@"Chicken", @"Tomato", @"Garlic", @"Cardamom", @"Coriander", @"Black pepper",
                                  @"Onion", @"Ginger", @"Cumin", @"Yogurt", @"Tomato paste", @"Cayenne pepper",
                                  @"Ghee", @"Cilantro"];
    NSString *dish6Description = @"Chicken pieces coated with many fragrant spices like turmeric, cardamom \
                                  and cloves, then simmered in a tomato sauce. This dish is a family \
                                  favorite. I have also taken it to potlucks and served it to guests in my home.";
    self.dishesArray[5] = [[CKTDish alloc] initWithName:@"Tomato chicken" subtitle:@"Chef Meera"
                                    imageFilename:@"indian2.jpg" profileImageFilename:@"profile4.jpg"
                                    ingredients:dish6Ingredients description:dish6Description];
    
    self.dishesArray[6] = [[CKTDish alloc] initWithName:@"Hot dog" subtitle:@"Chef Chandra"
                                          imageFilename:@"hd1.png" profileImageFilename:@"cra.png"];
    self.dishesArray[7] = [[CKTDish alloc] initWithName:@"Poached guinea pig" subtitle:@"Chef Vamanos"
                                    imageFilename:@"peruvian1.jpg" profileImageFilename:@"profile5.jpg"];

    NSArray *dish9Ingredients = @[@"Hot dog", @"Tomato", @"Lettuce", @"Mustard", @"Chopped onion", @"Bun"];
    NSString *dish9Description = @"What do you get when you mix an American classic with sandwich basics? \
                                  A new twist on modern cuisine.  Chef Chandra has done it again!";
    self.dishesArray[8] = [[CKTDish alloc] initWithName:@"Hot dog" subtitle:@"Chef Chandra"
                                          imageFilename:@"hd3.png" profileImageFilename:@"cra.png"
                                          ingredients:dish9Ingredients description:dish9Description];
    
    self.dishesArray[9] = [[CKTDish alloc] initWithName:@"Teriyaki chicken" subtitle:@"Chef Li"
                                    imageFilename:@"thai.jpg" profileImageFilename:@"profile1.jpg"];
    
    NSArray *dish11Ingredients = @[@"Hot dog", @"Bun", @"Bacon"];
    NSString *dish11Description = @"Did you wake up this morning saying, Oh good, another day I can be \
        completely fucking average.  NO!!  You woke up and wanted to be awesome.  And this is your hot dog. \
        It has no fucking compromises.  It's hot dog, bun, and fucking bacon.  You are the man \
        because you act like a man, by eating only the fucking manliest hot dogs man could \
        ever fucking invent.  Eat up and conquer.";
    self.dishesArray[10] = [[CKTDish alloc] initWithName:@"Hot dog" subtitle:@"Chef Chandra"
                                          imageFilename:@"hd2.png" profileImageFilename:@"cra.png"
                                          ingredients:dish11Ingredients description:dish11Description];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dishesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"homeViewCell";
    CKTHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"CKTHomeViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    [cell populate:self.dishesArray[indexPath.row]];
    
    //cell.textLabel.text = [self.booksArray objectAtIndex:indexPath.row];
    return cell;
}

@end
