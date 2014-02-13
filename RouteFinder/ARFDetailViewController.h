//
//  ARFDetailViewController.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARFPostRequest.h"
#import "ARFTimetableTableDatasSource.h"

@interface ARFDetailViewController : UIViewController <ARFPostRequestDelegate, ARFTimetableDatasourceDelegate>
//@interface ARFDetailViewController : UITableViewController <ARFPostRequestDelegate>

@property (strong, nonatomic) NSDictionary *detailRoute;

//@property (readonly, strong, nonatomic) NSMutableArray *weekdayTimes; //Array of NSString
//@property (readonly, strong, nonatomic) NSMutableArray *saturdayTimes; //Array of NSString
//@property (readonly, strong, nonatomic) NSMutableArray *sundayTimes; //Array of NSString

//- (NSMutableArray *)arrayInSection:(NSInteger)section;

enum {
    SECTION_WEEKDAYS,
    SECTION_SATURDAYS,
    SECTION_SUNDAYS,
};
//typedef int SectionType;

extern NSString *const NO_TIME_AVAILABLE_MSG;

@end
