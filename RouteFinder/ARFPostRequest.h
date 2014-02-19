//
//  ARFPostRequest.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    REQUEST_ROUTES_BY_STOP_NAME,
    REQUEST_STOPS_BY_ROUTE_ID,
    REQUEST_DEPARTURES_BY_ROUTE_ID
} RequestType;

@protocol ARFPostRequestDelegate <NSObject>
- (void)request:(RequestType)request didCompleteWithData:(NSArray *)data;
@optional
- (void)requestDidFail:(NSError *)error;
@end

@interface ARFPostRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

- (void)findRoutesByStopName:(NSString *)param delegate:(id<ARFPostRequestDelegate>)delegate;
- (void)findStopsByRouteId:(NSNumber *)param delegate:(id<ARFPostRequestDelegate>)delegate;
- (void)findDeparturesByRouteId:(NSNumber *)param delegate:(id<ARFPostRequestDelegate>)delegate;

@end
