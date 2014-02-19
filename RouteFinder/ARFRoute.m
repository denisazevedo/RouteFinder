//
//  ARFRoute.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 19/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFRoute.h"

@implementation ARFRoute

//Constants
NSString *const KEY_ID = @"id";
NSString *const KEY_SHORT_NAME = @"shortName";
NSString *const KEY_LONG_NAME = @"longName";
NSString *const KEY_NAME = @"name";
NSString *const KEY_SEQUENCE = @"sequence";
NSString *const KEY_CALENDAR = @"calendar";
NSString *const KEY_TIME = @"time";

NSString *const KEY_WEEK_DAY = @"WEEKDAY";
NSString *const KEY_SATURDAY = @"SATURDAY";
NSString *const KEY_SUNDAY = @"SUNDAY";

#pragma mark

- (void)addDeparture:(ARFDeparture *)departure {
    
    NSMutableArray *departuresArray = nil;
    
    if ([departure.calendar isEqualToString:KEY_WEEK_DAY])
        departuresArray = self.weekdayDepartures;
    else if ([departure.calendar isEqualToString:KEY_SATURDAY])
        departuresArray = self.saturdayDepartures;
    else if ([departure.calendar isEqualToString:KEY_SUNDAY])
        departuresArray = self.sundayDepartures;
    
    [departuresArray addObject:departure];
}

- (void)removeAllDepartures {
    [self.weekdayDepartures removeAllObjects];
    [self.saturdayDepartures removeAllObjects];
    [self.sundayDepartures removeAllObjects];
}

- (NSMutableArray *)departuresFromCalendar:(CalendarType)calendar {
    switch (calendar) {
        case WEEKDAYS:
            return self.weekdayDepartures;
        case SATURDAYS:
            return self.saturdayDepartures;
        case SUNDAYS:
            return self.sundayDepartures;
    }
}

//TODO To implement...
//- (BOOL)isEqual:(id)object {


#pragma mark - Initializers

//Designated initializer
- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.routeId = [dictionary[KEY_ID] integerValue];
        self.shortName = dictionary[KEY_SHORT_NAME];
        self.longName = dictionary[KEY_LONG_NAME];
    }
    return self;
}

- (NSMutableArray *)stops {
    if (!_stops)
        _stops = [[NSMutableArray alloc] init];
    return _stops;
}

- (NSMutableArray *)weekdayDepartures {
    if (!_weekdayDepartures)
        _weekdayDepartures = [[NSMutableArray alloc] init];
    return _weekdayDepartures;
}

- (NSMutableArray *)saturdayDepartures {
    if (!_saturdayDepartures)
        _saturdayDepartures = [[NSMutableArray alloc] init];
    return _saturdayDepartures;
}

- (NSMutableArray *)sundayDepartures {
    if (!_sundayDepartures)
        _sundayDepartures = [[NSMutableArray alloc] init];
    return _sundayDepartures;
}

@end
