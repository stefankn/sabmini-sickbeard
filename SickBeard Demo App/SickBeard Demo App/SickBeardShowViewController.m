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

@interface SickBeardShowViewController () <UIActionSheetDelegate>

- (void)refreshShowDetails;
- (IBAction)showActions:(id)sender;

@end

@implementation SickBeardShowViewController
@synthesize show;

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
    [self.show getFullDetails:^(SSBSickBeardResult *result) {
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

- (IBAction)showActions:(id)sender
{
    NSString *statusString;
    if (self.show.paused) {
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
    SickBeardEpisodesViewController *episodesViewController = (SickBeardEpisodesViewController *)segue.destinationViewController;
    episodesViewController.show = show;
    episodesViewController.season = cell.tag;
}

#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (self.show.paused) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [self.show unpause:^(SSBSickBeardResult *result) {
                [self refreshShowDetails];
            } onFailure:^(SSBSickBeardResult *result) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }];
        }
        else {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [self.show pause:^(SSBSickBeardResult *result) {
                [self refreshShowDetails];
            } onFailure:^(SSBSickBeardResult *result) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }];
        }
    }
    
    if (buttonIndex == 1)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.show refresh:^(SSBSickBeardResult *result) {
            [self refreshShowDetails];
        } onFailure:^(SSBSickBeardResult *result) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }
    
    if (buttonIndex == 2)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.show update:^(SSBSickBeardResult *result) {
            [self refreshShowDetails];
        } onFailure:^(SSBSickBeardResult *result) {
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
        return [self.show.genre count];
    }
    else if (section == 2) {
        return [self.show.season_list count];
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
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"Paused";
            if (self.show.paused) {
                cell.detailTextLabel.text = @"Yes";
            }
            else {
                cell.detailTextLabel.text = @"No";
            }
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Status";
            cell.detailTextLabel.text = self.show.status;
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"Network";
            cell.detailTextLabel.text = self.show.network;
        }
        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"Airs";
            cell.detailTextLabel.text = self.show.airs;
        }
        
        if (indexPath.row == 4) {
            cell.textLabel.text = @"Next episode";
            cell.detailTextLabel.text = self.show.airs;
            
            if ([self.show.next_ep_airdate isEqualToString:@""]) {
                cell.detailTextLabel.text = @"-";
            }
            else {
                cell.detailTextLabel.text = self.show.next_ep_airdate;
            }
        }
        
        if (indexPath.row == 5) {
            cell.textLabel.text = @"Quality";
            cell.detailTextLabel.text = self.show.quality;
        }
    }
    else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:GenreCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [self.show.genre objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:SeasonCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"Season %@", [self.show.season_list objectAtIndex:indexPath.row]];
        cell.tag = [[self.show.season_list objectAtIndex:indexPath.row] intValue];
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
        return self.show.show_name;
    }
    else if (section == 1) {
        return @"Genres";
    }
    else if (section == 2) {
        return @"Seasons";
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
