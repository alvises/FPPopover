//
//  FPViewController.m
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import "FPViewController.h"
#import "DemoTableController.h"

#import "FPPopoverController.h"

@interface FPViewController ()

@end

@implementation FPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)popover:(id)sender
{
    //the controller we want to present as a popover
    DemoTableController *controller = [[DemoTableController alloc] initWithStyle:UITableViewStylePlain];
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];
    [controller release];
    
    //popover.arrowDirection = FPPopoverArrowDirectionAny;
    popover.tint = FPPopoverDefaultTint;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(300, 500);
    }
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    //sender is the UIButton view
    [popover presentPopoverFromView:sender]; 
}


- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController 
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    [visiblePopoverController dismissPopoverAnimated:YES];
    [visiblePopoverController autorelease];
}

-(IBAction)topLeft:(id)sender
{
    [self popover:sender];
}

-(IBAction)topCenter:(id)sender
{
    [self popover:sender];
}
-(IBAction)topRight:(id)sender
{
    [self popover:sender];
}

-(IBAction)lt:(id)sender
{
    [self popover:sender];

}

-(IBAction)rt:(id)sender
{
    [self popover:sender];
}



-(IBAction)midLeft:(id)sender
{
    [self popover:sender];
}

-(IBAction)midCenter:(id)sender
{
    [self popover:sender];
}
-(IBAction)midRight:(id)sender
{
    [self popover:sender];
}

-(IBAction)bottomLeft:(id)sender
{
    [self popover:sender];
}
-(IBAction)bottomCenter:(id)sender
{
    [self popover:sender];
}
-(IBAction)bottomRight:(id)sender
{
    [self popover:sender];
}


@end
