//
//  NativeSingleViewController.h
//  ZAD_AdtimaMobileSDKDev
//
//  Created by anhnt5 on 3/4/16.
//  Copyright © 2016 WAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZAD_AdtimaMobileSDK/Adtima.h>

@interface NativeSingleViewController : UIViewController<ZAdsNativeDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgCover;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnInstall;

@property (nonatomic, strong) NSString *zoneId;
@property (nonatomic, strong) ZAdsNative *native1;

- (IBAction)goInstall:(id)sender;
@end
