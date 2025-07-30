//
//  PassportDetailViewController.m
//  IDCardDemo
//
//  Created by 张森森 on 2024/8/14.
//  Copyright © 2024 wintone. All rights reserved.
//

#import "PassportDetailViewController.h"
#import "NFCPassportReader.h"
#import "PassportImageTableViewCell.h"
#import "PassportDetailTableViewCell.h"
#import "PassportHeaderImageTableViewCell.h"
#import "PassportGroupIdsTableViewCell.h"
#import "PassportPAStatusTableViewCell.h"

@interface PassportDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *passportTable;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIImageView *passportImage;
@property (nonatomic,strong)UIImage *NFCHeeaderImage;
@property (nonatomic,strong)NSMutableArray *modelAry;
@property (nonatomic,strong)NSMutableArray *fieldAry;
@property (nonatomic,strong)NSMutableDictionary *countryDict;
@property (nonatomic,copy)NSString *NationalityCode;
@property (nonatomic,copy)NSString *issuingCountryCode;
@property (nonatomic,assign)BOOL isNFC;
@property (nonatomic,strong)NSArray *groupIds;
@property (nonatomic,copy)NSString *MRZStr;
@property (nonatomic,assign) NSInteger sodStatus;
@property (nonatomic,assign) NSInteger PAStatus;
/*
 PA认证的结果值。
 sodStatus：哈希值校验状态.1:成功。-1：无sod值，无法校验。0：读取的gdGroup中包含与SOD不匹配的GDs哈希值
 PAStatus：服务器返回的PA认证状态。-1:哈希值校验失败，未走到PA认证阶段 1、2认证成功。3：PKDcsca认证失败。4：未找到cds对应的PKDcsca证书。5：cds验sod签名失败。6：未找到sod对应的cds证书
 cdsMsg:cds验签结果
 pkdMsg:PKD认证结果
 pkdTime:PKD日期
 */
@property (nonatomic,strong)NSMutableDictionary *PADict;
@end

@implementation PassportDetailViewController    

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
        
    }
    return self;
}
#pragma mark 国家缩写和中文字典
- (NSMutableDictionary*)countryDict{
    
    if (_countryDict == nil) {
        _countryDict = [NSMutableDictionary new];
    }
    return _countryDict;
}
#pragma mark 数据源数组
- (NSMutableArray*)modelAry{
    if (_modelAry == nil) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}
