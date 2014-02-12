//
//  ARFDetailViewController.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARFDetailViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSDictionary *detailRoute;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
