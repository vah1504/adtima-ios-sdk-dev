//
//  VideoRollDemo.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by KhiemND on 9/5/18.
//  Copyright © 2018 WAD. All rights reserved.
//

#import "VideoRollDemo.h"
#import "Toast+UIView.h"
#import "SVProgressHUD.h"

#import <ZAD_AdtimaMobileSDK/Adtima.h>

@interface VideoRollDemo ()<ZAdsVideoRollListener>{
    ZAdsVideoRoll *videoRoll;
    NSArray *arrPreRolls;
    NSArray *arrMidRolls;
    NSArray *arrPostRolls;
    
    CGFloat durationMovive;// ? seconds
    CGFloat currentInSecond;
    CGFloat mCurrentPercent;
    NSTimer *mTrackingEventTimer;
    BOOL isPlayingVideo;
    
    BOOL mIsPreRollDisplayed;
    BOOL mIsMidRollDisplayed;
    BOOL mIsPostRollDisplayed;
}
@end

@implementation VideoRollDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self onActionShow:nil];
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

- (void)showLoading{
//    if (![SVProgressHUD isVisible]) {
//        [SVProgressHUD showWithStatus:@"Loading"];
//    }
    [self.view makeToast:@"Loading Video Roll"];
}

- (void)hideLoading{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

- (IBAction)onActionShow:(id)sender{
    [self showLoading];
    [self loadVideoRollAds];
    [self simulateVideoRollTracking];
}

- (IBAction)onActionRefresh:(id)sender{
    
}

- (void)loadVideoRollAds{
    videoRoll = [[ZAdsVideoRoll alloc] initWithZoneId:self.strZoneId];
    [videoRoll setAdsContentId:@"your-app-content-id"];
    [videoRoll addAdsTargeting:@"key-of-targeting" value:@"value-of-targeting"];
    
//    [FBAdSettings addTestDevice:[FBAdSettings testDeviceHash]];
    
    // Pre-roll setting
    [videoRoll setAdsPreRollSetting:MAX_ITEM value:2];
    [videoRoll setAdsPreRollSetting:MAX_ITEM_NON_SKIP value:1];
    [videoRoll setAdsPreRollSetting:TOTAL_DURATION_IN_SECS value:30];
    [videoRoll setAdsPreRollSetting:MAX_DURATION_PER_ITEM_IN_SECS value:30];
    [videoRoll setAdsPreRollSetting:TOTAL_SKIP_DURATION_IN_SECS value:10];
    
    //Mid-roll setting
    [videoRoll setAdsMidRollSetting:MAX_ITEM value:6];
    [videoRoll setAdsMidRollSetting:MAX_ITEM_NON_SKIP value:2];
    [videoRoll setAdsMidRollSetting:TOTAL_DURATION_IN_SECS value:180];
    [videoRoll setAdsMidRollSetting:MAX_DURATION_PER_ITEM_IN_SECS value:30];
    [videoRoll setAdsMidRollSetting:TOTAL_SKIP_DURATION_IN_SECS value:20];
    
    //Post-roll setting
    [videoRoll setAdsPostRollSetting:MAX_ITEM value:1];
    [videoRoll setAdsPostRollSetting:MAX_ITEM_NON_SKIP value:1];
    [videoRoll setAdsPostRollSetting:TOTAL_DURATION_IN_SECS value:30];
    [videoRoll setAdsPostRollSetting:MAX_DURATION_PER_ITEM_IN_SECS value:30];
    [videoRoll setAdsPostRollSetting:TOTAL_SKIP_DURATION_IN_SECS value:5];
    
    videoRoll.listener = self;
    [videoRoll loadAds];
}

- (void)simulateVideoRollTracking{
    NSLog(@"Start tracking Ad Video");
    durationMovive = 60;
    currentInSecond = 0;
    mIsPreRollDisplayed = NO;
    mIsMidRollDisplayed = NO;
    mIsPostRollDisplayed = NO;
    [self startVideoAdsTracker];
}

- (void)startVideoAdsTracker{
    @try {
        [self stopVideoAdsTracker];
        mTrackingEventTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(doTrackVideoAdsTracker) userInfo:nil repeats:YES];
        isPlayingVideo = YES;
    } @catch (NSException *exception) {
        
    }
}

