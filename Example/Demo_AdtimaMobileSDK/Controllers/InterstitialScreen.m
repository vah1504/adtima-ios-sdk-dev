//
//  InterstitialScreen.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by Khiem Nguyen on 7/7/17.
//  Copyright © 2017 WAD. All rights reserved.
//

#import "InterstitialScreen.h"
#import <ZAD_AdtimaMobileSDK/Adtima.h>
#import "SVProgressHUD.h"

extern NSString *kFbTestDevice;

@interface InterstitialScreen ()<ZAdsInterstitialDelegate>{
    ZAdsInterstitial *interstitial;
    BOOL clicking;
}
@property (nonatomic, weak) IBOutlet UILabel *lbStatus;
@end

@implementation InterstitialScreen

- (void)dealloc{
    interstitial.delegate = nil;
    interstitial = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lbStatus.text = @"NOT LOADED";
    self.lbStatus.textColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];

}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appWillResignActive{
//    if (interstitial) {
//        [interstitial dismiss];
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onLoadAd:(id)sender{
    if (clicking) {
        return;
    }
    else{
        clicking = YES;
    }
    [self initInterstitial];
    [self performSelector:@selector(showLoading) withObject:nil afterDelay:0.5];
    self.lbStatus.text = @"INITING";
    self.lbStatus.textColor = [UIColor blackColor];
}

- (IBAction)onShowAd:(id)sender{
    [interstitial haveAdsInventory];
    if (interstitial.isInterstitialAdsLoaded) {
        [interstitial show:self];
        self.lbStatus.text = @"SHOWN";
        self.lbStatus.textColor = [UIColor blackColor];
    }
}

- (IBAction)onDismissAd:(id)sender{
    [interstitial dismiss];
    interstitial = nil;
    self.lbStatus.text = @"NOT LOADED";
    self.lbStatus.textColor = [UIColor blackColor];
    clicking = NO;
}

- (void)showLoading{
//    if (!interstitial.isInterstitialAdsLoaded) {
//        [SVProgressHUD showWithStatus:@"Loading"];
//    }
    
}

- (void)initInterstitial{
    if (!interstitial) {
        interstitial = [[ZAdsInterstitial alloc] init];
    }
    [interstitial addAdsFacebookDevice:kFbTestDevice];
    [interstitial setAdsVideoAutoPlayPrefer:YES];
    [interstitial setAdsAudioAutoPlayPrefer:YES];
    [interstitial setAdsVideoSoundOnPrefer:NO];
    [interstitial addAdsTargeting:@"mp3" value:@"vitoiconsong"];
    [interstitial setZoneId:self.strZoneId];
    [interstitial setDelegate:self];
    
    [interstitial addAdsTargeting:@"category_id" value:@"11111"];
    [interstitial addAdsTargeting:@"category_name" value:@"News Category"];
    [interstitial addAdsTargeting:@"song_id" value:@"22222"];
    [interstitial addAdsTargeting:@"song_name" value:@"Song Name"];
    [interstitial addAdsTargeting:@"album_id" value:@"33333"];
    [interstitial addAdsTargeting:@"album_name" value:@"Album Name"];
    
    [interstitial addAdsTargeting:@"artist_id" value:@"44444"];
    [interstitial addAdsTargeting:@"artist_name" value:@"Artist Name"];
    
    [interstitial setAdsContentUrl:@"http://www.baomoi.com/nhung-pha-xu-ly-an-tuong-cua-ronaldo-nam-2016/r/21129105.epi"];
    [interstitial setContentId:@"http://adtima.vn"];
    
//    [FBAdSettings addTestDevice:[FBAdSettings testDeviceHash]];
//    [FBAdSettings clearTestDevices];
    
    [interstitial loadAdsInterstitial];
}

#pragma mark Delegate Interstitial
//================Delegate Interstitial======================

- (void)onInterstitialAdsLoadFinished:(NSString *)type {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            self.lbStatus.text = @"LOADED";
            self.lbStatus.textColor = [UIColor greenColor];
        });
    });
    NSLog(@"onInterstitialAdsLoadFinished - type = %@",type);
}

