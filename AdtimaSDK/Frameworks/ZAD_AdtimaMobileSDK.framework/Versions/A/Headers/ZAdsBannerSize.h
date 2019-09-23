//
//  ZAdsBannerSize.h
//  ZAD_AdtimaMobileSDK
//
//  Created by Nguyen Tuan Anh on 5/12/15.
//  Copyright (c) 2015 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, BannerSize) {
    STANDARD_BANNER, // ratio width:height  320:50, DEPRECATED from version 1.7.7
    MEDIUM_RECTANGLE, // ratio width:height  300:250
    FULL_PAGE,
    R31_RECTANGLE, // ratio width:height  3:1
    R169_RECTANGLE // ratio width:height  16:9
};

NSString *convertEnumToString(BannerSize input);

@interface ZAdsBannerSize : NSObject

@end
