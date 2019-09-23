//
//  VideoRollOneDemo.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by KhiemND on 4/4/19.
//  Copyright © 2019 WAD. All rights reserved.
//

#import "VideoRollOneDemo.h"
#import <ZAD_AdtimaMobileSDK/Adtima.h>

#import "Masonry.h"

@interface VideoRollOneDemo ()<ZAdsVideoRollOneDelegate>{
    IBOutlet UIView *viewContainer;
    IBOutlet UIButton *btnPlay;
    IBOutlet UILabel *lbProgress;
    IBOutlet UITextView *tvLog;
    
    NSString *textProgress;
    NSString *textLog;
    ZAdsVideoRollOne *videoRollOne;
    BOOL isLoadingAd;
    BOOL isPlayingAd;
    
    id adVideoNative;
}
@end

@implementation VideoRollOneDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildTextProgress:0];
    textLog = @"";
    tvLog.text = textLog;
    isLoadingAd = NO;
    isPlayingAd = NO;
    [self initVideoRoll];
}

#pragma mark - init methods
- (void)initVideoRoll{
    if (!self.strZoneId) {
        self.strZoneId = @"";
    }
    videoRollOne = [[ZAdsVideoRollOne alloc] initWithZoneId:self.strZoneId];
    [videoRollOne setAdsContentId:@"your-app-content-id"];
    [videoRollOne addAdsTargeting:@"key-of-targeting" value:@"value-of-targeting"];
    videoRollOne.listener = self;
}

- (void)doLoadAd{
    if (!videoRollOne) {
        [self initVideoRoll];
    }
    isLoadingAd = YES;
    [videoRollOne loadAds];
}

#pragma mark - selector methods
- (IBAction)onLoadAd:(id)sender{
    if (!isLoadingAd) {
        [self doLoadAd];
    }
}

- (IBAction)onPlayAd:(id)sender{
    if (videoRollOne.isAdsLoaded &&
        adVideoNative) {
        [self doAdsDisplay];
        [self doAdsStart];
        [self doAdsPause];
        [self doAdsResume];
//        [self doAdsClick];
        if ([adVideoNative isKindOfClass:[ZAdsFacebookRollNative class]] ||
            [adVideoNative isKindOfClass:[ZAdsIMARollNative class]]) {
            [self buildTextProgress:100];
            [self doAdsComplete];
            [self doAdsClose];
        } else{
            CGFloat duration = 30.0f;
            __block CGFloat time = 0.0;
            for(int i = 1; i <= duration; i ++){
                __weak VideoRollOneDemo *weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    do {
                        time += 1;
                        VideoRollOneDemo *strongSelf = weakSelf;
                        if (!strongSelf) {
                            break;
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf doAdsProgressByTimewithSecond:time withDuration:duration];
                            [strongSelf buildTextProgress:time*100.0/duration];
                            if (time == duration) {
                                [self doAdsComplete];
                                [self doAdsClose];
                            }
                        });
                    } while (false);
                });
            }
        }
    }
}

#pragma mark - build UIs
- (void)buildTextProgress:(CGFloat)progress{
    textProgress = [NSString stringWithFormat:@"Video Progress: %.0f",progress];
    lbProgress.text = textProgress;
}

- (void)addLogEvent:(NSString *)event{
    if (!event ||
        event.length == 0) {
        return;
    }
    if (textLog.length == 0) {
        textLog = event;
    }else {
        textLog = [NSString stringWithFormat:@"%@\n%@",textLog,event];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //Update UI
        tvLog.text = textLog;
        [self scrollTextViewToBottom:tvLog];
    });
}

-(void)scrollTextViewToBottom:(UITextView *)textView {
    if(textView.text.length > 0 ) {
        NSRange bottom = NSMakeRange(textView.text.length -1, 1);
        [textView scrollRangeToVisible:bottom];
    }
}

