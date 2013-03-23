//
//  FPViewController.h
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverController.h"
#import "ARCMacros.h"
@interface FPViewController : UIViewController <FPPopoverControllerDelegate>
{
    FPPopoverController *popover;
}
//ARC-enable and disable support
#if __has_feature(objc_arc)
    @property (weak, nonatomic) IBOutlet UIButton *noArrow;
    @property (weak, nonatomic) IBOutlet UIButton *transparentPopover;
#else
    @property (assign, nonatomic) IBOutlet UIButton *noArrow;
    @property (assign, nonatomic) IBOutlet UIButton *transparentPopover;
#endif

-(IBAction)topLeft:(id)sender;
-(IBAction)topCenter:(id)sender;
-(IBAction)topRight:(id)sender;

-(IBAction)lt:(id)sender;
-(IBAction)rt:(id)sender;


-(IBAction)midLeft:(id)sender;
-(IBAction)midCenter:(id)sender;
-(IBAction)midRight:(id)sender;

-(IBAction)bottomLeft:(id)sender;
-(IBAction)bottomCenter:(id)sender;
-(IBAction)bottomRight:(id)sender;

-(IBAction)goToTableView:(id)sender;
-(IBAction)navControllerPopover:(id)sender;

-(void)selectedTableRow:(NSUInteger)rowNum;


-(IBAction)noArrow:(id)sender;
-(IBAction)popover:(id)sender;

@end
