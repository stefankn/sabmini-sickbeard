//
//  SickBeardShowStatisticsViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 23-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SickBeardShowStatisticsViewController.h"
#import "SSBSickBeard.h"
#import "SSBSickBeardResult.h"
#import "SSBSickBeardShow.h"

@interface SickBeardShowStatisticsViewController ()

@property (nonatomic, strong) NSDictionary *statistics;

@end

@implementation SickBeardShowStatisticsViewController
@synthesize statistics, show;

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

    [self.show getStatistics:^(SSBSickBeardResult *result) {
        self.statistics = [NSDictionary dictionaryWithDictionary:result.data];
        NSLog(@"%@", self.statistics);
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 6;
    }
    else if (section == 1) {
        return [[self.statistics objectForKey:@"downloaded"] count];
    }
    else {
        return [[self.statistics objectForKey:@"snatched"] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StatisticCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Archived";
            cell.detailTextLabel.text = [[self.statistics objectForKey:@"archived"] stringValue];
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Ignored";
            cell.detailTextLabel.text = [[self.statistics objectForKey:@"ignored"] stringValue];
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"Skipped";
            cell.detailTextLabel.text = [[self.statistics objectForKey:@"skipped"] stringValue];
        }
        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"Unaired";
            cell.detailTextLabel.text = [[self.statistics objectForKey:@"unaired"] stringValue];
        }
        
        if (indexPath.row == 4) {
            cell.textLabel.text = @"Wanted";
            cell.detailTextLabel.text = [[self.statistics objectForKey:@"wanted"] stringValue];
        }
        
        if (indexPath.row == 5) {
            cell.textLabel.text = @"Total";
            cell.detailTextLabel.text = [[self.statistics objectForKey:@"total"] stringValue];
        }
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"1080p Bluray";
            cell.detailTextLabel.text = [[[self.statistics objectForKey:@"downloaded"] objectForKey:@"1080p_bluray"] stringValue];
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"720p Bluray";
            cell.detailTextLabel.text = [[[self.statistics objectForKey:@"downloaded"] objectForKey:@"720p_bluray"] stringValue];
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"720 WEB-DL";
            cell.detailTextLabel.text = [[[self.statistics objectForKey:@"downloaded"] objectForKey:@"720p_web-dl"] stringValue];
        }
        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"HD TV";
            cell.detailTextLabel.text = [[[self.statistics objectForKey:@"downloaded"] objectForKey:@"hd_tv"] stringValue];
        }
        
        if (indexPath.row == 4) {
            cell.textLabel.text = @"SD DVD";
            cell.detailTextLabel.text = [[[self.statistics objectForKey:@"downloaded"] objectForKey:@"sd_dvd"] stringValue];
        }
        
        if (indexPath.row == 5) {
            cell.textLabel.text = @"SD TV";
            cell.detailTextLabel.text = [[[self.statistics objectForKey:@"downloaded"] objectForKey:@"sd_tv"] stringValue];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"1080p Bluray";
            cell.detailTextLabel.text = [[[self.statistics objectForKey:@"snatched"] objectForKey:@"1080p_bluray"] stringValue];
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"720p Bluray";
            cell.detailTextLabel.text = [[[self.statistics objectForKey:@"snatched"] objectForKey:@"720p_bluray"] stringValue];
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"720 WEB-DL";
            cell.detailTextLabel.text = [[[self.statistics objectForKey:@"snatched"] objectForKey:@"720p_web-dl"] stringValue];
        }
        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"HD TV";
            cell.detailTextLabel.text = [[[self.statistics objectForKey:@"snatched"] objectForKey:@"hd_tv"] stringValue];
        }
        
        if (indexPath.row == 4) {
            cell.textLabel.text = @"SD DVD";
            cell.detailTextLabel.text = [[[self.statistics objectForKey:@"snatched"] objectForKey:@"sd_dvd"] stringValue];
        }
        
        if (indexPath.row == 5) {
            cell.textLabel.text = @"SD TV";
            cell.detailTextLabel.text = [[[self.statistics objectForKey:@"snatched"] objectForKey:@"sd_tv"] stringValue];
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Downloaded";
    }
    else if (section == 2) {
        return @"Snatched";
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
