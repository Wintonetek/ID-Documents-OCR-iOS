//
//  PassportGroupIdsTableViewCell.h
//  IDCardDemo
//
//  Created by 张森森 on 2024/8/23.
//  Copyright © 2024 wintone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PassportGroupIdsTableViewCell : UITableViewCell
//@property (nonatomic,strong)NSArray *groupIdAry;
@property (nonatomic,strong)NSMutableArray *imageViewsAry;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier groupIds:(NSArray*)groupIds;
@end

NS_ASSUME_NONNULL_END
