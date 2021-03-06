//
//  UserViewController.m
//  Live直播
//
//  Created by cz on 16/11/8.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "UserViewController.h"
#import "LFLiveKit.h"

@interface UserViewController () <LFLiveSessionDelegate>
{
    LFLiveStreamInfo *_stream;
}

//推流
@property (nonatomic, strong) LFLiveSession *session;

//显示视频流的视图
@property (nonatomic, weak) UIView *livingPreView;

@end

@implementation UserViewController


- (UIView *)livingPreView
{
    if (!_livingPreView) {
        UIView *livingPreView = [[UIView alloc] initWithFrame:self.view.bounds];
        livingPreView.backgroundColor = [UIColor clearColor];
        livingPreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:livingPreView atIndex:0];
        _livingPreView = livingPreView;
    }
    return _livingPreView;
}

- (LFLiveSession*)session
{
    if(!_session)
    {
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2] liveType:LFLiveRTMP];
        
        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向竖屏 */
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(720, 1280);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 15;
         videoConfiguration.videoMaxKeyframeInterval = 30;
         videoConfiguration.orientation = UIInterfaceOrientationPortrait;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration liveType:LFLiveRTMP];
         */
        
        // 设置代理
        _session.delegate = self;
        _session.running = YES;
        _session.preView = self.livingPreView;
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.title = @"直播";
    self.view.backgroundColor = [UIColor blackColor];
    /*
     开始直播
     */
    _stream = [[LFLiveStreamInfo alloc] init];
    // 如果是跟我blog教程搭建的本地服务器, 记得填写你电脑的IP地址
    //推流的服务器地址
    _stream.url = @"rtmp://172.20.10.2:1935/rtmplive/room";
    
    
    //初始化按钮
    [self initUI];
    
    
}

- (void)initUI
{
    /**
     *  切换前后摄像头
     */
    UIButton *switchCamareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchCamareButton.frame = CGRectMake(20, self.view.frame.size.height - 120, 120, 50);
    [switchCamareButton setTitle:@"切换摄像头" forState:UIControlStateNormal];
    [switchCamareButton addTarget:self action:@selector(switchCamareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchCamareButton];
    
    UIButton *beautifulButton = [UIButton buttonWithType:UIButtonTypeCustom];
    beautifulButton.frame = CGRectMake(200, self.view.frame.size.height - 120, 120, 50);
    [beautifulButton setTitle:@"启动美颜" forState:UIControlStateNormal];
    [beautifulButton addTarget:self action:@selector(beautifulButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beautifulButton];
    
    UIButton *startCamareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startCamareButton.frame = CGRectMake(20, self.view.frame.size.height - 200, 120, 50);
    [startCamareButton setTitle:@"开始直播" forState:UIControlStateNormal];
    [startCamareButton addTarget:self action:@selector(switchStartButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startCamareButton];
    
    UIButton *endCamareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    endCamareButton.frame = CGRectMake(200, self.view.frame.size.height - 200, 120, 50);
    [endCamareButton setTitle:@"结束直播" forState:UIControlStateNormal];
    [endCamareButton addTarget:self action:@selector(switchEndButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endCamareButton];
    
}

#pragma mark - 开启关闭直播
- (void)switchStartButtonClick:(UIButton *)sender
{
    //开始推流
    [self.session startLive:_stream];
}

- (void)switchEndButtonClick:(UIButton *)sender
{
    //结束直播 --- 停止推流
    [self.session stopLive];
}

#pragma mark - 是否启动美颜
- (void)beautifulButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected)
    {
        //启动美颜
        self.session.beautyFace = YES;
    }
    else
    {
        //关闭美颜
        self.session.beautyFace = NO;
    }
}

#pragma mark - 前后摄像头切换
- (void)switchCamareButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    //后置
    if (btn.selected)
    {
        self.session.captureDevicePosition = AVCaptureDevicePositionBack;
    }
    //前置
    else
    {
        self.session.captureDevicePosition = AVCaptureDevicePositionFront;
    }
}

#pragma mark -- LFStreamingSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSString *tempStatus;
    switch (state) {
        case LFLiveReady:
            tempStatus = @"准备中";
            break;
        case LFLivePending:
            tempStatus = @"连接中";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            break;
        default:
            break;
    }
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    
}

@end
