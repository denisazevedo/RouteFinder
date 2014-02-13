//
//  ARFDetailViewController.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFDetailViewController.h"
#import "ARFMasterViewController.h"

@interface ARFDetailViewController ()

@property (strong, nonatomic) ARFPostRequest *postRequestDelegate;

//Table view data
//TODO Use only one NSDictionary?
@property (strong, nonatomic) NSMutableArray *weekdayTimes;
@property (strong, nonatomic) NSMutableArray *saturdayTimes;
@property (strong, nonatomic) NSMutableArray *sundayTimes;

- (void)configureView;
@end

@implementation ARFDetailViewController

#pragma mark - Constants

NSString *const KEY_WEEK_DAY = @"WEEKDAY";
NSString *const KEY_SATURDAY = @"SATURDAY";
NSString *const KEY_SUNDAY = @"SUNDAY";

NSString *const NO_TIME_AVAILABLE_MSG = @"No time available";

int const SECTION_WEEKDAYS = 0;
int const SECTION_SATURDAYS = 1;
int const SECTION_SUNDAYS = 2;

#pragma mark - Managing the detail item

- (void)setDetailRoute:(id)newDetailRoute
{
    if (_detailRoute != newDetailRoute) {
        _detailRoute = newDetailRoute;
        
        // Update the view.
        //[self configureView];
    }
}

- (void)addTimesToTableView:(NSArray *)times inSection:(NSInteger)section {
    [[self arrayInSection:section] addObjectsFromArray:times];
    [self.tableView reloadData];
}


- (void)configureView
{
    if (self.detailRoute) {
        self.title = [self.detailRoute objectForKey:KEY_LONG_NAME];
    }
}


- (NSMutableArray *)arrayInSection:(NSInteger)section {
    NSMutableArray *array;
    switch (section) {
        case SECTION_WEEKDAYS:
            array = self.weekdayTimes;
            break;
        case SECTION_SATURDAYS:
            array = self.saturdayTimes;
            break;
        case SECTION_SUNDAYS:
            array = self.sundayTimes;
            break;
    }
    return array;
}

#pragma mark - Protocols

#pragma mark ARFPostRequestDelegate

- (void)requestDidComplete:(NSArray *)rows {
//    NSLog(@"%s Rows received: %d", __PRETTY_FUNCTION__, [rows count]);
    
    for (NSDictionary *row in rows) {
        if ([[row objectForKey:KEY_CALENDAR] isEqualToString:KEY_WEEK_DAY]) {

            if (self.weekdayTimes.count > 2) continue; //TODO remove (debug)

            [self.weekdayTimes addObject:[row objectForKey:KEY_TIME]];
        } else if ([[row objectForKey:KEY_CALENDAR] isEqualToString:KEY_SATURDAY]) {
            
            if (self.saturdayTimes.count > 2) continue; //TODO remove (debug)
            
            [self.saturdayTimes addObject:[row objectForKey:KEY_TIME]];
        } else if ([[row objectForKey:KEY_CALENDAR] isEqualToString:KEY_SUNDAY]) {
            
            if (self.sundayTimes.count > 2) continue; //TODO remove (debug)
            
            [self.sundayTimes addObject:[row objectForKey:KEY_TIME]];
        }
    }

    //Add a "No time available" message to the section
    if (self.weekdayTimes.count == 0) [self.weekdayTimes addObject:NO_TIME_AVAILABLE_MSG];
    if (self.saturdayTimes.count == 0) [self.saturdayTimes addObject:NO_TIME_AVAILABLE_MSG];
    if (self.sundayTimes.count == 0) [self.sundayTimes addObject:NO_TIME_AVAILABLE_MSG];
    
    [self.tableView reloadData];
    
    //TODO remove this debug stuff
    NSString *tmp = [NSString stringWithFormat:@"Weekday %d / Saturday %d / Sunday: %d",
                     [self.weekdayTimes count],
                     [self.saturdayTimes count],
                     [self.sundayTimes count]];
    NSLog(@"%@", tmp);
    self.detailDescriptionLabel.text = tmp;
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self arrayInSection:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    
    NSMutableArray *rows = [self arrayInSection:indexPath.section];
    //NSDictionary *time = [rows objectAtIndex:indexPath.row];
    //cell.textLabel.text = [time objectForKey:KEY_TIME];
    
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

#pragma mark - UIViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.detailRoute) {
        id routeId = [self.detailRoute objectForKey:KEY_ID];
        NSLog(@"%s routeId: %@", __PRETTY_FUNCTION__, routeId);
        
        [self.postRequestDelegate findDeparturesByRouteId:routeId delegate:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.weekdayTimes = [[NSMutableArray alloc] init];
    self.saturdayTimes = [[NSMutableArray alloc] init];
    self.sundayTimes = [[NSMutableArray alloc] init];
    
    //    self.postRequest = [[ARFPostRequest alloc] initWithDelegate:self];
    self.postRequestDelegate = [[ARFPostRequest alloc] init];

	[self configureView];
    
    //Test data
//    [self addTimesToTableView:@[@{KEY_TIME: @"1:23"},
//                                @{KEY_TIME: @"2:34"}] inSection:SECTION_WEEKDAYS];
//    [self addTimesToTableView:@[@{KEY_TIME: @"3:45"}] inSection:SECTION_SATURDAYS];
//    [self addTimesToTableView:@[@{KEY_TIME: @"4:56"},
//                                @{KEY_TIME: @"5:00"}] inSection:SECTION_SUNDAYS];

}

@end
