//
//  IncentivizedScreen.m
//  Demo_AdtimaMobileSDK
//
//  Created by KhiemND on 3/21/17.
//  Copyright © 2017 WAD. All rights reserved.
//

#import "IncentivizedScreen.h"
#import "Toast+UIView.h"

#define kNotInitialize @"NOT LOADED"
#define kLoading @"LOADING"
#define kLoaded @"LOADED"
#define kLoadFailed @"LOAD FAILED"
#define kShowing @"SHOWING"
#define kClosed @"CLOSED"
#define kRewarded @"REWARDED"

#import <ZAD_AdtimaMobileSDK/Adtima.h>

typedef enum {
    StatusAd_NotInit = -1,
    StatusAd_Loading,
    StatusAd_Loaded,
    StatusAd_LoadFailed,
    StatusAd_Showing,
    StatusAd_Closed,
    StatusAd_Rewarded
} StatusAd;

@interface IncentivizedScreen ()<ZAdsIncentivizedDelegate>{
    BOOL loading;
    BOOL success;
    BOOL closed;
    StatusAd statusAd;
}
@property (nonatomic, strong) ZAdsIncentivized *incentivized;
@property (nonatomic, weak) IBOutlet UILabel *lbStatusAd;
@property (nonatomic, weak) IBOutlet UIButton *btnLoad;
@property (nonatomic, weak) IBOutlet UIButton *btnShow;
@end

@implementation IncentivizedScreen

- (void)dealloc{
    NSLog(@"dealloc IncentivizedScreen");
}

- (ZAdsIncentivized *)incentivized{
    if (!_incentivized ||
        _incentivized == nil) {
        _incentivized = [[ZAdsIncentivized alloc] init];
        [_incentivized setAdsVideoAutoPlayPrefer:NO];
        [_incentivized setAdsVideoSoundOnPrefer:YES];
        [_incentivized addAdsTargeting:@"mp3" value:@"vitoiconsong"];
        [_incentivized setDelegate:self];
        [_incentivized setAdsRewardExtras:@"This is an ad extra"];
        
        [_incentivized addAdsTargeting:@"category_id" value:@"11111"];
        [_incentivized addAdsTargeting:@"category_name" value:@"News Category"];
        [_incentivized addAdsTargeting:@"song_id" value:@"22222"];
        [_incentivized addAdsTargeting:@"song_name" value:@"Song Name"];
        [_incentivized addAdsTargeting:@"album_id" value:@"33333"];
        [_incentivized addAdsTargeting:@"album_name" value:@"Album Name"];
        
        [_incentivized addAdsTargeting:@"artist_id" value:@"44444"];
        [_incentivized addAdsTargeting:@"artist_name" value:@"Artist Name"];
        
        [_incentivized setAdsContentUrl:@"http://www.baomoi.com/nhung-pha-xu-ly-an-tuong-cua-ronaldo-nam-2016/r/21129105.epi"];
    }
    [_incentivized setZoneId:_strAdId];
    [_incentivized setContentId:@"http://adtima.vn"];
    return _incentivized;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.isBeingDismissed || self.isMovingFromParentViewController) {
        // clean up code here
        self.incentivized = nil;
        statusAd = StatusAd_NotInit;
        [self checkStatusAd];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self checkStatusAd];
    _btnLoad.enabled = YES;
    _btnShow.enabled = NO;
    statusAd = StatusAd_NotInit;
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

- (IBAction)onLoadAd:(id)sender{
    _btnShow.enabled = NO;
    [self.incentivized loadAdsIncentivized];
    statusAd = StatusAd_Loading;
    [self checkStatusAd];
}

- (IBAction)onShowAd:(id)sender{
    [self.incentivized haveAdsInventory];
    if (self.incentivized.isIncentivizedAdsLoaded) {
        //        statusAd = StatusAd_Showing;
        //        [self checkStatusAd];
        //        __weak IncentivizedScreen *weakSafeSelf = self;
        //        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:500 repeats:NO block:^(NSTimer * _Nonnull timer) {
        //            [weakSafeSelf.incentivized show:weakSafeSelf];
        //        }];
        //        [timer fire];
        [self.incentivized show:self];
    }
    else{
        [self checkStatusAd];
    }
}

