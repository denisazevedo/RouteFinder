//
//  ARFMasterViewController.m
//  RouteFinder
//
//  Created by Denis C de Azevedo on 12/02/14.
//  Copyright (c) 2014 Denis C de Azevedo. All rights reserved.
//

#import "ARFRoutesSearchViewController.h"
#import "ARFRouteDetailsViewController.h"
#import "ARFMapViewController.h"

@interface ARFRoutesSearchViewController ()

//Connection delegate
@property (strong, nonatomic) ARFPostRequest *postRequestDelegate;
//Table view data
@property (strong, nonatomic) NSMutableArray *objects; //array of NSDictionary
//Outlets
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *footnoteLabel;

@end

@implementation ARFRoutesSearchViewController

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
        self.footnoteLabel.text = [NSString stringWithFormat:@"%d route(s) found", [self.objects count]];
    }
    self.tableView.tableFooterView.hidden = !isVisible;
}

- (void)clearTableView {
    [self.objects removeAllObjects];
    [self.tableView reloadData];
    [self refreshTableFooter:NO];
}

- (void)performSearch:(NSString *)routeName {
    [self clearTableView];
    if (routeName.length > 0) {
        NSString *param = [NSString stringWithFormat:@"%%%@%%", routeName];
        [self.postRequestDelegate findRoutesByStopName:param delegate:self];
        [self.loadingIndicator startAnimating];
    }
}

#pragma mark - IBActions

- (IBAction)search:(UIButton *)sender {
    //As per Cristiano's requirements, need a button called 'Search'
    [self searchBarSearchButtonClicked:self.searchBar];
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

- (void)requestDidFail:(NSError *)error {
    [self.loadingIndicator stopAnimating];
    self.footnoteLabel.text = [NSString stringWithFormat:@"%@", [error localizedDescription]];
    self.tableView.tableFooterView.hidden = NO;
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

#pragma mark Search Bar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length > 0) {
        [self performSearch:searchBar.text];
    }
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //There is no Cancel button to avoid conflicting with the Search button (in terms of layout)
    //See search method comment
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshTableFooter:NO];
    
    self.searchBar.delegate = self;
    
    self.postRequestDelegate = [[ARFPostRequest alloc] init];
}

#pragma mark - Segues

- (IBAction)unwindToMaster:(UIStoryboardSegue *)segue {
    
    ARFMapViewController *mapViewController = [segue sourceViewController];
    NSString *streetName = mapViewController.streetName;
    if (streetName) {
        self.searchBar.text = streetName;
        [self performSearch:streetName];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *route = self.objects[indexPath.row];
        
        [[segue destinationViewController] setRoute:route];
    }
}

@end
