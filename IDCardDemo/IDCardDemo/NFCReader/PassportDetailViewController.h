//
//  PassportDetailViewController.h
//  IDCardDemo
//
//  Created by 张森森 on 2024/8/14.
//  Copyright © 2024 wintone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassportDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PassportDetailViewController : UIViewController
@property (nonatomic,strong)NSMutableDictionary *OCRDict;
@property (copy, nonatomic) NSString *cropImagepath;
@property (copy, nonatomic) NSString *headImagepath;
@property (nonatomic,assign)int cardType;
- (void)replaceTextFieldModelWithmodel:(PassportDetailModel*)model;
@end

NS_ASSUME_NONNULL_END
