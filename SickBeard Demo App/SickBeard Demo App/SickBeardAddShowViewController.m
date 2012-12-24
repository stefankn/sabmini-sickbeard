//
//  SickBeardAddShowViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 23-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SickBeardAddShowViewController.h"
#import "SSBSickBeard.h"
#import "SSBSickBeardResult.h"
#import "SickBeardAddShowFinishViewController.h"

@interface SickBeardAddShowViewController () <UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UITableView *searchResultsTableView;
@property (nonatomic, weak) IBOutlet UISearchBar *showSearchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;

- (IBAction)cancelAddShow:(id)sender;

@end

@implementation SickBeardAddShowViewController
@synthesize searchResultsTableView, searchResults, showSearchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.searchResults = [NSMutableArray array];
    [self.showSearchBar becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.searchResultsTableView deselectRowAtIndexPath:[self.searchResultsTableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAddShow:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = (UITableViewCell *) sender;
    NSIndexPath *indexPath = [self.searchResultsTableView indexPathForCell:cell];
    
    NSDictionary *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    SickBeardAddShowFinishViewController *addShowFinishViewController = (SickBeardAddShowFinishViewController *)segue.destinationViewController;
    addShowFinishViewController.searchResult = searchResult;
}

#pragma mark -
#pragma mark UISearchBar Delegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchResults removeAllObjects];
	[self.searchResultsTableView reloadData];
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [SSBSickBeard searchTvdb:searchBar.text tvdb:@"" language:@"en" onComplete:^(NSDictionary *data) {
        [self.searchResults removeAllObjects];
        [self.searchResults addObjectsFromArray:[data objectForKey:@"results"]];
        [self.searchResultsTableView reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } onFailure:^(SSBSickBeardResult *result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [searchResult objectForKey:@"name"];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"First aired: %@", [searchResult objectForKey:@"first_aired"]];
    
    return cell;
}

@end
