//
//  PassportGroupIdsTableViewCell.m
//  IDCardDemo
//
//  Created by 张森森 on 2024/8/23.
//  Copyright © 2024 wintone. All rights reserved.
//

#import "PassportGroupIdsTableViewCell.h"

@implementation PassportGroupIdsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier groupIds:(NSArray*)groupIds{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imageViewsAry = [NSMutableArray array];
        NSArray *groupIdAry = @[@"COM",@"SOD",@"DG1", @"DG2", @"DG3", @"DG4", @"DG5", @"DG6", @"DG7", @"DG8", @"DG9", @"DG10", @"DG11", @"DG12", @"DG13", @"DG14", @"DG15", @"DG16"];
        CGFloat itemW = kScreenWidth/9;
        CGFloat itemH = 60;
        for (int i =0; i<groupIdAry.count; i++) {
            UIView *groupView = [[UIView alloc]init];
            groupView.backgroundColor = [UIColor whiteColor];
            groupView.frame = CGRectMake(itemW*(i%9), 10+itemH*(i/9), itemW, itemH);
            [self.contentView addSubview:groupView];
            
            UIImageView *groupImage = [[UIImageView alloc]init];
            groupImage.frame = CGRectMake(itemW/2-20, 5, 40, 40);
            [groupView addSubview:groupImage];
            
            UILabel *groupLabel = [[UILabel alloc]init];
            groupLabel.text = groupIdAry[i];
            groupLabel.font = [UIFont systemFontOfSize:12];
            groupLabel.frame = CGRectMake(0, 35, itemW, 15);
            groupLabel.textAlignment = NSTextAlignmentCenter;
            [groupView addSubview:groupLabel];
            if (groupIds.count ==0) {
                groupImage.image = [UIImage imageNamed:@"noReader"];

            }else{
                if ([groupIds containsObject:groupIdAry[i]]) {
                    groupImage.image = [UIImage imageNamed:@"reader"];
                }else{
                    groupImage.image = [UIImage imageNamed:@"noReader"];
                }
            }
            [self.imageViewsAry addObject:groupImage];
            
        }
    }
    
    return self;
}

@end
