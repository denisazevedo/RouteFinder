//
//  ARFTimetableTableDatasSource.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 13/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ARFTimetableDatasourceDelegate <NSObject>
- (NSMutableArray *)arrayInSection:(NSInteger)section;
@end

@interface ARFTimetableTableDatasSource : NSObject <UITableViewDataSource>

//Designated initializer
- (instancetype)initWithDelegate:(id<ARFTimetableDatasourceDelegate>)delegate;

@end
