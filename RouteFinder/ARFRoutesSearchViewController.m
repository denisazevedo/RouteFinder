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

//Connection helper
@property (strong, nonatomic) ARFPostRequest *postRequestHelper;
//Table view data
@property (strong, nonatomic) NSMutableArray *routes; //array of NSDictionary
//Outlets
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *totalRoutesFoundLabel;

@end

@implementation ARFRoutesSearchViewController

NSString *const KEY_SHORT_NAME = @"shortName";
NSString *const KEY_LONG_NAME = @"longName";
NSString *const KEY_ID = @"id";
NSString *const KEY_NAME = @"name";
NSString *const KEY_CALENDAR = @"calendar";
NSString *const KEY_TIME = @"time";

- (void)addRoutesToTableView:(NSArray *)routes {
    [self.routes addObjectsFromArray:routes];
    [self.tableView reloadData];
    [self refreshTableFooter:YES];
}

- (void)refreshTableFooter:(BOOL)isVisible {
    if (isVisible) {
        self.totalRoutesFoundLabel.text = [NSString stringWithFormat:@"%d route(s) found", [self.routes count]];
    }
    self.tableView.tableFooterView.hidden = !isVisible;
}

- (void)clearTableView {
    [self.routes removeAllObjects];
    [self.tableView reloadData];
    [self refreshTableFooter:NO];
}

- (void)performSearch:(NSString *)routeName {
    [self clearTableView];
    if (routeName.length > 0) {
        NSString *param = [NSString stringWithFormat:@"%%%@%%", routeName];
        [self.postRequestHelper findRoutesByStopName:param delegate:self];
        [self.loadingIndicator startAnimating];
    }
}

#pragma mark - IBActions

- (IBAction)search:(UIButton *)sender {
    //As per Cristiano's requirements, need a button called 'Search'
    [self searchBarSearchButtonClicked:self.searchBar];
}

#pragma mark - Properties

- (NSMutableArray *)routes {
    if (!_routes) {
        _routes = [[NSMutableArray alloc] init];
    }
    return _routes;
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
    self.totalRoutesFoundLabel.text = [NSString stringWithFormat:@"%@", [error localizedDescription]];
    self.tableView.tableFooterView.hidden = NO;
    
    NSString *msg = [NSString stringWithFormat:@"Connection failed!\nError: %@\nPlease check your connection settings", [error localizedDescription]];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:msg
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *route = self.routes[indexPath.row];
    
    cell.textLabel.text = route[KEY_SHORT_NAME];
    cell.detailTextLabel.text = [route[KEY_LONG_NAME] capitalizedString];
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
    
    self.postRequestHelper = [[ARFPostRequest alloc] init];
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
        NSDictionary *route = self.routes[indexPath.row];
        
        [[segue destinationViewController] setRoute:route];
    }
}

@end
