//
//  SickBeardAddServerViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 20-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SickBeardAddServerViewController.h"
#import "SSBSickBeard.h"

@interface SickBeardAddServerViewController ()

@property (nonatomic, weak) IBOutlet UITextField *friendlyNameField;
@property (nonatomic, weak) IBOutlet UITextField *hostField;
@property (nonatomic, weak) IBOutlet UITextField *portField;
@property (nonatomic, weak) IBOutlet UITextField *apikeyField;
@property (nonatomic, weak) IBOutlet UISwitch *httpsSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *defaultSwitch;

- (IBAction)cancelAddingServer:(id)sender;
- (IBAction)saveServer:(id)sender;

@end

@implementation SickBeardAddServerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.friendlyNameField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAddingServer:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveServer:(id)sender
{
    // Needs validation
    [SSBSickBeard createServer:self.friendlyNameField.text withHost:self.hostField.text withPort:self.portField.text withApikey:self.apikeyField.text enableHttps:[self.httpsSwitch isOn] setAsDefault:[self.defaultSwitch isOn]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
