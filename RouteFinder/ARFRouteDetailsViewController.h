//
//  ARFDetailViewController.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARFPostRequest.h"
#import "ARFRouteDetailsTableDatasource.h"
#import "ARFRoute.h"

@interface ARFRouteDetailsViewController : UIViewController <ARFPostRequestDelegate, ARFRouteDetailsTableDatasource>

@property (strong, nonatomic) ARFRoute *route;

@end
