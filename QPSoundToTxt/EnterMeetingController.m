//
//  EnterMeetingControllerX.m
//  QPSoundToTxt
//
//  Created by 张齐朴 on 15/10/5.
//  Copyright (c) 2015年 张齐朴. All rights reserved.
//

#import "EnterMeetingController.h"

@implementation EnterMeetingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavBar];

    [self initPcmRecorder];
    [self startRecord];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopRecord];
    [self cleanRipple];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createNavBar
{
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.alpha = 0.2;
    [self.view addSubview:self.navBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 100) / 2, 27, 100, 20)];
    label.text = @"正在录音...";
    label.textAlignment = NSTextAlignmentCenter;
    [self.navBar addSubview:label];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 34 + 30, 34);
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, - 20, 0, 5)];
    [backButton addTarget:self action:@selector(navBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navBar addSubview:backButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, CGRectGetWidth(self.navBar.frame), 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.navBar addSubview:lineView];
}

- (void)navBackAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initPcmRecorder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:NSTemporaryDirectory() error:nil];
    
    _pcmFilePath = [NSString stringWithFormat:@"%@录音文件%lu.pcm", NSTemporaryDirectory(), (unsigned long)files.count];
    
    _pcmRecorder = [IFlyPcmRecorder sharedInstance];
    _pcmRecorder.delegate = self;
    [_pcmRecorder setSaveAudioPath:_pcmFilePath];
}

- (void)startRecord
{
    [_pcmRecorder start];
}

- (void)stopRecord
{
    [_pcmRecorder stop];
}

#pragma mark

/**
 *  回调音频数据
 *
 *  @param buffer 音频数据
 *  @param size   表示音频的长度
 */
- (void) onIFlyRecorderBuffer: (const void *)buffer bufferSize:(int)size
{
    
}

/**
 *  回调音频的错误码
 *
 *  @param recoder 录音器
 *  @param error   错误码
 */
- (void) onIFlyRecorderError:(IFlyPcmRecorder*)recoder theError:(int) error
{
    NSLog(@"%i", error);
}

/**
 *  回调录音音量
 *
 *  @param power 音量值
 */
- (void) onIFlyRecorderVolumeChanged:(int) power
{
    NSLog(@"%i", power);
    if (abs(power - self.kvoPower) > 5) {
        self.kvoPower = power;
    
        CGFloat x = arc4random() % (int)CGRectGetWidth(self.view.frame);
        CGFloat y = arc4random() % (int)CGRectGetHeight(self.view.frame);

        CGPoint location = CGPointMake(x, y);
        [_ripple initiateRippleAtLocation:location];

    }
    
}

@end
