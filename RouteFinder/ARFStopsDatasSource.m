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
@property (weak, nonatomic) id<ARFRouteDetailsTableDatasource> datasource;
@end

@implementation ARFStopsDatasSource

//Designated initializer
- (instancetype)initWithDatasource:(id<ARFRouteDetailsTableDatasource>)datasource {
    self = [super init];
    if (self) {
        self.datasource = datasource;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ARFRoute *route = [self.datasource route];
    return [route.stops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];

    ARFRoute *route = [self.datasource route];
    ARFStop *stop = [route.stops objectAtIndex:indexPath.row];
   
    cell.textLabel.text = stop.name;
    if (!cell.textLabel.enabled)
        cell.textLabel.enabled = YES;
    return cell;
}

@end
