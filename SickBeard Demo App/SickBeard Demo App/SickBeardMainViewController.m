//
//  SickBeardMainViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 20-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SickBeardMainViewController.h"
#import "SSBSickBeardServer.h"
#import "SSBSickBeard.h"
#import "SSBSickBeardResult.h"

@interface SickBeardMainViewController () <UIActionSheetDelegate>

@end

@implementation SickBeardMainViewController

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

    // Set the active server to the default server if there is one
    SSBSickBeardServer *server = [SSBSickBeard getDefaultServer];
    if (server) {
        [SSBSickBeard setActiveServer:server];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([SSBSickBeard getActiveServer]) {
            return [NSString stringWithFormat:@"Active server: %@", [SSBSickBeard getActiveServer].friendlyName];
        }
        else {
            return @"No server active";
        }
    }

    return nil;
}

- (IBAction)serverActions:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Force episode search", @"Restart SickBeard", @"Shutdown SickBeard", nil];
	[sheet showInView:[UIApplication sharedApplication].keyWindow];
	sheet.actionSheetStyle = UIActionSheetStyleDefault;
}

#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [SSBSickBeard forceSearch:^(SSBSickBeardResult *result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            [SSBSickBeard setActiveServer:nil];
        } onFailure:^(SSBSickBeardResult *result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    }
    
    if (buttonIndex == 1)
    {
        [SSBSickBeard restartActiveServer:^(SSBSickBeardResult *result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            [SSBSickBeard setActiveServer:nil];
        } onFailure:^(SSBSickBeardResult *result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    }
    
    if (buttonIndex == 2)
    {
        [SSBSickBeard shutdownActiveServer:^(SSBSickBeardResult *result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            [SSBSickBeard setActiveServer:nil];
        } onFailure:^(SSBSickBeardResult *result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

@end
