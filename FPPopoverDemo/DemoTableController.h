//
//  DemoTableControllerViewController.h
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FPViewController;

@interface DemoTableController : UITableViewController
@property(nonatomic,assign) FPViewController *delegate;
@end
