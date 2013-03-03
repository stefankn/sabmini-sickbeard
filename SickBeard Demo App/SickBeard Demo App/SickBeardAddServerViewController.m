//
//  SickBeardAddServerViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 20-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SickBeardAddServerViewController.h"
#import "SSBSickBeard.h"

@interface SickBeardAddServerViewController () {
    IBOutlet UITextField *_friendlyNameField;
    IBOutlet UITextField *_hostField;
    IBOutlet UITextField *_portField;
    IBOutlet UITextField *_apikeyField;
    IBOutlet UISwitch *_httpsSwitch;
    IBOutlet UISwitch *_defaultSwitch;
}

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
    
    [_friendlyNameField becomeFirstResponder];
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
    [SSBSickBeard createServer:_friendlyNameField.text withHost:_hostField.text withPort:_portField.text withApikey:_apikeyField.text enableHttps:[_httpsSwitch isOn] setAsDefault:[_defaultSwitch isOn]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
