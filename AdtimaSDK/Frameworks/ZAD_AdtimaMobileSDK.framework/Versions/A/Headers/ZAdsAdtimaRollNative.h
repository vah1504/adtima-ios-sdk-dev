//
//  ZAdsAdtimaRollNative.h
//  ZAD_AdtimaMobileSDK
//
//  Created by KhiemND on 8/31/18.
//  Copyright © 2018 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAdsVideoRollListener.h"

@interface ZAdsAdtimaRollNative : NSObject
- (BOOL)isAdsAllowSkip;
- (NSInteger)getAdsSkipAfter;

//return data
- (NSString *)getAdsRawData;
- (NSString *)getAdsMediaUrl;
- (NSInteger)getAdsMediaDuration;

- (void)doAdsRequest:(NSString *)mediaUrl;
- (void)doAdsDisplay:(NSString *)mediaUrl;
- (void)doAdsStart:(NSString *)mediaUrl;
- (void)doAdsProgressByTimeWithUrl:(NSString *)mediaUrl withSecond:(NSInteger)second withDuration:(NSInteger)duration;
- (void)doAdsPause:(NSString *)mediaUrl;
- (void)doAdsResume:(NSString *)mediaUrl;
- (void)doAdsComplete:(NSString *)mediaUrl;
- (void)doAdsClose:(NSString *)mediaUrl;
- (void)doAdsClick:(NSString *)mediaUrl;
@end
