//
//  IDCardOCR.h
//  IDCardOCR
//
//  Created by chinasafe on 16/3/17.
//  Copyright © 2016年 chinasafe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "IDCardSlideLine.h"

@protocol ECFaceDetecterDelegate <NSObject>

//成功回调
- (void)ECFaceLiveCheckSuccessGetImage:(NSArray *)imgArr;


@end

@protocol ECFaceDetecterDelegate1 <NSObject>

//成功回调
- (void)ECFaceLiveCheckSuccessGetImage1:(NSArray *)imgArr;


@end


@interface IDCardOCR : NSObject
@property (nonatomic,assign)id delegate;

@property (nonatomic,assign)id delegate1;

- (NSString *)getSDKVersion;
/*
 初始化核心,调用其他方法之前，必须调用此初始化，否则，其他函数调用无效
 devcode:开发码
 recogLanguage:识别语言，0中文，3英文
 返回值：0-核心初始化成功；其他失败，具体失败原因参照开发手册
 */
-(int)InitIDCardWithDevcode:(NSString *)devcode recogLanguage:(int) recogLanguage;


//压入视频流
- (void)pushDetectBuffer:(CMSampleBufferRef )sampleBuffer;

/*
 初始化核心,调用其他方法之前，必须调用此初始化，否则，其他函数调用无效
 devcode:开发码
 recogLanguage:识别语言，0中文，3英文
 path:IDResource.bundle文件的路径, eg:mainBundle/IDResource.bundle
 返回值：0-核心初始化成功；其他失败，具体失败原因参照开发手册
 */
-(int)InitIDCardWithDevcode:(NSString *)devcode recogLanguage:(int) recogLanguage resourcePaht:(NSString *)path;


/* 设置接口下来要识别的区域类型
 @param type  -1 所有区域都不识别
               65535 识别所有区域
               0 头像区域
               1 一般识别区域
               2 定位区域
               3 新加坡身份证
               4 MRZ区域
               5 印尼身份证定位区域
               6 印尼身份证NIK区域
 */
- (int)setCurrentRegionTypeIOS:(int)nType;

- (int)SetDLRecogAttributeWithMainID:(int)nMainID RecogType:(int)nRecogType Reserve:(int)nReserve;

/*
 核心6.7.2.3版本之后可用
 设置识别模式及证件类型
 nMode：0－拍照识别、导入识别，1－视频流方式
 nType: 证件类型
 */
- (void)setParameterWithMode:(int)nMode CardType:(int)nType;

//设置清晰度判断的阈值,不设置，默认80；清晰度阈值区间0~255
- (void)setPictureClearValueEx:(int)nValue;

//设置检测边线方式，不设置，默认指导框检边方式；0-指导框；1-自动检边
- (void)setVideoStreamCropTypeExWithType:(int)nType;

/********************************************
 扫描识别专用接口
 ********************************************/

/*
 设置感兴区域
 参数：检边区域在实际图像中到整张图片上、下、左、右的距离，与分辨率和检边区域有关，详见demo设置
 返回值：0-设置成功；其他失败
 */
- (int) setROIWithLeft: (int)nLeft Top: (int)nTop Right: (int)nRight Bottom: (int)nBottom;
/*
 设置二代证识别类型
 nType:0-正反面 1-正面 2-背面
 返回值：0-设置成功；其他失败
 */
-(int) SetDetectIDCardType:(int) nType;


/*
 手持端视频流，支持多方向，0－无需旋转 1－90度 2－180度 3－270度（顺时针）
 参数：图像帧数据以及其宽高
 返回值：0－成功，其它－失败
 */
- (int)setRecogRotateType:(int)nRotateType;


/*
 核心6.7.2.3版本之后可用
 导入内存新接口
 参数：图像帧数据以及其宽高
 返回值：0－成功，其它－失败
 */
- (int) newLoadImageWithBuffer:(UInt8 *)buffer Width:(int)width Height:(int)height;

