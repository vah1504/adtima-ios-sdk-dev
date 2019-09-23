//
//  VideoViewController.h
//  ZAD_AdtimaMobileSDKDev
//
//  Created by anhnt5 on 3/7/16.
//  Copyright © 2016 WAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZAD_AdtimaMobileSDK/Adtima.h>

@interface VideoViewController : UIViewController<ZAdsVideoDelegate>

@property (nonatomic, strong) NSString *zoneId;
@property (nonatomic, strong) ZAdsVideo *nativeVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnPause;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnReplay;

- (IBAction)playVideo:(id)sender;
- (IBAction)pauseVideo:(id)sender;
- (IBAction)replay:(id)sender;

@end
