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

//Connection delegate
@property (strong, nonatomic) ARFPostRequest *postRequestDelegate;
//Table view data
@property (strong, nonatomic) NSMutableArray *objects; //array of NSDictionary
//Outlets
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *footnoteLabel;

@end

@implementation ARFMasterViewController

NSString *const KEY_SHORT_NAME = @"shortName";
NSString *const KEY_LONG_NAME = @"longName";
NSString *const KEY_ID = @"id";
NSString *const KEY_NAME = @"name";
NSString *const KEY_CALENDAR = @"calendar";
NSString *const KEY_TIME = @"time";

- (void)addRoutesToTableView:(NSArray *)routes {
    [self.objects addObjectsFromArray:routes];
    [self.tableView reloadData];
    [self refreshTableFooter:YES];
}

- (void)refreshTableFooter:(BOOL)isVisible {
    if (isVisible) {
        self.footnoteLabel.text = [NSString stringWithFormat:@"%d row(s) found", [self.objects count]];
    }
    self.tableView.tableFooterView.hidden = !isVisible;
}

- (void)clearTableView {
    //Clear the table view
    [self.objects removeAllObjects];
    [self.tableView reloadData];
    [self refreshTableFooter:NO];
}

#pragma mark - IBActions

- (IBAction)search:(UIButton *)sender {

    [self clearTableView];
    if (self.searchTextField.text.length > 0) {
        NSString *param = [NSString stringWithFormat:@"%%%@%%", self.searchTextField.text];
        [self.postRequestDelegate findRoutesByStopName:param delegate:self];
        [self.loadingIndicator startAnimating];
    }
}

#pragma mark - Properties

- (NSMutableArray *)objects {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    return _objects;
}

#pragma mark - Protocols

#pragma mark ARFPostRequestDelegate

- (void)requestDidComplete:(NSArray *)rows {
//    NSLog(@"%s Rows received: %d", __PRETTY_FUNCTION__, [rows count]);
    [self.loadingIndicator stopAnimating];
    [self addRoutesToTableView:rows];
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *object = self.objects[indexPath.row];
    
    cell.textLabel.text = object[KEY_SHORT_NAME];
    cell.detailTextLabel.text = [object[KEY_LONG_NAME] capitalizedString];
    return cell;
}

#pragma mark - UIViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshTableFooter:NO];
    
    self.postRequestDelegate = [[ARFPostRequest alloc] init];
    
    //Test data
//    [self addRoutesToTableView:@[@{KEY_ID: @22, KEY_SHORT_NAME: @"123", KEY_LONG_NAME: @"Agronomica"},
//                                 @{KEY_ID: @35, KEY_SHORT_NAME: @"456", KEY_LONG_NAME: @"Trindade"}]];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *route = self.objects[indexPath.row];
        
        [[segue destinationViewController] setDetailRoute:route];
    }
}

@end