#pragma mark - Video Roll One Delegates
- (BOOL)onAdsVideoRollOneContentHandler:(NSString *)contentScheme{
    return NO;
}

- (void)onAdsVideoRollOneLoadFailed:(NSInteger)errorCode{
    isLoadingAd = NO;
    NSString *message = @"";
    if (errorCode == SDK_INIT_ERROR ||
        errorCode == SDK_INIT_WAITING) {
        message = @"SDK_INIT_ERROR";
    } else if(errorCode == SDK_GET_ADS_ERROR){
        message = @"SDK_GET_ADS_ERROR";
    } else if(errorCode == SDK_RENDER_ADS_ERROR){
        message = @"SDK_RENDER_ADS_ERROR";
    } else if (errorCode == SDK_NO_ADS_TO_SHOW){
        message = @"SDK_NO_ADS_TO_SHOW";
    }
    [self addLogEvent:message];
}

- (void)onAdsVideoRollOneLoadFinished:(id)ad{
    isLoadingAd = NO;
    NSString *message = @"SDK_LOAD_AD_SUCCESS";
    NSString *className = @"";
    className = NSStringFromClass([ad class]);
    
    message = [NSString stringWithFormat:@"%@\nOBJECT IS %@", message, className];
    [self addLogEvent:message];
    
    adVideoNative = ad;
    
    if ([ad isKindOfClass:[ZAdsAdtimaRollNative class]]) {
        ZAdsAdtimaRollNative *adtima = (ZAdsAdtimaRollNative *) ad;
        [self addLogEvent:[NSString stringWithFormat:@"MEDIA FILE: %@", adtima.getAdsMediaUrl]];
        [self addLogEvent:[NSString stringWithFormat:@"ALLOW SKIP: %@", adtima.isAdsAllowSkip ? @"YES" : @"NO"]];
        [self addLogEvent:[NSString stringWithFormat:@"SKIP AFTER IN SECS: %d", (int)adtima.getAdsSkipAfter]];
        [self addLogEvent:[NSString stringWithFormat:@"DURATION IN SECS: %d", (int)adtima.getAdsMediaDuration]];
//        [self addLogEvent:[NSString stringWithFormat:@"DATA: %@", adtima.getAdsRawData]];

//        //Simulate the event called
//        //Call display-event when render it in player
//        [adtima doAdsDisplay:adtima.getAdsMediaUrl];
//        //Call start-event when video start playing
//        [adtima doAdsStart:adtima.getAdsMediaUrl];
//        //Call pause-event when video pause (if any)
//        [adtima doAdsPause:adtima.getAdsMediaUrl];
//        //Call resume-event when video resume to play (if has paused)
//        [adtima doAdsResume:adtima.getAdsMediaUrl];
//        // Call progress-event by percentage of video
//        for (int i = 0; i <= adtima.getAdsMediaDuration; i ++) {
//            [adtima doAdsProgressByTimeWithUrl:adtima.getAdsMediaUrl withSecond:i withDuration:adtima.getAdsMediaDuration];
//        }
//        // Call click-event when user click to ad, then jump to landing page
//        [adtima doAdsClick:adtima.getAdsMediaUrl];
//        // Call complete-event when video completed
//        [adtima doAdsComplete:adtima.getAdsMediaUrl];
//        // Call close-event when ad has come over
//        [adtima doAdsClose:adtima.getAdsMediaUrl];
    } else if ([ad isKindOfClass:[ZAdsFacebookRollNative class]]){
        ZAdsFacebookRollNative *facebook = (ZAdsFacebookRollNative *)ad;
        [self addLogEvent:[NSString stringWithFormat:@"PLACEMENT ID: %@", facebook.getAdsPlacementId]];
        [self addLogEvent:[NSString stringWithFormat:@"ALLOW SKIP: %@", facebook.isAdsAllowSkip ? @"YES" : @"NO"]];
        [self addLogEvent:[NSString stringWithFormat:@"SKIP AFTER IN SECS: %d", (int)facebook.getAdsSkipAfter]];
//        [self addLogEvent:[NSString stringWithFormat:@"DATA: %@", facebook.getAdsRawData]];

        //Simulate the event called
        //Call display-event when render it in player
//        [facebook doAdsDisplay:facebook.getAdsPlacementId];
//        // Call click-event when user click to ad, then jump to landing page
//        [facebook doAdsClick:facebook.getAdsPlacementId];
//        // Call complete-event when video completed
//        [facebook doAdsComplete:facebook.getAdsPlacementId];
//        // Call close-event when ad has come over
//        [facebook doAdsClose:facebook.getAdsPlacementId];
    } else if ([ad isKindOfClass:[ZAdsIMARollNative class]]){
        ZAdsIMARollNative *ima = (ZAdsIMARollNative *)ad;
        [self addLogEvent:[NSString stringWithFormat:@"PLACEMENT ID: %@", ima.getAdsPlacementId]];
        [self addLogEvent:[NSString stringWithFormat:@"ALLOW SKIP: %@", ima.isAdsAllowSkip ? @"YES" : @"NO"]];
        [self addLogEvent:[NSString stringWithFormat:@"SKIP AFTER IN SECS: %d", (int)ima.getAdsSkipAfter]];
//        [self addLogEvent:[NSString stringWithFormat:@"DATA: %@", ima.getAdsRawData]];

//        //Simulate the event called
//        //Call display-event when render it in player
//        [ima doAdsDisplay:ima.getAdsPlacementId];
//        // Call click-event when user click to ad, then jump to landing page
//        [ima doAdsClick:ima.getAdsPlacementId];
//        // Call complete-event when video completed
//        [ima doAdsComplete:ima.getAdsPlacementId];
//        // Call close-event when ad has come over
//        [ima doAdsClose:ima.getAdsPlacementId];
    }
}

