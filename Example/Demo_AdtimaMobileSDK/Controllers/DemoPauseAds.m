//
//  DemoPauseAds.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by KhiemND on 8/28/19.
//  Copyright © 2019 WAD. All rights reserved.
//

#import "DemoPauseAds.h"
#import "TestViewVideo.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVPlayerLayer.h>
#import <ZAD_AdtimaMobileSDK/Adtima.h>

#import "Masonry.h"

#define STATUS_LOADING @"LOADING"
#define STATUS_LOAD_SUCCESS @"LOAD SUCCESS"
#define STATUS_LOAD_FAIL @"LOAD FAIL"

#define ZONE_ID @"2393988274209648789"

@interface DemoPauseAds ()<ZAdsBannerDelegate>{
    AVPlayerItem *playerItem;
    float mCurrentPercent;
    ZAdsBanner *banner;
    UIView *viewPause;
    UIButton *btnResumeLandscape;
    UIButton *btnPauseLandscape;
}
@property (nonatomic, strong) IBOutlet TestView *viewPlayer;
@property (nonatomic, strong) AVPlayer *moviePlayer;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, weak) IBOutlet UILabel *lbProgress;
@property (nonatomic, weak) IBOutlet UILabel *lbStatus;
@property (nonatomic, strong) NSTimer *mTrackingEventTimer;
@property (nonatomic, strong) UIView *viewBannerPause;
@property (nonatomic, weak) IBOutlet UIButton *btnResume;
@end

@implementation DemoPauseAds

- (BOOL)isiPhoneXFamily{
    BOOL result = NO;
    @try {
        do {
            if (@available(iOS 11.0, *)) {
                result = [UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 20;
            }
        } while (false);
    } @catch (NSException *exception) {
        
    }
    return result;
}

- (void)dealloc{
    NSLog(@"dealloc Demo Pause Banner");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        NSLog(@"View controller was popped");
        banner.delegate = nil;
        [banner dismiss];
        [banner removeFromSuperview];
        banner = nil;
        [self stopVideoAdsTracker];
        [self.viewPlayer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Demo Pause Ads";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapViewPlayer)];
    [self.viewPlayer addGestureRecognizer:tap];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"big_buck_bunny.mp4" ofType:nil]];
    AVAsset *assets = [AVURLAsset URLAssetWithURL:url options:nil];
    playerItem = [AVPlayerItem playerItemWithAsset:assets];
    self.moviePlayer = [AVPlayer playerWithPlayerItem:playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.viewPlayer.layer addSublayer:self.playerLayer];
    self.viewPlayer.layerPlayer = self.playerLayer;
    self.playerLayer.needsDisplayOnBoundsChange = YES;
    [self.moviePlayer play];
    
    viewPause = [[UIView alloc] initWithFrame:self.viewPlayer.bounds];
    viewPause.userInteractionEnabled = NO;
    viewPause.backgroundColor = [UIColor blackColor];
    viewPause.alpha = 0.4;
    viewPause.hidden = YES;
    [self.viewPlayer addSubview:viewPause];
    [viewPause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.viewPlayer);
    }];
    
    [self startVideoAdsTracker];
    [self logStatus:STATUS_LOADING];
    
    btnResumeLandscape = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnResumeLandscape setTitle:@"Resume Video" forState:UIControlStateNormal];
    [btnResumeLandscape addTarget:self action:@selector(onResumeVideo:) forControlEvents:UIControlEventTouchUpInside];
    btnResumeLandscape.hidden = YES;
    [self.viewPlayer addSubview:btnResumeLandscape];
    [btnResumeLandscape mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewPlayer).offset(15);
        make.left.equalTo(self.viewPlayer).offset(15);
    }];
    
    btnPauseLandscape = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnPauseLandscape setTitle:@"Pause Video" forState:UIControlStateNormal];
    [btnPauseLandscape addTarget:self action:@selector(onPauseVideo:) forControlEvents:UIControlEventTouchUpInside];
    btnPauseLandscape.hidden = YES;
    [self.viewPlayer addSubview:btnPauseLandscape];
    [btnPauseLandscape mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnResumeLandscape.mas_bottom).offset(10);
        make.left.equalTo(self.viewPlayer).offset(15);
    }];
}

- (void)addNewBanner{
    @try{
        if (!self.viewBannerPause) {
            return;
        }
        if (banner) {
            [banner dismiss];
            [banner removeFromSuperview];
            banner = nil;
        }
        
        banner = [[ZAdsBanner alloc] initWithParentViewController:self];
        [banner setSize:MEDIUM_RECTANGLE];
        [banner setZoneId:ZONE_ID];
        [banner setContentId:@"adtima_zaloads"];
        [banner setAdsAutoRefresh:NO];
        [banner setAdsVideoSoundOnPrefer:NO];
        [banner setAdsVideoAutoPlayPrefer:YES];
        [banner setAdsAudioAutoPlayPrefer:NO];
        [banner setAdsBorderEnable:NO];
        banner.clipsToBounds = YES;
        banner.delegate = self;
        
        [self.viewBannerPause addSubview:banner];        
        [banner loadAdsBanner];
        [self logStatus:STATUS_LOADING];
    } @catch (...){}
}

