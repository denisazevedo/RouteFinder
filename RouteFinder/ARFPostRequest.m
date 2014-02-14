//
//  ARFPostRequest.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFPostRequest.h"

@interface ARFPostRequest ()

@property (assign) id<ARFPostRequestDelegate> delegate;
//Connection
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *responseData;

@end


@implementation ARFPostRequest

#define URL_ROUTES_BY_STOP_NAME @"https://dashboard.appglu.com/v1/queries/findRoutesByStopName/run"
#define URL_STOPS_BY_ROUTE_ID @"https://dashboard.appglu.com/v1/queries/findStopsByRouteId/run"
#define URL_DEPARTURES_BY_ROUTE_ID @"https://dashboard.appglu.com/v1/queries/findDeparturesByRouteId/run"

/*
//Designated initializer
- (instancetype)initWithDelegate:(id<ARFPostRequestDelegate>)delegate {
    self = [self init]; //super's designated initializer
    if (self) {
        self.delegate = delegate;
    }
    return self;
}
*/

- (void)findRoutesByStopName:(NSString *)param delegate:(id<ARFPostRequestDelegate>)delegate {
    self.delegate = delegate;
    [self postRequest:@{@"stopName": param}
                toURL:[NSURL URLWithString:URL_ROUTES_BY_STOP_NAME]];
}

- (void)findStopsByRouteId:(NSNumber *)param delegate:(id<ARFPostRequestDelegate>)delegate {
    self.delegate = delegate;
    [self postRequest:@{@"routeId": param}
                toURL:[NSURL URLWithString:URL_STOPS_BY_ROUTE_ID]];
}

- (void)findDeparturesByRouteId:(NSNumber *)param delegate:(id<ARFPostRequestDelegate>)delegate {
    self.delegate = delegate;
    [self postRequest:@{@"routeId": param}
                toURL:[NSURL URLWithString:URL_DEPARTURES_BY_ROUTE_ID]];
    //             delegate:delegate];
}
/*
 - (void)findDeparturesByRouteId:(NSNumber *)param {
 [self postRequest:@{@"routeId": param}
 toURL:[NSURL URLWithString:URL_DEPARTURES_BY_ROUTE_ID]];
 }
 */

//- (void)postRequest:(NSDictionary *)params toURL:(NSURL *)url delegate:(id)delegate {
- (void)postRequest:(NSDictionary *)params toURL:(NSURL *)url {

    //TODO add some setup to class initializer
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
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    [self performSelector:@selector(setNetworkActivityIndicatorVisible:) withObject:@YES afterDelay:3.0]; //show the network indicator after 3 seconds
}
/*
- (void)postRequest:(NSDictionary *)params toURL:(NSURL *)url {
    [self postRequest:params toURL:url delegate:self];
}
*/

- (void)setNetworkActivityIndicatorVisible:(NSNumber *)visible {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[visible boolValue]];
}


#pragma mark - Protocols
#pragma mark NSURLConnectionDataDelegate implementation

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self setNetworkActivityIndicatorVisible:@NO];
    NSLog(@"%s Received %d bytes", __PRETTY_FUNCTION__, [self.responseData length]);
//    NSLog(@"Response: %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&error];
    NSArray *rows = [json objectForKey:@"rows"];
    
    if ([self.delegate respondsToSelector:@selector(requestDidComplete:)]) {
        [self.delegate requestDidComplete:rows];
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
    [self setNetworkActivityIndicatorVisible:@NO];
    NSLog(@"Connection failed! Error - %@ - %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    NSString *msg = [NSString stringWithFormat:@"Connection failed!\nError: %@\nPlease check your connection settings", [error localizedDescription]];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:msg
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
    
    if ([self.delegate respondsToSelector:@selector(requestDidFail:)]) {
        [self.delegate requestDidFail:error];
    }
    
    self.connection = nil;
    self.responseData = nil;
}

@end
