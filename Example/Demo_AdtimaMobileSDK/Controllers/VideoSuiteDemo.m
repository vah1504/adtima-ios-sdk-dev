//
//  VideoSuiteDemo.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by Khiem Nguyen on 7/13/17.
//  Copyright © 2017 WAD. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "VideoSuiteDemo.h"
#import "TestViewVideo.h"
#import <ZAD_AdtimaMobileSDK/Adtima.h>

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVPlayerLayer.h>

#import "Masonry.h"


@interface VideoSuiteDemo ()<ZAdsVideoSuiteDelegate, ZAdsRollListener>{
    BOOL mIsPreRollDisplayed;
    BOOL mIsMidRollDisplayed;
    BOOL mIsPostRollDisplayed;
    float mCurrentPercent;
    CGFloat widthVideo;
    CGFloat heightVideo;
    NSString *strLog;
    AVPlayerItem *playerItem;
}
@property (nonatomic, weak) IBOutlet UILabel *lbTitle;
@property (nonatomic, weak) IBOutlet UITextView *textViewProgress;
@property (nonatomic, weak) IBOutlet UITextView *textViewEvent;
@property (nonatomic, strong) ZAdsVideoSuite *videoSuite;
@property (nonatomic, strong) TestView *viewPlayer;
@property (nonatomic, strong) AVPlayer *moviePlayer;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) NSTimer *mTrackingEventTimer;
@end

@implementation VideoSuiteDemo
@synthesize mTrackingEventTimer, videoSuite;
@synthesize textViewProgress, textViewEvent;
- (void)dealloc{
    [self.moviePlayer pause];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        NSLog(@"View controller was popped");
        [self stopVideoAdsTracker];
        if (self.videoSuite) {
            [self.videoSuite dismissAdsPreRoll];
            [self.videoSuite dismissAdsMidRoll];
            [self.videoSuite dismissAdsPostRoll];
        }
        [self.viewPlayer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (IBAction)appPause:(UIButton *)sender{
    NSLog(@"app Pause");
    if (videoSuite) {
        [videoSuite pauseAds];
    }
}

- (IBAction)appResume:(UIButton *)sender{
    NSLog(@"app resume");
    if (videoSuite) {
        [videoSuite resumeAds];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    textViewProgress.text = @"LOG PROGRESS:";
    textViewEvent.text = @"LOG EVENT";
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    widthVideo = window.bounds.size.width;
    heightVideo = window.bounds.size.width *9/16;
    
    if (self.viewPlayer) {
    }
    
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
    if (_strZoneId) {
        [self.videoSuite loadAds];
//        [self.videoSuite dismissAdsPreRoll];
//        [self.videoSuite dismissAdsMidRoll];
//        [self.videoSuite dismissAdsPostRoll];
    }
    [self startVideoAdsTracker];
//    [FBAdSettings addTestDevice:[FBAdSettings testDeviceHash]];
//    [FBAdSettings clearTestDevices];
}

- (void)loadVideoSuiteAds{
    videoSuite = [[ZAdsVideoSuite alloc] initWithZoneId:self.strZoneId];
    videoSuite.delegate = self;
    videoSuite.delegateRoll = self;
    [videoSuite setContentId:@"content-id"];
    [videoSuite addAdsTargeting:@"key-of-targeting" value:@"value-of-targeting"];
    
//    // Pre-roll setting
//    [videoSuite setAdsPreRollSetting:MAX_ITEM value:2];
//    [videoSuite setAdsPreRollSetting:MAX_ITEM_NON_SKIP value:1];
//    [videoSuite setAdsPreRollSetting:TOTAL_DURATION_IN_SECS value:30];
//    [videoSuite setAdsPreRollSetting:MAX_DURATION_PER_ITEM_IN_SECS value:30];
//    [videoSuite setAdsPreRollSetting:TOTAL_SKIP_AFTER_DURATION_IN_SECS value:10];
//
//    //Mid-roll setting
//    [videoSuite setAdsMidRollSetting:MAX_ITEM value:6];
//    [videoSuite setAdsMidRollSetting:MAX_ITEM_NON_SKIP value:2];
//    [videoSuite setAdsMidRollSetting:TOTAL_DURATION_IN_SECS value:180];
//    [videoSuite setAdsMidRollSetting:MAX_DURATION_PER_ITEM_IN_SECS value:30];
//    [videoSuite setAdsMidRollSetting:TOTAL_SKIP_AFTER_DURATION_IN_SECS value:20];
//
//    //Post-roll setting
//    [videoSuite setAdsPostRollSetting:MAX_ITEM value:1];
//    [videoSuite setAdsPostRollSetting:MAX_ITEM_NON_SKIP value:1];
//    [videoSuite setAdsPostRollSetting:TOTAL_DURATION_IN_SECS value:30];
//    [videoSuite setAdsPostRollSetting:MAX_DURATION_PER_ITEM_IN_SECS value:30];
//    [videoSuite setAdsPostRollSetting:TOTAL_SKIP_AFTER_DURATION_IN_SECS value:5];
//    [videoSuite set1AdPerRollView:YES];
    [videoSuite loadAds];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TestView *)viewPlayer{
    if (!_viewPlayer) {
        _viewPlayer = [[TestView alloc] init];
        _viewPlayer.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_viewPlayer];
        [_viewPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@(heightVideo));
//            make.top.left.right.and.bottom.equalTo(self.view);
        }];
    }
    return _viewPlayer;
}

