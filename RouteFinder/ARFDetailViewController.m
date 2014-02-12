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

@property (strong, nonatomic) NSMutableArray *weekdayTimes;
@property (strong, nonatomic) NSMutableArray *saturdayTimes;
@property (strong, nonatomic) NSMutableArray *sundayTimes;

- (void)configureView;
@end

@implementation ARFDetailViewController

NSString *const KEY_WEEK_DAY = @"WEEKDAY";
NSString *const KEY_SATURDAY = @"SATURDAY";
NSString *const KEY_SUNDAY = @"SUNDAY";

#pragma mark - Managing the detail item

- (void)setDetailRoute:(id)newDetailRoute
{
    if (_detailRoute != newDetailRoute) {
        _detailRoute = newDetailRoute;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailRoute) {
        NSString *label = [NSString stringWithFormat:@"%@ - %@",
                           [self.detailRoute objectForKey:KEY_SHORT_NAME],
                           [self.detailRoute objectForKey:KEY_LONG_NAME]];
        self.detailDescriptionLabel.text = label;
    }
}

#pragma mark - Protocols

#pragma mark ARFPostRequestDelegate

- (void)requestDidComplete:(NSArray *)rows {
//    NSLog(@"%s Rows received: %d", __PRETTY_FUNCTION__, [rows count]);
    
    for (NSDictionary *row in rows) {
        if ([[row objectForKey:@"calendar"] isEqualToString:KEY_WEEK_DAY]) {
            [self.weekdayTimes addObject:[row objectForKey:@"time"]];
        } else if ([[row objectForKey:@"calendar"] isEqualToString:KEY_SATURDAY]) {
            [self.saturdayTimes addObject:[row objectForKey:@"time"]];
        } else if ([[row objectForKey:@"calendar"] isEqualToString:KEY_SUNDAY]) {
            [self.sundayTimes addObject:[row objectForKey:@"time"]];
        }
    }

    //TODO remove this debug stuff
    NSString *tmp = [NSString stringWithFormat:@"Weekday %d / Saturday %d / Sunday: %d",
                     [self.weekdayTimes count],
                     [self.saturdayTimes count],
                     [self.sundayTimes count]];
    NSLog(@"%@", tmp);
    self.detailDescriptionLabel.text = tmp;
}

#pragma mark - UIViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id routeId = [self.detailRoute objectForKey:KEY_ID];
    NSLog(@"%s routeId: %@", __PRETTY_FUNCTION__, routeId);
    [self.postRequestDelegate findDeparturesByRouteId:routeId delegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.weekdayTimes = [[NSMutableArray alloc] init];
    self.saturdayTimes = [[NSMutableArray alloc] init];
    self.sundayTimes = [[NSMutableArray alloc] init];
    
	[self configureView];
    
//    self.postRequest = [[ARFPostRequest alloc] initWithDelegate:self];
    self.postRequestDelegate = [[ARFPostRequest alloc] init];
}

@end
