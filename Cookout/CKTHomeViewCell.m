//
//  CKTHomeViewCell.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/16/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTHomeViewCell.h"

@interface CKTHomeViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *foodImage;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *foodLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
@end

@implementation CKTHomeViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)populate:(CKTDish *)dish
{
    self.foodImage.image = [UIImage imageNamed:[dish imageFilename]];
    self.profileImage.image = [UIImage imageNamed:[dish profileImageFilename]];
    self.foodLabel.text = [dish name];
    self.subtitleLabel.text = [dish subtitle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
