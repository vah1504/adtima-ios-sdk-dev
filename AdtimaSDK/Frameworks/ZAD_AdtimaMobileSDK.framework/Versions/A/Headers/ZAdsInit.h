//
//  ZAdsInit.h
//  ZAD_AdtimaMobileSDK
//
//  Created by Nguyen Tuan Anh on 4/16/15.
//  Copyright (c) 2015 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSInteger const SDK_VERSION_CODE;
FOUNDATION_EXPORT NSInteger const ENVIRONMENT_SANDBOX;
FOUNDATION_EXPORT NSInteger const ENVIRONMENT_PRODUCT;
FOUNDATION_EXPORT NSInteger const ENVIRONMENT;
FOUNDATION_EXPORT NSString* const SDK_VERSION_NAME;
FOUNDATION_EXPORT NSString* const SDK_BUILD_NUMBER;
FOUNDATION_EXPORT NSString* const SDK_INIT_FINISHED;

@interface ZAdsInit : NSObject

+ (void)initSdk;
+ (void)initSdkWithAppId:(NSString *)appId;
+ (NSString *)getDeviceId;

@end
