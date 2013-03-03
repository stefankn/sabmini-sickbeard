//
//  SickBeardShowsViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 21-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SickBeardShowsViewController.h"
#import "SSBSickBeardServer.h"
#import "SSBSickBeard.h"
#import "SSBSickBeardShow.h"
#import "SSBSickBeardResult.h"
#import "SickBeardShowViewController.h"

@interface SickBeardShowsViewController () {
    NSMutableArray *_shows;
}

@end

@implementation SickBeardShowsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SSBSickBeard getShows:@"id" onlyPaused:NO onComplete:^(NSDictionary *data) {

        _shows = [NSMutableArray arrayWithArray:[data objectForKey:@"results"]];
        [self.tableView reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } onFailure:^(SSBSickBeardResult *result) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowDetailsSegue"])
    {
        UITableViewCell *cell = (UITableViewCell *) sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        SSBSickBeardShow *show = [_shows objectAtIndex:indexPath.row];
        SickBeardShowViewController *showViewController = (SickBeardShowViewController *)segue.destinationViewController;
        showViewController.show = show;
    }
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
    return [_shows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShowCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SSBSickBeardShow *show = [_shows objectAtIndex:indexPath.row];
    cell.textLabel.text = show.show_name;
    
    if ([show.quality isEqualToString:@"HD"]) {
        cell.imageView.image = [UIImage imageNamed:@"hd"];
    }
    else if ([show.quality isEqualToString:@"SD"]) {
        cell.imageView.image = [UIImage imageNamed:@"sd"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"cu"];
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Next episode: %@", show.next_ep_airdate];
    
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SSBSickBeardShow *show = [_shows objectAtIndex:indexPath.row];
        [show deleteShow:^(SSBSickBeardResult *result) {
            if (result.success) {
                [_shows removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } onFailure:^(SSBSickBeardResult *result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
        
    }
}

@end
