//
//  SSBSickBeardUpcomingEpisodesViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 21-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SSBSickBeardUpcomingEpisodesViewController.h"
#import "SSBSickBeard.h"
#import "SSBSickBeardResult.h"
#import "SSBSickBeardEpisode.h"
#import "SickBeardEpisodeViewController.h"

@interface SSBSickBeardUpcomingEpisodesViewController ()

@property (nonatomic, strong) NSDictionary *upcomingEpisodes;

@end

@implementation SSBSickBeardUpcomingEpisodesViewController
@synthesize upcomingEpisodes;

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

    [SSBSickBeard getFutureEpisodesForType:@"later" withPaused:YES sortOn:@"date" onComplete:^(NSDictionary *data) {

        self.upcomingEpisodes = [[NSDictionary alloc] initWithDictionary:data];

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
    UITableViewCell *cell = (UITableViewCell *) sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    SSBSickBeardEpisode *episode;
    if (indexPath.section == 0 && [self.upcomingEpisodes objectForKey:@"missing"]) {
        episode = [[self.upcomingEpisodes objectForKey:@"missing"] objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 1 && [self.upcomingEpisodes objectForKey:@"today"]) {
        episode = [[self.upcomingEpisodes objectForKey:@"today"] objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 2 && [self.upcomingEpisodes objectForKey:@"soon"]) {
        episode = [[self.upcomingEpisodes objectForKey:@"soon"] objectAtIndex:indexPath.row];
    }
    else {
        episode = [[self.upcomingEpisodes objectForKey:@"later"] objectAtIndex:indexPath.row];
    }

    SickBeardEpisodeViewController *episodeViewController = (SickBeardEpisodeViewController *)segue.destinationViewController;
    episodeViewController.episode = episode;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0 && [self.upcomingEpisodes objectForKey:@"missing"]) {
        return [[self.upcomingEpisodes objectForKey:@"missing"] count];
    }
    else if (section == 1 && [self.upcomingEpisodes objectForKey:@"today"]) {
        return [[self.upcomingEpisodes objectForKey:@"today"] count];
    }
    else if (section == 2 && [self.upcomingEpisodes objectForKey:@"soon"]) {
        return [[self.upcomingEpisodes objectForKey:@"soon"] count];
    }
    else if (section == 3 && [self.upcomingEpisodes objectForKey:@"later"]) {
        return [[self.upcomingEpisodes objectForKey:@"later"] count];
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EpisodeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SSBSickBeardEpisode *episode;
    
    if (indexPath.section == 0 && [self.upcomingEpisodes objectForKey:@"missing"]) {
        episode = [[self.upcomingEpisodes objectForKey:@"missing"] objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 1 && [self.upcomingEpisodes objectForKey:@"today"]) {
        episode = [[self.upcomingEpisodes objectForKey:@"today"] objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 2 && [self.upcomingEpisodes objectForKey:@"soon"]) {
        episode = [[self.upcomingEpisodes objectForKey:@"soon"] objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 3 && [self.upcomingEpisodes objectForKey:@"later"]) {
        episode = [[self.upcomingEpisodes objectForKey:@"later"] objectAtIndex:indexPath.row];
        
    }
    else {
        return nil;
    }
    
    cell.textLabel.text = episode.show_name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"S%@E%@ - %@", episode.season, episode.episode, episode.ep_name];
    
    if ([episode.quality isEqualToString:@"HD"]) {
        cell.imageView.image = [UIImage imageNamed:@"hd"];
    }
    else if ([episode.quality isEqualToString:@"SD"]) {
        cell.imageView.image = [UIImage imageNamed:@"sd"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"cu"];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 && [self.upcomingEpisodes objectForKey:@"missing"]) {
        return @"Missing";
    }
    else if (section == 1 && [self.upcomingEpisodes objectForKey:@"today"]) {
        return @"Today";
    }
    else if (section == 2 && [self.upcomingEpisodes objectForKey:@"soon"]) {
        return @"Soon";
    }
    else if (section == 3 && [self.upcomingEpisodes objectForKey:@"later"]) {
        return @"Later";
        
    }
    else {
        return nil;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
