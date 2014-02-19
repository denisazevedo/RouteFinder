//
//  ARFTimetableTableDatasSource.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 13/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFTimetableDataSource.h"
#import "ARFRouteDetailsViewController.h"
#import "ARFDeparture.h"

@interface ARFTimetableDataSource ()
@property (weak, nonatomic) id<ARFRouteDetailsTableDatasource> datasource;
@end

@implementation ARFTimetableDataSource

//Designated initializer
- (instancetype)initWithDatasource:(id<ARFRouteDetailsTableDatasource>)datasource {
    self = [super init];
    if (self) {
        self.datasource = datasource;
    }
    return self;
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    ARFRoute *route = [self.datasource route];
    
    BOOL hasDeparturesOnWeekdays = [[route departuresFromCalendar:WEEKDAYS] count] > 0;
    BOOL hasDeparturesOnSaturdays = [[route departuresFromCalendar:SATURDAYS] count] > 0;
    BOOL hasDeparturesOnSundays = [[route departuresFromCalendar:SUNDAYS] count] > 0;
    return hasDeparturesOnWeekdays + hasDeparturesOnSaturdays + hasDeparturesOnSundays;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ARFRoute *route = [self.datasource route];
    return [[route departuresFromCalendar:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    
    ARFRoute *route = [self.datasource route];
    NSMutableArray *departures = [route departuresFromCalendar:indexPath.section];
    ARFDeparture *departure = [departures objectAtIndex:indexPath.row];
    
    cell.textLabel.text = departure.time;
    return cell;
 }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    switch (section) {
        case WEEKDAYS:  title = @"Weekdays";  break;
        case SATURDAYS: title = @"Saturdays"; break;
        case SUNDAYS:   title = @"Sundays";   break;
    }
    return title;
}

@end
