//
//  WLBarcodeViewController.m
//
//
//  Created by Lee on 17/10/8.
//  Copyright (c) 2017年 shicaiguanjia. All rights reserved.
//

#import "WLBarcodeViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define frameWidth 110
@interface WLBarcodeViewController ()
@property (nonatomic, strong) UIImageView *scanLineImageView;
@property (nonatomic, strong) NSTimer *scanLineTimer;
@property (strong, nonatomic) UILabel *infoLabel;
@end

@implementation WLBarcodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithBlock:(void(^)(NSString*,BOOL))a{
    if (self=[super init]) {
        self.ScanResult=a;
        
    }
    
    return self;
}
-(void)createView{
    

    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    self.view.frame = mainBounds;
    
    CGRect readerFrame = self.view.frame;
    CGSize viewFinderSize = CGSizeMake(readerFrame.size.width - frameWidth, readerFrame.size.width - frameWidth);
    CGRect scanCrop = CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
                                 (readerFrame.size.height - viewFinderSize.height)/2,
                                 viewFinderSize.width,
                                 viewFinderSize.height);
    /* 画一个取景框开始 */
    // 正方形取景框的边长
    CGFloat edgeLength = 20.0;
    
    UIImageView *topLeft =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
                                                  (readerFrame.size.height - viewFinderSize.height)/2,
                                                  edgeLength, edgeLength)];
    topLeft.image = [UIImage imageNamed:@"qr_top_left.png"];
    [self.view addSubview:topLeft];
    
    UIImageView *topRight =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width + viewFinderSize.width)/2 - edgeLength,
                                                  (readerFrame.size.height - viewFinderSize.height)/2,
                                                  edgeLength, edgeLength)];
    topRight.image = [UIImage imageNamed:@"qr_top_right.png"];
    [self.view addSubview:topRight];
    
    UIImageView *bottomLeft =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
                                                  (readerFrame.size.height + viewFinderSize.height)/2 - edgeLength,
                                                  edgeLength, edgeLength)];
    bottomLeft.image = [UIImage imageNamed:@"qr_bottom_left"];
    [self.view addSubview:bottomLeft];
    
    UIImageView *bottomRight =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width + viewFinderSize.width)/2 - edgeLength,
                                                  (readerFrame.size.height + viewFinderSize.height)/2 - edgeLength,
                                                  edgeLength, edgeLength)];
    bottomRight.image = [UIImage imageNamed:@"qr_bottom_right"];
    [self.view addSubview:bottomRight];
    
    UIView *topLine =
    [[UIView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2-1,
                                             (readerFrame.size.height - viewFinderSize.height)/2-1,
                                             viewFinderSize.width+2, 1)];
    topLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:topLine];
    
    UIView *bottomLine =
    [[UIView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2-1,
                                             (readerFrame.size.height + viewFinderSize.height)/2,
                                             viewFinderSize.width+2, 1)];
    bottomLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bottomLine];
    
    UIView *leftLine =
    [[UIView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2-1,
                                             (readerFrame.size.height - viewFinderSize.height)/2-1,
                                             1, viewFinderSize.height+2)];
    leftLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:leftLine];
    
    UIView *rightLine =
    [[UIView alloc] initWithFrame:CGRectMake((readerFrame.size.width + viewFinderSize.width)/2,
                                             (readerFrame.size.height - viewFinderSize.height)/2-1,
                                             1, viewFinderSize.height+2)];
    rightLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:rightLine];
    
    self.scanLineImageView =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width - 230)/2,
                                                  (readerFrame.size.height - viewFinderSize.height)/2,
                                                  230, 10)];
    self.scanLineImageView.image = [UIImage imageNamed:@"qr_scan_line"];
    
    [self.view addSubview:self.scanLineImageView];
    
    /* 画一个取景框结束 */
    
    /* 配置取景框之外颜色开始 */
    // scanCrop
    UIView *viewTopScan =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainBounds.size.width, scanCrop.origin.y)];
    
    UIView *viewBottomScan =
    [[UIView alloc] initWithFrame:CGRectMake(0, scanCrop.origin.y+scanCrop.size.height,
                                             mainBounds.size.width,
                                             mainBounds.size.height - scanCrop.size.height - scanCrop.origin.y)];
    
    UIView *viewLeftScan =
    [[UIView alloc] initWithFrame:CGRectMake(0, scanCrop.origin.y, scanCrop.origin.x, scanCrop.size.height)];
    
    UIView *viewRightScan =
    [[UIView alloc] initWithFrame:CGRectMake(scanCrop.origin.x + scanCrop.size.width,
                                             scanCrop.origin.y,
                                             mainBounds.size.width - scanCrop.origin.x - scanCrop.size.width,
                                             scanCrop.size.height)];
    viewTopScan.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    viewBottomScan.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    viewLeftScan.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    viewRightScan.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    [self.view addSubview:viewTopScan];
    [self.view addSubview:viewBottomScan];
    [self.view addSubview:viewLeftScan];
    [self.view addSubview:viewRightScan];
    
    /* 配置取景框之外颜色结束 */
    
    // 返回键
    UIButton *goBackButton = ({
        UIButton *button =
        [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 36, 36)];
        [button setImage:[UIImage imageNamed:@"qr_vc_left"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 18.0;
        button.layer.backgroundColor = [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] CGColor];
        [button addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
        button;
    });
    [self.view addSubview:goBackButton];
    
    // 控制散光灯
    UIButton *torchSwitch = ({
        UIButton *button =
        [[UIButton alloc] initWithFrame:CGRectMake(mainBounds.size.width-44-20, 30, 36, 36)];
        [button setImage:[UIImage imageNamed:@"qr_vc_right"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 18.0;
        button.layer.backgroundColor = [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] CGColor];
        [button addTarget:self action:@selector(torchSwitch:) forControlEvents:UIControlEventTouchDown];
        button;
    });
    [self.view addSubview:torchSwitch];
    
    
    self.infoLabel =
    [[UILabel alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
                                              (readerFrame.size.height + viewFinderSize.height)/2 + 20,
                                              viewFinderSize.width, 30)];
    self.infoLabel.text = @"将二维码放入取景框中即可自动扫描";
    self.infoLabel.font = [UIFont systemFontOfSize:13.0];
    self.infoLabel.layer.cornerRadius = self.infoLabel.frame.size.height / 2;
    self.infoLabel.layer.backgroundColor = [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] CGColor];
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.infoLabel];
    
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //下方相册
    UIImageView*scanImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-87, self.view.frame.size.width, 87)];
    scanImageView.image=[UIImage imageNamed:@"qrcode_scan_bar.png"];
    scanImageView.userInteractionEnabled=YES;
    [self.view addSubview:scanImageView];
 NSArray*unSelectImageNames=@[@"qrcode_scan_btn_photo_nor.png",@"qrcode_scan_btn_flash_nor.png",@"qrcode_scan_btn_myqrcode_nor.png"];
 NSArray*selectImageNames=@[@"qrcode_scan_btn_photo_down.png",@"qrcode_scan_btn_flash_down.png",@"qrcode_scan_btn_myqrcode_down.png"];
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:unSelectImageNames[0]] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectImageNames[0]] forState:UIControlStateHighlighted];
    button.frame=CGRectMake(0, 0, 65, 87);
    [button addTarget:self action:@selector(pressPhotoLibraryButton:) forControlEvents:UIControlEventTouchUpInside];
    [scanImageView addSubview:button];
    
}
// 返回
- (void)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 控制散光灯
- (void)torchSwitch:(id)sender {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    if (device.hasTorch) {  // 判断设备是否有散光灯
        BOOL b = [device lockForConfiguration:&error];
        if (!b) {
            if (error) {
                NSLog(@"lock torch configuration error:%@", error.localizedDescription);
            }
            return;
        }
        device.torchMode =
        (device.torchMode == AVCaptureTorchModeOff ? AVCaptureTorchModeOn : AVCaptureTorchModeOff);
        [device unlockForConfiguration];
    }
}
#define LINE_SCAN_TIME  3.0     // 扫描线从上到下扫描所历时间（s）

