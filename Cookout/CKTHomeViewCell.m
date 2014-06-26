//
//  CKTHomeViewCell.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/16/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTAsyncImageView.h"
#import "CKTChef.h"
#import "CKTDataModel.h"
#import "CKTHomeViewCell.h"

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
    
    CKTChef *chef = [CKTDataModel.sharedDataModel chefWithId:dinner.chefId];
    
    self.foodImage.imageURL = [dinner imageUrl];
    self.profileImage.imageURL = [chef imageUrl];
    self.foodLabel.text = [dinner name];
    self.subtitleLabel.text = [chef name];
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