- (void)showViewBannerPause{
    @try{
        if (self.viewBannerPause) {
            [self dismissViewBannerPause];
        }
        
        if (!self.viewBannerPause) {
            CGFloat heightViewPause = self.viewPlayer.bounds.size.height - 20;
            CGFloat widthViewPause = floor(heightViewPause *300/250);
            
            BOOL isLandScape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
            
            if (isLandScape) {
                widthViewPause = 336;
                heightViewPause = 280;
            }
            
            self.viewBannerPause = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthViewPause, heightViewPause)];
            self.viewBannerPause.backgroundColor = [UIColor clearColor];
//            self.viewBannerPause.clipsToBounds = YES;
            
            [self addNewBanner];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            imgView.image = [UIImage imageNamed:@"ic_close_bt.png"];
            [self.viewBannerPause addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.viewBannerPause.mas_right);
                make.centerY.equalTo(self.viewBannerPause.mas_top);
                make.width.height.equalTo(@20);
            }];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapViewPlayer)];
            [imgView addGestureRecognizer:tap];
            
            [self.viewPlayer addSubview:self.viewBannerPause];
            [self.viewBannerPause mas_makeConstraints:^(MASConstraintMaker *make) {
                if (isLandScape) {
                    make.centerX.equalTo(self.viewPlayer);
                    CGFloat topView = floor(([[UIApplication sharedApplication].delegate window].bounds.size.height - heightViewPause) / 2);
                    make.top.equalTo(self.viewPlayer.mas_top).offset(topView);
                } else {
                    make.center.equalTo(self.viewPlayer);
                }
                make.width.equalTo(@(widthViewPause));
                make.height.equalTo(@(heightViewPause));
            }];
            self.viewBannerPause.hidden = YES;
        }
    } @catch (...){}
}

- (void)onTapViewPlayer{
    if ((self.viewBannerPause &&
         self.viewBannerPause.superview != nil) ||
        self.moviePlayer.rate <= 0
        ) {
        [self onResumeVideo:nil];
    }
}

- (void)dismissViewBannerPause{
    if (self.viewBannerPause) {
        if (banner) {
            [banner dismiss];
            banner.delegate = nil;
            [banner removeFromSuperview];
            banner = nil;
        }
        
        [self.viewBannerPause.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.viewBannerPause removeFromSuperview];
        self.viewBannerPause = nil;
    }
}

- (void)startVideoAdsTracker{
    @try {
        [self stopVideoAdsTracker];
        self.mTrackingEventTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(doTrackVideoAdsTracker) userInfo:nil repeats:YES];
    } @catch (NSException *exception) {
        
    }
}

- (void)stopVideoAdsTracker{
    if (self.mTrackingEventTimer) {
        [self.mTrackingEventTimer invalidate];
        self.mTrackingEventTimer = nil;
    }
}

- (void)doTrackVideoAdsTracker{
    @try {
        if (self.moviePlayer &&
            (self.moviePlayer.rate != 0 && self.moviePlayer.error == nil)) {
            float durationInSecond = CMTimeGetSeconds(self.moviePlayer.currentItem.duration);
            float currentInSecond = CMTimeGetSeconds(self.moviePlayer.currentItem.currentTime);
            if (durationInSecond > 0) {
                mCurrentPercent = currentInSecond *100/ durationInSecond;
            } else {
                mCurrentPercent = 0;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //Update UI
                NSString *message = [NSString stringWithFormat:@"Progress Video: %d",(int)mCurrentPercent];
                [self logProgress:message];
            });
        }
    } @catch (...){}
}

- (void)logProgress:(NSString *)message{
    self.lbProgress.text = message;
}

- (void)logStatus:(NSString *)status{
    if (status) {
        if ([status isEqualToString:STATUS_LOADING]) {
            self.lbStatus.textColor = [UIColor darkTextColor];
        } else if ([status isEqualToString:STATUS_LOAD_SUCCESS]){
            self.lbStatus.textColor = [UIColor greenColor];
        } else {
            self.lbStatus.textColor = [UIColor redColor];
        }
        self.lbStatus.text = status;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onPauseVideo:(id)sender{
    if (self.moviePlayer &&
        self.moviePlayer.rate > 0) {
        [self.moviePlayer pause];
        viewPause.hidden = NO;
        [self showViewBannerPause];
    }
}

- (IBAction)onResumeVideo:(id)sender{
    if (self.moviePlayer &&
        self.moviePlayer.rate  < 1) {
        [self.moviePlayer play];
    }
    viewPause.hidden = YES;
    [self dismissViewBannerPause];
}

- (void)onHideNavigationBar:(BOOL)shouldHide{
    [[self navigationController] setNavigationBarHidden:shouldHide animated:YES];
    if (shouldHide) {
        btnResumeLandscape.hidden = NO;
        btnPauseLandscape.hidden = NO;
    } else {
        btnResumeLandscape.hidden = YES;
        btnPauseLandscape.hidden = YES;
    }
    [self dismissViewBannerPause];
}

#pragma mark - device orientation
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            [self onHideNavigationBar:NO];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [self onHideNavigationBar:YES];
            break;
        default:
            break;
    }
}

#pragma mark - banner ad delegate
- (void)onBannerAdsLoadFinished:(NSString *)tag kind:(NSString *)type{
    [self logStatus:STATUS_LOAD_SUCCESS];
    if (self.viewBannerPause &&
        self.viewBannerPause.superview != nil) {
        self.viewBannerPause.hidden = NO;
        [banner bannerViewWillAppear];
        [banner show];
    }
}

- (void)onBannerAdsLoadFailed:(NSString *)tag error:(NSInteger)errorCode{
    NSString *strMessage = [NSString stringWithFormat:@"%@: %d",STATUS_LOAD_FAIL, (int)errorCode];
    [self logStatus:strMessage];
}

- (void)onBannerAdsClicked:(NSString *)tag{
    [self performSelector:@selector(dismissViewBannerPause) withObject:nil afterDelay:1.0];
}
@end
