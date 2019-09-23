//
//  AppDelegate.m
//  Demo_AdtimaMobileSDK
//
//  Created by Nguyen Tuan Anh on 4/25/15.
//  Copyright (c) 2015 WAD. All rights reserved.
//

#import "AppDelegate.h"
#import <ZAD_AdtimaMobileSDK/Adtima.h>

@interface AppDelegate ()<ZAdsBundleDelegate>
@end

@implementation AppDelegate
    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
//    NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    NSLog(@"idfaString:%@",idfaString);
//
//    NSError *error;
//    BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
//    if (!success) {
//        //Handle error
//        NSLog(@"%@", [error localizedDescription]);
//    } else {
//        // Yay! It worked!
//    }
//    [FBAdSettings setLogLevel:FBAdLogLevelLog];
//    NSURL *audioFileLocationURL = [ [ NSBundle mainBundle ] URLForResource:@"audiofile"
//                                                             withExtension:@"mp3" ];
//    player = [ AVPlayer playerWithURL:audioFileLocationURL ];
//    
//    [player play];
    
    [ZAdsInit initSdk];
//    [self preloadAds];
    NSLog(@"%@",[ZAdsInit getDeviceId]);
    return YES;
}

- (void)onBundleAdsLoadFailed{
    NSLog(@"onBundleAdsLoadFailed");
}

- (void)onBundleAdsLoadFinished{
    NSLog(@"onBundleAdsLoadFinished");
}

- (void)preloadAds{
    /*
     * Preload ad with setting, this block can be placed on Main Application or
     * anywhere which serve the preload method. This will load and cache the ad for future use
     */
    ZAdsBundle *adsBundle = [[ZAdsBundle alloc] init];
    adsBundle.delegate = self;
    [adsBundle addAdsZoneIdMap:@"2782763237760267929" class:[ZAdsBanner class]];
    [adsBundle addAdsZoneIdMap:@"1104007998045910684" class:[ZAdsBanner class]];
    [adsBundle addAdsZoneIdMap:@"535981053978310298" class:[ZAdsInterstitial class]];
    [adsBundle addAdsZoneIdMap:@"1104007998045910684" class:[ZAdsInterstitial class]];
    
    [adsBundle setAdsSetting:@(NO) forKey:ALLOW_DUPLICATE];
    
    /*
     *MP3
     */
    [adsBundle addAdsTargeting:@"song_id" value:@"AD45AA"];
    [adsBundle addAdsTargeting:@"album_id" value:@"AUJH12"];
    [adsBundle addAdsTargeting:@"artist_id" value:@"YHS12A"];
    [adsBundle addAdsTargeting:@"song_name" value:@"See you again"];
    [adsBundle addAdsTargeting:@"artist_name" value:@"Wiz Khalifa, Charlie Puth"];
    // If content url is not available, just send the domain to us
    [adsBundle setAdsContentUrl:@"http://mp3.zing.vn"];
    // Or if available
    [adsBundle setAdsContentUrl:@"http://mp3.zing.vn/album/Ngay-Cuoi-Single-Khac-Viet-Huong-Tram/ZOUUE9OE.html"];
    
    /*
     *BaoMoi
     */
    [adsBundle addAdsTargeting:@"news_id" value:@"AD45AA"];
    [adsBundle addAdsTargeting:@"category_id" value:@"AUJH12"];
    [adsBundle addAdsTargeting:@"news_title" value:@"YHS12A"];
    [adsBundle addAdsTargeting:@"category_title" value:@"See you again"];
    [adsBundle addAdsTargeting:@"artist_name" value:@"Wiz Khalifa, Charlie Puth"];
    // If content url is not available, just send the domain to us
    [adsBundle setAdsContentUrl:@"http://www.baomoi.com"];
    // Or if available
    [adsBundle setAdsContentUrl:@"http://www.baomoi.com/cam-tay-chi-viec-cho-dan-xa-mien-nui-nuoi-ca-long/r/20671611.epi#home|news"];
    
    [adsBundle preloadAds];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}
    
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    [ super remoteControlReceivedWithEvent:event ];
    
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            
            case UIEventSubtypeNone:
            break;
            case UIEventSubtypeMotionShake:
            break;
            case UIEventSubtypeRemoteControlPlay:
            NSLog(@"play music");
            break;
            case UIEventSubtypeRemoteControlPause:
            NSLog(@"pause music");
            break;
            case UIEventSubtypeRemoteControlStop:
            break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
            break;
            case UIEventSubtypeRemoteControlNextTrack:
            NSLog(@"play next music");
            break;
            case UIEventSubtypeRemoteControlPreviousTrack:
            NSLog(@"play previous music");
            break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
            break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
            break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
            break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
            break;
        }
    }
}
@end
