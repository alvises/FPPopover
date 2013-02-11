//
//  FPDemoTableViewController.m
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 6/10/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import "FPDemoTableViewController.h"
#import "FPPopoverController.h"
#import "DemoTableController.h"
@interface FPDemoTableViewController ()

@end

@implementation FPDemoTableViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    [self.navigationController setNavigationBarHidden:NO];

}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void)popover:(id)sender
{
    //the controller we want to present as a popover
    DemoTableController *controller = [[DemoTableController alloc] initWithStyle:UITableViewStylePlain];
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];
    
    //popover.arrowDirection = FPPopoverArrowDirectionAny;
    popover.tint = FPPopoverDefaultTint;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(300, 500);
    }
    popover.arrowDirection = FPPopoverArrowDirectionRight;
    
    //sender is the UIButton view
    [popover presentPopoverFromView:sender];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //accessory view button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(popover:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = button;
    cell.textLabel.text = [NSString stringWithFormat:@"Row %d",indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/




@end
