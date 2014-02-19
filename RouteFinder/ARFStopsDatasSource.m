//
//  ARFStopsTableDatasSource.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 13/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFStopsDatasSource.h"
#import "ARFRouteDetailsViewController.h"
#import "ARFStop.h"

@interface ARFStopsDatasSource ()
@property (weak, nonatomic) id<ARFTableDatasourceDelegate> delegate;
@end

@implementation ARFStopsDatasSource

//Designated initializer
- (instancetype)initWithDelegate:(id<ARFTableDatasourceDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(objects)]) {
        return [[self.delegate objects] count];
    } else {
        return [[self.delegate objectsInSection:SECTION_STOPS] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];

    ARFStop *stop = nil;
    if ([self.delegate respondsToSelector:@selector(objects)]) {
        stop = [[self.delegate objects] objectAtIndex:indexPath.row];
    } else {
        stop = [[self.delegate objectsInSection:SECTION_STOPS] objectAtIndex:indexPath.row];
    }
   
    cell.textLabel.text = stop.name;
    if (!cell.textLabel.enabled)
        cell.textLabel.enabled = YES;
    return cell;
}

@end
