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

@interface SickBeardShowQualityViewController () {
    NSMutableArray *_archive;
    NSMutableArray *_initial;
    NSArray *_qualityEntries;
    NSDictionary *_qualityEntriesFullNames;
}

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

    _qualityEntries = [NSArray arrayWithObjects:@"fullhdbluray", @"hdbluray", @"hdwebdl", @"hdtv", @"sddvd", @"sdtv", @"any", nil];
    _qualityEntriesFullNames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1080p BluRay", @"720p BluRay", @"720p WEB-DL", @"HD TV", @"SD DVD", @"SD TV", @"Any", nil] forKeys:_qualityEntries];
    
    _initial = [NSMutableArray arrayWithArray:[_show.quality_details objectForKey:@"initial"]];
    _archive = [NSMutableArray arrayWithArray:[_show.quality_details objectForKey:@"archive"]];
}

- (void)viewWillDisappear:(BOOL)animated
{    
    [super viewWillDisappear:animated];
    
    [_show setQuality:_initial archive:_archive onComplete:^(SSBSickBeardResult *result) {
        [_delegate qualitySettingsChanged];
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
    return [_qualityEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QualityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *qualityEntry = [_qualityEntries objectAtIndex:indexPath.row];
    cell.textLabel.text = [_qualityEntriesFullNames objectForKey:qualityEntry];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 0)
    {
        NSEnumerator *e = [_initial objectEnumerator];
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
        NSEnumerator *e = [_archive objectEnumerator];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSString *qualityEntry = [_qualityEntries objectAtIndex:indexPath.row];
        
        NSMutableArray *defaultsInitialTemp = [NSMutableArray arrayWithArray:_initial];
        NSEnumerator *e = [_initial objectEnumerator];
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
        
        [_initial removeAllObjects];
        [_initial addObjectsFromArray:defaultsInitialTemp];
        
        if (!exist) {
            [_initial addObject:qualityEntry];
        }
        
        [self.tableView reloadData];
    }
    else
    {
        NSString *qualityEntry = [_qualityEntries objectAtIndex:indexPath.row];
        
        NSMutableArray *defaultsArchiveTemp = [NSMutableArray arrayWithArray:_archive];
        NSEnumerator *e = [_archive objectEnumerator];
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
        
        [_archive removeAllObjects];
        [_archive addObjectsFromArray:defaultsArchiveTemp];
        
        if (!exist) {
            [_archive addObject:qualityEntry];
        }
        
        [self.tableView reloadData];
    }
}

@end