- (void)onInterstitialAdsLoadFailed:(NSInteger)errorCode {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        NSString *errorMessage = @"SDK_INIT_ERROR";
        switch (errorCode) {
            case -2:
            {
                errorMessage = @"CONNECT SERVER ERROR";
            }
                break;
            case -3:
            {
                errorMessage = @"NO FILL";
            }
                break;
            case -4:
            {
                errorMessage = @"NO ADS TO SHOW";
            }
                break;
            case -5:
            {
                errorMessage = @"SDK INITING";
            }
                break;
            default:
                break;
        }
        self.lbStatus.text = [NSString stringWithFormat:@"FAILED, code: %d %@",(long)errorCode, errorMessage];
        self.lbStatus.textColor = [UIColor redColor];
    });
    NSLog(@"onInterstitialAdsLoadFailed = %zi", errorCode);
    clicking = NO;
}

- (void)onInterstitialAdsOpened {
    NSLog(@"onInterstitialAdsOpened");
}

- (void)onInterstitialAdsClosed {
    NSLog(@"onInterstitialAdsClosed");
    clicking = NO;
}

- (void)onInterstitialAdsClicked{
    NSLog(@"onInterstitialAdsClicked");
    [interstitial dismiss];
    interstitial = nil;
//    [self performSelector:@selector(doDismissInters) withObject:nil afterDelay:1];
}

- (void)doDismissInters{
    [interstitial dismiss];
    interstitial = nil;
}

- (void)onInterstitialAdsInteracted {
    NSLog(@"onInterstitialAdsInteracted");
}
- (void)onInterstitialClickPlayVideo {
    NSLog(@"onInterstitialClickPlayVideo");
}

- (void)onInterstitialFinishPlayVideo {
    NSLog(@"onInterstitialFinishPlayVideo");
}

- (void)onInterstitialMuteVideo:(BOOL)isMute {
    if (isMute) {
        NSLog(@"sound Ads is OFF");
    } else{
        NSLog(@"sound Ads is ON");
    }
}

- (void)onInterstitialPauseVideo {
    NSLog(@"onInterstitialPauseVideo");
}

- (void)onInterstitialAdsVideoStage:(ZAdsVideoStage)stage{
    NSString *strStage = nil;
    
    switch (stage) {
        case OPENED:
        {
            strStage = @"OPENED";
        }
            break;
        case STARTED:
        {
            strStage = @"STARTED";
        }
            break;
        case COMPLETED:
        {
            strStage = @"COMPLETED";
        }
            break;
        case CLOSED:
        {
            strStage = @"CLOSED";
        }
            break;
        case ERROR:
        {
            strStage = @"ERROR";
        }
            break;
        case CLICK_TO_PLAY:
        {
            strStage = @"CLICK_TO_PLAY";
        }
            break;
        case AUTO_PLAY:
        {
            strStage = @"AUTO_PLAY";
        }
            break;
        default:
            break;
    }
    
    if (strStage != nil) {
        NSLog(@"AdsVideoStage: %@",strStage);
    }
}

- (void)onInterstitialAdsAudioStage:(ZAdsAudioStage)stage{
    NSString *strStage = nil;
    
    switch (stage) {
        case AUDIO_OPENED:
        {
            strStage = @"AUDIO_OPENED";
        }
            break;
        case AUDIO_STARTED:
        {
            strStage = @"AUDIO_STARTED";
        }
            break;
        case AUDIO_COMPLETED:
        {
            strStage = @"AUDIO_COMPLETED";
        }
            break;
        case AUDIO_CLOSED:
        {
            strStage = @"AUDIO_CLOSED";
        }
            break;
        case AUDIO_ERROR:
        {
            strStage = @"AUDIO_ERROR";
        }
            break;
        case AUDIO_CLICK_TO_PLAY:
        {
            strStage = @"AUDIO_CLICK_TO_PLAY";
        }
            break;
        case AUDIO_AUTO_PLAY:
        {
            strStage = @"AUDIO_AUTO_PLAY";
        }
            break;
        case AUDIO_PAUSED:
        {
            strStage = @"AUDIO_PAUSED";
        }
            break;
        case AUDIO_RESUMED:
        {
            strStage = @"AUDIO_RESUMED";
        }
            break;
        case AUDIO_SKIPPED:
        {
            strStage = @"AUDIO_SKIPPED";
        }
            break;
        default:
            break;
    }
    
    if (strStage != nil) {
        NSLog(@"AdsAudioStage: %@",strStage);
    }
}

- (void)onInterstitialAdsLeaveVideoFullscreen{
    NSLog(@"onInterstitialAdsLeaveVideoFullscreen");
}

@end
