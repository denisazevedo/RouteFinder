//
//  ARFMapViewController.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 14/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ARFMapViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSString *streetName;

@end
