//
//  ARFMasterViewController.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    findRoutesByStopName,
    findDeparturesByRouteId
} RequestType;

@interface ARFMasterViewController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

extern NSString *const KEY_SHORT_NAME;
extern NSString *const KEY_LONG_NAME;
extern NSString *const KEY_ID;

@end