/*
 核心6.7.2.3版本之后可用
 找边新接口; 调用“导入内存新接口”之后调用此接口
 返回值：SlideLine类的属性allLine值 1－成功，0－失败
 */
- (IDCardSlideLine *) newConfirmSlideLine;

/*
 获取四点接口，找边新接口之后调用
 返回值：NSDictionary对象，
 {  
    key:value
    @"isSucceed":,NSNumber对象
    @"point1":CGPoint,
    @"point2":CGPoint,
    @"point3":CGPoint,
    @"point4":CGPoint
 }
 isSucceed：NSNumber对象，1-获取四点成功，-1获取四点失败
 point1、point2、point3、point4依次连接，逆时针画出检测出的框
 */
- (NSDictionary *)obtainRealTimeFourConersID;
/*
 光斑检测
 0：检测到敏感区域内有光斑；
 -1：未成功初始化核心；
 -2：敏感区域内未检测到光斑；
 -3：未成功加载图像数据。
 */
- (int)detectLightspot;

/*
 核心6.7.2.3版本之后可用
 检测图片清晰度新接口
 返回值：0－成功，其它－失败
 */
- (int) newCheckPicIsClear;

/*
 核心6.7.3.5版本之后可用
 排他接口
 参数：nCartType-证件类型，isSet-YES设置排他，NO-不设置
 返回值：无意义
 */
- (int)setIDCardRejectType:(int)nCartType isSet:(bool)isSet;

/*
 获取机读码类型
 参数：图像帧数据以及其宽高、感兴区域
 返回值：1代表1034，2代表1036，3代表1033，即两行和三行机读码
 */
- (int) GetAcquireMRZSignal:(UInt8 *)buffer Width:(int)width Height:(int)height Left:(int)left Right:(int)right Top:(int)top Bottom:(int)bottom RotateType:(int)rotatetype;

/*获取泰文身份证特征点，项目定制接口,必须在识别后调用
 返回值：0:成功；
 1：图像为空；
 参数：xpos[6]:特征点的x坐标，值为-1表示特征检测失败；
 ypos[6]:特征点的y坐标，值为-1表示特征检测失败；
 0：存储左上角圆心；
 1：存储左侧条码的中心位置；
 2：存储芯片中心位置；
 3：存储顶部标题行的中心位置；
 4：存储Name单词区域的左上角位置；
 5：存储右下角数字串区域的左上角位置
 注意：请在调用识别接口后调用此接口，因为分析的是裁切后的图像
 */
- (NSDictionary *) getThaiFeaturePos;

/************************************************************************/
/* 获取图像来源属性，即判断图像是原件，复印件还是屏拍件
 输入：mainID，证件类型；
 scale，判断的范围，比如设置为1，及判断是原件还是黑白复印件；
 比如设置为5（1+4），及判断是否是原件，黑边复印件还是屏拍件；
 返回值：0：原件;1：黑白复印件；2：彩色复印件；4：屏拍件
 <0定义为错误信息*/
/************************************************************************/
- (int)GetImageSourceTypeWithCardType:(int)nCardType scale:(int)nScale;

/*
 加载机读码
 参数：图像帧数据以及其宽高
 */
- (int) loadMRZImageWithBuffer:(UInt8 *)buffer Width:(int)width Height:(int)height;

/********************************************
 手动拍照&导入识别专用接口
 ********************************************/

/*
 导入图片路径
 lpImageFileName:图片路径；type传入0即可
 返回值：0－成功，其它－失败 3-图片为空
 */
-(int)LoadImageToMemoryWithFileName:(NSString *)lpImageFileName Type:(int)type;
/*
 核心6.7.2.3版本之后可用
 图像预处理接口
 nProcessType：0－取消所有操作，1－裁切，2-旋转 3－裁切+旋转，4-倾斜校正  5－裁切+倾斜校正， 6-倾斜校正+旋转 7－裁切+倾斜校正+旋转
 nSetType: 0－取消操作，1－设置操作
 */
