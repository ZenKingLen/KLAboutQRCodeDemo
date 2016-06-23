//
//  ZKLQRCodeScanViewController.m
//  KLQRCodeScanDemo
//
//  Created by user on 16/5/16.
//  Copyright © 2016年 ZKL. All rights reserved.
//

#import "ZKLQRCodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ZKLQRCodeScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

// 使用扫描二维码, 需要导入框架  <AVFoundation/AVFoundation.h>
// 手机震动, 需要导入框架       <AudioToolbox/AudioToolbox.h>
/**
 *      输入输出流管道(控制输入输出流)
 */
@property (nonatomic, strong) AVCaptureSession *session;
/**
 *      显示捕获到的相机输出流
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preLayer;
/**
 *      获取摄像设备
 */
@property (nonatomic, strong) AVCaptureDevice *device;
/**
 *      创建输入流
 */
@property (nonatomic, strong) AVCaptureDeviceInput *input;
/**
 *      创建输出流
 */
@property (nonatomic, strong) AVCaptureMetadataOutput *output;

@end

@implementation ZKLQRCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    // 开始扫描二维码
    [self startScan];
    // 点击返回主界面
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismissMainView)];
    [self.view addGestureRecognizer: tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) dealloc {
    // 视图消失, 关闭通道
    [self.session stopRunning];
}

- (void) dismissMainView {
    [self dismissViewControllerAnimated: YES completion: nil];
}
// 开始扫描二维码
- (void) startScan {
    // 获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    // 创建输入流
    NSError *error = nil;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice: self.device error: &error];
    if (error) {
        NSLog(@"input error: %@", error);
    }
    // 创建输出流
    self.output = [AVCaptureMetadataOutput new];
    // 设置代理, 在主线程中刷新
    [self.output setMetadataObjectsDelegate:self queue: dispatch_get_main_queue()];
    // 初始化连接对象
    self.session = [AVCaptureSession new];
    // 设置高质量采集率
    [self.session setSessionPreset: AVCaptureSessionPresetHigh];
    // 输入输出流加入到会话中
    [self.session addInput: self.input];
    [self.session addOutput: self.output];
    // 设置扫描支持的编码格式
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    // 设置扫描layer
    self.preLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
    self.preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    self.preLayer.frame = CGRectMake((windowSize.width - 160)/4, windowSize.height/6 - 30, windowSize.width/2 + 80 , windowSize.height/2);
    [self.view.layer insertSublayer: self.preLayer atIndex:0];
    self.preLayer.cornerRadius = 10;
    self.preLayer.borderColor = [UIColor orangeColor].CGColor; ;
    self.preLayer.borderWidth = 3;
    // 启动管道, 开始捕获
    [self.session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

// 扫描二维码
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 判断是否存在数据
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = [metadataObjects lastObject];
        // 二维码扫描信息处理
        NSLog(@"obj --> %@", obj);
    }
}



@end
