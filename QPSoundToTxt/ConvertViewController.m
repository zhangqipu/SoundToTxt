//
//  ConvertViewController.m
//  QPSoundToTxt
//
//  Created by 张齐朴 on 15/10/3.
//  Copyright (c) 2015年 张齐朴. All rights reserved.
//

#import "ConvertViewController.h"
#import "ISRDataHelper.h"

@interface ConvertViewController ()

@property (nonatomic, assign) BOOL isSplited;
@property (nonatomic, assign) int currentIndex;

@end

@implementation ConvertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self splitAudioWithFileName:self.pchFilePath];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerKeyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self unregisterKeyboardNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  注册键盘通知
 */
- (void)registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/**
 *  取消键盘通知
 */
- (void)unregisterKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

/**
 *  键盘Frame变动回调函数
 */
- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    // 根据键盘高度改变输入框Frame
    NSDictionary *info       = [notification userInfo];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect   = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 如果变化了18 则frame 变化18 * 2
    // 如果已经变化则不做处理
    // 键盘回收，将开关志伟NO
    
    // 变化的Y值
    CGFloat changeY = CGRectGetMidY(endKeyboardRect) - CGRectGetMidY(beginKeyboardRect);
    
    [self.textView.superview setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.textView.frame = CGRectMake(CGRectGetMinX(self.textView.frame), CGRectGetMinY(self.textView.frame), CGRectGetWidth(self.textView.frame), CGRectGetHeight(self.textView.frame) + changeY);
}

- (void)startAudioStreamRecognizeWithPath:(NSString *)pcmFilePath
{
    [self initRecognizer];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (!pcmFilePath || [pcmFilePath length] == 0) {
        return;
    }
    
    if (![fm fileExistsAtPath:pcmFilePath]) {
        NSLog(@"==========================\n文件不存在%@", pcmFilePath);
        [self.activityView stopAnimating];
        return;
    }
    
    BOOL ret  = [_iFlySpeechRecognizer startListening];
    if (ret) {
        //启动发送数据线程
        [NSThread detachNewThreadSelector:@selector(sendAudioThreadWithPath:) toTarget:self withObject:pcmFilePath];
    }
    
}

- (void)initRecognizer
{
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        _iFlySpeechRecognizer.delegate = self;

        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:@"10000" forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:@"10000" forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        //设置语言
        [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        //            [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant ACCENT]];
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
        
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_STREAM forKey:@"audio_source"];    //设置音频数据模式为音频流

    }
}

- (void)sendAudioThreadWithPath:(NSString *)pcmFilePath
{
    NSData *data = [NSData dataWithContentsOfFile:pcmFilePath];    //从文件中读取音频
    
    long count = data.length / 10000; // 分割成10k 一次
    unsigned long audioLen = data.length/count;
    
    for (int i = 0 ; i < count - 1; i++) {    //分割音频
        char * part1Bytes = malloc(audioLen);
        NSRange range = NSMakeRange(audioLen*i, audioLen);
        [data getBytes:part1Bytes range:range];
        NSData * part1 = [NSData dataWithBytes:part1Bytes length:audioLen];
        
        int ret = [self.iFlySpeechRecognizer writeAudio:part1];//写入音频，让SDK识别
        free(part1Bytes);
        
        
        if(!ret) {     //检测数据发送是否正常
            [self.iFlySpeechRecognizer stopListening];
            
            return;
        }
    }
    
    //处理最后一部分
    unsigned long writtenLen = audioLen * (count-1);
    char * part3Bytes = malloc(data.length-writtenLen);
    NSRange range = NSMakeRange(writtenLen, data.length-writtenLen);
    [data getBytes:part3Bytes range:range];
    NSData * part3 = [NSData dataWithBytes:part3Bytes length:data.length-writtenLen];
    
    [_iFlySpeechRecognizer writeAudio:part3];
    free(part3Bytes);
    [_iFlySpeechRecognizer stopListening];//音频数据写入完成，进入等待状态
}

#pragma mark
#pragma mark IFly Delegate

/**
 开始识别回调
 ****/
- (void)onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
}

/**
 停止录音回调
 ****/
