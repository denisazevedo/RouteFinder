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
@property (weak, nonatomic) id<ARFTableDatasourceDelegate> delegate;
@end

@implementation ARFTimetableDataSource

//Designated initializer
- (instancetype)initWithDelegate:(id<ARFTableDatasourceDelegate>)delegate {
    self = [self init]; //super's designated initializer
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    BOOL hasDeparturesOnWeekdays = [[self.delegate objectsInSection:SECTION_WEEKDAYS] count] > 0;
    BOOL hasDeparturesOnSaturdays = [[self.delegate objectsInSection:SECTION_SATURDAYS] count] > 0;
    BOOL hasDeparturesOnSundays = [[self.delegate objectsInSection:SECTION_SUNDAYS] count] > 0;
    return hasDeparturesOnWeekdays + hasDeparturesOnSaturdays + hasDeparturesOnSundays;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.delegate objectsInSection:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    
    NSMutableArray *rows = [self.delegate objectsInSection:indexPath.section];
    ARFDeparture *departure = [rows objectAtIndex:indexPath.row];
    
    cell.textLabel.text = departure.time;
    return cell;
 }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    switch (section) {
        case SECTION_WEEKDAYS:  title = @"Weekdays";  break;
        case SECTION_SATURDAYS: title = @"Saturdays"; break;
        case SECTION_SUNDAYS:   title = @"Sundays";   break;
    }
    return title;
}

@end
