//
//  ZAdsFacebookRollNative.h
//  ZAD_AdtimaMobileSDK
//
//  Created by KhiemND on 8/31/18.
//  Copyright © 2018 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAdsVideoRollListener.h"

@interface ZAdsFacebookRollNative : NSObject
- (BOOL)isAdsAllowSkip;
- (NSInteger)getAdsSkipAfter;
- (NSString *)getAdsRawData;
- (NSString *)getAdsPlacementId;
- (void)doAdsRequest:(NSString *)mediaUrl;
- (void)doAdsDisplay:(NSString *)placementId;
- (void)doAdsComplete:(NSString *)placementId;
- (void)doAdsClose:(NSString *)placementId;
- (void)doAdsClick:(NSString *)placementId;
@end
