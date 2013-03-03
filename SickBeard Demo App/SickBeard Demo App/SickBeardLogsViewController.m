//
//  SickBeardLogsViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 24-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SickBeardLogsViewController.h"
#import "SSBSickBeard.h"
#import "SSBSickBeardResult.h"

@interface SickBeardLogsViewController () <UIActionSheetDelegate> {
    NSMutableArray *_logs;
}

- (IBAction)logFilter:(id)sender;

@end

@implementation SickBeardLogsViewController

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
    
    _logs = [NSMutableArray array];

    [self refreshLog:@"error"];
}

- (void)refreshLog:(NSString *)minimumLevel
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SSBSickBeard getLogs:minimumLevel onComplete:^(NSDictionary *data) {
        [_logs removeAllObjects];
        [_logs addObjectsFromArray:[data objectForKey:@"data"]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.tableView reloadData];
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

- (IBAction)logFilter:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Minimum level" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Debug", @"Info", @"Warning", @"Error", nil];
	[sheet showInView:[UIApplication sharedApplication].keyWindow];
	sheet.actionSheetStyle = UIActionSheetStyleDefault;
}

#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 4) {
        NSString *minLevel;
        if (buttonIndex == 0) minLevel = @"debug";
        if (buttonIndex == 1) minLevel = @"info";
        if (buttonIndex == 2) minLevel = @"warning";
        if (buttonIndex == 3) minLevel = @"error";
        
        [self refreshLog:minLevel];
    }
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
    return [_logs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [_logs objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize size = [[_logs objectAtIndex:indexPath.row] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
    return size.height + 10;
}

@end
