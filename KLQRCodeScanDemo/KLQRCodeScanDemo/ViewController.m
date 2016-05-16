//
//  ViewController.m
//  KLQRCodeScanDemo
//
//  Created by user on 16/5/16.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZKLQRCodeScanViewController.h"

@interface ViewController ()

/**
 *      扫描二维码
 */
@property (weak, nonatomic) IBOutlet UIButton *scanQRCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *scanLocalButton;
@property (weak, nonatomic) IBOutlet UIButton *createQRCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *createHDQRCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *saveToLocalAlbumButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.scanQRCodeButton addTarget: self action: @selector(scanQRCode) forControlEvents: UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scan QRCode 二维码扫描

- (void) scanQRCode {
    // 判断版本
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ( [systemVersion floatValue] < 7.0) {
        [self.navigationController pushViewController: [ZKLQRCodeScanViewController new] animated: YES];
        return;
    }
    // 判断是否有权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示" message: @"请先到系统“隐私”中打开相机权限" delegate: nil cancelButtonTitle: @"知道了" otherButtonTitles: nil];
        alert.delegate = self;
        alert.alertViewStyle = UIAlertActionStyleDefault;
        [alert show];
        return;
    }
//    [self.navigationController pushViewController: [ZKLQRCodeScanViewController new] animated: YES];
    [self presentViewController: [ZKLQRCodeScanViewController new] animated: YES completion: nil];
}

@end
