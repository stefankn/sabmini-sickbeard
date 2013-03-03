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

@interface SSBSickBeardUpcomingEpisodesViewController () {
    NSDictionary *_upcomingEpisodes;
}

@end

@implementation SSBSickBeardUpcomingEpisodesViewController

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

        _upcomingEpisodes = [[NSDictionary alloc] initWithDictionary:data];

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
    if (indexPath.section == 0 && [_upcomingEpisodes objectForKey:@"missing"]) {
        episode = [[_upcomingEpisodes objectForKey:@"missing"] objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 1 && [_upcomingEpisodes objectForKey:@"today"]) {
        episode = [[_upcomingEpisodes objectForKey:@"today"] objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 2 && [_upcomingEpisodes objectForKey:@"soon"]) {
        episode = [[_upcomingEpisodes objectForKey:@"soon"] objectAtIndex:indexPath.row];
    }
    else {
        episode = [[_upcomingEpisodes objectForKey:@"later"] objectAtIndex:indexPath.row];
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
    if (section == 0 && [_upcomingEpisodes objectForKey:@"missing"]) {
        return [[_upcomingEpisodes objectForKey:@"missing"] count];
    }
    else if (section == 1 && [_upcomingEpisodes objectForKey:@"today"]) {
        return [[_upcomingEpisodes objectForKey:@"today"] count];
    }
    else if (section == 2 && [_upcomingEpisodes objectForKey:@"soon"]) {
        return [[_upcomingEpisodes objectForKey:@"soon"] count];
    }
    else if (section == 3 && [_upcomingEpisodes objectForKey:@"later"]) {
        return [[_upcomingEpisodes objectForKey:@"later"] count];
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
    
    if (indexPath.section == 0 && [_upcomingEpisodes objectForKey:@"missing"]) {
        episode = [[_upcomingEpisodes objectForKey:@"missing"] objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 1 && [_upcomingEpisodes objectForKey:@"today"]) {
        episode = [[_upcomingEpisodes objectForKey:@"today"] objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 2 && [_upcomingEpisodes objectForKey:@"soon"]) {
        episode = [[_upcomingEpisodes objectForKey:@"soon"] objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 3 && [_upcomingEpisodes objectForKey:@"later"]) {
        episode = [[_upcomingEpisodes objectForKey:@"later"] objectAtIndex:indexPath.row];
        
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
    if (section == 0 && [_upcomingEpisodes objectForKey:@"missing"]) {
        return @"Missing";
    }
    else if (section == 1 && [_upcomingEpisodes objectForKey:@"today"]) {
        return @"Today";
    }
    else if (section == 2 && [_upcomingEpisodes objectForKey:@"soon"]) {
        return @"Soon";
    }
    else if (section == 3 && [_upcomingEpisodes objectForKey:@"later"]) {
        return @"Later";
    }
    else {
        return nil;
    }
}

@end
