//
//  ZAdsBundle.h
//  ZAD_AdtimaMobileSDK
//
//  Created by Khiem Nguyen on 6/23/17.
//  Copyright © 2017 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *ALLOW_DUPLICATE;

@protocol ZAdsBundleDelegate <NSObject>
@optional
- (void)onBundleAdsLoadFinished:(NSString*)tag;
- (void)onBundleAdsLoadFailed:(NSString*)tag errorCode:(NSInteger)errorCode;
@end

@interface ZAdsBundle : NSObject
-(void)setAdsSetting:(id)object forKey:(NSString*)key;
-(void)addAdsTargeting:(NSString *)strKey value:(NSString *)strValue;
-(void)setAdsTargeting:(NSDictionary *)data;
- (NSDictionary *)getAdsTargeting;
-(void)setAdsContentUrl:(NSString*)contentUrl;
-(NSString *)getAdsContentUrl;
-(void)addAdsZoneIdMap:(NSString*)zoneId class:(Class)clazz;
-(void)removeAdsZoneIdMap:(NSString*)zoneId;
-(void)preloadAds;
-(void)preloadAdsWithTag:(NSString *)tag;

@property (nonatomic, weak) id<ZAdsBundleDelegate> delegate;
@property (nonatomic, strong) NSString *tag;
@end