- (void)logProgress:(NSString *)strProgress{
    if (strProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update UI
            NSString *log = [NSString stringWithFormat:@"\n%@",strProgress];
            textViewProgress.text = [textViewProgress.text stringByAppendingString:log];
            [self scrollTextViewToBottom:textViewProgress];
        });
    }
}

- (void)logEvent:(NSString *)strEvent{
    if (strEvent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update UI
            NSString *log = [NSString stringWithFormat:@"\n%@",strEvent];
            textViewEvent.text = [textViewEvent.text stringByAppendingString:log];
            [self scrollTextViewToBottom:textViewEvent];
        });
    }
}

-(void)scrollTextViewToBottom:(UITextView *)textView {
    if(textView.text.length > 0 ) {
        NSRange bottom = NSMakeRange(textView.text.length -1, 1);
        [textView scrollRangeToVisible:bottom];
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

- (void)startVideoAdsTracker{
    @try {
        [self stopVideoAdsTracker];
        mTrackingEventTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(doTrackVideoAdsTracker) userInfo:nil repeats:YES];
    } @catch (NSException *exception) {
        
    }
}

- (void)doTrackVideoAdsTracker{
    @try {
        if (self.moviePlayer &&
            (self.moviePlayer.rate != 0 && self.moviePlayer.error == nil)) {
            float durationInSecond = CMTimeGetSeconds(self.moviePlayer.currentItem.duration);
            float currentInSecond = CMTimeGetSeconds(self.moviePlayer.currentItem.currentTime);
            mCurrentPercent = currentInSecond *100/ durationInSecond;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //Update UI
                NSString *message = [NSString stringWithFormat:@"Video progress: %d",(int)mCurrentPercent];
                [self logProgress:message];
            });
            
            if (mCurrentPercent >= 85) {
                if (!mIsPostRollDisplayed) {
                    mIsPostRollDisplayed = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //Update UI
                        [self.videoSuite haveAdsInventory];
                        if (self.videoSuite.isAdsPostRollReady) {
                            NSString *message = @"ADS_POST_ROLL_READY";
                            [self logEvent:message];
                            [self.videoSuite showAdsPostRoll:self.viewPlayer];
                        }
                        else{
                            NSString *message = @"ADS_POST_ROLL_NOT_READY";
                            [self logEvent:message];
                        }
                    });
                }
            } else if (mCurrentPercent >= 45){
                if (!mIsMidRollDisplayed) {
                    mIsMidRollDisplayed = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //Update UI
                        [self.videoSuite haveAdsInventory];
                        if (self.videoSuite.isAdsMidRollReady) {
                            NSString *message = @"ADS_MID_ROLL_READY";
                            [self logEvent:message];
                            [self.videoSuite showAdsMidRoll:self.viewPlayer];
                        } else{
                            NSString *message = @"ADS_MID_ROLL_NOT_READY";
                            [self logEvent:message];
                        }
                    });
                }
            } else if (mCurrentPercent >= 5){
                if (!mIsPreRollDisplayed) {
                    mIsPreRollDisplayed = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //Update UI
                        [self.videoSuite haveAdsInventory];
                        if (self.videoSuite.isAdsPreRollReady) {
                            NSString *message = @"ADS_PRE_ROLL_READY";
                            [self logEvent:message];
                            [self.videoSuite showAdsPreRoll:self.viewPlayer];
                        } else{
                            NSString *message = @"ADS_PRE_ROLL_NOT_READY";
                            [self logEvent:message];
                        }
                    });
                }
            }
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)stopVideoAdsTracker{
    if (mTrackingEventTimer) {
        [mTrackingEventTimer invalidate];
        mTrackingEventTimer = nil;
    }
}

