//
//  ViewController.m
//  Barcode
//
//  Created by Lee on 15/12/15.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ViewController.h"
#import "WLBarcodeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startScan:(id)sender {
    WLBarcodeViewController *vc=[[WLBarcodeViewController alloc] initWithBlock:^(NSString *str, BOOL isScceed) {
        
        if (isScceed) {
            NSLog(@"扫描后的结果~%@",str);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫码结果" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            NSLog(@"扫描后的结果~%@",str);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫码结果" message:@"无法识别" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
