//
//  ARFDetailViewController.h
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARFPostRequest.h"

@interface ARFDetailViewController : UIViewController <ARFPostRequestDelegate>

@property (strong, nonatomic) NSDictionary *detailRoute;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
