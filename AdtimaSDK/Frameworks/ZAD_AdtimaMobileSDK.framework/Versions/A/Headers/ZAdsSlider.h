//
//  ZAdsSlider.h
//  ZAD_AdtimaMobileSDK
//
//  Created by Nguyen Tuan Anh on 9/18/15.
//  Copyright (c) 2015 WAD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZAdsSliderDelegate;

@interface ZAdsSlider : UIViewController

@property (nonatomic, weak) id<ZAdsSliderDelegate> delegate;
@property (nonatomic) BOOL mAutoSlide;

- (void)loadAds;
- (void)setAdsZoneId:(NSArray *)arrListZoneIds;
- (void)showSlider;
- (void)loadSliderWithYOrigin:(float)origin;
- (void)setPaddingLeftRight:(float)padding;

- (void)setAdsVideoSoundOnPrefer:(BOOL)isSound;
- (void)setAdsVideoAutoPlayPrefer:(BOOL)isAuto;
- (BOOL)isAdsVideoAutoPlayPrefer;
- (BOOL)isAdsVideoSoundOnPrefer;

@end

@protocol ZAdsSliderDelegate <NSObject>
@optional

/*
 */
- (void)onSliderAdsLoadFinished;

/*
 */
- (void)onSliderAdsLoadFailed:(NSInteger)errorCode;

/*
 */
- (void)onSliderAdsOpened;

/*
 */
- (void)onSliderAdsClosed;

/*
 */
- (void)onSliderAdsLeftApplication;

@end