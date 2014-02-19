//
//  ARFDetailViewController.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARFPostRequest.h"
#import "ARFRoute.h"

@protocol ARFTableDatasourceDelegate <NSObject>
@required
- (NSMutableArray *)objectsInSection:(NSInteger)section;
@optional
- (NSMutableArray *)objects;
@end


@interface ARFRouteDetailsViewController : UIViewController <ARFPostRequestDelegate, ARFTableDatasourceDelegate>

@property (strong, nonatomic) ARFRoute *route;

enum {
    //Timetable
    SECTION_WEEKDAYS,
    SECTION_SATURDAYS,
    SECTION_SUNDAYS,
    //Stops
    SECTION_STOPS,
};

@end
