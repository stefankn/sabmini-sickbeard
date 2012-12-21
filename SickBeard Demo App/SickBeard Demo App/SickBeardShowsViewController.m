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

@interface SickBeardShowsViewController ()

@property (nonatomic, strong) NSArray *shows;

@end

@implementation SickBeardShowsViewController
@synthesize shows;

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

    SSBSickBeardServer *server = [SSBSickBeardServers createServer:@"Test server" withHost:@"10.0.1.110" withPort:@"8081" withApikey:@"8b1a4a7850815520f2c06cf1ebc9586c" enableHttps:YES store:NO];
    SSBSickBeard *sickBeard = [[SSBSickBeard alloc] initWithServer:server];
    
    [sickBeard getShows:@"id" onlyPaused:NO onComplete:^(NSDictionary *data) {

        self.shows = [NSArray arrayWithArray:[data objectForKey:@"results"]];
        [self.tableView reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } onFailure:^(SSBSickBeardResult *result) {
        
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.shows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShowCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SSBSickBeardShow *show = [self.shows objectAtIndex:indexPath.row];
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
