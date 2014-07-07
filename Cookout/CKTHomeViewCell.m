//
//  CKTHomeViewCell.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/16/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTAsyncImageView.h"
#import "CKTDataModel.h"
#import "CKTHomeViewCell.h"
#import "CKTUser.h"

@interface CKTHomeViewCell ()
@property (strong, nonatomic) IBOutlet CKTAsyncImageView *foodImage;
@property (strong, nonatomic) IBOutlet CKTAsyncImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *foodLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
@end

@implementation CKTHomeViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)populate:(CKTDinner *)dinner
{
    [self unload];

    CKTUser *chef = [CKTDataModel.sharedDataModel userWithId:dinner.chefId];
    self.foodImage.imageURL = dinner.imageNSUrl;
    self.profileImage.imageURL = chef.imageNSUrl;
    self.foodLabel.text = dinner.name;
    self.subtitleLabel.text = chef.name;
}

- (void)unload
{
    [CKTAsyncImageLoader.sharedLoader cancelLoadingImagesForTarget:self.foodImage];
    [CKTAsyncImageLoader.sharedLoader cancelLoadingImagesForTarget:self.profileImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
