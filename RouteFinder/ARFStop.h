//
//  ARFStop.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 19/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARFStop : NSObject

@property (nonatomic) NSInteger stopId;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) int sequence;

//Designated initializer
- (instancetype)initFromDictionary:(NSDictionary *)dictionary;

@end
