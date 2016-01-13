//
//  ViewController.m
//  QPSoundToTxt
//
//  Created by 张齐朴 on 15/10/1.
//  Copyright (c) 2015年 张齐朴. All rights reserved.
//
// 1.集成iFly
// 2.音频流转文字流程
// 3.加入录音
// 4.制作UI

#import "ViewController.h"
#import <iflyMSC/iflyMSC.h>
#import "ISRDataHelper.h"
#import "MenuLabel.h"
#import "HyPopMenuView.h"
#import "EnterMeetingController.h"
#import "SelectFileController.h"
#import "GLIRViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self showMenu];
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)showMenu {
//    
//    NSArray *Objs = @[
//                      [MenuLabel CreatelabelIconName:@"tabbar_compose_idea" Title:@"开始会议"],
//                      [MenuLabel CreatelabelIconName:@"tabbar_compose_photo" Title:@"生成笔记"],
//                      [MenuLabel CreatelabelIconName:@"tabbar_compose_camera" Title:@"查看笔记"],
//                      [MenuLabel CreatelabelIconName:@"tabbar_compose_lbs" Title:@"签到"],
//                      [MenuLabel CreatelabelIconName:@"tabbar_compose_review" Title:@"点评"],
//                      [MenuLabel CreatelabelIconName:@"tabbar_compose_more" Title:@"更多"]
//                      ];
//    CGFloat x,y,w,h;
//    x = CGRectGetWidth(self.view.bounds)/2 - 213/2;
//    y = CGRectGetHeight([UIScreen mainScreen].bounds)/2 * 0.3f;
//    w = 213;
//    h = 57;
//    //自定义的头部视图
//    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
////    topView.image = [UIImage imageNamed:@"compose_slogan"];
//    topView.contentMode = UIViewContentModeScaleAspectFit;
//    
//    NSMutableDictionary *AudioDictionary = [NSMutableDictionary dictionary];
//    
//    //添加弹出菜单音效
//    [AudioDictionary setObject:@"composer_open" forKey:kHyPopMenuViewOpenAudioNameKey];
//    [AudioDictionary setObject:@"wav" forKey:kHyPopMenuViewOpenAudioTypeKey];
//    //添加取消菜单音效
//    [AudioDictionary setObject:@"composer_close" forKey:kHyPopMenuViewCloseAudioNameKey];
//    [AudioDictionary setObject:@"wav" forKey:kHyPopMenuViewCloseAudioTypeKey];
//    //添加选中按钮音效
//    [AudioDictionary setObject:@"composer_select" forKey:kHyPopMenuViewSelectAudioNameKey];
//    [AudioDictionary setObject:@"wav" forKey:kHyPopMenuViewSelectAudioTypeKey];
//    
//    
//    [HyPopMenuView CreatingPopMenuObjectItmes:Objs TopView:nil OpenOrCloseAudioDictionary:AudioDictionary SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
//        
//        [self gotoControllerWithIndex:index];
//    }];
//    
//}
//
//- (void)gotoControllerWithIndex:(NSInteger)idx
//{
//    BaseViewController *vc = nil;
//    
//    switch (idx) {
//        case 0: {
//            vc = [[EnterMeetingController alloc] init];
//            break;
//        }
//        case 1: {
//            vc = [[SelectFileController alloc] init];
//            ((SelectFileController *)vc).rootPath = NSTemporaryDirectory();
//            break;
//        }
//        case 2: {
//            
//            break;
//        }
//            
//        default:
//            break;
//    }
//    
//    if (vc) [self presentViewController:vc animated:YES completion:nil];
//}


- (IBAction)meetingBeginAction:(id)sender
{
    EnterMeetingController *vc = [[EnterMeetingController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)meetingNoteAction:(id)sender
{
    SelectFileController *vc = [[SelectFileController alloc] init];
    vc.rootPath = NSTemporaryDirectory();
    [self presentViewController:vc animated:YES completion:nil];

}

@end
