//
//  PassportDetailTableViewCell.h
//  IDCardDemo
//
//  Created by 张森森 on 2024/8/16.
//  Copyright © 2024 wintone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassportDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PassportDetailTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *fieldLabel;
@property (nonatomic,strong)UITextField *valueText;
@property (nonatomic,strong)UIImageView *typeImage;
@property (nonatomic,strong)PassportDetailModel *model;
@property (nonatomic,copy)NSString *NationalityCode;
@property (nonatomic,copy)NSString *issuingCountryCode;
@end

NS_ASSUME_NONNULL_END
