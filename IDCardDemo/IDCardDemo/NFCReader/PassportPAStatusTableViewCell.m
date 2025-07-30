//
//  PassportPAStatusTableViewCell.m
//  IDCardDemo
//
//  Created by 张森森 on 2025/5/15.
//  Copyright © 2025 wintone. All rights reserved.
//

#import "PassportPAStatusTableViewCell.h"

@implementation PassportPAStatusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier PADict:(NSMutableDictionary*)PAdict{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        NSInteger PAStatus = [PAdict[@"PAStatus"]integerValue];
        NSInteger sodStatus = [PAdict[@"sodStatus"]integerValue];
        NSString * cdsMsg = PAdict[@"cdsMsg"];
        NSString * pkdMsg = PAdict[@"pkdMsg"];
        NSString *pkdTime = PAdict[@"pkdTime"];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"芯片信息认证";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.frame = CGRectMake(15, 15, 200, 20);
        [self.contentView addSubview:titleLabel];
        
        UILabel *resultLabel = [[UILabel alloc]init];
        resultLabel.frame = CGRectMake(15, 50, 150, 30);
        resultLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:resultLabel];
        
        UILabel *tipsLabel = [[UILabel alloc]init];
        tipsLabel.frame = CGRectMake(160, 57, 180, 15);
        tipsLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:tipsLabel];
        [self setResultUIWithResultLabel:resultLabel tipsLabel:tipsLabel PAStatus:PAStatus sodStatus:sodStatus];
        
        UILabel* timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.text = [NSString stringWithFormat:@"PKD更新日期:%@",pkdTime];
        timeLabel.font = [UIFont systemFontOfSize:15];
        timeLabel.frame = CGRectMake(15, 95, 200, 15);
        [self.contentView addSubview:timeLabel];
        
        UILabel *certificateLabel = [[UILabel alloc]init];
        certificateLabel.text = @"认证链展示:";
        certificateLabel.textColor = [UIColor grayColor];
        certificateLabel.font = [UIFont systemFontOfSize:15];
        certificateLabel.frame = CGRectMake(15, 125, 200, 15);
        [self.contentView addSubview:certificateLabel];
        
        if (PAStatus ==0) {
            return self;
        }
        
        CGFloat marginViewW = 40;
        CGFloat dataViewW = (kScreenWidth - 30 - marginViewW*3)/4;
        CGFloat dataViewH = 95;
        
        int allMargin = 3;
        if (sodStatus ==0||sodStatus==-1) {
            allMargin = 1;
        }else{
            if (PAStatus==5||PAStatus==6) {
                allMargin = 2;
            }
        }
        
        for (int i = 0; i<allMargin; i++) {
            UIView *marginView = [[UIView alloc]init];
            marginView.backgroundColor = [UIColor whiteColor];
            marginView.tag = 5151730+i;
            marginView.frame = CGRectMake(15+dataViewW+i*(dataViewW+marginViewW), 155, marginViewW, dataViewH);
            [self.contentView addSubview:marginView];
            
            UIImageView *arrowImage = [[UIImageView alloc]init];
            arrowImage.image = [UIImage imageNamed:@"gjt"];
            arrowImage.frame = CGRectMake(0, 20, marginViewW, 15);
            [marginView addSubview:arrowImage];
            
            
            UILabel *resultLabel = [[UILabel alloc]init];
            resultLabel.numberOfLines = 0;
            resultLabel.textAlignment = NSTextAlignmentCenter;
            resultLabel.font = [UIFont systemFontOfSize:8];
            resultLabel.frame = CGRectMake(0, 35, marginViewW, 50);
            [marginView addSubview:resultLabel];
            
            [self setMarginViewUIWithArrowImage:arrowImage resultLabel:resultLabel index:i PAStatus:PAStatus sodStatus:sodStatus cdsMsg:cdsMsg pkdMsg:pkdMsg];
            
            
        }
        NSArray *signTitles = @[@"PKD CSCA",@"CDS",@"SOD",@"DGs"];
        NSArray *nameTitles = @[@"公钥目录国家签名认证机构证书库",@"证件签名者证书",@"证件安全对象",@"护照数据"];
        if (sodStatus == 0||sodStatus == -1) {
            signTitles = @[@"SOD",@"DGs"];
            nameTitles = @[@"证件安全对象",@"护照数据"];
        }else{
            if (PAStatus==5||PAStatus ==6) {
                signTitles = @[@"CDS",@"SOD",@"DGs"];
                nameTitles = @[@"证件签名者证书",@"证件安全对象",@"护照数据"];
            }
            
        }
        for (int i = 0; i<signTitles.count; i++) {
            UIView *dataView = [[UIView alloc]init];
            dataView.backgroundColor = [UIColor whiteColor];
            dataView.tag = 5151630+i;
            dataView.layer.cornerRadius = 5;
            dataView.frame = CGRectMake(15+i*(dataViewW+marginViewW), 155, dataViewW, dataViewH);
            [self.contentView addSubview:dataView];
            
            CAShapeLayer *border = [CAShapeLayer layer];
            border.fillColor   = UIColor.clearColor.CGColor;
            border.lineWidth   = 3.0;  // 默认宽度
            border.strokeColor = RGBACOLOR(75, 165, 39, 1).CGColor;  // 默认颜色
            border.frame = dataView.bounds;
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:dataView.bounds cornerRadius:5.0]; // 和 cornerRadius 一致
            border.path = path.CGPath;
            border.cornerRadius  = 5;
            border.masksToBounds = YES;
            // 插到最底层：
            [dataView.layer insertSublayer:border atIndex:0];
           
            
            UIImageView *successImage = [[UIImageView alloc]init];
            successImage.tag = 5151640+i;
            successImage.image = [UIImage imageNamed:@"success"];
            successImage.frame = CGRectMake(-10, -10, 20, 20);
            [dataView addSubview:successImage];
            if (i==0) {
                successImage.hidden = YES;
            }
            
            UILabel *signLabel = [[UILabel alloc]init];
            signLabel.tag = 5151660+i;
            signLabel.text = signTitles[i];
            signLabel.textColor = RGBACOLOR(75, 165, 39, 1);
            signLabel.font = [UIFont boldSystemFontOfSize:15];
            signLabel.textAlignment = NSTextAlignmentCenter;
            signLabel.numberOfLines = 0;
            signLabel.frame = CGRectMake(5, 10, dataViewW-10, 40);
            [dataView addSubview:signLabel];
            
            UILabel *nameLabel = [[UILabel alloc]init];
            nameLabel.tag = 5151670+i;
            nameLabel.text = nameTitles[i];
            nameLabel.textColor = RGBACOLOR(75, 165, 39, 1);
            nameLabel.font = [UIFont systemFontOfSize:8];
            nameLabel.numberOfLines = 0;
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.frame = CGRectMake(5, 50, dataViewW -10, 40);
            [dataView addSubview:nameLabel];
          
            [self setDataViewUIWithBorder:border imageView:successImage signLabel:signLabel nameLabel:nameLabel index:i PAStatus:PAStatus sodStatus:sodStatus];
          
        }
        
        
    }
    return self;
}
#pragma mark 设置认证结果UI
- (void)setResultUIWithResultLabel:(UILabel*)resultLabel tipsLabel:(UILabel *)tipsLabel PAStatus:(NSInteger)PAStatus sodStatus:(NSInteger)sodStatus{
    NSInteger resultStatus = 1;
    NSInteger tipsStatus = 1;
    NSString *resultStr = @"认证结果:";
    NSString *resultStatusStr = @"";
    NSString *tipsStr = @"";
    if (sodStatus==0) {//哈希值校验失败
        resultStatus = 0;
        tipsStatus = 0;
        resultStatusStr = @"认证失败";
        tipsStr = @"(哈希值校验失败)";
    }else if (sodStatus ==-1){//无安全对象（sod）
        resultStatus = -1;
        tipsStatus = -1;
        resultStatusStr = @"无法认证";
        tipsStr = @"(无证件安全对象)";
    }else{
        if (PAStatus==1||PAStatus ==2) {//认证成功
            resultStatus = 1;
            tipsStatus = 1;
            resultStatusStr = @"认证通过";
            tipsStr = @"";
        }else if (PAStatus==3||PAStatus ==5){//pkd认证失败
            resultStatus = 0;
            resultStatusStr = @"认证失败";
            if (PAStatus ==3) {//证书认证失败
                tipsStatus = 2;
                tipsStr = @"(公钥目录证书认证失败)";
            }else{//签名认证失败
                tipsStatus = 3;
                tipsStr = @"(证件签名认证失败)";
            }
            
        }else if (PAStatus ==4||PAStatus==6){//pkd无cds证书
            resultStatus = -1;
            resultStatusStr = @"无法认证";
            if (PAStatus ==4) {
                tipsStatus = -2;
                tipsStr = @"(公钥目录无对应证书)";
            }else{
                tipsStatus = -3;
                tipsStr = @"(无证件签名证书)";
            }
        }
        
    }
    
    NSString *resultTitle = [NSString stringWithFormat:@"%@%@",resultStr,resultStatusStr];
    UIColor *resultColor = resultStatus == 1?RGBACOLOR(75, 165, 39, 1):(resultStatus==0?RGBACOLOR(255, 0, 0, 1):RGBACOLOR(252, 170, 122, 1));
    
    NSString *tipsTitle = tipsStr;
    UIColor *tipsColor = tipsStatus > 0?RGBACOLOR(255, 0, 0, 1):RGBACOLOR(252, 170, 122, 1);
    
    resultLabel.textColor = resultColor;

    
    tipsLabel.textColor = tipsColor;
    tipsLabel.text = tipsTitle;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:resultTitle];
    NSRange agreementRange = [resultTitle rangeOfString:resultStr];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor grayColor]
                             range:agreementRange];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:agreementRange];
    resultLabel.attributedText = attributedString;
    
}
#pragma mark 设置dataView的UI
- (void)setDataViewUIWithBorder:(CAShapeLayer*)border imageView:(UIImageView*)successImage signLabel:(UILabel*)signLabel nameLabel:(UILabel*)nameLabel index:(int)i PAStatus:(NSInteger)PAStatus sodStatus:(NSInteger)sodStatus {
   
    UIColor *redColor = RGBACOLOR(255, 0, 0, 1);
    UIColor *orangColor = RGBACOLOR(252, 170, 122, 1);
    UIColor *lightGrayColor = RGBACOLOR(108, 108, 108, 1);
    UIColor *greenColor = RGBACOLOR(75, 165, 39, 1);
    
    if (sodStatus ==0||sodStatus ==-1) {
        if (sodStatus ==-1) {
            if (i ==0) {
                border.strokeColor = RGBACOLOR(108, 108, 108, 1).CGColor;
                successImage.hidden = YES;
                signLabel.textColor = RGBACOLOR(108, 108, 108, 1);
                nameLabel.textColor = RGBACOLOR(108, 108, 108, 1);
            }else{
                border.strokeColor = RGBACOLOR(252, 170, 122, 1).CGColor;
                successImage.hidden = NO;
                successImage.image = [UIImage imageNamed:@"query"];
                signLabel.textColor = RGBACOLOR(252, 170, 122, 1);
                nameLabel.textColor = RGBACOLOR(252, 170, 122, 1);
            }
            
        }else if (sodStatus ==0){
            if (i ==0) {
                border.strokeColor = RGBACOLOR(255, 0, 0, 1).CGColor;
                successImage.hidden = YES;
                signLabel.textColor = RGBACOLOR(255, 0, 0, 1);
                nameLabel.textColor = RGBACOLOR(255, 0, 0, 1);
            }else{
                border.strokeColor = redColor.CGColor;
                successImage.hidden = NO;
                successImage.image = [UIImage imageNamed:@"fail"];
                signLabel.textColor = redColor;
                nameLabel.textColor = redColor;
            }
        }
    }else{
        if (PAStatus==5||PAStatus==6) {
            if (PAStatus ==5) {
                if (i ==0) {
                    border.strokeColor = redColor.CGColor;
                    successImage.hidden = YES;
                    signLabel.textColor = redColor;
                    nameLabel.textColor = redColor;
                }else if(i==1||i==2){
                    border.strokeColor = redColor.CGColor;
                    successImage.hidden = NO;
                    successImage.image = [UIImage imageNamed:@"fail"];
                    signLabel.textColor = redColor;
                    nameLabel.textColor = redColor;
                }
            }else if (PAStatus ==6){
                if (i ==0) {
                    border.strokeColor = lightGrayColor.CGColor;
                    successImage.hidden = YES;
                    signLabel.textColor = lightGrayColor;
                    nameLabel.textColor = lightGrayColor;
                }else if(i == 1){
                    border.strokeColor = orangColor.CGColor;
                    successImage.hidden = NO;
                    successImage.image = [UIImage imageNamed:@"query"];
                    signLabel.textColor = orangColor;
                    nameLabel.textColor = orangColor;
                }else if (i ==2){
                    border.strokeColor = greenColor.CGColor;
                    successImage.hidden = NO;
                    successImage.image = [UIImage imageNamed:@"query"];
                    signLabel.textColor = greenColor;
                    nameLabel.textColor = greenColor;
                }
            }
        }else if (PAStatus == 3||PAStatus ==4){
            if (PAStatus ==3) {
                if (i==0) {
                    border.strokeColor = greenColor.CGColor;
                    successImage.hidden = YES;
                    signLabel.textColor = greenColor;
                    nameLabel.textColor = greenColor;
                }else{
                    border.strokeColor = redColor.CGColor;
                    successImage.hidden = NO;
                    successImage.image = [UIImage imageNamed:@"fail"];
                    signLabel.textColor = redColor;
                    nameLabel.textColor = redColor;
                }
            }else if (PAStatus == 4){
                if (i==0) {
                    border.strokeColor = greenColor.CGColor;
                    successImage.hidden = YES;
                    signLabel.textColor = greenColor;
                    nameLabel.textColor = greenColor;
                }else if (i==1){
                    border.strokeColor = orangColor.CGColor;
                    successImage.hidden = NO;
                    successImage.image = [UIImage imageNamed:@"query"];
                    signLabel.textColor = orangColor;
                    nameLabel.textColor = orangColor;
                }else{
                    border.strokeColor = greenColor.CGColor;
                    successImage.hidden = NO;
                    successImage.image = [UIImage imageNamed:@"query"];
                    signLabel.textColor = greenColor;
                    nameLabel.textColor = greenColor;
                }
            }
            
        }else if (PAStatus ==1){
            if (i==0) {
                signLabel.text = @"PKD CDS";
                nameLabel.text = @"公钥目录证件签名者证书库";
            }
           
        }
        
    }
    
}

