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

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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
    
    // 初始化按钮
    [self.scanQRCodeButton addTarget: self action: @selector(scanQRCode) forControlEvents: UIControlEventTouchUpInside];
    [self.scanLocalButton addTarget: self action: @selector(scanLocalQRCode) forControlEvents: UIControlEventTouchUpInside];
    [self.createQRCodeButton addTarget: self action: @selector(createQRCode) forControlEvents: UIControlEventTouchUpInside];
    [self.createHDQRCodeButton addTarget: self action: @selector(createHDQRCode) forControlEvents: UIControlEventTouchUpInside];
    [self.saveToLocalAlbumButton addTarget: self action: @selector(saveQRCodeToAlbum) forControlEvents: UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scan QRCode                          二维码扫描

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
    [self presentViewController: [ZKLQRCodeScanViewController new] animated: YES completion: nil];
}

#pragma mark - Scan QRCode from local album         从本地选取二维码读取

- (void)scanLocalQRCode {
    // 判断是否有权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示" message: @"请先到系统“隐私”中打开相机权限" delegate: nil cancelButtonTitle: @"知道了" otherButtonTitles: nil];
        alert.delegate = self;
        alert.alertViewStyle = UIAlertActionStyleDefault;
        [alert show];
        return;
    }
    // 判断 iOS 版本是否超过8.0, 低于该版本无法从本地选取图片读取
    NSString *deviceVersion = [[UIDevice currentDevice] systemVersion];
    if ([deviceVersion floatValue] < 8.0) {
        // 低于该版本, 提示用户处理方法
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"用户提示" message: @"抱歉, 你当前的系统版本小于8.0, 不能从本地扫描二维码, 请升级系统版本或者使用当前摄像头扫描" delegate: nil cancelButtonTitle: @"知道了" otherButtonTitles: nil];
        alert.delegate = self;
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    } else {
        // 从相册中选择二维码图片
        if ( [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary] ) {
            UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
            pickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickerVC.delegate = self;
            // 转场动画
            pickerVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            //            [self presentViewController: pickerVC animated: YES completion: nil];
            [self.navigationController pushViewController: pickerVC animated: YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示" message: @"未知原因, 打开相册失败" delegate: nil cancelButtonTitle: @"知道了" otherButtonTitles: nil];
            alert.delegate = self;
            alert.alertViewStyle = UIAlertActionStyleDefault;
            [alert show];
            return ;
        }
    }
}

#pragma mark - Scan QRCode from local album  代理 UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 使用 CIDetector 处理 图片
    UIImage *QRCodeImage = info[UIImagePickerControllerOriginalImage];
    CIDetector *detector = [CIDetector detectorOfType: CIDetectorTypeQRCode context: nil options: @{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    [picker dismissViewControllerAnimated: YES completion:^{
        // 获取结果集
        NSArray *result = [detector featuresInImage: [CIImage imageWithCGImage: QRCodeImage.CGImage]];
        if (result.count > 0) {
            // 结果集元素
            CIQRCodeFeature *feature = [result objectAtIndex: 0];
            NSString *obj = feature.messageString;
            // 二维码信息处理
            NSLog(@"obj: %@", obj);
        }
    }];
}


#pragma mark - create QRCode                        生成二维码

- (void) createQRCode {
    
}

#pragma mark - create HDQRCode                      生成高清的二维码

- (void) createHDQRCode {
    
}

#pragma mark - save QRCode to local album           保存二维码到本地相册

- (void) saveQRCodeToAlbum {
    
}


@end
