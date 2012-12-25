//
//  SickBeardShowQualityViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 24-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SickBeardShowQualityViewController.h"
#import "SSBSickBeardShow.h"
#import "SSBSickBeard.h"
#import "SSBSickBeardResult.h"

@interface SickBeardShowQualityViewController ()

@property (nonatomic, strong) NSMutableArray *archive;
@property (nonatomic, strong) NSMutableArray *initial;
@property (nonatomic, strong) NSArray *qualityEntries;
@property (nonatomic, strong) NSDictionary *qualityEntriesFullNames;

@end

@implementation SickBeardShowQualityViewController

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

    self.qualityEntries = [NSArray arrayWithObjects:@"fullhdbluray", @"hdbluray", @"hdwebdl", @"hdtv", @"sddvd", @"sdtv", @"any", nil];
    self.qualityEntriesFullNames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1080p BluRay", @"720p BluRay", @"720p WEB-DL", @"HD TV", @"SD DVD", @"SD TV", @"Any", nil] forKeys:self.qualityEntries];
    
    self.initial = [NSMutableArray arrayWithArray:[self.show.quality_details objectForKey:@"initial"]];
    self.archive = [NSMutableArray arrayWithArray:[self.show.quality_details objectForKey:@"archive"]];
}

- (void)viewWillDisappear:(BOOL)animated
{    
    [super viewWillDisappear:animated];
    
    [self.show setQuality:self.initial archive:self.archive onComplete:^(SSBSickBeardResult *result) {
        [self.delegate qualitySettingsChanged];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.qualityEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QualityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *qualityEntry = [self.qualityEntries objectAtIndex:indexPath.row];
    cell.textLabel.text = [self.qualityEntriesFullNames objectForKey:qualityEntry];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 0)
    {
        NSEnumerator *e = [self.initial objectEnumerator];
        NSString *object;
        while (object = [e nextObject])
        {
            if ([object isEqualToString:qualityEntry])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    else
    {
        NSEnumerator *e = [self.archive objectEnumerator];
        NSString *object;
        while (object = [e nextObject])
        {
            if ([object isEqualToString:qualityEntry])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Initial";
    }
    else {
        return @"Archive";
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
    if (indexPath.section == 0)
    {
        NSString *qualityEntry = [self.qualityEntries objectAtIndex:indexPath.row];
        
        NSMutableArray *defaultsInitialTemp = [NSMutableArray arrayWithArray:self.initial];
        NSEnumerator *e = [self.initial objectEnumerator];
        NSString *object;
        
        int i = 0;
        BOOL exist = NO;
        
        while (object = [e nextObject])
        {
            if ([object isEqualToString:qualityEntry])
            {
                [defaultsInitialTemp removeObjectAtIndex:i];
                exist = YES;
            }
            
            i++;
        }
        
        [self.initial removeAllObjects];
        [self.initial addObjectsFromArray:defaultsInitialTemp];
        
        if (!exist) {
            [self.initial addObject:qualityEntry];
        }
        
        [self.tableView reloadData];
    }
    else
    {
        NSString *qualityEntry = [self.qualityEntries objectAtIndex:indexPath.row];
        
        NSMutableArray *defaultsArchiveTemp = [NSMutableArray arrayWithArray:self.archive];
        NSEnumerator *e = [self.archive objectEnumerator];
        NSString *object;
        
        int i = 0;
        BOOL exist = NO;
        
        while (object = [e nextObject])
        {
            if ([object isEqualToString:qualityEntry])
            {
                [defaultsArchiveTemp removeObjectAtIndex:i];
                exist = YES;
            }
            
            i++;
        }
        
        [self.archive removeAllObjects];
        [self.archive addObjectsFromArray:defaultsArchiveTemp];
        
        if (!exist) {
            [self.archive addObject:qualityEntry];
        }
        
        [self.tableView reloadData];
    }
}

@end