- (void)setMarginViewUIWithArrowImage:(UIImageView*)arrowImage resultLabel:(UILabel*)resultLabel index:(int)i PAStatus:(NSInteger)PAStatus sodStatus:(NSInteger)sodStatus cdsMsg:(NSString*)cdsMsg pkdMsg:(NSString*)pkdMsg{
    
    UIColor *redColor = RGBACOLOR(255, 0, 0, 1);
    UIColor *orangColor = RGBACOLOR(252, 170, 122, 1);
    UIColor *lightGrayColor = RGBACOLOR(108, 108, 108, 1);
    UIColor *greenColor = RGBACOLOR(75, 165, 39, 1);
    
    if (sodStatus ==0||sodStatus==-1) {
        if (sodStatus==-1) {
            arrowImage.image = [UIImage imageNamed:@"ljt"];
            resultLabel.text = @"无证件安全对象";
            resultLabel.textColor = lightGrayColor;
        }else if (sodStatus ==0){
            arrowImage.image = [UIImage imageNamed:@"rjt"];
            resultLabel.text = @"哈希值校验失败";
            resultLabel.textColor = redColor;
        }
    }else{
        if (PAStatus ==5||PAStatus==6) {
            if (PAStatus ==5) {
                if (i==0) {
                    arrowImage.image = [UIImage imageNamed:@"rjt"];
                    resultLabel.text = cdsMsg;
                    resultLabel.textColor = redColor;
                }else if (i==1){
                    arrowImage.image = [UIImage imageNamed:@"rjt"];
                    resultLabel.text = @"哈希值检验成功";
                    resultLabel.textColor = greenColor;
                }
            }else{
                if (i==0) {
                    arrowImage.image = [UIImage imageNamed:@"ljt"];
                    resultLabel.text = cdsMsg;
                    resultLabel.textColor = lightGrayColor;
                }else if (i==1){
                    arrowImage.image = [UIImage imageNamed:@"gjt"];
                    resultLabel.text = @"哈希值检验成功";
                    resultLabel.textColor = greenColor;
                }
            }
        }else if (PAStatus ==3||PAStatus ==4||PAStatus==2||PAStatus==1){
            if (i==0) {
                if (PAStatus==3) {
                    arrowImage.image = [UIImage imageNamed:@"rjt"];
                    resultLabel.text = pkdMsg;
                    resultLabel.textColor = redColor;
                }else if(PAStatus ==4){
                    arrowImage.image = [UIImage imageNamed:@"ojt"];
                    resultLabel.text = pkdMsg;
                    resultLabel.textColor = orangColor;
                }else if (PAStatus ==2){
                    arrowImage.image = [UIImage imageNamed:@"gjt"];
                    resultLabel.text = pkdMsg;
                    resultLabel.textColor = greenColor;
                    
                }else if (PAStatus ==1){
                    arrowImage.image = [UIImage imageNamed:@"gjt"];
                    resultLabel.text = pkdMsg;
                    resultLabel.textColor = greenColor;
                }
                
            }else if (i==1){
                arrowImage.image = [UIImage imageNamed:@"gjt"];
                resultLabel.text = cdsMsg;
                resultLabel.textColor = greenColor;
            }else if (i==2){
                arrowImage.image = [UIImage imageNamed:@"gjt"];
                resultLabel.text = @"哈希值检验成功";
                resultLabel.textColor = greenColor;
            }
            
        }
    }
    
}
@end