- (ZAdsVideoSuite *)videoSuite{
    if (!videoSuite) {
        videoSuite = [[ZAdsVideoSuite alloc] initWithZoneId:_strZoneId];
        videoSuite.delegate = self;
        videoSuite.delegateRoll = self;
        [videoSuite setContentId:@"http://adtima.vn"];
        
//        // Pre-roll setting
//        [videoSuite setAdsPreRollSetting:MAX_ITEM value:2];
//        [videoSuite setAdsPreRollSetting:MAX_ITEM_NON_SKIP value:1];
//        [videoSuite setAdsPreRollSetting:TOTAL_DURATION_IN_SECS value:30];
//        [videoSuite setAdsPreRollSetting:MAX_DURATION_PER_ITEM_IN_SECS value:30];
//        [videoSuite setAdsPreRollSetting:TOTAL_SKIP_AFTER_DURATION_IN_SECS value:10];
//        
//        //Mid-roll setting
//        [videoSuite setAdsMidRollSetting:MAX_ITEM value:6];
//        [videoSuite setAdsMidRollSetting:MAX_ITEM_NON_SKIP value:2];
//        [videoSuite setAdsMidRollSetting:TOTAL_DURATION_IN_SECS value:180];
//        [videoSuite setAdsMidRollSetting:MAX_DURATION_PER_ITEM_IN_SECS value:30];
//        [videoSuite setAdsMidRollSetting:TOTAL_SKIP_AFTER_DURATION_IN_SECS value:20];
//        
//        //Post-roll setting
//        [videoSuite setAdsPostRollSetting:MAX_ITEM value:1];
//        [videoSuite setAdsPostRollSetting:MAX_ITEM_NON_SKIP value:1];
//        [videoSuite setAdsPostRollSetting:TOTAL_DURATION_IN_SECS value:30];
//        [videoSuite setAdsPostRollSetting:MAX_DURATION_PER_ITEM_IN_SECS value:30];
//        [videoSuite setAdsPostRollSetting:TOTAL_SKIP_AFTER_DURATION_IN_SECS value:5];
        
        [videoSuite setAdsServingNumPerPosition:2];
    }
    return videoSuite;
}

- (IBAction)onLoadVideoSuite:(id)sender{
    [self.videoSuite loadAds];
}

- (void)onAdsLoadFinished{
    NSLog(@"onAdsLoadFinished");
}

- (void)onAdsLoadFailed:(NSInteger)errorCode{
    NSLog(@"onAdsLoadFailed:%ld", errorCode);
}

