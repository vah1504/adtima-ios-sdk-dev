//
//  FieldEntity.h
//  ZAD_AdtimaMobileSDKDev
//
//  Created by Khiem Nguyen on 4/11/18.
//  Copyright © 2018 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FieldAdType) {
    FieldAdTypeWelcome,
    FieldAdTypeInterstitial,
    FieldAdTypeMasthead,
    FieldAdTypeMediumBanner
};

@interface FieldEntity : NSObject
@property (nonatomic) BOOL showDemoPauseAd;
@property (nonatomic) FieldAdType adType;
@property (nonatomic, copy) NSString *strName;
@property (nonatomic, strong) NSMutableArray *arrZones;
@end
