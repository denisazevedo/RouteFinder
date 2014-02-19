//
//  ARFDeparture.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 19/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WEEKDAYS,
    SATURDAYS,
    SUNDAYS
} CalendarType;

@interface ARFDeparture : NSObject

@property (nonatomic) NSInteger departureId;
@property (strong, nonatomic) NSString *calendar;
@property (strong, nonatomic) NSString *time; //or NSDate?

//Designated initializer
- (instancetype)initFromDictionary:(NSDictionary *)dictionary;

@end
