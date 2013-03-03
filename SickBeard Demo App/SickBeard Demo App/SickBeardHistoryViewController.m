//
//  SickBeardHistoryViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 23-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SickBeardHistoryViewController.h"
#import "SSBSickBeard.h"
#import "SSBSickBeardEpisode.h"
#import "SSBSickBeardResult.h"
#import "SickBeardEpisodeViewController.h"

@interface SickBeardHistoryViewController () <UIActionSheetDelegate> {
    NSMutableArray *_episodes;
}

- (IBAction)historyActions:(id)sender;
- (void)refreshHistory;

@end

@implementation SickBeardHistoryViewController

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
    [self refreshHistory];
}

- (void)refreshHistory
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [SSBSickBeard getHistory:100 forType:@"" onComplete:^(NSDictionary *data) {
        _episodes = [NSMutableArray arrayWithArray:[data objectForKey:@"results"]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.tableView reloadData];
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
    
    SSBSickBeardEpisode *episode = [_episodes objectAtIndex:indexPath.row];
    
    SickBeardEpisodeViewController *episodeViewController = (SickBeardEpisodeViewController *)segue.destinationViewController;
    episodeViewController.episode = episode;
}

- (IBAction)historyActions:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Clear history", @"Clear older than 30 days", nil];
	[sheet showInView:[UIApplication sharedApplication].keyWindow];
	sheet.actionSheetStyle = UIActionSheetStyleDefault;
}

#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [SSBSickBeard clearHistory:^(SSBSickBeardResult *result) {
            [self refreshHistory];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } onFailure:^(SSBSickBeardResult *result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }
    
    if (buttonIndex == 1)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [SSBSickBeard trimHistory:^(SSBSickBeardResult *result) {
            [self refreshHistory];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } onFailure:^(SSBSickBeardResult *result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
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
    return [_episodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EpisodeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SSBSickBeardEpisode *episode = [_episodes objectAtIndex:indexPath.row];
    cell.textLabel.text = episode.show_name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"S%@E%@ - %@ - %@", episode.season, episode.episode, episode.status, episode.quality];
    
    return cell;
}

@end
