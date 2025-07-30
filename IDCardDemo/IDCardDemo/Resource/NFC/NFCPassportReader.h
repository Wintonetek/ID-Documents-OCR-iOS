//
//  NFCPassportReader.h
//  NFCPassportReader
//
//  Created by 张森森 on 2024/8/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKey.h>

typedef void(^passportDetailBlock)(NSMutableDictionary *passportDict,NSArray *groupIds,NSDictionary*matchDict,NSDictionary*sodDict);

@interface NFCPassportReader : NSObject
/*
  护照信息，NFC识别护照接口获取护照信息成功之后才会有值。
 */
//护照头像
@property (nonatomic,strong)UIImage *passportImage;
//签发国代码
@property (nonatomic,copy)NSString *issuingCountry;
//签英文姓名
@property (nonatomic,copy)NSString *englishName;
//护照号码
@property (nonatomic,copy)NSString *passportNumber;
//出生日期
@property (nonatomic,copy)NSString *dateOfBirth;
//有效期至
@property (nonatomic,copy)NSString *dateOfExpiry;
//持证人国籍代码
@property (nonatomic,copy)NSString *nationalityCodes;
//本国姓名
@property (nonatomic,copy)NSString *nationalName;
//性别
@property (nonatomic,copy)NSString *sex;
//出生地点
@property (nonatomic,copy)NSString *placeOfBirth;
//签发地点
@property (nonatomic,copy)NSString *placeOfIssue;
//签发日期
@property (nonatomic,copy)NSString *dateOfIssue;
//签发机关 
@property (nonatomic,copy)NSString *issuingOrganization;
//MRZ
@property (nonatomic,copy)NSString *passportMRZ;
// 证件类型
@property (nonatomic,assign)int cardType;
//换证次数
@property (nonatomic,copy)NSString *numberOfTimes;
//签发次数
@property (nonatomic,copy)NSString *numberOfIssuances;
//各个dg的哈希值与sod里的哈希值是否匹配
@property (nonatomic,strong)NSDictionary *matchDict;
//sod的base64值
@property (nonatomic,strong)NSDictionary *sodDict;
/**
  初始化授权
  devcode : 授权文件开发码
 */
-(int)InitIDCardWithDevcode:(NSString *)devcode;
/**
 NFC扫描护照接口,需配合扫描识别获取三要素
 passportNumber:护照号码
 dateOfBirth :出生日期
 dateOfExpiry :有效期至
 passportDetailBlock: 返回信息,包含passportDict:护照信息（国际化文件内NFC的内容即为该字典的Key） groupIds:NFC扫描时读取的护照标签包含的groupId。
 matchDict:各个dg的哈希值与sod里的哈希值是否匹配
 sodDict:sod的base64值
 */
- (void)NFCScanPassportWithCardType:(int)cardType passportNumber:(NSString*)passportNumber dateOfBirth:(NSString*)dateOfBirth dateOfExpiry:(NSString*)dateOfExpiry skipDg2:(BOOL) skipDg2 passportDetail:(passportDetailBlock)passportDetailBlock;

@end
                                                                                                                            
