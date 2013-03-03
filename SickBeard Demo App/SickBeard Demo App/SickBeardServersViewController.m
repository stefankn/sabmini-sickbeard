//
//  SickBeardServersViewController.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 23-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SickBeardServersViewController.h"
#import "SSBSickBeard.h"
#import "SSBSickBeardServer.h"

#pragma mark -
#pragma mark Server Quick Menu Item

@interface ServerMenuItem : UIMenuItem {
	NSIndexPath *_indexPath;
    NSMutableString *_category;
}

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableString *category;

@end

@implementation ServerMenuItem
@synthesize indexPath = _indexPath, category = _category;

@end

@interface SickBeardServersViewController () {
    NSMutableArray *_servers;
}

@end

@implementation SickBeardServersViewController

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

    _servers = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshServers];
}

- (void)refreshServers
{
    [_servers removeAllObjects];
    [_servers addObjectsFromArray:[SSBSickBeard getServers]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)handleLongItemPress:(UILongPressGestureRecognizer *)longPressRecognizer
{
    if (longPressRecognizer.state == UIGestureRecognizerStateBegan)
	{
		NSIndexPath *pressedIndexPath = [self.tableView indexPathForRowAtPoint:[longPressRecognizer locationInView:self.tableView]];
		
		if (pressedIndexPath && (pressedIndexPath.row != NSNotFound) && (pressedIndexPath.section != NSNotFound))
		{
			[self becomeFirstResponder];
    
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            ServerMenuItem *setDefaultMenuItem = [[ServerMenuItem alloc] initWithTitle:@"Set as default" action:@selector(setDefaultServer:)];
            setDefaultMenuItem.indexPath = pressedIndexPath;
            
            menuController.menuItems = [NSArray arrayWithObject:setDefaultMenuItem];
            [menuController setTargetRect:[self.tableView rectForRowAtIndexPath:pressedIndexPath] inView:self.tableView];
            [menuController setMenuVisible:YES animated:YES];
        }
    }
}

- (void)setDefaultServer:(UIMenuController *)menuController
{
    ServerMenuItem *setDefaultMenuItem = [[[UIMenuController sharedMenuController] menuItems] objectAtIndex:0];
    SSBSickBeardServer *server = [_servers objectAtIndex:setDefaultMenuItem.indexPath.row];
    [server setAsDefault];
    
    [self refreshServers];
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
    return [_servers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ServerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongItemPress:)];
    [cell addGestureRecognizer:longPress];
    
    SSBSickBeardServer *server = [_servers objectAtIndex:indexPath.row];
    cell.textLabel.text = server.friendlyName;
    
    if (server.isDefault) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - Default server", server.host];
    }
    else {
        cell.detailTextLabel.text = server.host;
    }
    
    if (server.https) {
        cell.imageView.image = [UIImage imageNamed:@"server_secure"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"server"];
    }
    
    if ([server.identifier isEqualToString:[SSBSickBeard getActiveServer].identifier]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SSBSickBeardServer *server = [_servers objectAtIndex:indexPath.row];
        
        if ([server.identifier isEqualToString:[SSBSickBeard getActiveServer].identifier]) {
            [SSBSickBeard setActiveServer:nil];
        }
        
        [server remove];
        [_servers removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSBSickBeardServer *server = [_servers objectAtIndex:indexPath.row];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [SSBSickBeard setActiveServer:server];
    [self refreshServers];
}

@end
