//
//  ZAdsMobileSDK.h
//  ZAD_AdtimaMobileSDK
//
//  Created by KhiemND on 5/6/19.
//  Copyright © 2019 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZAdsMobileSDK : NSObject
/// Returns the shared ZAdsMobileSDK instance.
+ (ZAdsMobileSDK *)sharedInstance;
@property(nonatomic, assign) BOOL audioSessionIsApplicationManaged;
@end
