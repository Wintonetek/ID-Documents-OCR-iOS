//
//  PassportHeaderImageTableViewCell.h
//  IDCardDemo
//
//  Created by 张森森 on 2024/8/16.
//  Copyright © 2024 wintone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PassportHeaderImageTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *OCRHeaderImage;
@property(nonatomic,strong)UIImageView *NFCHeaderImage;
@end

NS_ASSUME_NONNULL_END
