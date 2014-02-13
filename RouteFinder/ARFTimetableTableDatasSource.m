//
//  ARFTimetableTableDatasSource.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 13/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFTimetableTableDatasSource.h"
#import "ARFDetailViewController.h"

@interface ARFTimetableTableDatasSource ()
@property (nonatomic, strong) id<ARFTableDatasourceDelegate> delegate;
@end

@implementation ARFTimetableTableDatasSource

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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.delegate objectsInSection:section] count];
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    
    NSMutableArray *rows = [self.delegate objectsInSection:indexPath.section];
    
    NSString *time = [rows objectAtIndex:indexPath.row];
    cell.textLabel.text = time;
    if ([time isEqualToString:NO_TIME_AVAILABLE_MSG]) {
        cell.textLabel.enabled = NO;
    }
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
