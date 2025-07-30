//
//  ViewController.m
//  IDCardDemo
//

#import "ViewController.h"
#import "ResultViewController.h"
#import "IDCardCameraViewController.h"
#import "PassportDetailViewController.h"
#if TARGET_IPHONE_SIMULATOR//simulator
#elif TARGET_OS_IPHONE//device
#import "IDCardOCR.h"

#endif

@interface ViewController ()< UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSString *_originalImagepath;
    NSString *_cropImagepath;
    NSString *_headImagePath;
    NSString *_loadImagePath;
    NSDictionary *_IDTypeDic;
}

@property (strong, nonatomic) NSMutableArray *types;

@property (assign, nonatomic) int mainID;
@property (assign, nonatomic) int subID;

@property (assign, nonatomic) int resultCount;

@property (strong, nonatomic) NSString *typeName;

#if TARGET_IPHONE_SIMULATOR//simulator
#elif TARGET_OS_IPHONE//device
@property (strong, nonatomic) IDCardOCR *cardRecog;
#endif


@end

@implementation ViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    _originalImagepath = [documentsDirectory stringByAppendingPathComponent:@"originalImage.jpg"];
    _cropImagepath = [documentsDirectory stringByAppendingPathComponent:@"cropImage.jpg"];
    _headImagePath = [documentsDirectory stringByAppendingPathComponent:@"headImage.jpg"];
    _loadImagePath = [documentsDirectory stringByAppendingPathComponent:@"loadImage.jpg"];

    /*读取证件类型列表信息;cardType.plist字典说明：
     {
        @"mainID/subID":@"证件英文名字（证件中文名字）"
     }
     */
    NSString *cardTypePath = [[NSBundle mainBundle] pathForResource:@"cardType" ofType:@"plist"];
    _IDTypeDic = [NSDictionary dictionaryWithContentsOfFile:cardTypePath];
    //NSLog(@"_IDTypeDic = %@",_IDTypeDic);
    
    //设置默认证件
    self.mainID = 2;
    self.subID = 0;
    self.typeName = NSLocalizedString(@"China Resident Identity Card(居民身份证)", nil);
    
}

