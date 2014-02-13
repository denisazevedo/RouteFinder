//
//  ARFStopsTableDatasSource.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 13/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFStopsTableDatasSource.h"

@interface ARFStopsTableDatasSource ()
@property (strong, nonatomic) NSMutableArray *objects;
@end

@implementation ARFStopsTableDatasSource

//Designated initializer
- (instancetype)initWithObjects:(NSMutableArray *)objects {
     self = [self init]; //super's designated initializer
     if (self) {
         self.objects = objects;
     }
     return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];

    NSString *name = [self.objects objectAtIndex:indexPath.row];
    cell.textLabel.text = name;
    if (!cell.textLabel.enabled) cell.textLabel.enabled = YES;
    return cell;
}

@end
