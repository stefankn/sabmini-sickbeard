//
//  SickBeardEpisodeViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 22-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SickBeardEpisodeViewController.h"
#import "SSBSickBeardEpisode.h"
#import "SSBSickBeardResult.h"

@interface SickBeardEpisodeViewController () <UIActionSheetDelegate>

- (void)refreshEpisodeDetails;
- (IBAction)episodeActions:(id)sender;

@end

@implementation SickBeardEpisodeViewController

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

    [self refreshEpisodeDetails];
}

- (void)refreshEpisodeDetails
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [_episode getFullDetails:^(SSBSickBeardResult *result) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.tableView reloadData];
    } onFailure:^(SSBSickBeardResult *result) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)episodeActions:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Episode status" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Wanted", @"Skipped", @"Archived", @"Ignored", nil];
	[sheet showInView:[UIApplication sharedApplication].keyWindow];
	sheet.actionSheetStyle = UIActionSheetStyleDefault;
}

#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 4)
    {
        NSString *status;
        
        if (buttonIndex == 0) status = @"wanted";
        if (buttonIndex == 1) status = @"skipped";
        if (buttonIndex == 2) status = @"archived";
        if (buttonIndex == 3) status = @"ignored";
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [_episode changeStatus:status onComplete:^(SSBSickBeardResult *result) {
            [self refreshEpisodeDetails];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EpisodeDetailCell";
    static NSString *DescriptionCellIdentifier = @"DescriptionCell";
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Airdate";
            cell.detailTextLabel.text = _episode.airdate;
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Quality";
            cell.detailTextLabel.text = _episode.quality;
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"Status";
            cell.detailTextLabel.text = _episode.status;
        }
    }
    
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:DescriptionCellIdentifier forIndexPath:indexPath];
        
        if ([_episode.ep_plot isEqualToString:@""]) {
            cell.textLabel.text = @"No description available";
        }
        else {
            cell.textLabel.text = _episode.ep_plot;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [NSString stringWithFormat:@"Episode %@ - %@", _episode.episode, _episode.name];
    }
    
    return @"Episode description";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1)
	{
        if ([_episode.ep_plot isEqualToString:@""]) {
            return 50;
        }
        else {
            CGSize size = [_episode.ep_plot sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
            return size.height + 10;
        }
	}
	else
	{
		return 50;
	}
}

@end