- (void)checkStatusAd{
    
    switch (statusAd) {
        case StatusAd_NotInit:
        {
            _lbStatusAd.text = kNotInitialize;
            _lbStatusAd.textColor = [UIColor redColor];
        }
            break;
        case StatusAd_Loading:
        {
            _lbStatusAd.text = kLoading;
            _lbStatusAd.textColor = [UIColor darkTextColor];
        }
            break;
        case StatusAd_Loaded:
        {
            _lbStatusAd.text = kLoaded;
            _lbStatusAd.textColor = [UIColor greenColor];
        }
            break;
        case StatusAd_LoadFailed:
        {
            _lbStatusAd.text = kLoadFailed;
            _lbStatusAd.textColor = [UIColor redColor];
        }
            break;
        case StatusAd_Closed:
        {
            _lbStatusAd.text = kClosed;
            _lbStatusAd.textColor = [UIColor darkTextColor];
        }
            break;
        case StatusAd_Showing:
        {
            _lbStatusAd.text = kShowing;
            _lbStatusAd.textColor = [UIColor darkTextColor];
        }
            break;
        case StatusAd_Rewarded:
        {
            _lbStatusAd.text = kRewarded;
            _lbStatusAd.textColor = [UIColor greenColor];
        }
            break;
        default:
            break;
    }
}

//================Delegate Incentivized======================

- (void)onIncentivizedAdsLoadFinished:(NSString *)type {
    statusAd = StatusAd_Loaded;
    [self checkStatusAd];
    _btnLoad.enabled = YES;
    _btnShow.enabled = YES;
}

- (void)onIncentivizedAdsLoadFailed:(NSInteger)errorCode {
    statusAd = StatusAd_LoadFailed;
    [self checkStatusAd];
    _btnLoad.enabled = YES;
    _btnShow.enabled = NO;
    NSString *strError = [NSString stringWithFormat:@"ad load failed with errorCode = %zi", errorCode];
    [self.view makeToast:strError];
    NSLog(@"%s%d",__PRETTY_FUNCTION__, (int)errorCode);
}

-(void)onIncentivizedAdsOpened {
    NSLog(@"onIncentivizedAdsOpened");
    _btnShow.enabled = YES;
    _btnLoad.enabled = YES;
}

- (void)onIncentivizedAdsClosed {
    NSLog(@"onIncentivizedAdsClosed");
    //    statusAd = StatusAd_Closed;
    //    [self checkStatusAd];
    self.incentivized = nil;
    statusAd = StatusAd_NotInit;
    _btnLoad.enabled = YES;
    _btnShow.enabled = YES;
}

- (void)onIncentivizedAdsInteracted {
    NSLog(@"onIncentivizedAdsInteracted");
}

- (void)onIncentivizedMuteVideo:(BOOL)isMute {
    NSString *status = (isMute)? @"SOUND OFF" : @"SOUND ON";
    NSLog(@"VIDEO REWARD %@",status);
}

- (void)onIncentivizedAdsRewarded:(id)extras token:(NSString *)token{
    
    @try{
        id item = nil;
        
        if (extras &&
            [extras isKindOfClass:[NSString class]]) {
            item = [extras copy];
        }
        
        statusAd = StatusAd_Rewarded;
        [self checkStatusAd];
        
        if (!token) {
            token =@"(null)";
        }
        
        NSDictionary *dict = @{
                               @"item" : item,
                               @"token" : token
                               };
        
        [self performSelector:@selector(doSelectorShowReward:) withObject:dict afterDelay:0.5];
    }@catch(...){
        
    }
}

- (void)doSelectorShowReward:(NSDictionary*)dict{
    @try{
        NSString *token = dict[@"token"];
        id item = dict[@"item"];
        [self showRewarded:item token:token];
    }@catch(...){
        
    }
}

- (void)showRewarded:(id)extras token:(NSString *)token{
    NSString *item = @"unknown";
    if (extras &&
        [extras isKindOfClass:[NSString class]]) {
        item = extras;
    }
    
    NSString *message = [NSString stringWithFormat:
                         @"rewarded %@; token:%@",
                         item,
                         token];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alertView show];
}

- (void)onAdsVideoStage:(ZAdsVideoStage)stage{
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
        case CONVERSION:
        {
            strStage = @"CONVERSION";
        }
            break;
        default:
            break;
    }
    
    if (strStage != nil) {
        NSLog(@"VIDEO REWARD STAGE: %@",strStage);
    }
}

#pragma mark - Orientation handling

- (BOOL)shouldAutorotate
{
//    NSArray *supportedOrientationsInPlist = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UISupportedInterfaceOrientations"];
//    BOOL isPortraitLeftSupported = [supportedOrientationsInPlist containsObject:@"UIInterfaceOrientationPortrait"];
//    BOOL isPortraitRightSupported = [supportedOrientationsInPlist containsObject:@"UIInterfaceOrientationPortraitUpsideDown"];
//    return isPortraitLeftSupported && isPortraitRightSupported;
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
//    return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
//    UIInterfaceOrientation currentInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    return UIInterfaceOrientationIsPortrait(currentInterfaceOrientation) ? currentInterfaceOrientation : UIInterfaceOrientationPortrait;
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
//    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
    return YES;
}

@end
