//
//  DemoTableControllerViewController.h
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemoTableController;

@protocol DemoTableViewControllerDelegate

- (void)DemoTableControllerDidFinish:(DemoTableController *)controller selectedValue:(NSString *)textSelected;

@end


@interface DemoTableController : UITableViewController

@property(weak,nonatomic) id <DemoTableViewControllerDelegate> delegate;

@end
