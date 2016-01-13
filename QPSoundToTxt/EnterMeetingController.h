//
//  EnterMeetingControllerX.h
//  QPSoundToTxt
//
//  Created by 张齐朴 on 15/10/5.
//  Copyright (c) 2015年 张齐朴. All rights reserved.
//

#import "GLIRViewController.h"
#import <iflyMSC/iflyMSC.h>

@interface EnterMeetingController : GLIRViewController <IFlyPcmRecorderDelegate>

@property (nonatomic, strong) UIView *navBar;

@property (nonatomic, strong) NSString *pcmFilePath; //音频文件路径
@property (nonatomic, strong) IFlyPcmRecorder *pcmRecorder; // 录音器

@property (nonatomic, assign) int kvoPower;

@end
