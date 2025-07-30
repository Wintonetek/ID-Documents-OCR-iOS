//
//  PassportDetailModel.m
//  IDCardDemo
//
//  Created by 张森森 on 2024/8/16.
//  Copyright © 2024 wintone. All rights reserved.
//

#import "PassportDetailModel.h"

@implementation PassportDetailModel
/**
   生成model。出生地点，签发地点，签发日期，签发机关OCR识别取值时略有差异。
   field：key值
   dict：扫描识别结果（OCR扫描结果或者NFC识别结果）
   mrzAry、vizAry:用来区分结果从何处解析
  isNFCReader ：是否是NFC识别之后的结果
 
 */
- (id)initWithField:(NSString*)field Dict:(NSMutableDictionary*)dict mrzAry:(NSMutableArray*)mrzAry vizAry:(NSMutableArray*)vizAry isNFCReadeer:(BOOL)isNFCReader{
   
    self = [super init];
    if (self) {
        
        if (dict[field] !=nil && ![dict[field] isEqualToString:@""]) {
            self.field = field;
            if ([field isEqualToString:NSLocalizedString(@"Sex", nil)]) {
               
                    if ([dict[field] isEqualToString:@"F"]||[dict[field] isEqualToString:@"女"]) {
                        self.value = @"女/F";
                    }else if ([dict[field] isEqualToString:@"M"]||[dict[field] isEqualToString:@"男"]){
                        self.value = @"男/M";
                    }else{
                        self.value = dict[field];
                    }
                
               
            }else{
                
                self.value = dict[field];

            }
            
            if ([mrzAry containsObject:field]) {
                if (isNFCReader) {
                    self.type = 3;
                }else{
                    self.type = 1;
                }
            }else if ([vizAry containsObject:field]){
                if (isNFCReader) {
                    self.type = 3;
                }else{
                    self.type = 2;
                }
            }
        }else if ([field isEqualToString:NSLocalizedString(@"Place of birth", nil)]){
            if (dict[NSLocalizedString(@"Place of birth (only PRC)", nil)] !=nil&&![dict[NSLocalizedString(@"Place of birth (only PRC)", nil)] isEqualToString:@""]) {
                self.field = field;
                self.value = dict[NSLocalizedString(@"Place of birth (only PRC)", nil)];
                if (isNFCReader) {
                    self.type = 3;
                }else{
                    self.type = 2;
                }
            }
        }else if ([field isEqualToString:NSLocalizedString(@"Place of issue", nil)]){
            if (dict[NSLocalizedString(@"Place of issue (only PRC)", nil)] !=nil&&![dict[NSLocalizedString(@"Place of issue (only PRC)", nil)] isEqualToString:@""]) {
                self.field = field;
                self.value = dict[NSLocalizedString(@"Place of issue (only PRC)", nil)];
                if (isNFCReader) {
                    self.type = 3;
                }else{
                    self.type = 2;
                }
            }
        }else if ([field isEqualToString:NSLocalizedString(@"Date of issue", nil)]){
            if (dict[NSLocalizedString(@"Date of issue (only PRC)", nil)] !=nil&&![dict[NSLocalizedString(@"Date of issue (only PRC)", nil)] isEqualToString:@""]) {
                self.field = field;
                self.value = dict[NSLocalizedString(@"Date of issue (only PRC)", nil)];
                if (isNFCReader) {
                    self.type = 3;
                }else{
                    self.type = 2;
                }
            }
        }else if ([field isEqualToString:NSLocalizedString(@"Issuing organization", nil)]){
            if (dict[NSLocalizedString(@"Authority(OCR)", nil)] !=nil&&![dict[NSLocalizedString(@"Authority(OCR)", nil)] isEqualToString:@""]) {
                self.field = field;
                self.value = dict[NSLocalizedString(@"Authority(OCR)", nil)];
                if (isNFCReader) {
                    self.type = 3;
                }else{
                    self.type = 2;
                }
            }
        }else if ([field isEqualToString:NSLocalizedString(@"Passport number", nil)]){
            if (dict[[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Passport number", nil),@"MRZ"]] !=nil&&![dict[[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Passport number", nil),@"MRZ"]] isEqualToString:@""]) {
                self.field = field;
                self.value = dict[[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Passport number", nil),@"MRZ"]];
                if (isNFCReader) {
                    self.type = 3;
                }else{
                    self.type = 1;
                }
            }else if (dict[@"The passport number from MRZ"] !=nil&& ![dict[@"The passport number from MRZ"] isEqualToString:@""]){
                self.field = field;
                self.value = dict[@"The passport number from MRZ"];
                if (isNFCReader) {
                    self.type = 3;
                }else{
                    self.type = 1;
                }
            }
            
        }else if ([field isEqualToString:NSLocalizedString(@"Date of birth", nil)]){
            if (dict[[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Date of birth", nil),@"OCR"]] !=nil&&![dict[[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Date of birth", nil),@"OCR"]] isEqualToString:@""]) {
                self.field = field;
                self.value = dict[[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Date of birth", nil),@"OCR"]];
                if (isNFCReader) {
                    self.type = 3;
                }else{
                    self.type = 1;
                }
            }
            
        }else if ([field isEqualToString:NSLocalizedString(@"Date of expiry", nil)]){
            if (dict[[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Date of expiry", nil),@"OCR"]] !=nil&&![dict[[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Date of expiry", nil),@"OCR"]] isEqualToString:@""]) {
                self.field = field;
                self.value = dict[[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Date of expiry", nil),@"OCR"]];
                if (isNFCReader) {
                    self.type = 3;
                }else{
                    self.type = 1;
                }
            }
            
        }else if ([field isEqualToString:NSLocalizedString(@"Card number", nil)]){
            if (dict[NSLocalizedString(@"Passport number", nil)]!=nil) {
                self.field = field;
                self.value = dict[NSLocalizedString(@"Passport number", nil)];
                if (isNFCReader) {
                    self.type = 3;
                }else{
                    self.type = 1;
                }
            }
        }else if ([field isEqualToString:NSLocalizedString(@"Valid until", nil)]){
            if (dict[NSLocalizedString(@"Date of expiry", nil)]!=nil) {
                self.field = field;
                self.value = dict[NSLocalizedString(@"Date of expiry", nil)];
                if (isNFCReader) {
                    self.type = 3;
                }else{
                    self.type = 1;
                }
            }
        }else if ([field isEqualToString:NSLocalizedString(@"Chinese name", nil)]){
            
            if (dict[NSLocalizedString(@"National name", nil)]!=nil) {
                self.field = field;
                self.value = dict[NSLocalizedString(@"National name", nil)];
                if (isNFCReader) {
                    self.type = 3;
                }else{
                    self.type = 1;
                }
            }
        }
        
    }
    return self;
}

@end
