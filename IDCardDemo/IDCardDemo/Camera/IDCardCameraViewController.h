//
//  CameraViewController.h
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, RecogOrientation){
    RecogInHorizontalScreen    = 0,
    RecogInVerticalScreen      = 1, 
};

@interface IDCardCameraViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, retain) CALayer *customLayer;

@property (nonatomic,assign) BOOL isProcessingImage;

@property (strong, nonatomic) AVCaptureSession *session;

@property (strong, nonatomic) AVCaptureDeviceInput *captureInput;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@property (strong, nonatomic) AVCaptureConnection *videoConnection;

@property (assign, nonatomic) RecogOrientation recogOrientation;

@property (assign, nonatomic) int mainID;
@property (assign, nonatomic) int subID;

@property (copy, nonatomic) NSString *typeName;

//“0”- guide frame; “1”- automatic line detection
@property (assign, nonatomic) int cropType;

@end
