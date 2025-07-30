//
//  PassportDetailModel.h
//  IDCardDemo
//
//  Created by 张森森 on 2024/8/16.
//  Copyright © 2024 wintone. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PassportDetailModel : NSObject
@property (nonatomic,copy)NSString *field;
@property (nonatomic,copy)NSString *value;
//1:mrz 2:viz 3:nfc
@property (nonatomic,assign)NSInteger type;
- (id)initWithField:(NSString*)field Dict:(NSMutableDictionary*)dict mrzAry:(NSMutableArray*)mrzAry vizAry:(NSMutableArray*)vizAry isNFCReadeer:(BOOL)isNFCReader;
@end

NS_ASSUME_NONNULL_END
