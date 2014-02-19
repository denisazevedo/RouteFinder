//
//  ARFRoute.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 19/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARFStop.h"
#import "ARFDeparture.h"

@interface ARFRoute : NSObject

@property (nonatomic) NSInteger routeId;
@property (strong, nonatomic) NSString *shortName;
@property (strong, nonatomic) NSString *longName;

@property (strong, nonatomic) NSMutableArray *stops; //Array of ARFStop
@property (strong, nonatomic) NSMutableArray *weekdayDepartures; //Array of ARFDeparture
@property (strong, nonatomic) NSMutableArray *saturdayDepartures; //Array of ARFDeparture
@property (strong, nonatomic) NSMutableArray *sundayDepartures; //Array of ARFDeparture

- (void)addDeparture:(ARFDeparture *)departure;
- (void)removeAllDepartures;

//Designated initializer
- (instancetype)initFromDictionary:(NSDictionary *)dictionary;

//Constants
extern NSString *const KEY_ID;
extern NSString *const KEY_SHORT_NAME;
extern NSString *const KEY_LONG_NAME;
extern NSString *const KEY_NAME;
extern NSString *const KEY_SEQUENCE;
extern NSString *const KEY_CALENDAR;
extern NSString *const KEY_TIME;

@end
