//
//  SickBeardShowViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 22-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SickBeardShowViewController.h"
#import "SSBSickBeardShow.h"
#import "SSBSickBeardResult.h"
#import "SickBeardEpisodesViewController.h"
#import "SickBeardShowStatisticsViewController.h"
#import "SickBeardShowQualityViewController.h"

@interface SickBeardShowViewController () <UIActionSheetDelegate, SickBeardShowQualityDelegate>

- (void)refreshShowDetails;
- (IBAction)showActions:(id)sender;

@end

@implementation SickBeardShowViewController

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
    
    [self refreshShowDetails];
}

- (void)refreshShowDetails
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [_show getFullDetails:^(SSBSickBeardResult *result) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.tableView reloadData];
        
        [_show getBanner:^(UIImage *banner) {
            UIImageView *bannerView = [[UIImageView alloc] initWithImage:banner];
            bannerView.contentMode = UIViewContentModeScaleAspectFit;
            self.tableView.tableHeaderView = bannerView;
            
        } onFailure:nil];
        
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

- (IBAction)showActions:(id)sender
{
    NSString *statusString;
    if (_show.paused) {
        statusString = @"Unpause show";
    }
    else {
        statusString = @"Pause show";
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:statusString, @"Refresh show", @"Update show", nil];
	[sheet showInView:[UIApplication sharedApplication].keyWindow];
	sheet.actionSheetStyle = UIActionSheetStyleDefault;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = (UITableViewCell *)sender;
    
    if ([[segue identifier] isEqualToString:@"StatisticsSegue"])
    {
        SickBeardShowStatisticsViewController *statisticsViewController = (SickBeardShowStatisticsViewController *)segue.destinationViewController;
        statisticsViewController.show = _show;
        
    }
    else if ([[segue identifier] isEqualToString:@"QualitySegue"])
    {
        SickBeardShowQualityViewController *showQualityViewController = (SickBeardShowQualityViewController *)segue.destinationViewController;
        showQualityViewController.show = _show;
        showQualityViewController.delegate = self;
    } else
    {
        SickBeardEpisodesViewController *episodesViewController = (SickBeardEpisodesViewController *)segue.destinationViewController;
        episodesViewController.show = _show;
        episodesViewController.season = cell.tag;
    }
}

#pragma mark -
#pragma mark SickBeardShowQuality Delegate Methods

- (void)qualitySettingsChanged
{
    [self refreshShowDetails];
}

#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (_show.paused) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [_show unpause:^(SSBSickBeardResult *result) {
                [self refreshShowDetails];
            } onFailure:^(SSBSickBeardResult *result) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }];
        }
        else {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [_show pause:^(SSBSickBeardResult *result) {
                [self refreshShowDetails];
            } onFailure:^(SSBSickBeardResult *result) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }];
        }
    }
    
    if (buttonIndex == 1)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [_show refresh:^(SSBSickBeardResult *result) {
            [self refreshShowDetails];
        } onFailure:^(SSBSickBeardResult *result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }
    
    if (buttonIndex == 2)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [_show update:^(SSBSickBeardResult *result) {
            [self refreshShowDetails];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 6;
    }
    else if (section == 1) {
        return [_show.genre count];
    }
    else if (section == 2) {
        return [_show.season_list count];
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShowDetailsCell";
    static NSString *GenreCellIdentifier = @"GenreCell";
    static NSString *SeasonCellIdentifier = @"SeasonCell";
    static NSString *StatisticsCellIdentifier = @"StatisticsCell";
    static NSString *QualityCellIdentifier = @"QualityCell";
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        if (indexPath.row != 5) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"Paused";
            if (_show.paused) {
                cell.detailTextLabel.text = @"Yes";
            }
            else {
                cell.detailTextLabel.text = @"No";
            }
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Status";
            cell.detailTextLabel.text = _show.status;
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"Network";
            cell.detailTextLabel.text = _show.network;
        }
        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"Airs";
            cell.detailTextLabel.text = _show.airs;
        }
        
        if (indexPath.row == 4) {
            cell.textLabel.text = @"Next episode";
            cell.detailTextLabel.text = _show.airs;
            
            if ([_show.next_ep_airdate isEqualToString:@""]) {
                cell.detailTextLabel.text = @"-";
            }
            else {
                cell.detailTextLabel.text = _show.next_ep_airdate;
            }
        }
        
        if (indexPath.row == 5) {
            cell = [tableView dequeueReusableCellWithIdentifier:QualityCellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"Quality";
            cell.detailTextLabel.text = _show.quality;
        }
    }
    else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:GenreCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [_show.genre objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:SeasonCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"Season %@", [_show.season_list objectAtIndex:indexPath.row]];
        cell.tag = [[_show.season_list objectAtIndex:indexPath.row] intValue];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:StatisticsCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"Statistics";
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return _show.show_name;
    }
    else if (section == 1) {
        return @"Genres";
    }
    else if (section == 2) {
        return @"Seasons";
    }

    return nil;
}

@end