#pragma mark model的field数组，用与NFC前后更新数据源
- (NSMutableArray*)fieldAry{
    if (_fieldAry == nil) {
        _fieldAry = [NSMutableArray array];
    }
    return _fieldAry;
}
- (NSMutableDictionary*)PADict{
    if (_PADict == nil) {
        _PADict = [NSMutableDictionary new];
    }
    return _PADict;
}
- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
        
    //获取国籍字典
    NSString *path = [[NSBundle mainBundle]pathForResource:@"IDResource" ofType:@"bundle"];
    NSString *filePath = [NSString stringWithFormat:@"%@/IDCDF/country_names.dat",path];
    NSData *fileData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    NSString * fileStr = [[NSString alloc]initWithData:fileData encoding:NSUTF16StringEncoding];
    NSArray *countrys = [fileStr componentsSeparatedByString:@"\n"];
    if (countrys.count>0) {
        for (NSString *countryStr in countrys) {
            
            NSArray *countryAry = [countryStr componentsSeparatedByString:@"|"];
            self.countryDict[countryAry.firstObject] = countryAry.lastObject;
        }
        self.NationalityCode = self.countryDict[self.OCRDict[NSLocalizedString(@"Nationality code", nil)]];
        self.issuingCountryCode =self.countryDict[self.OCRDict[NSLocalizedString(@"Issuing country code", nil)]];
    }
    self.passportImage = [[UIImageView alloc]init];
    self.passportImage.frame = CGRectMake(15, kNavBarAndStatusBarHeight, kScreenWidth-30, 260);
    self.passportImage.image = [UIImage imageWithContentsOfFile:self.cropImagepath];
    [self.view addSubview:self.passportImage];
            
    self.passportTable = [[UITableView alloc]init];
    self.passportTable.delegate = self;
    self.passportTable.dataSource = self;
    self.passportTable.separatorStyle = 0;
    self.passportTable.frame = CGRectMake(0, kNavBarAndStatusBarHeight+260, kScreenWidth, kScreenHeight-kNavBarAndStatusBarHeight-260-100);
    [self.passportTable registerClass:[PassportHeaderImageTableViewCell class] forCellReuseIdentifier:@"headerImage"];
    [self.passportTable registerClass:[PassportImageTableViewCell class] forCellReuseIdentifier:@"passportImage"];
    [self.passportTable registerClass:[PassportDetailTableViewCell class] forCellReuseIdentifier:@"passportDetail"];
    [self.passportTable registerClass:[PassportGroupIdsTableViewCell class] forCellReuseIdentifier:@"groupId"];
    [self.passportTable registerClass:[PassportPAStatusTableViewCell class] forCellReuseIdentifier:@"PA"];
    [self.view addSubview:self.passportTable];
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.frame = CGRectMake(0, kScreenHeight-100, kScreenWidth, 100);
    [self.view addSubview:self.bottomView];

    UIButton * scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, 25, 120, 40)];
    [scanBtn addTarget:self action:@selector(startScan) forControlEvents:UIControlEventTouchUpInside];
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"NFCReader"] forState:UIControlStateNormal];
    scanBtn.layer.cornerRadius = 5;
    [self.bottomView addSubview:scanBtn];
    
    if (self.cardType == 14 ||self.cardType == 25||self.cardType == 22) {
        __weak typeof(self)weakSelf = self;
        [self.OCRDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:NSLocalizedString(@"Valid until", nil)]) {
                NSString *objStr = [NSString stringWithFormat:@"%@",obj];
                if ([objStr containsString:@"-"]) {
                    
                    NSArray *objAry = [objStr componentsSeparatedByString:@"-"];
                    NSString *validUntilStr = [weakSelf getResultDateWithOCRDate:objAry.lastObject];
                    self.OCRDict[key] = validUntilStr;
                }
            }
        }];
    }
    NSLog(@"识别结果》》》》》》%@",self.OCRDict);
    self.MRZStr = self.OCRDict[@"MRZ3"]==nil?(self.OCRDict[@"MRZ2"]==nil?(self.OCRDict[@"MRZ"]==nil?@"":self.OCRDict[@"MRZ"]):[NSString stringWithFormat:@"%@\n%@",self.OCRDict[@"MRZ1"],self.OCRDict[@"MRZ2"]]):[NSString stringWithFormat:@"%@\n%@\n%@",self.OCRDict[@"MRZ1"],self.OCRDict[@"MRZ2"],self.OCRDict[@"MRZ3"]];
    [self configDataWithIsNFCReader:NO passportDict:self.OCRDict];
                    
}
#pragma mark 生成护照展示数据源
- (void)configDataWithIsNFCReader:(BOOL)isNFCReader passportDict:(NSMutableDictionary*)dict{
    
    NSMutableArray *mrzAry = [NSMutableArray array];
    NSMutableArray *vizAry = [NSMutableArray array];
    NSMutableArray * allFieldAry = [NSMutableArray array];
    if (self.cardType == 13) {
        [mrzAry addObject:NSLocalizedString(@"Passport number", nil)];
        [mrzAry addObject:NSLocalizedString(@"Date of expiry", nil)];
        [mrzAry addObject:NSLocalizedString(@"Issuing country code", nil)];
        [mrzAry addObject:NSLocalizedString(@"English name", nil)];
        [mrzAry addObject:NSLocalizedString(@"Date of birth", nil)];
        [mrzAry addObject:NSLocalizedString(@"Nationality code", nil)];
        
        if ([self.OCRDict[NSLocalizedString(@"Nationality code", nil)] isEqualToString:@"CHN"]) {
            [vizAry addObject:NSLocalizedString(@"National name", nil)];
        }
        [vizAry addObject:NSLocalizedString(@"Sex", nil)];
        [vizAry addObject:NSLocalizedString(@"Place of birth", nil)];
        [vizAry addObject:NSLocalizedString(@"Place of issue", nil)];
        [vizAry addObject:NSLocalizedString(@"Date of issue", nil)];
        [vizAry addObject:NSLocalizedString(@"Issuing organization", nil)];
    }else{
        if (self.cardType ==14||self.cardType ==22||self.cardType ==25||self.cardType ==29) {
            
            [vizAry addObject:NSLocalizedString(@"Card number", nil)];
            [vizAry addObject:NSLocalizedString(@"Valid until", nil)];
            [vizAry addObject:NSLocalizedString(@"English name", nil)];
            [vizAry addObject:NSLocalizedString(@"Date of birth", nil)];
            [vizAry addObject:NSLocalizedString(@"Chinese name", nil)];
            [vizAry addObject:NSLocalizedString(@"Sex", nil)];
            if (self.cardType ==14) {
                [vizAry addObject:NSLocalizedString(@"Number", nil)];

            }else if (self.cardType ==25){
                [vizAry addObject:NSLocalizedString(@"Number of issuances", nil)];
            }
            [vizAry addObject:NSLocalizedString(@"Date of issue", nil)];
            [vizAry addObject:NSLocalizedString(@"Issuing organization", nil)];
           
        }else if (self.cardType ==15||self.cardType ==26){
            [mrzAry addObject:NSLocalizedString(@"Card number", nil)];
            [mrzAry addObject:NSLocalizedString(@"Valid until", nil)];
            [mrzAry addObject:NSLocalizedString(@"English name", nil)];
            [mrzAry addObject:NSLocalizedString(@"Date of birth", nil)];
            [mrzAry addObject:NSLocalizedString(@"Chinese name", nil)];
            [mrzAry addObject:NSLocalizedString(@"Sex", nil)];
            if (self.cardType ==15) {
                [vizAry addObject:NSLocalizedString(@"Number", nil)];

            }else if (self.cardType ==26){
                [vizAry addObject:NSLocalizedString(@"Number of issuances", nil)];
            }
            [mrzAry addObject:NSLocalizedString(@"Date of issue", nil)];
            [mrzAry addObject:NSLocalizedString(@"Issuing organization", nil)];
        }
       
    }
    [allFieldAry addObjectsFromArray:mrzAry];
    [allFieldAry addObjectsFromArray:vizAry];
    for (NSString *field in allFieldAry) {
        PassportDetailModel *model = [[PassportDetailModel alloc]initWithField:field Dict:dict mrzAry:mrzAry vizAry:vizAry isNFCReadeer:isNFCReader];
        
        if (model !=nil&&model.value !=nil) {
            if (isNFCReader) {
                
                if ([self.fieldAry containsObject:field]) {
                    [self.modelAry replaceObjectAtIndex:[self.fieldAry indexOfObject:field] withObject:model];
                }else{
                    [self.modelAry addObject:model];

                }
     
            }else{
                [self.fieldAry addObject:field];
                [self.modelAry addObject:model];

            }
        }
    }
    if (self.passportTable) {
        [self.passportTable reloadData];
    }
}
#pragma mark 更新输入框的信息
- (void)replaceTextFieldModelWithmodel:(PassportDetailModel *)model{
    
    self.OCRDict[model.field] = model.value;
    
    for (PassportDetailModel*oldModel in self.modelAry) {
        if ([oldModel.field isEqualToString:model.field]) {
            [self.modelAry replaceObjectAtIndex:[self.modelAry indexOfObject:oldModel]  withObject:model];
            return;
        }
    }
}
//tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.isNFC?5:3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if(section ==2){
    return self.modelAry.count;
  }
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
        PassportImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"passportImage" forIndexPath:indexPath];
        imageCell.MRZLabel.text = self.MRZStr;
        imageCell.selectionStyle = 0;
        return imageCell;
    }else if (indexPath.section == 1){
        PassportHeaderImageTableViewCell *headerImageCell = [tableView dequeueReusableCellWithIdentifier:@"headerImage" forIndexPath:indexPath];
        headerImageCell.OCRHeaderImage.image = [UIImage imageWithContentsOfFile:self.headImagepath];
        if (self.NFCHeeaderImage !=nil) {
            headerImageCell.NFCHeaderImage.image = self.NFCHeeaderImage;
        }
        headerImageCell.selectionStyle = 0;
        return headerImageCell;
    }else if (indexPath.section ==2){
        PassportDetailTableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"passportDetail" forIndexPath:indexPath];
        detailCell.model = self.modelAry[indexPath.row];
        detailCell.selectionStyle = 0;
        return detailCell;
    }else if (indexPath.section == 3){
        PassportGroupIdsTableViewCell * groupIdCell = [[PassportGroupIdsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupId" groupIds:self.groupIds];
        groupIdCell.selectionStyle = 0;
        return groupIdCell;
    }else if (indexPath.section ==4){
        PassportPAStatusTableViewCell *PACell = [[PassportPAStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PA" PADict:self.PADict];
        return PACell;
    }
    
    return [[UITableViewCell alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 90;
    }else if (indexPath.section ==1){
        return 150;
    }else if (indexPath.section ==2){
        return 25;
    }else if (indexPath.section ==4){
        return 280;
    }
    return 140;
}
#pragma mark NFC扫描护照
- (void)startScan{
    
    NFCPassportReader *passportReader = [[NFCPassportReader alloc]init];
    int initNFC =  [passportReader InitIDCardWithDevcode:kDevcode];
    if (initNFC !=0) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%d",initNFC] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertView addAction:cancel];
        [self presentViewController:alertView animated:YES completion:nil];
        return;
    }
    
    NSString *birthStr = @"";
    NSString *expiryStr = @"";
    NSString *passportNumber = @"";
   
    for (PassportDetailModel *model in self.modelAry) {
        if ([model.field isEqualToString:NSLocalizedString(@"Passport number", nil)]) {
            passportNumber = model.value;
        }else if ([model.field isEqualToString:NSLocalizedString(@"Date of expiry", nil)]){
            expiryStr = [self getMRZDateWithOCRDate:model.value];
        }else if ([model.field isEqualToString:NSLocalizedString(@"Date of birth", nil)]){
            birthStr = [self getMRZDateWithOCRDate:model.value];
        }
        
    }
    if (self.cardType !=13) {
        for (PassportDetailModel *model in self.modelAry) {
            if ([model.field isEqualToString:NSLocalizedString(@"Card number", nil)]) {
                passportNumber = model.value;
            }else if([model.field isEqualToString:NSLocalizedString(@"Valid until", nil)]){
                expiryStr = [self getMRZDateWithOCRDate:model.value];

            }
        }
     
    }
    if ([passportNumber isEqualToString:@""]||[expiryStr isEqualToString:@""]||[birthStr isEqualToString:@""]) {
        [self configAlertViewWithTitle:@"" message:NSLocalizedString(@"Three element tips", nil)];
        NSLog(@"证件号码、出生日期及有效期不能为空");
        return;
    }
    __weak typeof(self)weakSelf = self;
    [passportReader NFCScanPassportWithCardType:self.cardType passportNumber:passportNumber dateOfBirth:birthStr dateOfExpiry:expiryStr skipDg2:NO passportDetail:^(NSMutableDictionary *passportDict, NSArray *groupIds, NSDictionary *matchDict, NSDictionary *sodDict) {
        
        if (groupIds.count>0) {
            NSLog(@"NFCDict>>>>>.%@",passportDict);
            weakSelf.isNFC = YES;
            weakSelf.NFCHeeaderImage = passportReader.passportImage;
            weakSelf.groupIds = groupIds;
            weakSelf.NationalityCode = weakSelf.countryDict[passportDict[NSLocalizedString(@"Nationality code", nil)]];
            weakSelf.issuingCountryCode =weakSelf.countryDict[passportDict[NSLocalizedString(@"Issuing country code", nil)]];
            if (weakSelf.cardType != 13) {
                weakSelf.MRZStr = [NSString stringWithFormat:@"%@",[self getFinaMRZWhithStr:passportReader.passportMRZ]];
            }else{
                weakSelf.MRZStr = passportReader.passportMRZ;
            }
            
            if (sodDict[@"SOD"] !=nil&&![sodDict[@"SOD"]isEqualToString:@""]) {
                [self getSodStatusWithMatchDict:matchDict sodDict:sodDict completion:^{
                    [weakSelf configDataWithIsNFCReader:YES passportDict:passportDict];

                }];
            }
        }
        
    }];
    
}
#pragma mark 日期格式转换
- (NSString*)getMRZDateWithOCRDate:(NSString*)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateString];
    formatter.dateFormat = @"yyMMdd";
    NSString *shortDateString = [formatter stringFromDate:date];
    return shortDateString;
}
#pragma mark 港澳台证件有效期转换
- (NSString *)getResultDateWithOCRDate:(NSString*)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formatter dateFromString:dateString];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *shortDateString = [formatter stringFromDate:date];
    return shortDateString;
}
- (NSMutableString*)getFinaMRZWhithStr:(NSString*)MRZStr{
    // 创建一个可变字符串
    NSMutableString *mutableString = [NSMutableString stringWithString:MRZStr];

    // 需要插入换行符的位置数组（假设按索引升序排列）
    NSArray *positions = @[@30, @60];

    // 逆序遍历插入位置，避免索引偏移
    for (NSNumber *position in [positions reverseObjectEnumerator]) {
        NSInteger index = [position integerValue];
        [mutableString insertString:@"\n" atIndex:index];
    }

    // 打印结果
    NSLog(@"%@", mutableString);
    return mutableString;
}
#pragma mark 解析SOD值
- (void)getSodStatusWithMatchDict:(NSDictionary*)matchDict sodDict:(NSDictionary*)sodDict completion:(void(^)(void))completion{
    NSInteger sodStatus = 1;//哈希值校验状态.1:成功。-1：无sod值，无法校验。0：读取的gdGroup中包含与SOD不匹配的GDs哈希值
    if (sodDict.count ==0) {//无SOD值
        sodStatus = -1;
    }else{
        BOOL hasFalse = [[matchDict allValues] containsObject:@(NO)];
        if (hasFalse) {
            sodStatus = 0;//包含与SOD不匹配的GDs哈希值。
        }
    }
    self.PADict[@"sodStatus"] = [NSString stringWithFormat:@"%ld",sodStatus];

    if (sodStatus ==1) {//哈希值校验成功，请求PA认证
        if (sodDict[@"SOD"] !=nil&&![sodDict[@"SOD"]isEqualToString:@""]) {
            NSString* sodStr = sodDict[@"SOD"];//用于认证的sod的base64值。
            [self uploadSodWithSodStr:sodStr completion:completion];
        }
    }else{
        completion();
    }
 
}
#pragma mark sod上传
- (void)uploadSodWithSodStr:(NSString*)SodStr completion:(void(^)(void))completion{

     //创建请求对象
    NSURL *url = [NSURL URLWithString:@"https://netocr.com/validatePassport/sodVerifierBase64"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    // 生成随机边界字符串
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];

    // 构建请求体
    NSMutableData *body = [NSMutableData data];

    NSDictionary *params = @{
        @"fileBase64": SodStr,
        @"key": PKDRequestKey,
        @"secret":PKDRequestSecret,
        @"typeId":@"3090",
        @"format":@"json"
    };
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary]
                          dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:
                           @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]
                          dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", value]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    }];

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    request.HTTPBody = body;

    // 创建会话并发送请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        
        if (httpResponse.statusCode == 200) {
            NSError *jsonError;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data
                options:kNilOptions
                error:&jsonError];
            
            if (!jsonError) {
                NSLog(@"Response: %@", responseDict);
                NSString *pkdTime = responseDict[@"data"][@"pkdTime"];
                NSDictionary *trustChainDict = responseDict[@"data"][@"trustChain"];
                NSString * cdsMsg = trustChainDict[@"cdsMsg"];
                NSString * pkdMsg = trustChainDict[@"pkdMsg"];
                NSString * status = [NSString stringWithFormat:@"%@",trustChainDict[@"status"]];
                self.PADict[@"PAStatus"] = status;//1-6分别代表不同状态
                self.PADict[@"cdsMsg"] = cdsMsg;//签名验证结果
                self.PADict[@"pkdMsg"] = pkdMsg;//证书验证结果
                self.PADict[@"pkdTime"] = pkdTime;//PKD更新日期
                /*具体返回值信息解析可参考NFC开发手册*/
            } else {
                NSLog(@"JSON解析错误: %@", jsonError);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        } else {
            NSLog(@"HTTP错误状态码: %ld", (long)httpResponse.statusCode);
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    }];

    [task resume];
    
}
- (void)configAlertViewWithTitle:(NSString*)title message:(NSString*)message{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