- (void)createTimer {
    self.scanLineTimer =
    [NSTimer scheduledTimerWithTimeInterval:LINE_SCAN_TIME
                                     target:self
                                   selector:@selector(moveUpAndDownLine)
                                   userInfo:nil
                                    repeats:YES];
}

// 扫描条上下滚动
- (void)moveUpAndDownLine {
    self.scanLineImageView.hidden = NO;
    CGRect readerFrame = self.view.frame;
    CGSize viewFinderSize = CGSizeMake(self.view.frame.size.width - frameWidth, self.view.frame.size.width - frameWidth);
    
    CGRect scanLineframe = self.scanLineImageView.frame;
    scanLineframe.origin.y =
    (readerFrame.size.height - viewFinderSize.height)/2;
    self.scanLineImageView.frame = scanLineframe;
   
    
    __weak __typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:LINE_SCAN_TIME - 0.05
                     animations:^{
                         CGRect scanLineframe = weakSelf.scanLineImageView.frame;
                         scanLineframe.origin.y =
                         (readerFrame.size.height + viewFinderSize.height)/2 -
                         weakSelf.scanLineImageView.frame.size.height;
                         
                         weakSelf.scanLineImageView.frame = scanLineframe;
                     }
                     completion:^(BOOL finished) {
                         weakSelf.scanLineImageView.hidden = YES;
                     }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //相机界面的定制在self.view上加载即可
    BOOL Custom= [UIImagePickerController
                  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];//判断摄像头是否能用
    if (Custom) {
        [self initCapture];//启动摄像头
    }
    [self createView];
   
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [self moveUpAndDownLine];
    if (self.scanLineTimer == nil) {
        
        [self createTimer];
    }
    [super viewDidAppear:animated];
}
#pragma mark 选择相册
- (void)pressPhotoLibraryButton:(UIButton *)button
{

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.isScanning = NO;
    [self.captureSession stopRunning];
    if (self.scanLineTimer) {
        [self.scanLineTimer invalidate];
        self.scanLineTimer = nil;
    }

    [self presentViewController:picker animated:YES completion:^{
    }];
}
#pragma mark 点击取消
- (void)pressCancelButton:(UIButton *)button
{
    self.isScanning = NO;
    [self.captureSession stopRunning];
    
    self.ScanResult(nil,YES);

    if (self.scanLineTimer) {
        [self.scanLineTimer invalidate];
        self.scanLineTimer = nil;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 开启相机
- (void)initCapture
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice* inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    [self.captureSession addInput:captureInput];
    
    
   // if (IOS7) {
        AVCaptureMetadataOutput*_output=[[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        [self.captureSession addOutput:_output];
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        CGRect readerFrame = self.view.frame;
        CGSize viewFinderSize = CGSizeMake(readerFrame.size.width - frameWidth, readerFrame.size.width - frameWidth);
        CGRect scanCrop =
        CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
                   (readerFrame.size.height - viewFinderSize.height)/2,
                   viewFinderSize.width,
                   viewFinderSize.height);
        
        _output.rectOfInterest =
        CGRectMake(scanCrop.origin.y/readerFrame.size.height,
                   scanCrop.origin.x/readerFrame.size.width,
                   scanCrop.size.height/readerFrame.size.height,
                   scanCrop.size.width/readerFrame.size.width
                   );
        if (!self.captureVideoPreviewLayer) {
            self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        }
    
        self.captureVideoPreviewLayer.frame = self.view.bounds;
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer: self.captureVideoPreviewLayer];
        
        self.isScanning =  YES;
        [self.captureSession startRunning];
    
        
//    }else{
//        AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
//        captureOutput.alwaysDiscardsLateVideoFrames = YES;
//        [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
//
//        NSString* key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
//        NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
//        NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
//        [captureOutput setVideoSettings:videoSettings];
//        [self.captureSession addOutput:captureOutput];
//        
//        NSString* preset = 0;
//        if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
//            [UIScreen mainScreen].scale > 1 &&
//            [inputDevice
//             supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
//                // NSLog(@"960");
//                preset = AVCaptureSessionPresetiFrame960x540;
//            }
//        if (!preset) {
//            // NSLog(@"MED");
//            preset = AVCaptureSessionPresetMedium;
//        }
//        self.captureSession.sessionPreset = preset;
//        
//        if (!self.captureVideoPreviewLayer) {
//            self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
//        }
//        // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
//        self.captureVideoPreviewLayer.frame = self.view.bounds;
//        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//        [self.view.layer addSublayer: self.captureVideoPreviewLayer];
//        
//        self.isScanning = YES;
//        [self.captureSession startRunning];
//        
//        
//    }

    
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
    // Get the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,
                                                              NULL);
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage =
    CGImageCreate(width,
                  height,
                  8,
                  32,
                  bytesPerRow,
                  colorSpace,
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  provider,
                  NULL,
                  true,
                  kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    // Create and return an image object representing the specified Quartz image
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    
    return image;
}

#pragma mark 对图像进行解码
- (void)decodeImage:(UIImage *)image
{
    self.isScanning = NO;
    self.isScanning = NO;
    ZBarSymbol *symbol = nil;
    
    ZBarReaderController* read = [ZBarReaderController new];
    
    read.readerDelegate = self;
    
    CGImageRef cgImageRef = image.CGImage;
    
    for(symbol in [read scanImage:cgImageRef])break;
    
    if (symbol!=nil) {

        self.ScanResult(symbol.data,YES);
       
    }else{

        self.ScanResult(nil,NO);
       
    }
    self.isScanning = NO;
    [self.captureSession stopRunning];
    if (self.scanLineTimer) {
        [self.scanLineTimer invalidate];
        self.scanLineTimer = nil;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    [self decodeImage:image];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate//IOS7下触发
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    
    if (metadataObjects.count>0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        self.ScanResult(metadataObject.stringValue,YES);
    }else{
       self.ScanResult(nil,NO);
    }
    
    [self.captureSession stopRunning];
    if (self.scanLineTimer) {
        [self.scanLineTimer invalidate];
        self.scanLineTimer = nil;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}



#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [self dismissViewControllerAnimated:YES completion:^{
      [self decodeImage:image];  
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.isScanning = YES;
        [self.captureSession startRunning];
    }];
}

#pragma mark - DecoderDelegate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
