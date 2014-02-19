//
//  ARFPostRequest.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ARFPostRequestDelegate <NSObject>
- (void)requestDidComplete:(NSArray *)rows;
@optional
- (void)requestDidFail:(NSError *)error;
@end

@interface ARFPostRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

- (void)findRoutesByStopName:(NSString *)param delegate:(id<ARFPostRequestDelegate>)delegate;
- (void)findStopsByRouteId:(NSNumber *)param delegate:(id<ARFPostRequestDelegate>)delegate;
- (void)findDeparturesByRouteId:(NSNumber *)param delegate:(id<ARFPostRequestDelegate>)delegate;

@end
