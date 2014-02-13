//
//  ARFStopsTableDatasSource.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 13/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARFDetailViewController.h"

@interface ARFStopsTableDatasSource : NSObject <UITableViewDataSource>

//Designated initializer
//- (instancetype)initWithObjects:(NSMutableArray *)objects;

//@property (strong, nonatomic) NSMutableArray *stops;

//Designated initializer
- (instancetype)initWithDelegate:(id<ARFTableDatasourceDelegate>)delegate;

@end