- (void)stopVideoAdsTracker{
    if (mTrackingEventTimer) {
        [mTrackingEventTimer invalidate];
        mTrackingEventTimer = nil;
        isPlayingVideo = NO;
    }
}

- (void)doTrackVideoAdsTracker{
    @try {
        if (isPlayingVideo) {
            currentInSecond += 0.2;
            mCurrentPercent = currentInSecond *100/ durationMovive;
            if (currentInSecond >= durationMovive) {
                isPlayingVideo = NO;
                [self stopVideoAdsTracker];
                [self logProgress:@"Video progress: 100"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //Update UI
                NSString *message = [NSString stringWithFormat:@"Video progress: %d",(int)mCurrentPercent];
//                NSLog(@"%@",message);
                [self logProgress:message];
            });
            
            //track video post roll
            if (mCurrentPercent >= 85) {
                if (!mIsPostRollDisplayed) {
                    mIsPostRollDisplayed = YES;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //Update UI
                        [videoRoll haveAdsInventory];
                        if (arrPostRolls.count > 0) {
                            NSString *message = @"ADS_POST_ROLL_READY";
                            [self logEvent:message];
                            //simulate tracking postroll
                            [self logEvent:@"START TRACKING POST ROLL ADS"];
                            [self doSimulateTrackingArrVideoRolls:arrPostRolls];
                        } else{
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
                        [videoRoll haveAdsInventory];
                        
                        if (arrMidRolls.count > 0) {
                            NSString *message = @"ADS_MID_ROLL_READY";
                            [self logEvent:message];
                            //simulate tracking midroll
                            [self logEvent:@"START TRACKING MID ROLL ADS"];
                            [self doSimulateTrackingArrVideoRolls:arrMidRolls];
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
                        [videoRoll haveAdsInventory];
                        
                        if (arrPreRolls.count > 0) {
                            NSString *message = @"ADS_PRE_ROLL_READY";
                            [self logEvent:message];
                            //simulate tracking preroll
                            [self logEvent:@"START TRACKING PRE ROLL ADS"];
                            [self doSimulateTrackingArrVideoRolls:arrPreRolls];
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

- (void)logProgress:(NSString *)progress{
    self.lbProgress.text = progress;
}

- (void)logEvent:(NSString *)strEvent{
    if (strEvent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update UI
            NSString *log = [NSString stringWithFormat:@"\n%@",strEvent];
            _txtLog.text = [_txtLog.text stringByAppendingString:log];
            [self scrollTextViewToBottom:_txtLog];
        });
    }
}

-(void)scrollTextViewToBottom:(UITextView *)textView {
    if(textView.text.length > 0 ) {
        NSRange bottom = NSMakeRange(textView.text.length -1, 1);
        [textView scrollRangeToVisible:bottom];
    }
    
}

- (void)doSimulateTrackingArrVideoRolls:(NSArray *)arrAds{
    NSInteger indexItem = -1;
    double timeFire = 0;
    isPlayingVideo = NO;
    
    __weak VideoRollDemo *weakSelf = self;
    do {
        indexItem += 1;
        timeFire += indexItem * 500 * NSEC_PER_MSEC;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeFire), dispatch_get_main_queue(), ^{
            VideoRollDemo *strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            
            @try {
                id item = arrAds.count > indexItem ? [arrAds objectAtIndex:indexItem] : nil;
                if (!item) {
                    return;
                }
                [strongSelf logEvent:[NSString stringWithFormat:@"TRACKING ITEM %d", (int)indexItem]];
                if ([item isKindOfClass:[ZAdsAdtimaRollNative class]]) {
                    ZAdsAdtimaRollNative *rollNative = item;
                    NSString *mediaUrl = [rollNative getAdsMediaUrl];
                    [strongSelf logEvent:@"start tracking item adtima roll"];
                    [strongSelf logEvent:@"tracking ads request"];
                    [rollNative doAdsRequest:mediaUrl];
                    [strongSelf logEvent:@"tracking ads display"];
                    [rollNative doAdsDisplay:mediaUrl];
                    [strongSelf logEvent:@"tracking ads Start"];
                    [rollNative doAdsStart:mediaUrl];
                    [strongSelf logEvent:@"tracking ads pause"];
                    [rollNative doAdsPause:mediaUrl];
                    [strongSelf logEvent:@"tracking ads resume"];
                    [rollNative doAdsResume:mediaUrl];
                    [strongSelf logEvent:@"tracking ads complete"];
                    [rollNative doAdsComplete:mediaUrl];
                    [strongSelf logEvent:@"tracking ads close"];
                    [rollNative doAdsClose:mediaUrl];
                    [strongSelf logEvent:@"tracking ads click"];
                    //                [rollNative doAdsClick:mediaUrl];
                } else if ([item isKindOfClass:[ZAdsFacebookRollNative class]]){
                    ZAdsFacebookRollNative *rollNative = item;
                    NSString *placementId = [rollNative getAdsPlacementId];
                    [strongSelf logEvent:@"start tracking item facebook roll"];
                    [strongSelf logEvent:@"tracking ads request"];
                    [rollNative doAdsRequest:placementId];
                    [strongSelf logEvent:@"tracking ads display"];
                    [rollNative doAdsDisplay:placementId];
                    [strongSelf logEvent:@"tracking ads complete"];
                    [rollNative doAdsComplete:placementId];
                    [strongSelf logEvent:@"tracking ads close"];
                    [rollNative doAdsClose:placementId];
                    [strongSelf logEvent:@"tracking ads click"];
                    //                [rollNative doAdsClick:placementId];
                }
            } @catch (NSException *exception) {
                
            }
            strongSelf->isPlayingVideo = YES;
        });
    } while (indexItem < (arrAds.count - 1));
}

- (IBAction)onReloadAdVideoRoll:(id)sender{
    if(videoRoll){
        [videoRoll loadAds];
    }
}

#pragma mark - ZAdsVideoRoll delegate
- (void)onAdsVideoRollLoadFailed:(NSInteger)errorCode{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)onAdsVideoRollLoadFinished:(ZAdsVideoRollPosition)position ads:(NSArray *)ads{
//    if (position != PRE_ROLL){
//        return;
//    }
    NSString *strPosition = @"";
    switch (position) {
        case PRE_ROLL:
                strPosition = @"PREROLL";
            arrPreRolls = ads;
            break;
        case MID_ROLL:
            strPosition = @"MIDROLL";
            arrMidRolls = ads;
            break;
        case POST_ROLL:
            strPosition = @"POSTROLL";
            arrPostRolls = ads;
            break;
        default:
            break;
    }
    NSLog(@"--------------------------------\n%@",strPosition);
    if (ads == nil &&
        ads.count == 0) {
        NSLog(@"AD EMPTY");
    } else{
        BOOL stop = NO;
        for (id item in ads) {
//            if (stop == YES) {
//                return;
//            }
            if ([item isKindOfClass:[ZAdsAdtimaRollNative class]]) {
                ZAdsAdtimaRollNative *adtima = item;
                NSLog(@"-----INDEX: %d", (int)[ads indexOfObject:adtima]);
                NSLog(@"-----MEDIA FILE: %@", adtima.getAdsMediaUrl);
                NSLog(@"ALLOW SKIP: %@", adtima.isAdsAllowSkip ? @"TRUE" : @"FALSE");
                NSLog(@"SKIP AFTER IN SECS: %d", (int)adtima.getAdsSkipAfter);
                NSLog(@"DURATION IN SECS: %d", (int)adtima.getAdsMediaDuration);
//                NSLog(@"nDATA: %@", adtima.getAdsRawData);

//                // Simulate the event called
//                // Call display-event when render it in player
//                [adtima doAdsDisplay:adtima.getAdsMediaUrl];
//                // Call start-event when video start playing
//                [adtima doAdsStart:adtima.getAdsMediaUrl];
//                // Call pause-event when video pause (if any)
//                [adtima doAdsPause:adtima.getAdsMediaUrl];
//                // Call resume-event when video resume to play (if has paused)
//                [adtima doAdsResume:adtima.getAdsMediaUrl];
//
//                // Call progress-event by time in secs of video
//                 for (int j = 0; j <= adtima.getAdsMediaDuration; j ++) {
//                     [adtima doAdsProgressByTimeWithUrl:adtima.getAdsMediaUrl withSecond:j withDuration:adtima.getAdsMediaDuration];
//                 }
//
//                // Call click-event when user click to ad, then jump to landing page
////                [adtima doAdsClick:adtima.getAdsMediaUrl];
//                // Call complete-event when video completed
//                [adtima doAdsComplete:adtima.getAdsMediaUrl];
//                // Call close-event when ad has come over
//                [adtima doAdsClose:adtima.getAdsMediaUrl];
//
//                stop = YES;
            } else if ([item isKindOfClass:[ZAdsFacebookRollNative class]]){
//                continue;
                ZAdsFacebookRollNative *facebook = item;

                NSLog(@"-----INDEX: %d", (int)[ads indexOfObject:facebook]);
                NSLog(@"-----MEDIA FILE: %@", facebook.getAdsPlacementId);
                NSLog(@"ALLOW SKIP: %@", facebook.isAdsAllowSkip ? @"TRUE" : @"FALSE");
                NSLog(@"SKIP AFTER IN SECS: %d", (int)facebook.getAdsSkipAfter);
                NSLog(@"nDATA: %@", facebook.getAdsRawData);

//                // Simulate the event called
//                // Call display-event when render it in player
//                [facebook doAdsDisplay:facebook.getAdsPlacementId];
//
//                // Call click-event when user click to ad, then jump to landing page
////                [facebook doAdsClick:facebook.getAdsPlacementId];
//                // Call complete-event when video completed
//                [facebook doAdsComplete:facebook.getAdsPlacementId];
//                // Call close-event when ad has come over
//                [facebook doAdsClose:facebook.getAdsPlacementId];
            }  else if ([item isKindOfClass:[ZAdsIMARollNative class]]){
                //                continue;
                ZAdsIMARollNative *ima = item;
                
                NSLog(@"-----INDEX: %d", (int)[ads indexOfObject:ima]);
                NSLog(@"-----MEDIA FILE: %@", ima.getAdsPlacementId);
                NSLog(@"ALLOW SKIP: %@", ima.isAdsAllowSkip ? @"TRUE" : @"FALSE");
                NSLog(@"SKIP AFTER IN SECS: %d", (int)ima.getAdsSkipAfter);
                NSLog(@"nDATA: %@", ima.getAdsRawData);
                
//                // Simulate the event called
//                // Call display-event when render it in player
//                [ima doAdsDisplay:ima.getAdsPlacementId];
//                
//                // Call click-event when user click to ad, then jump to landing page
//                //                [facebook doAdsClick:facebook.getAdsPlacementId];
//                // Call complete-event when video completed
//                [ima doAdsComplete:ima.getAdsPlacementId];
//                // Call close-event when ad has come over
//                [ima doAdsClose:ima.getAdsPlacementId];
            }
        }
    }
}

- (BOOL)onAdsVideoRollContentHandler:(NSString *)contentScheme{
    // Return true if you want to handle content scheme (open in-app browser),
    // or return false if you not
    return NO;
}

#pragma mark - Orientation handling
- (BOOL)shouldAutorotate
{
    NSArray *supportedOrientationsInPlist = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UISupportedInterfaceOrientations"];
    BOOL isPortraitLeftSupported = [supportedOrientationsInPlist containsObject:@"UIInterfaceOrientationPortrait"];
    BOOL isPortraitRightSupported = [supportedOrientationsInPlist containsObject:@"UIInterfaceOrientationPortraitUpsideDown"];
    return isPortraitLeftSupported && isPortraitRightSupported;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    UIInterfaceOrientation currentInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return UIInterfaceOrientationIsPortrait(currentInterfaceOrientation) ? currentInterfaceOrientation : UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}
@end
