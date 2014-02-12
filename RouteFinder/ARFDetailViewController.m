//
//  ARFDetailViewController.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFDetailViewController.h"
#import "ARFMasterViewController.h"

@interface ARFDetailViewController ()
- (void)configureView;
@end

@implementation ARFDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItem) {
        NSString *label = [NSString stringWithFormat:@"%@ - %@",
                           [self.detailItem objectForKey:KEY_SHORT_NAME],
                           [self.detailItem objectForKey:KEY_LONG_NAME]];
        self.detailDescriptionLabel.text = label;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureView];
}

@end
