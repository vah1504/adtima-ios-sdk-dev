//
//  ZAdsIMARollNative.h
//  ZAD_AdtimaMobileSDK
//
//  Created by KhiemND on 4/3/19.
//  Copyright © 2019 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAdsVideoRollListener.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZAdsIMARollNative : NSObject
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

NS_ASSUME_NONNULL_END
