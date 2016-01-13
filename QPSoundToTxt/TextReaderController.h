//
//  TextReaderController.h
//  QPSoundToTxt
//
//  Created by 张齐朴 on 15/10/5.
//  Copyright (c) 2015年 张齐朴. All rights reserved.
//

#import "BaseViewController.h"

@interface TextReaderController : BaseViewController

@property (nonatomic, strong) NSString *content;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
