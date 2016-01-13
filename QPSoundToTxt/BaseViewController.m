//
//  BaseViewController.m
//  QPSoundToTxt
//
//  Created by 张齐朴 on 15/10/1.
//  Copyright (c) 2015年 张齐朴. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavBar];
}

- (void)createNavBar
{
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    self.navBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
