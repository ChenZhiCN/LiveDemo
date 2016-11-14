//
//  ShowViewController.m
//  Live直播
//
//  Created by cz on 16/11/6.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "ShowViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface ShowViewController ()

@property (nonatomic, strong) IJKFFMoviePlayerController *moivePlayerCtrl;

@end

@implementation ShowViewController

- (void)initBackBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"ba_back"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, 20, 40, 40);
    [btn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    self.title = self.anchor.myname;
    
    
    /*
     iOS8系统支持硬解码.
     
     软解码：CPU
     硬解码: 显卡的GPU, 硬解码可以避免手机发烫。
     */
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    //开启硬解码
    [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    
    if([self.type isEqualToString:@"映客"])
    {
        _moivePlayerCtrl = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:_anchor.stream_addr] withOptions:options];
    }
    else
    {
        _moivePlayerCtrl = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:_anchor.flv] withOptions:options];
    }
    
    _moivePlayerCtrl.view.frame = self.view.bounds;
    _moivePlayerCtrl.scalingMode = IJKMPMovieScalingModeFill;
    [self.view addSubview:_moivePlayerCtrl.view];
    
    //开始拉流
    [_moivePlayerCtrl prepareToPlay];
    [_moivePlayerCtrl play];
    
    
    //启动通知
    [self installMovieNotificationObservers];
    [self initBackBtn];
}


- (void)dealloc
{
    //关闭拉流
    [_moivePlayerCtrl shutdown];
    
    //移除通知
    [self removeMovieNotificationObservers];
}



#pragma mark - 通知方法
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _moivePlayerCtrl.loadState;
    
    ////状态为缓冲几乎完成，可以连续播放
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }
    ////缓冲中
    else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        /*
         这里主播可能已经结束直播了。我们需要请求服务器查看主播是否已经结束直播。
         方法：
         1、从服务器获取主播是否已经关闭直播。
         优点：能够正确的获取主播端是否正在直播。
         缺点：主播端异常crash的情况下是没有办法通知服务器该直播关闭的。
         2、用户http请求该地址，若请求成功表示直播未结束，否则结束
         优点：能够真实的获取主播端是否有推流数据
         缺点：如果主播端丢包率太低，但是能够恢复的情况下，数据请求同样是失败的。
         */
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}


- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}
- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    
#if 0
    //    NSLog(@"%@",notification);
    //    IJKMPMoviePlaybackStateStopped,        停止
    //    IJKMPMoviePlaybackStatePlaying,        正在播放
    //    IJKMPMoviePlaybackStatePaused,         暂停
    //    IJKMPMoviePlaybackStateInterrupted,    打断
    //    IJKMPMoviePlaybackStateSeekingForward, 快进
    //    IJKMPMoviePlaybackStateSeekingBackward 快退
    
    
    switch (self.player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"停止");
            break;
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"正在播放");
            break;
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"暂停");
            break;
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"打断");
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
            NSLog(@"快进");
            break;
        case IJKMPMoviePlaybackStateSeekingBackward:
            NSLog(@"快退");
            break;
        default:
            break;
    }
#endif
    
    switch (_moivePlayerCtrl.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_moivePlayerCtrl.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_moivePlayerCtrl.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_moivePlayerCtrl.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_moivePlayerCtrl.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_moivePlayerCtrl.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_moivePlayerCtrl.playbackState);
            break;
        }
    }
}
#pragma Install Notifiacation
- (void)installMovieNotificationObservers
{
    
    /*
     IJKFFMoviePlayerController 支持的通知有很多,常见的有:
     
     IJKMPMoviePlayerLoadStateDidChangeNotification(加载状态改变通知)
     IJKMPMoviePlayerPlaybackDidFinishNotification(播放结束通知)
     IJKMPMoviePlayerPlaybackStateDidChangeNotification(播放状态改变通知)
     */
    
    //监听加载状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_moivePlayerCtrl];
    //播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_moivePlayerCtrl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_moivePlayerCtrl];
    //播放状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_moivePlayerCtrl];
    
}
- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_moivePlayerCtrl];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_moivePlayerCtrl];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_moivePlayerCtrl];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_moivePlayerCtrl];
    
}


@end
