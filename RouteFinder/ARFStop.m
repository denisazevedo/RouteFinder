//
//  ARFStop.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 19/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFStop.h"
#import "ARFRoute.h"

@implementation ARFStop

#pragma mark - Initializer

//Designated initializer
- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        self.stopId = [dictionary[KEY_ID] integerValue];
        self.name = [dictionary[KEY_NAME] capitalizedString];
        self.sequence = [dictionary[KEY_SEQUENCE] intValue];
    }
    return self;
}

@end
