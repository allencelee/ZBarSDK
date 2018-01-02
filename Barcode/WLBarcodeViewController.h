//
//  WLBarcodeViewController.h
//
//
//  Created by Lee on 17/10/8.
//  Copyright (c) 2017年 shicaiguanjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZBarReaderController.h"

#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7

@interface WLBarcodeViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate,ZBarReaderDelegate,UIImagePickerControllerDelegate,AVCaptureMetadataOutputObjectsDelegate>


@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, assign) BOOL isScanning;

@property (nonatomic,copy)void(^ScanResult)(NSString*result,BOOL isSucceed);/**< 返回扫码结果*/
//初始化函数
-(id)initWithBlock:(void(^)(NSString*,BOOL))a;


@end