- (void)processImageWithProcessType:(int)nProcessType setType:(int)nSetType;

/********************************************
 公共接口
 ********************************************/

/*
 保存裁切后的整幅图片
 path:保存路径
 返回值：0-成功；其他失败
 */
- (int) saveImage:(NSString *)path;

/*
 保存裁切后的头像
 path:保存路径
 返回值：0-成功；其他失败
 */
- (int) saveHeaderImage: (NSString *)path;

/*
 保存裁切后的条码
 path:保存路径
 返回值：0-成功；其他失败
 */
- (int) saveThaiIDBarCodeImage:(NSString *)path;

/*
 证件识别
 返回值：证件类型代码
 2012版本扫描识别时，全部调用该方法
 */
- (int) autoRecogChineseID:(int)nMainID;
/*
 证件识别
 返回值：证件类型代码
 拍照识别和导入识别时调用该方法
 */
- (int) pictureRecogWithMainID:(int)nMainID;
/*
 识别证件
 nMainID：证件类型代码
 返回值：证件类型代码
 2012版本改方法暂时废弃
 */
- (int) recogIDCardWithMainID: (int) nMainID;

/*
 识别证件
 nMainID：证件类型代码;
 nSubID :证件类型子代码
 返回值：证件类型代码
 */
- (int) recogIDCardWithMainID: (int) nMainID subID:(int)nSubID;

/*导入识别取字段名*/
-(NSString *)GetFieldNameWithIndex:(int) nIndex nMain:(int)nMain;

/*导入识别取识别结果*/
-(NSString *)GetRecogResultWithIndex:(int) nIndex nMain:(int)nMain;

/*扫描识别取字段名*/
-(NSString *)GetFieldNameWithIndex:(int) nIndex;

/*扫描取识别结果*/
-(NSString *)GetRecogResultWithIndex:(int) nIndex;

/*取识别模板名*/
-(NSString *)GetRecogIDCardName;

/*释放核心*/
-(void)recogFree;

/********************************************
 废弃接口
 ********************************************/
/*以下6个扫描识别接口在核心6.7.2.3版本之后不在使用 扫描识别调用上面的接口 详细见demo*/
//根据证件类型设置剪边
-(int) setConfirmSideMethodWithType:(int) aType;
//是否检测区域的有效性（二代证、护照检边防止误触发），传YES设置，NO不设置
- (int) IsDetectRegionValid:(BOOL) detect;
//180°旋转开关，目前只支持二代证正面
- (int) IsDetect180Rotate:(BOOL) isRotate;
// 找边
- (IDCardSlideLine *) confirmSlideLineWithBuffer:(UInt8 *)buffer Width:(int)width Height:(int)height;
//检测图片是否清晰
- (int) checkPicIsClearWithBuffer:(UInt8 *)buffer width:(int)width height:(int)height;
// 导入内存
- (int) loadImageWithBuffer:(UInt8 *)buffer Width:(int)width Height:(int)height;

/*以下2个导入识别接口在核心6.7.2.3版本之后不在使用 导入识别&手动拍照调用上面的接口 详细见demo*/
//旋转 导入识别时用
- (BOOL) AutoRotateImage:(int)recogType;
//裁切 导入识别时用
- (int)AutoCropImage:(int) nID;

// 获取证件子类型
- (int)getSubId;
/********************************************
 自动分类接口
 ********************************************/


- (void)setIDCardIDWithMainID:(int)nMainID subID:(int)nSubID subIDCount:(int)nSubIDCount;
- (void)addIDCardIDWithMainID:(int)nMainID subID:(int)nSubID subIDCount:(int)nSubIDCount;
- (int)recogIDCard;

- (int)autoMyKadAndPassport;

-(NSString *)getCoreVersion;
@end
