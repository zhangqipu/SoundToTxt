//
//  ConvertViewController.h
//  QPSoundToTxt
//
//  Created by 张齐朴 on 15/10/3.
//  Copyright (c) 2015年 张齐朴. All rights reserved.
//

#import "BaseViewController.h"
#import <iflyMSC/iflyMSC.h>

@interface ConvertViewController : BaseViewController <IFlySpeechRecognizerDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSString *pchFilePath;

@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer; //不带界面的识别对象
@property (nonatomic, strong) NSString *result;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
