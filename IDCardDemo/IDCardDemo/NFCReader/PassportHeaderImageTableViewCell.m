//
//  PassportHeaderImageTableViewCell.m
//  IDCardDemo
//
//  Created by 张森森 on 2024/8/16.
//  Copyright © 2024 wintone. All rights reserved.
//

#import "PassportHeaderImageTableViewCell.h"

@implementation PassportHeaderImageTableViewCell

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
        
        CGFloat imageW = 90;
        CGFloat maginW = (kScreenWidth - imageW*2)/4;
        self.OCRHeaderImage = [[UIImageView alloc]init];
        self.OCRHeaderImage.frame = CGRectMake(maginW, 10, imageW, 130);
        [self.contentView addSubview:self.OCRHeaderImage];
        
        self.NFCHeaderImage = [[UIImageView alloc]init];
//        self.NFCHeaderImage.backgroundColor = [UIColor redColor];
        self.NFCHeaderImage.frame = CGRectMake(imageW+maginW*3, 10, imageW, 130);
        [self.contentView addSubview:self.NFCHeaderImage];
        
        
        
    }
    return self;
}
@end
