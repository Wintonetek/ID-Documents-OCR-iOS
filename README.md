# # ID-Documents-OCR-iOS
# 证件识别，包含二代证、回乡证、往来港澳通行证、护照识别及NFC读取数据等多种证件的识别。
# 
# 关于证件识别SDK的集成具体信息，可与我们联系。
# 也可以参考附带的示例Demo来通过代码学习本SDK的用法。
# 
# # 证件主类型说明
# # 证件名称    证件MAINID（10进制表示）
# # 一代身份证（暂不支持）    1
# # 二代身份证正面    2
# # 二代身份证证背面    3
# # 临时身份证    4
# # 驾照    5
# # 行驶证    6
# # 军官证    7
# # 士兵证（暂不支持）    8
# # 中华人民共和国往来港澳通行证    9
# # 台湾居民往来大陆通行证    10
# # 大陆居民往来台湾通行证    11
# # 签证    12
# # 护照    13
# # 港澳居民来往内地通行证正面    14
# # 港澳居民来往内地通行证背面    15
# # 
# # 新版港澳通行证    22
# # 边境地区出入境通行证    23
# # 新版台湾居民往来大陆通行证（正面）    25
# # 新版台湾居民往来大陆通行证（背面）    26
# # 机动车驾驶证副页    28
# # 往来台湾通行证2017版-照片页    29
# # 机动车行驶证副页    30
# # 港澳台居民居住证-照片页    31
# # 港澳台居民居住证-签发机关页    32
# # 外国人永久居留身份证2017版-照片页    33
# # 电子驾照    34
# # 电子行驶证    35
# # 电子驾照副页    36
# # 电子行驶证副业    37
# # 居住证    1000
# # 香港永久性居民身份证2003版本    1001(1)
# # 香港居民身份证2018版    1001(2)
# # 登机牌（拍照设备目前不支持登机牌的识别）（暂不支持）    1002
# # 边民证（A）（照片页）（暂不支持）    1003
# # 边民证（B）（个人信息页）（暂不支持）    1004
# # 澳门身份证    1005
# # 领取凭证(扫描仪支持) （暂不支持）    1006
# # 律师证（A）（信息页）    1007
# # 律师证（B） （照片页）    1008
# # 中华人民共和国道路运输证IC卡（暂不支持）    1009
# # 新版澳门身份证（暂不支持）    1012
# # 新版深圳市居住证    1013
# # 澳门蓝卡    1014
# # 香港入境小票    1015
# # 护照机读码（暂不支持）    1020
# # 北京社保卡    1021
# # 全民健康保险卡    1030
# # 台湾身份证正面    1031
# # 台湾身份证背面    1032
# # MRZ3*30（暂不支持）    1033
# # MRZ2*44（暂不支持）    1034
# # MRZ2*36（暂不支持）    1036
# # 厦门社会保障卡    1039
# # 福建社会保障卡-照片页    1041
# # 马来西亚身份证    2001
# # 加利福尼亚驾照    2002
# # 新西兰驾照    2003
# # 新加坡身份证    2004
# # ID2（MRZ2*36）TD-2型机读码    2006
# # ID1（MRZ3*30）（暂不支持）    2007
# # ID3（MRZ2*44）（暂不支持）    2008
# # TD-1型机读码    2009
# # 印度尼西亚居民身份证-KEPT    2010(1)
# # 印度尼西亚居民身份证-KPT    2010(2)
# # 泰国身份证（正面）    2011
# # 泰国驾驶证    2012(1)
# # 泰国驾驶证-私家车    2012(2)
# # 墨西哥选民证AB    2013(1)
# # 墨西哥选民证C    2013(2)
# # 墨西哥选民证DE    2013(3)
# # 墨西哥选民证背面ABC    2014
# # 泰国身份证（反面）    2016
# # 瑞典驾驶证    2020
# # 马来西亚驾照    2021
# # 菲律宾身份证    2022
# # 新加坡驾驶证    2031
# # 印度尼西亚驾驶证    2041
# # 日本驾照    2051
# 
# 2 接口说明
# 以下接口的调用请参考SDK中Demo程序！！ 
# 
# 2.1 -(int)InitIDCardWithDevcode:(NSString *)devcode recogLanguage:(int) recogLanguage; 
# /*
#  初始化核心,调用其他方法之前，必须调用此方法否则其他函数调用无效！
#  devcode:开发码
#  recogLanguage:识别语言，0-中文，识别结果字段为中文;3-英文,识别结果字段为英文    
#  返回值:0成功，其它值表示失败；根据此方法返回值判断授权和核心初始化是否成功！
# */
# 下表为此返回值和对应的描述。 
# 返回值    返回值描述
# 0    核心初始化成；
# -10012    核心初始化方法未传入开发码；参考2.1
# -10600    未找到授权文件；参考1.4.2
# -10601    核心初始化方法传入的开发码错误；参考1.4.1、2.1
# -10602    工程plist文件中Bundle identifier与授权文件绑定的值不一致；参考1.4.3、1.4.4
# -10603    授权过期; 
# -10604    核心版本号错误
# -10605    工程plist文件中Bundle display name与授权文件绑定的值不一致；参考1.4.3、1.4.4
# -10606    工程plist文件中CompanyName与授权文件绑定的值不一致；参考1.4.3、1.4.4
# -10090    授权到期，但未超过30天; 
# -10609    SDK版本号错误；
# 
# 
# 2.2- (void)setParameterWithMode:(int)nMode CardType:(int)nType;
# /*
#  设置识别模式及证件类型
#  参数：nMode：0－拍照识别、导入识别;1－视频流方式
#  nType: 证件类型
#  */
# 
# 2.3- (void)setPictureClearValueEx:(int)nValue;
# /*
#  设置清晰度判断的阈值，默认80;
#  参数：nValue:0-255
#  */
# 
# 
# 2.4- (void)setVideoStreamCropTypeExWithType:(int)nType;
# /*
#  设置检测边线方式，不设置，默认指导框检边方式;
#  参数：nType：0-指导框;1-自动检边
#  */
# 
# 
# 2.5- (int) setROIWithLeft: (int)nLeft Top: (int)nTop Right: (int)nRight Bottom: (int)nBottom;
# /*
#  设置感兴区域
#  参数：真实图像中指导框区域在整张图片上、下、左、右的距离，详见demo设置
#  返回值：0-设置成功；其他失败
#  */
# 
# 
# 2.6-(int) SetDetectIDCardType:(int) nType;
# /*
#  设置二代身份证识别类型
#  参数：nType:0-正反面;1-正面;2-背面
#  返回值：0-设置成功;其他失败
#  */
# 
# 
# 2.7- (int)setRecogRotateType:(int)nRotateType;
# /*
#  视频流设置旋转方向
#  参数：nRotateType：顺时针方向旋转；0－不旋转；1－90度；2－180度；3－270度
#  返回值：0－成功，其它－失败
#  */
# 
# 
# 2.8- (int) newLoadImageWithBuffer:(UInt8 *)buffer Width:(int)width Height:(int)height;
# /*
#  图像数据导入内存
#  参数：图像数据及其宽高
#  返回值：0－成功，其它－失败
#  */
# 
# 
# 2.9- (IDCardSlideLine *) newConfirmSlideLine;
# /*
#  检测边线
#  返回值：SlideLine对象，检边成功后，属性allLine值当前设置的证件类型代号
#  */
# 
# 
# 2.10- (NSDictionary *)obtainRealTimeFourConersID;
# /*
#  检测边线成功后，获取四点
#  返回值：NSDictionary对象，
#  {
#  key:value
#  @"isSucceed":,NSNumber对象
#  @"point1":CGPoint,
#  @"point2":CGPoint,
#  @"point3":CGPoint,
#  @"point4":CGPoint
#  }
#  isSucceed：NSNumber对象，1-获取四点成功，-1获取四点失败
#  point1、point2、point3、point4依次连接，逆时针画出检测出的框
#  */
# 
# 2.11- (int)detectLightspot;
# /*
#  光斑检测
#  返回值：
#   0：检测到敏感区域内有光斑；
#  -1：未成功初始化核心；
#  -2：敏感区域内未检测到光斑；
#  -3：未成功加载图像数据。
#  */
# 
# 
# 2.12- (int) newCheckPicIsClear;
# /*
#  检测图片清晰度
#  返回值：0－成功，其它－失败
#  */
# 
# 
# 2.13- (int)setIDCardRejectType:(int)nCartType isSet:(bool)isSet;
# /*
#  排他接口
#  参数：nCartType-证件类型；isSet-YES设置排他，NO-不设置
#  返回值：无意义
#  */
# 
# 
# 2.14- (int) GetAcquireMRZSignal:(UInt8 *)buffer Width:(int)width Height:(int)height Left:(int)left Right:(int)right Top:(int)top Bottom:(int)bottom RotateType:(int)rotatetype;
# /*
#  获取机读码类型
#  参数：图像数据以及其宽高、感兴区域
#  返回值：1代表1034，2代表1036，3代表1033，即两行和三行机读码
#  */
# 
# 
# 2.15- (int) loadMRZImageWithBuffer:(UInt8 *)buffer Width:(int)width Height:(int)height;
# /*
#  加载机读码
#  参数：图像数据以及其宽高
#  返回值：0－成功，其它－失败 
#  */
# 
# 2.16-(int)LoadImageToMemoryWithFileName:(NSString *)lpImageFileName Type:(int)type;
# /*
#  导入图片路径
#  参数：lpImageFileName:图片路径；type传入0即可
#  返回值：0－成功，其它－失败 3-图片为空
#  */
# 
# 2.17- (void)processImageWithProcessType:(int)nProcessType setType:(int)nSetType;
# /*
#  图像预处理接口
#  参数：nProcessType：0－取消所有操作，1－裁切，2-旋转 3－裁切+旋转，4-倾斜校   正  5－裁切+倾斜校正， 6-倾斜校正+旋转 7－裁切+倾斜校正+旋转
#  nSetType: 0－取消操作，1－设置操作
#  */
# 
# 
# 
# 2.18- (int) saveImage:(NSString *)path;
# /*
#  保存裁切后的整幅图片
#  参数：path:保存路径
#  返回值：0-成功；其他失败
#  */
# 
# 
# 2.19- (int) saveHeaderImage: (NSString *)path;
# /*
#  保存裁切后的头像
#  参数：path:保存路径
#  返回值：0-成功；其他失败
#  */
# 
# 
# 2.20- (int) autoRecogChineseID;
# /*
#  自动识别二代证正反面，需要时调用
#  返回值：证件类型代码
#  */
# 
# 
# 2.21- (int) recogIDCardWithMainID: (int) nMainID;
# /*
#  识别证件
#  参数：nMainID：证件类型代码
#  返回值：证件类型代码
#  */
# 
# 
# /*扫描识别取字段名*/
# 2.22-(NSString *)GetFieldNameWithIndex:(int) nIndex;
# 
# /*扫描取识别结果*/
# 2.23-(NSString *)GetRecogResultWithIndex:(int) nIndex;
# 
# /*导入识别取字段名*/
# 2.24-(NSString *)GetFieldNameWithIndex:(int) nIndex nMain:(int)nMain;
# 
# /*导入识别取识别结果*/
# 2.25-(NSString *)GetRecogResultWithIndex:(int) nIndex nMain:(int)nMain;
# /*释放核心*/
# 2.26-(void)recogFree;
# 
# 3 NFC读取与PKD校验
# 以下接口的调用请参考SDK中Demo程序！！ 
# 
# 3.1 -(int)InitIDCardWithDevcode:(NSString *)devcode; 
# /*
#  初始化核心,调用其他方法之前，必须调用此方法否则其他函数调用无效！
#  devcode:开发码    
#  返回值:0成功，其它值表示失败；根据此方法返回值判断授权和核心初始化是否成功！
# */
# 下表为此返回值和对应的描述。 
# 返回值    返回值描述
# 0    核心初始化成；
# -10012    核心初始化方法未传入开发码；参考2.1
# -10600    未找到授权文件；参考1.4.2
# -10601    核心初始化方法传入的开发码错误；参考1.4.1、2.1
# -10602    工程plist文件中Bundle identifier与授权文件绑定的值不一致；参考1.4.3、1.4.4
# -10603    授权过期; 
# -10604    核心版本号错误
# -10605    工程plist文件中Bundle display name与授权文件绑定的值不一致；参考1.4.3、1.4.4
# -10606    工程plist文件中CompanyName与授权文件绑定的值不一致；参考1.4.3、1.4.4
# -10090    授权到期，但未超过30天; 
# -10609    SDK版本号错误；
# -10704    未授权NFC
# 
# /**
#  NFC扫描护照接口,需配合扫描识别获取三要素
#  cardType : 证件ID
#  passportNumber:护照号码
#  dateOfBirth :出生日期
#  dateOfExpiry :有效期至
#  passportDetailBlock: 返回信息,包含passportDict:护照信息（国际化文件内NFC的内容即为该字典的Key） groupIds:NFC扫描时读取的护照标签包含的groupId。
#  matchDict:各个dg的哈希值与sod里的哈希值是否匹配
#  sodDict:sod的base64值
#  */
# 3.2 - (void)NFCScanPassportWithCardType:(int)cardType passportNumber:(NSString*)passportNumber dateOfBirth:(NSString*)dateOfBirth dateOfExpiry:(NSString*)dateOfExpiry passportDetail:(passportDetailBlock)passportDetailBlock;
# 注2：
# //NFC
# "Issuing country code" = "签发国代码";
# "English name" = "英文姓名";
# "Passport number" = "护照号码" ;
# "Date of birth" = "出生日期";
# "Date of expiry" = "有效期至";
# "Nationality code" = "持证人国籍代码";
# "National name" = "本国姓名";
# "Sex" = "性别";
# "Place of birth" = "出生地点";
# "Place of issue" = "签发地点";
# "Date of issue" = "签发日期";
# "Issuing organization" = "签发机关";
# //回乡证，台胞证
# "Card number" = "证件号码";
# "Valid until" = "有效期至";
# "Chinese name" = "中文姓名";
# "Number" = "换证次数";
# "Number of issuances" = "签发次数";
# 以上既是国际化内容又是passportDict（识别接口返回的护照信息的字典）的key值
# 
# PKD认证（芯片信息认证）
# 认证流程共三部分：各DG哈希值与SOD里的哈希值校验（即matchDict）、SOD证件签名验证、公钥目录证书认证/查询。
# (1)判断NFC读取信息返回的matchDict里是否包含不匹配的哈希值，若包含则直接判定为认证失败，若哈希值都匹配则进行服务端认证。
# (2)将sodDict里的SOD的base64值上传至服务端进行验证。
# 3.2 服务端验证说明
# 接口：https://netocr.com/validatePassport/sodVerifierBase64
# 请求方式：POST
# 请求参数：fileBase64（SOD的base64值）
# 
# 具体的集成流程与识别信息可联系我们获取开发手册和测试授权。
# 
# 联系我们：
# Email: lijj@sinosecu.com.cn  &  zhangss@sinosecu.com.cn
# WhatsApp:+86 17310630901
