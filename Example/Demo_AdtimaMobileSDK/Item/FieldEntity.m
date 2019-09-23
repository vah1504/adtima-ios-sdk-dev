//
//  FieldEntity.m
//  ZAD_AdtimaMobileSDKDev
//
//  Created by Khiem Nguyen on 4/11/18.
//  Copyright © 2018 WAD. All rights reserved.
//

#import "FieldEntity.h"

@implementation FieldEntity
- (instancetype)init{
    self = [super init];
    if (self) {
        self.arrZones = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
