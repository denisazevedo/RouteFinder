//
//  ARFDetailViewController.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFRouteDetailsViewController.h"
#import "ARFRoutesSearchViewController.h"
#import "ARFStopsDatasSource.h"
#import "ARFTimetableDataSource.h"

@interface ARFRouteDetailsViewController ()

@property (strong, nonatomic) ARFPostRequest *postRequestDelegate;

//Outlets
@property (weak, nonatomic) IBOutlet UITableView *tableView; //TODO change to collection view???
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
//TODO add a table footer to details table
@property (strong, nonatomic) id<UITableViewDataSource> stopsDatasource;
@property (strong, nonatomic) id<UITableViewDataSource> timetableDatasource;
//Table view data
@property (strong, nonatomic) NSMutableArray *stops; //Array of NSString
//TODO Use only one NSDictionary?
@property (readwrite, strong, nonatomic) NSMutableArray *weekdayTimes; //Array of NSString
@property (readwrite, strong, nonatomic) NSMutableArray *saturdayTimes; //Array of NSString
@property (readwrite, strong, nonatomic) NSMutableArray *sundayTimes; //Array of NSString
@property (nonatomic) BOOL isTimetableLoaded;

- (void)updateView;
@end

@implementation ARFRouteDetailsViewController

#pragma mark - Constants

NSString *const KEY_WEEK_DAY = @"WEEKDAY";
NSString *const KEY_SATURDAY = @"SATURDAY";
NSString *const KEY_SUNDAY = @"SUNDAY";

NSString *const NO_TIME_AVAILABLE_MSG = @"No time available";

int const SEGMENT_STOPS = 0;
int const SEGMENT_TIMETABLE = 1;

#pragma mark - Managing the detail item

- (void)setRoute:(id)newRoute
{
    if (_route != newRoute) {
        _route = newRoute;
        [self updateView];
    }
}

- (void)addTimesToTableView:(NSArray *)times inSection:(NSInteger)section {
    [[self objectsInSection:section] addObjectsFromArray:times];
    [self.tableView reloadData];
}

- (void)updateView
{
    if (self.route) {
        self.title = [self.route[KEY_LONG_NAME] capitalizedString];
        [self clearTableView];
    }
}

- (void)clearTableView {
    [self.stops removeAllObjects];
    [self.weekdayTimes removeAllObjects];
    [self.saturdayTimes removeAllObjects];
    [self.sundayTimes removeAllObjects];
    [self.tableView reloadData];
}


- (IBAction)segmentAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == SEGMENT_STOPS) {
        self.tableView.dataSource = self.stopsDatasource;
        
    } else if (sender.selectedSegmentIndex == SEGMENT_TIMETABLE) { //Timetable
        self.tableView.dataSource = self.timetableDatasource;
        if (!self.isTimetableLoaded && self.route[KEY_ID]) {
            [self.loadingIndicator startAnimating];
            [self.postRequestDelegate findDeparturesByRouteId:self.route[KEY_ID] delegate:self];
        }
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)objects {
    return self.stops;
}

- (NSMutableArray *)objectsInSection:(NSInteger)section {
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
        default: //case SECTION_STOPS:
            array = self.stops;
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
                [self.weekdayTimes addObject:[row objectForKey:KEY_TIME]];
            } else if ([[row objectForKey:KEY_CALENDAR] isEqualToString:KEY_SATURDAY]) {
                [self.saturdayTimes addObject:[row objectForKey:KEY_TIME]];
            } else if ([[row objectForKey:KEY_CALENDAR] isEqualToString:KEY_SUNDAY]) {
                [self.sundayTimes addObject:[row objectForKey:KEY_TIME]];
            }
        }
        self.isTimetableLoaded = YES;
        
        //Adds a "No time available" message to the section
        if (self.weekdayTimes.count == 0)
            [self.weekdayTimes addObject:NO_TIME_AVAILABLE_MSG];
        if (self.saturdayTimes.count == 0)
            [self.saturdayTimes addObject:NO_TIME_AVAILABLE_MSG];
        if (self.sundayTimes.count == 0)
            [self.sundayTimes addObject:NO_TIME_AVAILABLE_MSG];
    }

    [self.tableView reloadData];
    [self.loadingIndicator stopAnimating];
}

- (void)requestDidFail:(NSError *)error {
    [self.loadingIndicator stopAnimating];
}

#pragma mark - UIViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.route) {
        NSLog(@"%s routeId: %@", __PRETTY_FUNCTION__, self.route[KEY_ID]);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.stops = [[NSMutableArray alloc] init];
    self.weekdayTimes = [[NSMutableArray alloc] init];
    self.saturdayTimes = [[NSMutableArray alloc] init];
    self.sundayTimes = [[NSMutableArray alloc] init];
    
    self.postRequestDelegate = [[ARFPostRequest alloc] init];

    self.stopsDatasource = [[ARFStopsDatasSource alloc] initWithDelegate:self];
    self.timetableDatasource = [[ARFTimetableDataSource alloc] initWithDelegate:self];
    
    self.tableView.dataSource = self.stopsDatasource;

    if (self.route) {
        [self.postRequestDelegate findStopsByRouteId:self.route[KEY_ID] delegate:self]; //TODO pass the datasource???
        [self.loadingIndicator startAnimating];
    }
}

@end
