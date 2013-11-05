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

@interface SickBeardAddShowFinishViewController () {
    NSArray *_rootDirs;
    NSString *_selectedRootDir;
    BOOL _useDefaultRootDir;
    NSArray *_qualityEntries;
    NSDictionary *_qualityEntriesFullNames;
    NSDictionary *_defaults;
    BOOL _useDefaultStatus;
    NSString *_selectedStatus;
    NSMutableArray *_defaultsInitial;
    NSMutableArray *_defaultsArchive;
    BOOL _flattenFolders;
}

- (IBAction)addShow:(id)sender;
- (void)flattenFoldersSwitchToggled:(UISwitch *)sw;

@end

@implementation SickBeardAddShowFinishViewController

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
    
    self.title = [_searchResult objectForKey:@"name"];
    _useDefaultRootDir = YES;
    _useDefaultStatus = YES;
    _qualityEntries = [NSArray arrayWithObjects:@"fullhdbluray", @"hdbluray", @"fullhdwebdl", @"hdwebdl", @"fullhdtv", @"rawhdtv", @"hdtv", @"sddvd", @"sdtv", @"any", nil];
    _qualityEntriesFullNames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1080p BluRay", @"720p BluRay", @"1080p WEB-DL", @"720p WEB-DL", @"1080p HD TV", @"Raw HD TV", @"HD TV", @"SD DVD", @"SD TV", @"Any", nil] forKeys:_qualityEntries];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SSBSickBeard getRootDirs:^(NSDictionary *data) {
        _rootDirs = [NSMutableArray arrayWithArray:[data objectForKey:@"data"]];
        [self.tableView reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } onFailure:^(SSBSickBeardResult *result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    [SSBSickBeard getDefaults:^(NSDictionary *data) {
        _defaults = [NSDictionary dictionaryWithDictionary:[data objectForKey:@"data"]];
        _defaultsInitial = [NSMutableArray arrayWithArray:[_defaults objectForKey:@"initial"]];
        _defaultsArchive = [NSMutableArray arrayWithArray:[_defaults objectForKey:@"archive"]];
        _flattenFolders = [[_defaults objectForKey:@"flatten_folders"] boolValue];
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
    if ([_defaultsInitial count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"Please check at least one quality in the initial section!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([_rootDirs count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"No root path defined!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [SSBSickBeard addNewShow:[_searchResult objectForKey:@"tvdbid"] showLocation:_selectedRootDir flattenFolders:_flattenFolders initial:_defaultsInitial archive:_defaultsArchive initialStatus:_selectedStatus language:@"en" onComplete:^(SSBSickBeardResult *result) {
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
        _flattenFolders = YES;
    }
    else {
        _flattenFolders = NO;
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
        return [_rootDirs count];
    }
    else if (section == 1) {
        return 4;
    }
    else if (section == 2) {
        return [_qualityEntries count];
    }
    else if (section == 3) {
        return [_qualityEntries count];
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
        NSDictionary *rootDir = [_rootDirs objectAtIndex:indexPath.row];
        cell.textLabel.text = [rootDir objectForKey:@"location"];
        
        if ([[rootDir objectForKey:@"default"] boolValue] && _useDefaultRootDir) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            _selectedRootDir = [rootDir objectForKey:@"location"];
        }
        else {
            if ([_selectedRootDir isEqualToString:[rootDir objectForKey:@"location"]]) {
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
            
            if (_useDefaultStatus)
            {
                if ([[_defaults objectForKey:@"status"] isEqualToString:@"skipped"]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    _selectedStatus = @"skipped";
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            else
            {
                if ([_selectedStatus isEqualToString:@"skipped"])
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
            
            if (_useDefaultStatus)
            {
                if ([[_defaults objectForKey:@"status"] isEqualToString:@"wanted"]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    _selectedStatus = @"wanted";
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            else
            {
                if ([_selectedStatus isEqualToString:@"wanted"])
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
            
            if (_useDefaultStatus)
            {
                if ([[_defaults objectForKey:@"status"] isEqualToString:@"archived"]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    _selectedStatus = @"archived";
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            else
            {
                if ([_selectedStatus isEqualToString:@"archived"])
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
            
            if (_useDefaultStatus)
            {
                if ([[_defaults objectForKey:@"status"] isEqualToString:@"ignored"]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    _selectedStatus = @"ignored";
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            else
            {
                if ([_selectedStatus isEqualToString:@"ignored"])
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
        NSString *qualityEntry = [_qualityEntries objectAtIndex:indexPath.row];
        cell.textLabel.text = [_qualityEntriesFullNames objectForKey:qualityEntry];
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSEnumerator *e = [_defaultsInitial objectEnumerator];
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
        NSString *qualityEntry = [_qualityEntries objectAtIndex:indexPath.row];
        cell.textLabel.text = [_qualityEntriesFullNames objectForKey:qualityEntry];
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSEnumerator *e = [_defaultsArchive objectEnumerator];
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
        flattenFoldersSwitch.on = _flattenFolders;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        _useDefaultRootDir = NO;
        NSDictionary *rootDir = [_rootDirs objectAtIndex:indexPath.row];
        _selectedRootDir = [rootDir objectForKey:@"location"];
        [self.tableView reloadData];
    }
    
    if (indexPath.section == 1) {
        _useDefaultStatus = NO;
        
        if (indexPath.row == 0) {
            _selectedStatus = @"skipped";
        }
        
        if (indexPath.row == 1) {
            _selectedStatus = @"wanted";
        }
        
        if (indexPath.row == 2) {
            _selectedStatus = @"archived";
        }
        
        if (indexPath.row == 3) {
            _selectedStatus = @"ignored";
        }
        
        [self.tableView reloadData];
    }
    
    if (indexPath.section == 2) {
        NSString *qualityEntry = [_qualityEntries objectAtIndex:indexPath.row];
        
        NSMutableArray *defaultsInitialTemp = [NSMutableArray arrayWithArray:_defaultsInitial];
        NSEnumerator *e = [_defaultsInitial objectEnumerator];
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
        
        [_defaultsInitial removeAllObjects];
        [_defaultsInitial addObjectsFromArray:defaultsInitialTemp];
        
        if (!exist) {
            [_defaultsInitial addObject:qualityEntry];
        }
        
        [self.tableView reloadData];
    }
    
    if (indexPath.section == 3) {
        NSString *qualityEntry = [_qualityEntries objectAtIndex:indexPath.row];
        
        NSMutableArray *defaultsArchiveTemp = [NSMutableArray arrayWithArray:_defaultsArchive];
        NSEnumerator *e = [_defaultsArchive objectEnumerator];
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
        
        [_defaultsArchive removeAllObjects];
        [_defaultsArchive addObjectsFromArray:defaultsArchiveTemp];
        
        if (!exist) {
            [_defaultsArchive addObject:qualityEntry];
        }
        
        [self.tableView reloadData];
    }
}

@end
