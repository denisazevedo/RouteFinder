//
//  ARFStopsTableDatasSource.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 13/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARFDetailViewController.h"

@interface ARFStopsDatasSource : NSObject <UITableViewDataSource>

//Designated initializer
- (instancetype)initWithDelegate:(id<ARFTableDatasourceDelegate>)delegate;

@end
