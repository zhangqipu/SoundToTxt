//
//  TextReaderController.m
//  QPSoundToTxt
//
//  Created by 张齐朴 on 15/10/5.
//  Copyright (c) 2015年 张齐朴. All rights reserved.
//

#import "TextReaderController.h"

@interface TextReaderController ()

@end

@implementation TextReaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textView.text = self.content;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navBar.alpha = 0.4;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navBar.alpha = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