- (void)onAdsRollEvent:(int)event viewRoll:(VideoSuiteRoll)rollView{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (rollView == PreRoll) {
            if (event == EVENT_STARTED) {
                NSString *message = @"ADS_PRE_ROLL_STARTED";
                [self logEvent:message];
                [self.moviePlayer pause];
            } else if (event == EVENT_ERROR){
                NSString *message = @"ADS_PRE_ROLL_ERROR";
                [self logEvent:message];
                [self.videoSuite dismissAdsPreRoll];
                [self.moviePlayer play];
            } else if (event == EVENT_COMPLETED){
                NSString *message = @"ADS_PRE_ROLL_COMPLETED";
                [self logEvent:message];
                [self.videoSuite dismissAdsPreRoll];
                [self.moviePlayer play];
            } else if (event == EVENT_LOADED){
                NSString *message = @"ADS_PRE_ROLL_LOADED";
                [self logEvent:message];
            }
        } else if (rollView == MidRoll){
            if (event == EVENT_STARTED) {
                NSString *message = @"ADS_MID_ROLL_STARTED";
                [self logEvent:message];
                [self.moviePlayer pause];
            } else if (event == EVENT_ERROR){
                NSString *message = @"ADS_MID_ROLL_ERROR";
                [self logEvent:message];
                [self.videoSuite dismissAdsMidRoll];
                [self.moviePlayer play];
            } else if (event == EVENT_COMPLETED){
                NSString *message = @"ADS_MID_ROLL_COMPLETED";
                [self logEvent:message];
                [self.videoSuite dismissAdsMidRoll];
                [self.moviePlayer play];
            } else if (event == EVENT_LOADED){
                NSString *message = @"ADS_MID_ROLL_LOADED";
                [self logEvent:message];
            }
        } else if (rollView == PostRoll){
            if (event == EVENT_STARTED) {
                NSString *message = @"ADS_POST_ROLL_START";
                [self logEvent:message];
                [self.moviePlayer pause];
            } else if (event == EVENT_ERROR){
                NSString *message = @"ADS_POST_ROLL_ERROR";
                [self logEvent:message];
                [self.videoSuite dismissAdsPostRoll];
                [self.moviePlayer play];
            } else if (event == EVENT_COMPLETED){
                NSString *message = @"ADS_POST_ROLL_COMPLETED";
                [self logEvent:message];
                [self.videoSuite dismissAdsPostRoll];
                [self.moviePlayer play];
            } else if (event == EVENT_LOADED){
                NSString *message = @"ADS_POST_ROLL_LOADED";
                [self logEvent:message];
            }
        }
    });
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
//     {
//         
//     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
//     {
//         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//         switch (orientation) {
//             case UIInterfaceOrientationPortrait:
//                 [self videoMinimize];
//                 break;
//             case UIInterfaceOrientationLandscapeLeft:
//             case UIInterfaceOrientationLandscapeRight:
//                 [self videoFullscreen];
//                 break;
//             default:
//                 break;
//         }
//     }];
//}

- (void)videoMinimize:(NSTimeInterval)duration{
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update UI
            if (self.viewPlayer.superview &&
                self.viewPlayer.superview != self.view) {
                [self.viewPlayer removeFromSuperview];
                [self.view addSubview:self.viewPlayer];
                [self.viewPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view);
                    make.left.equalTo(self.view);
                    make.width.equalTo(self.view);
                    make.height.equalTo(@(heightVideo));
//                    make.top.left.right.and.bottom.equalTo(self.view);
                }];
                [_viewPlayer layoutIfNeeded]; // Ensures that all pending layout operations have been completed
                [UIView animateWithDuration:duration animations:^{
                    // Make all constraint changes here
                    [_viewPlayer layoutIfNeeded]; // Forces the layout of the subtree animation block and then captures all of the frame changes
                }];
            }
        });
    } @catch (NSException *exception) {
        
    }
}

- (void)videoFullscreen:(NSTimeInterval)duration{
    dispatch_async(dispatch_get_main_queue(), ^{
        //Update UI
         UIWindow *window = [[UIApplication sharedApplication].delegate window];
        if (window &&
            self.viewPlayer.superview &&
            self.viewPlayer.superview != window) {
            [self.viewPlayer removeFromSuperview];
            [window addSubview:self.viewPlayer];
            [self.viewPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.and.bottom.equalTo(window);
            }];
            
            [_viewPlayer layoutIfNeeded]; // Ensures that all pending layout operations have been completed
            [UIView animateWithDuration:duration animations:^{
                // Make all constraint changes here
                [_viewPlayer layoutIfNeeded]; // Forces the layout of the subtree animation block and then captures all of the frame changes
            }];
        }
    });
}

#pragma mark - Orientation handling

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            [self videoMinimize:duration];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [self videoFullscreen:duration];
            break;
        default:
            break;
    }
}
//- (BOOL)shouldAutorotate
//{
//    NSArray *supportedOrientationsInPlist = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UISupportedInterfaceOrientations"];
//    BOOL isPortraitLeftSupported = [supportedOrientationsInPlist containsObject:@"UIInterfaceOrientationPortrait"];
//    BOOL isPortraitRightSupported = [supportedOrientationsInPlist containsObject:@"UIInterfaceOrientationPortraitUpsideDown"];
//    return isPortraitLeftSupported && isPortraitRightSupported;
//    return NO;
//}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    UIInterfaceOrientation currentInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    return UIInterfaceOrientationIsPortrait(currentInterfaceOrientation) ? currentInterfaceOrientation : UIInterfaceOrientationPortrait;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
//}

@end
