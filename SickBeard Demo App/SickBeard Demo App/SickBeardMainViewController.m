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

@interface SickBeardMainViewController ()

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
    
    //SSBSickBeardServer *server = [SSBSickBeard createServer:@"Test server" withHost:@"10.0.1.110" withPort:@"8081" withApikey:@"8b1a4a7850815520f2c06cf1ebc9586c" enableHttps:YES store:NO];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            [SSBSickBeard forceSearch:^(SSBSickBeardResult *result) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [SSBSickBeard setActiveServer:nil];
            } onFailure:^(SSBSickBeardResult *result) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }];
        }
        
        if (indexPath.row == 1) {
            [SSBSickBeard restartActiveServer:^(SSBSickBeardResult *result) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [SSBSickBeard setActiveServer:nil];
            } onFailure:^(SSBSickBeardResult *result) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }];
        }
        
        if (indexPath.row == 2) {
            [SSBSickBeard shutdownActiveServer:^(SSBSickBeardResult *result) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [SSBSickBeard setActiveServer:nil];
            } onFailure:^(SSBSickBeardResult *result) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:result.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }];
        }
        
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}

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
    else {
        return nil;
    }
}

@end
