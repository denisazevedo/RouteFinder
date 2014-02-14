//
//  ARFMasterViewController.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARFPostRequest.h"

@interface ARFMasterViewController : UITableViewController <ARFPostRequestDelegate, UISearchBarDelegate>

//Constants
extern NSString *const KEY_SHORT_NAME;
extern NSString *const KEY_LONG_NAME;
extern NSString *const KEY_ID;
extern NSString *const KEY_NAME;
extern NSString *const KEY_CALENDAR;
extern NSString *const KEY_TIME;

@end
