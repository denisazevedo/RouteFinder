//
//  ARFDeparture.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 19/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFDeparture.h"
#import "ARFRoute.h"

@implementation ARFDeparture

#pragma mark - Initializer

//Designated initializer
- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.departureId = [dictionary[KEY_ID] integerValue];
        self.calendar = dictionary[KEY_CALENDAR];
        self.time = dictionary[KEY_TIME];
    }
    return self;
}

@end
