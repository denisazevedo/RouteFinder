//
//  ARFMapViewController.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 14/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFMapViewController.h"

@interface ARFMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) NSMutableArray *geocodingResults;

@end

//TODO Use AddressBook framework for address formatting
@implementation ARFMapViewController

NSString * const CITY_NAME = @"Florianopolis";

- (IBAction)longPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint pressPoint = [sender locationInView:self.mapView];
        [self reverseGeocodeLocationFromPoint:pressPoint];
    }
}

- (void)reverseGeocodeLocationFromPoint:(CGPoint)point {
    
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            if (error)
                                NSLog(@"%s Error: %@", __PRETTY_FUNCTION__, error);
                            else {
                                [self reverseGeocodingDidComplete:placemarks];
                            }
                        }];
}

- (void)reverseGeocodingDidComplete:(NSArray *)placemarks {
    CLPlacemark *placemark = [placemarks objectAtIndex:0];
    
    self.streetName = placemark.addressDictionary[@"Thoroughfare"];
    NSLog(@"Reverse geocoding - Street name: %@", self.streetName);
    
    [self removePins];
    [self addPinToPlacemark:placemark];
}

- (void)geocodingDidComplete:(NSArray *)placemarks {
    [_geocodingResults removeAllObjects];
    [_geocodingResults addObjectsFromArray:placemarks];
    
    CLPlacemark *placemark = [placemarks objectAtIndex:0];
    
    [self addPinToPlacemark:placemark];
}

- (void)addPinToPlacemark:(CLPlacemark*)placemark {
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = placemark.location.coordinate;
    
    NSString *street = placemark.addressDictionary[@"Thoroughfare"];
    NSString *city = placemark.addressDictionary[@"City"];
    
    if (street) {
        annotation.title = street;
        annotation.subtitle = city;
    } else {
        annotation.title = city;
    }
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
}

- (void)removePins {
    [self.mapView removeAnnotations:self.mapView.annotations];
}

const int SPAN_METERS = 2500;

- (void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, SPAN_METERS, SPAN_METERS);
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void)initializeMap { //Add annotation on Florianopolis city
    [self.geocoder geocodeAddressString:CITY_NAME
                      completionHandler:^(NSArray *placemarks, NSError *error) {
                          if (error)
                              NSLog(@"%s Error: %@", __PRETTY_FUNCTION__, error);
                          else {
                              [self addPinToPlacemark:[placemarks objectAtIndex:0]];
                          }
                      }];
}

- (void)confirmStreetForSearch {
    if (self.streetName) {
        
        NSString *title = [NSString stringWithFormat:@"Do you want to show the routes for this street?\n%@", self.streetName];
        UIActionSheet *confirm = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:@"No"
                                               destructiveButtonTitle:@"Yes, please"
                                                    otherButtonTitles:nil];
        [confirm showInView:self.view];
    }
}

#pragma mark UIViewController Lifecycle

- (void)viewDidLoad {
    self.mapView.delegate = self;
    _geocodingResults = [[NSMutableArray alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    
    //[self.mapView setShowsUserLocation:YES];
    [self initializeMap];
}

#pragma mark - Protocols

#pragma mark ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { //Yes, please
        [self performSegueWithIdentifier:@"UnwindToMaster" sender:self];
    }
}

#pragma mark MKMapView Delegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    [self zoomToCoordinate:[annotationView.annotation coordinate]];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [self zoomToCoordinate:[view.annotation coordinate]];
    [self confirmStreetForSearch];
}

@end

