//
//  ARFDetailViewController.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFDetailViewController.h"
#import "ARFMasterViewController.h"
#import "ARFStopsTableDatasSource.h"

@interface ARFDetailViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) ARFPostRequest *postRequestDelegate;

//Table view data
//TODO change to collection view???
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) id<UITableViewDataSource> stopsDatasource;
@property (strong, nonatomic) id<UITableViewDataSource> timetableDatasource;
@property (strong, nonatomic) NSMutableArray *stops; //Array of NSString
//TODO Use only one NSDictionary?
@property (readwrite, strong, nonatomic) NSMutableArray *weekdayTimes; //Array of NSString
@property (readwrite, strong, nonatomic) NSMutableArray *saturdayTimes; //Array of NSString
@property (readwrite, strong, nonatomic) NSMutableArray *sundayTimes; //Array of NSString
@property (nonatomic) BOOL isTimetableLoaded;

- (void)configureView;
@end

@implementation ARFDetailViewController

#pragma mark - Constants

NSString *const KEY_WEEK_DAY = @"WEEKDAY";
NSString *const KEY_SATURDAY = @"SATURDAY";
NSString *const KEY_SUNDAY = @"SUNDAY";

NSString *const NO_TIME_AVAILABLE_MSG = @"No time available";

//int const SECTION_WEEKDAYS = 0;
//int const SECTION_SATURDAYS = 1;
//int const SECTION_SUNDAYS = 2;

int const SEGMENT_STOPS = 0;
int const SEGMENT_TIMETABLE = 1;

#pragma mark - Managing the detail item

- (void)setDetailRoute:(id)newDetailRoute
{
    if (_detailRoute != newDetailRoute) {
        _detailRoute = newDetailRoute;
        // Update the view.
        [self configureView];
    }
}

- (void)addTimesToTableView:(NSArray *)times inSection:(NSInteger)section {
    [[self arrayInSection:section] addObjectsFromArray:times];
    [self.tableView reloadData];
}

- (void)configureView
{
    if (self.detailRoute) {
        self.title = [self.detailRoute[KEY_LONG_NAME] capitalizedString];
    }
}

- (IBAction)segmentAction:(UISegmentedControl *)sender {
//    NSLog(@"SegmentControl changed: %d", sender.selectedSegmentIndex);
    
    if (sender.selectedSegmentIndex == SEGMENT_STOPS) {
//        [self.tableView setHidden:NO];
        self.tableView.dataSource = self.stopsDatasource;
        
    } else if (sender.selectedSegmentIndex == SEGMENT_TIMETABLE) { //Timetable
//        [self.tableView setHidden:YES];
        self.tableView.dataSource = self.timetableDatasource;
        if (!self.isTimetableLoaded) [self.postRequestDelegate findDeparturesByRouteId:self.detailRoute[KEY_ID] delegate:self]; //TODO set the routeID to a instance property
    }
    
    [self.tableView reloadData];
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
    NSLog(@"%s Rows received: %d", __PRETTY_FUNCTION__, [rows count]);
    
    if (self.segmentedControl.selectedSegmentIndex == SEGMENT_STOPS) {
        self.tableView.dataSource = self.stopsDatasource;

        for (NSDictionary *row in rows) {
            NSString *name = [row objectForKey:KEY_NAME];
            [self.stops addObject:[name capitalizedString]];
        }
        
    } else if (self.segmentedControl.selectedSegmentIndex == SEGMENT_TIMETABLE) {
        self.tableView.dataSource = self.timetableDatasource;

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
        self.isTimetableLoaded = YES;
        
        //Add a "No time available" message to the section
        if (self.weekdayTimes.count == 0) [self.weekdayTimes addObject:NO_TIME_AVAILABLE_MSG];
        if (self.saturdayTimes.count == 0) [self.saturdayTimes addObject:NO_TIME_AVAILABLE_MSG];
        if (self.sundayTimes.count == 0) [self.sundayTimes addObject:NO_TIME_AVAILABLE_MSG];
    }

    [self.tableView reloadData];
}

#pragma mark - UIViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.detailRoute) {
        id routeId = [self.detailRoute objectForKey:KEY_ID];
        NSLog(@"%s routeId: %@", __PRETTY_FUNCTION__, routeId);
        
//        [self.postRequestDelegate findStopsByRouteId:routeId delegate:self];
        //[self.postRequestDelegate findDeparturesByRouteId:routeId delegate:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.stops = [[NSMutableArray alloc] init];
    self.weekdayTimes = [[NSMutableArray alloc] init];
    self.saturdayTimes = [[NSMutableArray alloc] init];
    self.sundayTimes = [[NSMutableArray alloc] init];
    
    //    self.postRequest = [[ARFPostRequest alloc] initWithDelegate:self];
    self.postRequestDelegate = [[ARFPostRequest alloc] init];

//    if (self.detailRoute) {
//    }
    
    self.stopsDatasource = [[ARFStopsTableDatasSource alloc] initWithObjects:self.stops];
    self.timetableDatasource = [[ARFTimetableTableDatasSource alloc] initWithDelegate:self];
    
    id routeId = [self.detailRoute objectForKey:KEY_ID];
    self.tableView.dataSource = self.stopsDatasource;
    [self.postRequestDelegate findStopsByRouteId:routeId delegate:self]; //TODO pass the datasource???
//    [self.postRequestDelegate findDeparturesByRouteId:routeId delegate:self]; //TODO lazy call

	[self configureView];
    
    //Test data
//    [self addTimesToTableView:@[@{KEY_TIME: @"1:23"},
//                                @{KEY_TIME: @"2:34"}] inSection:SECTION_WEEKDAYS];
//    [self addTimesToTableView:@[@{KEY_TIME: @"3:45"}] inSection:SECTION_SATURDAYS];
//    [self addTimesToTableView:@[@{KEY_TIME: @"4:56"},
//                                @{KEY_TIME: @"5:00"}] inSection:SECTION_SUNDAYS];

}

@end