- (void)onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void)onError:(IFlySpeechError *) error
{
    NSLog(@"%@",[error errorDesc]);
    NSLog(@"%i", [error errorCode]);
    
    NSString *text ;
    
    if (error.errorCode == 0 ) {
        if (_result.length == 0) {
            text = @"无识别结果";
        } else {
            text = @"识别成功";
            [_iFlySpeechRecognizer destroy];
            _iFlySpeechRecognizer = nil;
            self.currentIndex++;
            [self startAudioStreamRecognizeWithPath:[NSString stringWithFormat:@"%@/%i.pcm", [[self.pchFilePath componentsSeparatedByString:@"."] firstObject], self.currentIndex]];

        }
    } else {
        text = [NSString stringWithFormat:@"发生错误：%d %@", error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }
    
    NSLog(@"%@", text);
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void)onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    _result = [NSString stringWithFormat:@"%@%@", _result == nil ? @"" : _result, resultFromJson];
    self.textView.text = _result;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView scrollRectToVisible:CGRectMake(0, self.textView.contentSize.height-30, CGRectGetWidth(self.textView.frame), 30) animated:YES];

    });
    
    if (isLast){
        NSLog(@"----------------------\n听写结果%@\n----------------------\n",  self.result);
//        self.textView.text = self.result;
    }
}

/**
 听写取消回调
 ****/
- (void)onCancel
{
    NSLog(@"识别取消");
}

#pragma 文件分割

- (void)splitAudioWithFileName:(NSString *)fileName
{
    // 如果文件超过了2M就进行分割，每个分割文件的大小事1M
    NSData *data = [NSData dataWithContentsOfFile:fileName];    //从文件中读取音频
    NSString *partFileName = nil;
    if (data.length > 2 * 1024 * 2024) {
        [self createDirAtTmpWithFileName:self.pchFilePath];
        
        long count = data.length / (1 * 1024 * 1024); // 分割成每个文件1M
        unsigned long audioLen = data.length / count;
        
        for (int i = 0 ; i < count - 1; i++) {    //分割音频
            char * part1Bytes = malloc(audioLen);
            NSRange range = NSMakeRange(audioLen*i, audioLen);
            [data getBytes:part1Bytes range:range];
            NSData * part1 = [NSData dataWithBytes:part1Bytes length:audioLen];
            
            partFileName = [NSString stringWithFormat:@"%@/%i.pcm", [[fileName componentsSeparatedByString:@"."] firstObject], i];
            [part1 writeToFile:partFileName atomically:YES];
            free(part1Bytes);
        }
        
        //处理最后一部分
        unsigned long writtenLen = audioLen * (count - 1);
        char * part3Bytes = malloc(data.length - writtenLen);
        NSRange range = NSMakeRange(writtenLen, data.length - writtenLen);
        [data getBytes:part3Bytes range:range];
        NSData * part3 = [NSData dataWithBytes:part3Bytes length:data.length - writtenLen];
        partFileName = [NSString stringWithFormat:@"%@/%lu.pcm", [[fileName componentsSeparatedByString:@"."] firstObject], count - 1];
        [part3 writeToFile:partFileName atomically:YES];
        free(part3Bytes);
        
        self.isSplited = YES;
        [self startAudioStreamRecognizeWithPath:[NSString stringWithFormat:@"%@/%i.pcm", [[self.pchFilePath componentsSeparatedByString:@"."] firstObject], self.currentIndex]];
    } else {
        [self startAudioStreamRecognizeWithPath:self.pchFilePath];
    }
}

- (void)createDirAtTmpWithFileName:(NSString *)fileName
{
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *filePath = [[fileName componentsSeparatedByString:@"."] firstObject];
    
    [fileManger createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
}

- (IBAction)saveButtonAction:(id)sender
{
    BOOL ret = [self.textView.text writeToFile:[NSString stringWithFormat:@"%@.txt", [[self.pchFilePath componentsSeparatedByString:@"."] firstObject]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (ret) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🍀保存成功"
                                                        message:[NSString stringWithFormat:@"请看(%@.txt)", [[[[self.pchFilePath componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."] firstObject]]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)textView:(nonnull UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nonnull NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}

@end
