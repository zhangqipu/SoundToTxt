//
//  SelectFileController.h
//  QPSoundToTxt
//
//  Created by 张齐朴 on 15/10/1.
//  Copyright (c) 2015年 张齐朴. All rights reserved.
//

#import "BaseViewController.h"

@interface DataModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSNumber *size;

@end

@interface SelectFileController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *rootPath;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end
