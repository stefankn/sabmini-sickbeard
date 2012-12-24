//
//  SickBeardAddShowFinishViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 24-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SickBeardAddShowFinishViewController.h"
#import "SSBSickBeard.h"
#import "SSBSickBeardResult.h"

@interface SickBeardAddShowFinishViewController ()

@property (nonatomic, strong) NSArray *rootDirs;
@property (nonatomic, strong) NSString *selectedRootDir;
@property (nonatomic, assign) BOOL useDefaultRootDir;
@property (nonatomic, strong) NSArray *qualityEntries;
@property (nonatomic, strong) NSDictionary *qualityEntriesFullNames;
@property (nonatomic, strong) NSDictionary *defaults;
@property (nonatomic, assign) BOOL useDefaultStatus;
@property (nonatomic, strong) NSString *selectedStatus;
@property (nonatomic, strong) NSMutableArray *defaultsInitial;
@property (nonatomic, strong) NSMutableArray *defaultsArchive;
@property (nonatomic, assign) BOOL flattenFolders;

- (IBAction)addShow:(id)sender;
- (void)flattenFoldersSwitchToggled:(UISwitch *)sw;

@end

@implementation SickBeardAddShowFinishViewController
@synthesize searchResult, rootDirs, selectedRootDir, useDefaultRootDir, qualityEntries, qualityEntriesFullNames, defaults, useDefaultStatus, selectedStatus, defaultsArchive, defaultsInitial, flattenFolders;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.searchResult objectForKey:@"name"];
    self.useDefaultRootDir = YES;
    self.useDefaultStatus = YES;
    self.qualityEntries = [NSArray arrayWithObjects:@"fullhdbluray", @"hdbluray", @"hdwebdl", @"hdtv", @"sddvd", @"sdtv", @"unknown", nil];
    self.qualityEntriesFullNames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1080p BluRay", @"720p BluRay", @"720p WEB-DL", @"HD TV", @"SD DVD", @"SD TV", @"Unknown", nil] forKeys:self.qualityEntries];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SSBSickBeard getRootDirs:^(NSDictionary *data) {
        self.rootDirs = [NSMutableArray arrayWithArray:[data objectForKey:@"data"]];
        [self.tableView reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } onFailure:^(SSBSickBeardResult *result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    [SSBSickBeard getDefaults:^(NSDictionary *data) {
        self.defaults = [NSDictionary dictionaryWithDictionary:[data objectForKey:@"data"]];
        self.defaultsInitial = [NSMutableArray arrayWithArray:[self.defaults objectForKey:@"initial"]];
        self.defaultsArchive = [NSMutableArray arrayWithArray:[self.defaults objectForKey:@"archive"]];
        self.flattenFolders = [[self.defaults objectForKey:@"flatten_folders"] boolValue];
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

- (IBAction)addShow:(id)sender
{
    if ([self.defaultsInitial count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"Please check at least one quality in the initial section!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([self.rootDirs count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"No root path defined!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [SSBSickBeard addNewShow:[self.searchResult objectForKey:@"tvdbid"] showLocation:self.selectedRootDir flattenFolders:self.flattenFolders initial:self.defaultsInitial archive:self.defaultsArchive initialStatus:self.selectedStatus language:@"en" onComplete:^(SSBSickBeardResult *result) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self dismissViewControllerAnimated:YES completion:nil];
        } onFailure:^(SSBSickBeardResult *result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }
}

- (void)flattenFoldersSwitchToggled:(UISwitch *)sw
{
    if (sw.on) {
        self.flattenFolders = YES;
    }
    else {
        self.flattenFolders = NO;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [self.rootDirs count];
    }
    else if (section == 1) {
        return 4;
    }
    else if (section == 2) {
        return [self.qualityEntries count];
    }
    else if (section == 3) {
        return [self.qualityEntries count];
    }
    else if (section == 4) {
        return 1;
    }
        
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CheckmarkCell";
    static NSString *SwitchCellIdentifier = @"SwitchCell";
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSDictionary *rootDir = [self.rootDirs objectAtIndex:indexPath.row];
        cell.textLabel.text = [rootDir objectForKey:@"location"];
        
        if ([[rootDir objectForKey:@"default"] boolValue] && self.useDefaultRootDir) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedRootDir = [rootDir objectForKey:@"location"];
        }
        else {
            if ([self.selectedRootDir isEqualToString:[rootDir objectForKey:@"location"]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Skipped";
            
            if (self.useDefaultStatus)
            {
                if ([[self.defaults objectForKey:@"status"] isEqualToString:@"skipped"]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    self.selectedStatus = @"skipped";
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            else
            {
                if ([self.selectedStatus isEqualToString:@"skipped"])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Wanted";
            
            if (self.useDefaultStatus)
            {
                if ([[self.defaults objectForKey:@"status"] isEqualToString:@"wanted"]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    self.selectedStatus = @"wanted";
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            else
            {
                if ([self.selectedStatus isEqualToString:@"wanted"])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"Archived";
            
            if (self.useDefaultStatus)
            {
                if ([[self.defaults objectForKey:@"status"] isEqualToString:@"archived"]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    self.selectedStatus = @"archived";
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            else
            {
                if ([self.selectedStatus isEqualToString:@"archived"])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }
        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"Ignored";
            
            if (self.useDefaultStatus)
            {
                if ([[self.defaults objectForKey:@"status"] isEqualToString:@"ignored"]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    self.selectedStatus = @"ignored";
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            else
            {
                if ([self.selectedStatus isEqualToString:@"ignored"])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }
    }
    
    if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSString *qualityEntry = [self.qualityEntries objectAtIndex:indexPath.row];
        cell.textLabel.text = [self.qualityEntriesFullNames objectForKey:qualityEntry];
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSEnumerator *e = [self.defaultsInitial objectEnumerator];
        NSString *object;
        while (object = [e nextObject])
        {
            if ([object isEqualToString:qualityEntry])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    
    if (indexPath.section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSString *qualityEntry = [self.qualityEntries objectAtIndex:indexPath.row];
        cell.textLabel.text = [self.qualityEntriesFullNames objectForKey:qualityEntry];
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSEnumerator *e = [self.defaultsArchive objectEnumerator];
        NSString *object;
        while (object = [e nextObject])
        {
            if ([object isEqualToString:qualityEntry])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    
    if (indexPath.section == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:SwitchCellIdentifier forIndexPath:indexPath];
        
        UISwitch *flattenFoldersSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [flattenFoldersSwitch addTarget:self action:@selector(flattenFoldersSwitchToggled:) forControlEvents:UIControlEventTouchUpInside];
        flattenFoldersSwitch.on = self.flattenFolders;
        cell.accessoryView = flattenFoldersSwitch;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Pick the parent folder";
    }
    else if (section == 1) {
        return @"Set the initial status of missing episodes";
    }
    else if (section == 2) {
        return @"Initial - Preferred quality";
    }
    else if (section == 3) {
        return @"Archive - Preferred quality (optional)";
    }
    
    return nil;
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
    if (indexPath.section == 0) {
        self.useDefaultRootDir = NO;
        NSDictionary *rootDir = [self.rootDirs objectAtIndex:indexPath.row];
        self.selectedRootDir = [rootDir objectForKey:@"location"];
        [self.tableView reloadData];
    }
    
    if (indexPath.section == 1) {
        self.useDefaultStatus = NO;
        
        if (indexPath.row == 0) {
            self.selectedStatus = @"skipped";
        }
        
        if (indexPath.row == 1) {
            self.selectedStatus = @"wanted";
        }
        
        if (indexPath.row == 2) {
            self.selectedStatus = @"archived";
        }
        
        if (indexPath.row == 3) {
            self.selectedStatus = @"ignored";
        }
        
        [self.tableView reloadData];
    }
    
    if (indexPath.section == 2) {
        NSString *qualityEntry = [self.qualityEntries objectAtIndex:indexPath.row];
        
        NSMutableArray *defaultsInitialTemp = [NSMutableArray arrayWithArray:self.defaultsInitial];
        NSEnumerator *e = [self.defaultsInitial objectEnumerator];
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
        
        [self.defaultsInitial removeAllObjects];
        [self.defaultsInitial addObjectsFromArray:defaultsInitialTemp];
        
        if (!exist) {
            [self.defaultsInitial addObject:qualityEntry];
        }
        
        [self.tableView reloadData];
    }
    
    if (indexPath.section == 3) {
        NSString *qualityEntry = [self.qualityEntries objectAtIndex:indexPath.row];
        
        NSMutableArray *defaultsArchiveTemp = [NSMutableArray arrayWithArray:self.defaultsArchive];
        NSEnumerator *e = [self.defaultsArchive objectEnumerator];
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
        
        [self.defaultsArchive removeAllObjects];
        [self.defaultsArchive addObjectsFromArray:defaultsArchiveTemp];
        
        if (!exist) {
            [self.defaultsArchive addObject:qualityEntry];
        }
        
        [self.tableView reloadData];
    }
}

@end
