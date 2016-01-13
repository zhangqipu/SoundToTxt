//
//  SelectFileController.m
//  QPSoundToTxt
//
//  Created by 张齐朴 on 15/10/1.
//  Copyright (c) 2015年 张齐朴. All rights reserved.
//

#import "SelectFileController.h"
#import "ConvertViewController.h"
#import "TextReaderController.h"

@implementation DataModel

@end

@interface SelectFileController ()

@end

@implementation SelectFileController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configDataSource
{
    /*
     {
     NSFileCreationDate = "2015-10-06 02:40:54 +0000";
     NSFileExtensionHidden = 0;
     NSFileGroupOwnerAccountID = 501;
     NSFileGroupOwnerAccountName = mobile;
     NSFileModificationDate = "2015-10-06 02:40:57 +0000";
     NSFileOwnerAccountID = 501;
     NSFileOwnerAccountName = mobile;
     NSFilePosixPermissions = 420;
     NSFileProtectionKey = NSFileProtectionCompleteUntilFirstUserAuthentication;
     NSFileReferenceCount = 1;
     NSFileSize = 89290;
     NSFileSystemFileNumber = 3847869;
     NSFileSystemNumber = 16777218;
     NSFileType = NSFileTypeRegular;
     }
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:self.rootPath error:nil];
    NSString *tmpPath = NSTemporaryDirectory();
    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableArray *arr2 = [NSMutableArray array];
    NSMutableArray *arr3 = [NSMutableArray array];
    
    self.dataSource = nil;
    self.dataSource = [NSMutableArray array];
    
    for (NSString *fileName in fileNames) {
        NSDictionary *attr = [fileManager attributesOfItemAtPath:
                              [NSString stringWithFormat:@"%@%@", tmpPath, fileName] error:nil];
        
        NSDate *time = attr[NSFileCreationDate];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        DataModel *dataModel = [[DataModel alloc] init];
        dataModel.name = fileName;
        dataModel.time = [formatter stringFromDate:time];
        dataModel.size = attr[NSFileSize];
        
        if ([fileName hasSuffix:@".pcm"]) {
            [arr1 addObject:dataModel];
        } else if ([fileName hasSuffix:@".txt"]) {
            [arr2 addObject:dataModel];
        } else {
            [arr3 addObject:dataModel];
        }
    }
    
    [self.dataSource addObject:arr1];
    [self.dataSource addObject:arr2];
    [self.dataSource addObject:arr3];
    
    [self.tableView reloadData];
}

#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellId];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    }
    
    DataModel *model = self.dataSource[indexPath.section][indexPath.row];
    
    NSString *fileName = model.name;
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = [self getDetailTextWithTime:model.time andSize:model.size];
    
    if ([fileName hasSuffix:@".pcm"]) {
        cell.imageView.image = [UIImage imageNamed:@"music"];
    } else if ([fileName hasSuffix:@".txt"]) {
        cell.imageView.image = [UIImage imageNamed:@"text"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"what"];
    }
    
    return cell;
}

- (NSString *)getDetailTextWithTime:(NSString *)time andSize:(NSNumber *)size
{
    NSString *retStr = [time substringToIndex:19];
    int s = [size intValue] / 1024;
    
    if (s > 1024) {
        retStr = [retStr stringByAppendingFormat:@"    %iM", s / 1024];
    } else {
        retStr = [retStr stringByAppendingFormat:@"    %iK", s];
    }
    
    return retStr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取选中音频路径
    // 跳转到语音文字转换界面
    DataModel *model = self.dataSource[indexPath.section][indexPath.row];

    NSString *filePath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), model.name];
    
    if ([filePath hasSuffix:@".pcm"]) {
        ConvertViewController *vc = [[ConvertViewController alloc] init];
        vc.pchFilePath = filePath;
        [self presentViewController:vc animated:YES completion:nil];
        
    } else if ([filePath hasSuffix:@".txt"]) {
        TextReaderController *vc = [[TextReaderController alloc] init];
        
        NSString *textContent = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        vc.content = textContent;
        
        [self presentViewController:vc animated:YES completion:nil];
        
    } else {
//        SelectFileController *vc = [[SelectFileController alloc] init];
//        vc.rootPath = filePath;
//        [self presentViewController:vc animated:YES completion:nil];
//        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath      {
    return  UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.dataSource[section] count] > 0) {
    if (section == 0) {
        return @"音频";
    } else if (section == 1) {
        return @"文本";
    } else {
        return @"其它";
    }
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteLocalFileWithIndexPath:indexPath];
    [self.dataSource[indexPath.section] removeObjectAtIndex:indexPath.row];
    
    [tableView reloadData];
}

- (void)deleteLocalFileWithIndexPath:(NSIndexPath *)indexPath
{
    DataModel *model = self.dataSource[indexPath.section][indexPath.row];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), model.name] error:nil];
}

@end
