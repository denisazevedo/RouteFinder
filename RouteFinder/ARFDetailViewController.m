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

//Connection
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *responseData;

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

#define URL_DEPARTURES_BY_ROUTE_ID @"https://dashboard.appglu.com/v1/queries/findDeparturesByRouteId/run"

- (void)postRequest:(NSDictionary *)params toURL:(NSURL *)url delegate:(id)delegate {
    
    self.responseData = [NSMutableData dataWithCapacity:0];
    
    NSDictionary *jsonParams = @{@"params": params};
    NSError *error;
    NSData *postParams = [NSJSONSerialization dataWithJSONObject:jsonParams options:0 error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postParams];
    [request setValue:[NSString stringWithFormat:@"%d", [postParams length]] forHTTPHeaderField:@"Content-Length"];
    //Authentication
    [request setValue:@"Basic V0tENE43WU1BMXVpTThWOkR0ZFR0ek1MUWxBMGhrMkMxWWk1cEx5VklsQVE2OA==" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"staging" forHTTPHeaderField:@"X-AppGlu-Environment"];
    //JSON
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
}

- (void)postRequest:(NSDictionary *)params toURL:(NSURL *)url {
    [self postRequest:params toURL:url delegate:self];
}

- (void)findDeparturesByRouteId:(NSNumber *)param {
    [self postRequest:@{@"routeId": param}
                toURL:[NSURL URLWithString:URL_DEPARTURES_BY_ROUTE_ID]];
}

#pragma mark - Protocols
#pragma mark NSURLConnectionDataDelegate implementation

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"Received %d bytes", [self.responseData length]);
//    NSLog(@"Response: %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&error];
    NSArray *rows = [json objectForKey:@"rows"];
    
    //TODO
    for (NSDictionary *row in rows) {
        if ([[row objectForKey:@"calendar"] isEqualToString:KEY_WEEK_DAY]) {
            [self.weekdayTimes addObject:[row objectForKey:@"time"]];
        } else if ([[row objectForKey:@"calendar"] isEqualToString:KEY_SATURDAY]) {
            [self.saturdayTimes addObject:[row objectForKey:@"time"]];
        } else if ([[row objectForKey:@"calendar"] isEqualToString:KEY_SUNDAY]) {
            [self.sundayTimes addObject:[row objectForKey:@"time"]];
        }
    }
//    self.detailDescriptionLabel.text = [(NSDictionary *)rows[0] objectForKey:@"time"];
    NSString *tmp = [NSString stringWithFormat:@"Weekday %d / Saturday %d / Sunday: %d",
                     [self.weekdayTimes count],
                     [self.saturdayTimes count],
                     [self.sundayTimes count]];
    NSLog(@"%@", tmp);
    self.detailDescriptionLabel.text = tmp;
    
    self.connection = nil;
    self.responseData = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

#pragma mark NSURLConnectionDelegate implementation

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ - %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    NSString *msg = [NSString stringWithFormat:@"Connection failed!\nError: %@\nPlease check your connection settings", [error localizedDescription]];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:msg
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
    self.connection = nil;
    self.responseData = nil;
}

#pragma mark - UIViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id routeId = [self.detailRoute objectForKey:KEY_ID];
    NSLog(@"%s routeId: %@", __PRETTY_FUNCTION__, routeId);
    [self findDeparturesByRouteId:routeId];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.weekdayTimes = [[NSMutableArray alloc] init];
    self.saturdayTimes = [[NSMutableArray alloc] init];
    self.sundayTimes = [[NSMutableArray alloc] init];
    
	[self configureView];
}

@end