//Select Document Type
- (IBAction)selectCardType:(id)sender{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Select Document Type", nil) message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray *allValues = [_IDTypeDic allValues];
    
    for (NSString *valueStr in allValues) {
        UIAlertAction *cardTypeAction = [UIAlertAction actionWithTitle:NSLocalizedString(valueStr, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSInteger index = [allValues indexOfObject:valueStr];
            NSString *IDStr = [[_IDTypeDic allKeys] objectAtIndex:index];
            NSArray *IDArray = [IDStr componentsSeparatedByString:@"/"];
            self.mainID = [[IDArray objectAtIndex:0]  intValue];
            self.typeName = [[_IDTypeDic allValues] objectAtIndex:index];
            self.subID = [[IDArray objectAtIndex:1]  intValue];
        }];
        [alertController addAction:cardTypeAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancle", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    if (IS_IPAD) {
        UIPopoverPresentationController *popPC = alertController.popoverPresentationController;
        if (popPC) {
            popPC.sourceView = self.view;
            popPC.sourceRect = CGRectMake(self.view.bounds.size.width/2 - 1,
                                          self.view.bounds.size.height,
                                          2, 2);
            
        }
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }else{
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
   
}

- (IBAction)scanningInHorizontalScreen:(id)sender{
    [self initCameraWithRecogOrientation:RecogInHorizontalScreen CropType:0];
}
- (IBAction)scanningInVerticalScreen:(id)sender{
    [self initCameraWithRecogOrientation:RecogInVerticalScreen CropType:0];
}
- (IBAction)scanningIntelligent:(id)sender {
    [self initCameraWithRecogOrientation:RecogInHorizontalScreen CropType:1];
}

- (void) initCameraWithRecogOrientation: (int)recogOrientation CropType:(int)cropType{
    IDCardCameraViewController *cameraVC = [[IDCardCameraViewController alloc] init];
    cameraVC.mainID = self.mainID;
    cameraVC.typeName = self.typeName;
    cameraVC.subID = self.subID;
    cameraVC.cropType = cropType;
    cameraVC.recogOrientation = recogOrientation;
    [self.navigationController pushViewController:cameraVC animated:YES];
}

- (IBAction)selectToRecog:(id)sender{
    
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing=YES;
    picker.sourceType=sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSelectorInBackground:@selector(didFinishedSelect:) withObject:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)didFinishedSelect:(UIImage *)image{
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:_originalImagepath atomically:YES];
    //NSLog(@"_originalImagepath= %@",_originalImagepath);
    [self performSelectorInBackground:@selector(recog) withObject:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController*)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#if TARGET_IPHONE_SIMULATOR//simulator

#elif TARGET_OS_IPHONE//device
// Initialize the recognition core
- (void) initRecog
{
    NSDate *before = [NSDate date];
    
    /*Acquire system language, load Chinese templates under Chinese system environment, and load English templates under non-Chinese system environment.
     Under English template, the field name is in English. For example, for Chinese field name “姓名”, the responsible English template is “Name”*/
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    int initLanguages;
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    if ([preferredLang rangeOfString:@"zh"].length > 0) {
        initLanguages = 0;
    }else{
        initLanguages = 3;
    }
    self.cardRecog = [[IDCardOCR alloc] init];
    /*Notice: This development code and the authorization under this project is just used for demo and please replace the  code and .lsc file under Copy Bundle Resources */
    int intRecog = [self.cardRecog InitIDCardWithDevcode:kDevcode recogLanguage:initLanguages];
    NSLog(@"intRecog = %d\nSDKVersion = %@",intRecog,[self.cardRecog getSDKVersion]);
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:before];
    NSLog(@"%f", time);
   
}

- (void)recog{
    // Initialize the recognition core
    [self initRecog];
    //set recognition pattern
    if (self.mainID ==3000) { //Machine readable zone
        [self.cardRecog setIDCardIDWithMainID:1033 subID:0 subIDCount:1];
        [self.cardRecog addIDCardIDWithMainID:1034 subID:0 subIDCount:1];
        [self.cardRecog addIDCardIDWithMainID:1036 subID:0 subIDCount:1];
    }else if(self.mainID ==2) { //Chinese ID card
        [self.cardRecog setIDCardIDWithMainID:self.mainID subID:0 subIDCount:1];
        [self.cardRecog addIDCardIDWithMainID:3 subID:0 subIDCount:1];
        
    }else{
        [self.cardRecog setIDCardIDWithMainID:self.mainID subID:self.subID subIDCount:1];
    }
    //close rejection
    if (self.mainID ==2) {
        [self.cardRecog setIDCardRejectType:self.mainID isSet:true];
        [self.cardRecog setIDCardRejectType:3 isSet:true];
    }
    
    //set parameter and card type
    [self.cardRecog setParameterWithMode:0 CardType:self.mainID];
    //image pretreatment
    [self.cardRecog processImageWithProcessType:7 setType:1];
    
    
    //load image
    int loadImage = [self.cardRecog LoadImageToMemoryWithFileName:_originalImagepath Type:0];
    NSLog(@"加载图片>>>%d",loadImage);
    int recog = -1;
    if (self.mainID != 3000) {
        recog = [self.cardRecog pictureRecogWithMainID:self.mainID];
       
        // save the cut image to headImagePath
        [self.cardRecog saveHeaderImage:_headImagePath];
        
        // save the cut full image to imagepath
        [self.cardRecog saveImage:_cropImagepath];
       
        //图像来源属性 0：原件;1：黑白复印件；2：彩色复印件；4：屏拍件
        int sourceType = [self.cardRecog GetImageSourceTypeWithCardType:self.mainID scale:1];
        NSString *sourceTypeStr = @"";
        switch (sourceType) {
            case 0:
                sourceTypeStr = @"原件";
                break;
            case 1:
                sourceTypeStr = @"黑白复印件";
                break;
            case 2:
                sourceTypeStr = @"彩色复印件";
                break;
            case 4:
                sourceTypeStr = @"屏拍件";
                break;
            default:
                break;
        }
        NSString *allResult = @"";
        NSMutableDictionary *resultMuDic = [NSMutableDictionary dictionary];

        for (int i = 1; i < 25; i++) {

            // acquire fields value
            NSString *field = [self.cardRecog GetFieldNameWithIndex:i nMain:self.mainID];
            // acquire fields result
            NSString *result = [self.cardRecog GetRecogResultWithIndex:i nMain:self.mainID];
            NSLog(@"%@:%@\n",field, result);
            if (result==nil) {result =@"";}

            if(field != NULL){
                allResult = [allResult stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n", field, result]];
                [resultMuDic setObject:result forKey:field];

            }
        }
        if (![allResult isEqualToString:@""]) {
            allResult =  [allResult stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",@"图像来源属性",sourceTypeStr]];

            //free initialize the recognition core
            [self.cardRecog recogFree];
            
            //jump to the result pagepa
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createResultView:allResult recog:recog resultDict:resultMuDic];

            });
        }else{
        }
    }
}

#endif
- (void)createResultView:(NSString *)allResult recog:(int)recog resultDict:(NSMutableDictionary*)resultDict{
    
    if (self.mainID == 13) {
        PassportDetailViewController *detailVC = [[PassportDetailViewController alloc]init];
        detailVC.OCRDict = resultDict;
        detailVC.cropImagepath = _cropImagepath;
        detailVC.headImagepath = _headImagePath;
        [self.navigationController pushViewController:detailVC animated:YES];

    }else{
        ResultViewController *rvc = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
        NSLog(@"allresult = %@", allResult);
        rvc.resultString = allResult;
        rvc.cropImagepath = recog>0?_cropImagepath:_originalImagepath;
        rvc.headImagepath = _headImagePath;
        rvc.originalImagepath = _originalImagepath;
        rvc.typeName = self.typeName;
        [self.navigationController pushViewController:rvc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
