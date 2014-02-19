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
#import "ARFStop.h"
#import "ARFDeparture.h"

@interface ARFRouteDetailsViewController ()

//Connection helper
@property (strong, nonatomic) ARFPostRequest *postRequestHelper;
//Outlets
@property (weak, nonatomic) IBOutlet UITableView *tableView; //TODO change to collection view???
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
//TODO add a table footer to details table
@property (strong, nonatomic) id<UITableViewDataSource> stopsDatasource;
@property (strong, nonatomic) id<UITableViewDataSource> timetableDatasource;
@property (nonatomic) BOOL isTimetableLoaded;

@end

@implementation ARFRouteDetailsViewController

//Constants
int const SEGMENT_STOPS = 0;
int const SEGMENT_TIMETABLE = 1;

#pragma mark - Managing the detail item

- (void)setRoute:(ARFRoute *)route {
    if (_route.routeId != route.routeId) {
        _route = route;
        [self updateView];
    }
}

- (void)updateView {
    if (self.route) {
        self.title = [self.route.longName capitalizedString];
        [self clearTableView];
    }
}

- (void)clearTableView {
    [self.route.stops removeAllObjects];
    [self.route removeAllDepartures];
    [self.tableView reloadData];
}

- (IBAction)segmentAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == SEGMENT_STOPS) {
        self.tableView.dataSource = self.stopsDatasource;
        
    } else if (sender.selectedSegmentIndex == SEGMENT_TIMETABLE) { //Timetable
        self.tableView.dataSource = self.timetableDatasource;
        if (!self.isTimetableLoaded && self.route.routeId) {
            [self.loadingIndicator startAnimating];
            [self.postRequestHelper findDeparturesByRouteId:@(self.route.routeId) delegate:self];
        }
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)objects {
    return self.route.stops;
}

- (NSMutableArray *)objectsInSection:(NSInteger)section {
    NSMutableArray *array;
    switch (section) {
        case SECTION_WEEKDAYS:
            array = self.route.weekdayDepartures;
            break;
        case SECTION_SATURDAYS:
            array = self.route.saturdayDepartures;
            break;
        case SECTION_SUNDAYS:
            array = self.route.sundayDepartures;
            break;
        case SECTION_STOPS:
            array = self.route.stops;
            break;
    }
    return array;
}

#pragma mark - Protocols

#pragma mark ARFPostRequestDelegate

- (void)requestDidComplete:(NSArray *)rows {
    //NSLog(@"%s Rows received: %d", __PRETTY_FUNCTION__, [rows count]);
    
    if (self.segmentedControl.selectedSegmentIndex == SEGMENT_STOPS) {
        [self processStopsResponse:rows];
    } else if (self.segmentedControl.selectedSegmentIndex == SEGMENT_TIMETABLE) {
        [self processTimetableResponse:rows];
    }

    [self.tableView reloadData];
    [self.loadingIndicator stopAnimating];
}

- (void)processStopsResponse:(NSArray *)stops {
    self.tableView.dataSource = self.stopsDatasource;
    
    for (NSDictionary *dictionary in stops) {
        ARFStop *stop = [[ARFStop alloc] initFromDictionary:dictionary];
        [self.route.stops addObject:stop];
    }
}

- (void)processTimetableResponse:(NSArray *)timetable {
    self.tableView.dataSource = self.timetableDatasource;
    
    for (NSDictionary *dictionary in timetable) {
        ARFDeparture *departure = [[ARFDeparture alloc] initFromDictionary:dictionary];
        [self.route addDeparture:departure];
    }
    self.isTimetableLoaded = YES; //To handle the network activity indicator
}

- (void)requestDidFail:(NSError *)error {
    [self.loadingIndicator stopAnimating];
    
    NSString *msg = [NSString stringWithFormat:@"Connection failed!\nError: %@\nPlease check your connection settings", [error localizedDescription]];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:msg
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
}

#pragma mark - UIViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.postRequestHelper = [[ARFPostRequest alloc] init];

    self.stopsDatasource = [[ARFStopsDatasSource alloc] initWithDelegate:self];
    self.timetableDatasource = [[ARFTimetableDataSource alloc] initWithDelegate:self];
    
    self.tableView.dataSource = self.stopsDatasource;

    if (self.route) {
        [self.postRequestHelper findStopsByRouteId:@(self.route.routeId) delegate:self]; //TODO pass the datasource???
        [self.loadingIndicator startAnimating];
    }
}

@end
