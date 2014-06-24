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

- (void)populate:(CKTDinner *)dinner
{
    self.foodImage.image = [UIImage imageNamed:[dinner imageFilename]];
    self.profileImage.image = [UIImage imageNamed:[dinner profileImageFilename]];
    self.foodLabel.text = [dinner name];
    self.subtitleLabel.text = [dinner subtitle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