#pragma mark - function track video ad
- (void)doAdsRequest{
    do {
        @try {
            if (!adVideoNative) {
                break;
            }
            NSString *textCheck = @"";
            if ([adVideoNative respondsToSelector:@selector(getAdsMediaUrl)]) {
                textCheck = [adVideoNative getAdsMediaUrl];
            }
            if ([adVideoNative respondsToSelector:@selector(doAdsRequest:)]) {
                [adVideoNative doAdsRequest:textCheck];
            } else {
                break;
            }
            NSString *event = NSStringFromSelector(_cmd);
            [self addLogEvent:event];
        } @catch (NSException *exception) {
            
        }
    } while (false);
}

- (void)doAdsDisplay{
    do {
        @try {
            if (!adVideoNative) {
                break;
            }
            NSString *textCheck = @"";
            if ([adVideoNative respondsToSelector:@selector(getAdsMediaUrl)]) {
                textCheck = [adVideoNative getAdsMediaUrl];
            }
            if ([adVideoNative respondsToSelector:@selector(doAdsDisplay:)]) {
                [adVideoNative doAdsDisplay:textCheck];
            } else {
                break;
            }
            NSString *event = NSStringFromSelector(_cmd);
            [self addLogEvent:event];
        } @catch (NSException *exception) {
            
        }
    } while (false);
}

- (void)doAdsStart{
    do {
        @try {
            if (!adVideoNative) {
                break;
            }
            NSString *textCheck = @"";
            if ([adVideoNative respondsToSelector:@selector(getAdsMediaUrl)]) {
                textCheck = [adVideoNative getAdsMediaUrl];
            }
            if ([adVideoNative respondsToSelector:@selector(doAdsStart:)]) {
                [adVideoNative doAdsStart:textCheck];
            } else {
                break;
            }
            NSString *event = NSStringFromSelector(_cmd);
            [self addLogEvent:event];
        } @catch (NSException *exception) {
            
        }
    } while (false);
}

