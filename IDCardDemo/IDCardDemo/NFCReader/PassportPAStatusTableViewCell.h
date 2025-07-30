//
//  PassportPAStatusTableViewCell.h
//  IDCardDemo
//
//  Created by 张森森 on 2025/5/15.
//  Copyright © 2025 wintone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PassportPAStatusTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)NSMutableArray *dataViewAry;
@property (nonatomic,strong)NSMutableArray *marginViewAry;
@property (nonatomic,strong)NSMutableDictionary *PADict;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier PADict:(NSMutableDictionary*)PAdict;
@end

NS_ASSUME_NONNULL_END
