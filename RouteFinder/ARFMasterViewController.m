//
//  ARFMasterViewController.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFMasterViewController.h"
#import "ARFDetailViewController.h"

@interface ARFMasterViewController ()
//Table view data
@property (strong, nonatomic) NSMutableArray *objects; //array of NSDictionary
//Connection
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *responseData;
@property (nonatomic) RequestType currentRequest;
//Outlets
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation ARFMasterViewController

NSString *const KEY_SHORT_NAME = @"shortName";
NSString *const KEY_LONG_NAME = @"longName";
NSString *const KEY_ID = @"id";

#pragma mark - UIViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self addRoutesToTableView:@[@{KEY_SHORT_NAME: @"123", KEY_LONG_NAME: @"Agronomica"},
    //                             @{KEY_SHORT_NAME: @"456", KEY_LONG_NAME: @"Trindade"}]];
}


#define URL_ROUTES_BY_STOP_NAME @"https://dashboard.appglu.com/v1/queries/findRoutesByStopName/run"
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

- (void)findRoutesByStopName:(NSString *)param {
    self.currentRequest = findRoutesByStopName;
    [self postRequest:@{@"stopName": param}
                toURL:[NSURL URLWithString:URL_ROUTES_BY_STOP_NAME]];
}

- (void)findDeparturesByRouteId:(NSNumber *)param {
    self.currentRequest = findDeparturesByRouteId;
    [self postRequest:@{@"params": @{@"routeId": param}}
                toURL:[NSURL URLWithString:URL_DEPARTURES_BY_ROUTE_ID]];
}

- (void)addRoutesToTableView:(NSArray *)routes {
    [self.objects addObjectsFromArray:routes];
    [self.tableView reloadData];
}

- (void)clearTableView {
    //Clear the table view
    [self.objects removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)search:(UIButton *)sender {
    
    if (self.searchTextField.text) {
        [self clearTableView];
        
        NSString *param = [NSString stringWithFormat:@"%%%@%%", self.searchTextField.text];
        //NSLog(@"Search touched: %@", param);
    
        [self findRoutesByStopName:param];
    }
}

#pragma mark - Properties

- (NSMutableArray *)objects {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    return _objects;
}

#pragma mark - Protocols
#pragma mark NSURLConnectionDataDelegate implementation

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Received %d bytes", [self.responseData length]);
    NSLog(@"Response: %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&error];
    NSArray *rows = [json objectForKey:@"rows"];
    
    if (self.currentRequest == findRoutesByStopName) {
        [self addRoutesToTableView:rows];
    } else if (self.currentRequest == findDeparturesByRouteId) {
        
    }
    
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

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *object = self.objects[indexPath.row];
    
    cell.textLabel.text = [object objectForKey:KEY_SHORT_NAME];
    cell.detailTextLabel.text = [object objectForKey:KEY_LONG_NAME];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *route = self.objects[indexPath.row];
        
        id routeId = [route objectForKey:KEY_ID];
        [self findDeparturesByRouteId:routeId];
        
        [[segue destinationViewController] setDetailRoute:route];
    }
}

@end