- (void)doAdsProgressByTimewithSecond:(NSInteger)second withDuration:(NSInteger)duration{
    do {
        @try {
            if (!adVideoNative) {
                break;
            }
            NSString *textCheck = @"";
            if ([adVideoNative respondsToSelector:@selector(getAdsMediaUrl)]) {
                textCheck = [adVideoNative getAdsMediaUrl];
            }
            if ([adVideoNative respondsToSelector:@selector(doAdsProgressByTimeWithUrl:withSecond:withDuration:)]) {
                [adVideoNative doAdsProgressByTimeWithUrl:textCheck withSecond:second withDuration:duration];
            } else {
                break;
            }
            NSString *event = NSStringFromSelector(_cmd);
            [self addLogEvent:event];
        } @catch (NSException *exception) {
            
        }
    } while (false);
}

- (void)doAdsPause{
    do {
        @try {
            if (!adVideoNative) {
                break;
            }
            NSString *textCheck = @"";
            if ([adVideoNative respondsToSelector:@selector(getAdsMediaUrl)]) {
                textCheck = [adVideoNative getAdsMediaUrl];
            }
            if ([adVideoNative respondsToSelector:@selector(doAdsPause:)]) {
                [adVideoNative doAdsPause:textCheck];
            } else {
                break;
            }
            NSString *event = NSStringFromSelector(_cmd);
            [self addLogEvent:event];
        } @catch (NSException *exception) {
            
        }
    } while (false);
}

- (void)doAdsResume{
    do {
        @try {
            if (!adVideoNative) {
                break;
            }
            NSString *textCheck = @"";
            if ([adVideoNative respondsToSelector:@selector(getAdsMediaUrl)]) {
                textCheck = [adVideoNative getAdsMediaUrl];
            }
            if ([adVideoNative respondsToSelector:@selector(doAdsResume:)]) {
                [adVideoNative doAdsResume:textCheck];
            } else {
                break;
            }
            NSString *event = NSStringFromSelector(_cmd);
            [self addLogEvent:event];
        } @catch (NSException *exception) {
            
        }
    } while (false);
}

- (void)doAdsComplete{
    do {
        @try {
            if (!adVideoNative) {
                break;
            }
            NSString *textCheck = @"";
            if ([adVideoNative respondsToSelector:@selector(getAdsMediaUrl)]) {
                textCheck = [adVideoNative getAdsMediaUrl];
            }
            if ([adVideoNative respondsToSelector:@selector(doAdsComplete:)]) {
                [adVideoNative doAdsComplete:textCheck];
            } else {
                break;
            }
            NSString *event = NSStringFromSelector(_cmd);
            [self addLogEvent:event];
        } @catch (NSException *exception) {
            
        }
    } while (false);
}

- (void)doAdsClose{
    do {
        @try {
            if (!adVideoNative) {
                break;
            }
            NSString *textCheck = @"";
            if ([adVideoNative respondsToSelector:@selector(getAdsMediaUrl)]) {
                textCheck = [adVideoNative getAdsMediaUrl];
            }
            if ([adVideoNative respondsToSelector:@selector(doAdsClose:)]) {
                [adVideoNative doAdsClose:textCheck];
            } else {
                break;
            }
            NSString *event = NSStringFromSelector(_cmd);
            [self addLogEvent:event];
        } @catch (NSException *exception) {
            
        }
    } while (false);
}

- (void)doAdsClick{
    do {
        @try {
            if (!adVideoNative) {
                break;
            }
            NSString *textCheck = @"";
            if ([adVideoNative respondsToSelector:@selector(getAdsMediaUrl)]) {
                textCheck = [adVideoNative getAdsMediaUrl];
            }
            if ([adVideoNative respondsToSelector:@selector(doAdsClick:)]) {
                [adVideoNative doAdsClick:textCheck];
            } else {
                break;
            }
            NSString *event = NSStringFromSelector(_cmd);
            [self addLogEvent:event];
        } @catch (NSException *exception) {
            
        }
    } while (false);
}
@end
