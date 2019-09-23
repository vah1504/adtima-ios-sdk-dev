//
//  NativeSingleViewController.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by anhnt5 on 3/4/16.
//  Copyright © 2016 WAD. All rights reserved.
//

#import "NativeSingleViewController.h"
#import "SVProgressHUD.h"

@interface NativeSingleViewController ()

@end

@implementation NativeSingleViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        // View is disappearing because a new view controller was pushed onto the stack
        NSLog(@"New view controller was pushed");
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        if (self.native1) {
            self.native1 = nil;
        }
    }
}

- (void)showLoading{
    if (![SVProgressHUD isVisible]) {
        [SVProgressHUD showWithStatus:@"Loading"];
    }
}

- (void)hideLoading{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!self.native1) {
        self.native1 = [[ZAdsNative alloc] init];
    }
    self.native1.delegate = self;
    [self.native1 setZoneId:self.zoneId]; //1188858104930320973
    self.native1.adsTag = @"11111";
    self.native1.parentView = self;
    
    [self.native1 addAdsTargeting:@"category_id" value:@"11111"];
    [self.native1 addAdsTargeting:@"category_name" value:@"News Category"];
    [self.native1 addAdsTargeting:@"song_id" value:@"22222"];
    [self.native1 addAdsTargeting:@"song_name" value:@"Song Name"];
    [self.native1 addAdsTargeting:@"album_id" value:@"33333"];
    [self.native1 addAdsTargeting:@"album_name" value:@"Album Name"];
    
    [self.native1 addAdsTargeting:@"artist_id" value:@"44444"];
    [self.native1 addAdsTargeting:@"artist_name" value:@"Artist Name"];
    
    [self.native1 setAdsContentUrl:@"http://www.baomoi.com/nhung-pha-xu-ly-an-tuong-cua-ronaldo-nam-2016/r/21129105.epi"];
    [self.native1 setContentId:@"http://adtima.vn"];
    
    [self showLoading];
    [self.native1 loadAdsNative];
    [self.native1 registerAdsInteraction:_btnInstall];
    [self.native1 setAdsImpressionManualHandle:YES];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
      target:self
     action:@selector(submitFeedback)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMetaData {
    @try {
        NSString *jsonObjectMetaData = [self.native1 getMetaData];
        //NSLog(@"%@", jsonObjectMetaData);
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObjectMetaData options:NSJSONWritingPrettyPrinted error:nil];
//        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:nil];
//        
//        NSLog(@"articleId = %@", [dict objectForKey:@"articleId"]);
//        NSLog(@"hidePrTag = %@", [dict objectForKey:@"hidePrTag"]);
    } @catch (NSException *exception) {
        
    }
}

-(void)submitFeedback{
    if (_native1) {
        [_native1 feedbackAds:@[@1,@2]];
    }
}

#pragma mark Delegate Banner
//================Delegate Banner======================

- (void)onNativeAdsLoadFinished:(NSString *)tag{
    if ([tag isEqualToString:self.native1.adsTag]) {
        dispatch_queue_t queue = dispatch_queue_create("demo_sdk", nil);
        dispatch_async(queue, ^{
            NSData * imageLogo = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[self.native1 getLogo]]];
            NSData * imageCover = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[self.native1 getPortraitCover]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                //Update UI
                _lblTitle.text = [self.native1 getTitle];
                _lblDesc.text = [self.native1 getAppDescription];
                _imgLogo.image = [UIImage imageWithData:imageLogo];
                _imgCover.image = [UIImage imageWithData:imageCover];
                [_btnInstall setTitle:[self.native1 getAction] forState:UIControlStateNormal];
                [self.native1 haveAdsInventory];
                [self.native1 displayAds];
                [self getMetaData];
                [self hideLoading];
            });
        });
    }else{
        [self hideLoading];
    }
}

- (void)onNativeAdsLoadFailed:(NSString *)tag error:(NSInteger)errorCode {
    NSLog(@"%s code:%d", __PRETTY_FUNCTION__, (int)errorCode);
    [self.native1 haveAdsInventory];
    [self hideLoading];
}

- (void)onNativeAdsOpened:(NSString *)tag {
    //NSLog(@"onBannerAdsOpened");
}

- (void)onNativeAdsClosed:(NSString *)tag {
    NSLog(@"onNativeAdsClosed");
}

- (void)onNativeAdsLeftApplication:(NSString *)tag {
    //NSLog(@"onBannerAdsLeftApplication");
}

- (BOOL)onNativeAdsContentHandler:(NSString *)tag content:(NSString *)content {
    //NSLog(@"tag = %@ - %@", tag, content);
    return FALSE;
}
//======================================================

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.native1 didScrollFromParent];
}


- (IBAction)goInstall:(id)sender {
    [self.native1 registerAdsClick];
}
@end
