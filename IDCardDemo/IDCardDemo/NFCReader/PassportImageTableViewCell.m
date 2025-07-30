//
//  PassportImageTableViewCell.m
//  IDCardDemo
//
//  Created by 张森森 on 2024/8/16.
//  Copyright © 2024 wintone. All rights reserved.
//

#import "PassportImageTableViewCell.h"

@implementation PassportImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.passportImage = [[UIImageView alloc]init];
//        self.passportImage.frame = CGRectMake(0, 0, kScreenWidth, 250);
//        [self.contentView addSubview:self.passportImage];
        
        UILabel *MRZTitle = [[UILabel alloc]init];
        MRZTitle.text = @"MRZ:";
        MRZTitle.textColor = [UIColor blackColor];
        MRZTitle.font = [UIFont fontWithName:@"Courier" size:15];
        MRZTitle.frame = CGRectMake(15, 10, 45, 20);
        [self.contentView addSubview:MRZTitle];
        
        self.MRZLabel = [[UILabel alloc]init];
        self.MRZLabel.font = [UIFont fontWithName:@"Courier" size:13];
//        self.MRZLabel.backgroundColor = [UIColor redColor];
        self.MRZLabel.numberOfLines = 0;
        self.MRZLabel.textColor = [UIColor blackColor];
        self.MRZLabel.frame = CGRectMake(15, 25, kScreenWidth-30, 60);
        [self.contentView addSubview:self.MRZLabel];
        
    }
    return self;
}

@end
