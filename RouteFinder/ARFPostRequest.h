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
- (void)requestDidFail:(NSError *)error;
@end

@interface ARFPostRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

/*
//Designated initializer
- (instancetype)initWithDelegate:(id<ARFPostRequestDelegate>)delegate;
@property (assign) id<ARFPostRequestDelegate> delegate;
- (void)findRoutesByStopName:(NSString *)param;
- (void)findDeparturesByRouteId:(NSNumber *)param;
*/

- (void)findRoutesByStopName:(NSString *)param delegate:(id<ARFPostRequestDelegate>)delegate;
- (void)findStopsByRouteId:(NSNumber *)param delegate:(id<ARFPostRequestDelegate>)delegate;
- (void)findDeparturesByRouteId:(NSNumber *)param delegate:(id<ARFPostRequestDelegate>)delegate;

@end
