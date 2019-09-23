//
//  DemoEntity.h
//  Demo_AdtimaMobileSDK
//
//  Created by anhnt5 on 4/15/16.
//  Copyright © 2016 WAD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoEntity : NSObject

@property (nonatomic, strong) NSString *strName;
@property (nonatomic, strong) NSString *strZoneId;

+ (instancetype)initWithName:(NSString *)name zoneId:(NSString *)zoneId;

@end
