//
//  DemoEntity.m
//  Demo_AdtimaMobileSDK
//
//  Created by anhnt5 on 4/15/16.
//  Copyright © 2016 WAD. All rights reserved.
//

#import "DemoEntity.h"

@implementation DemoEntity

+ (instancetype)initWithName:(NSString *)name zoneId:(NSString *)zoneId {
    DemoEntity *item = [[DemoEntity alloc] init];
    item.strName = name;
    item.strZoneId = zoneId;
    return item;
}

@end
