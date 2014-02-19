//
//  ARFTimetableTableDatasSource.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 13/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARFRouteDetailsViewController.h"

@interface ARFTimetableDataSource : NSObject <UITableViewDataSource>

//Designated initializer
- (instancetype)initWithDatasource:(id<ARFRouteDetailsTableDatasource>)datasource;

@end
