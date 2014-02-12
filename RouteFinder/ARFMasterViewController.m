//
//  ARFMasterViewController.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFMasterViewController.h"

#import "ARFDetailViewController.h"

@interface ARFMasterViewController ()
@property (strong, nonatomic) NSMutableArray *objects;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation ARFMasterViewController

NSString *const KEY_SHORT_NAME = @"shortName";
NSString *const KEY_LONG_NAME = @"longName";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addRouteToTable:@{KEY_SHORT_NAME: @"123", KEY_LONG_NAME: @"Agronomica"}];
    [self addRouteToTable:@{KEY_SHORT_NAME: @"456", KEY_LONG_NAME: @"Trindade"}];
}

- (void)addRouteToTable:(id)route {
    [self.objects addObject:route];
    [self.tableView reloadData];
}

#pragma mark - Actions

- (IBAction)search:(UIButton *)sender {
    if (self.searchTextField.text) {
        NSString *param = [NSString stringWithFormat:@"%%%@%%", self.searchTextField.text];
        NSLog(@"Search touched: %@", param);
    }
}

#pragma mark - Properties

- (NSMutableArray *)objects {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    return _objects;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *object = self.objects[indexPath.row];
    cell.textLabel.text = [object objectForKey:KEY_SHORT_NAME];
    cell.detailTextLabel.text = [object objectForKey:KEY_LONG_NAME];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
