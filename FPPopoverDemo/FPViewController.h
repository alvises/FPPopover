//
//  FPViewController.h
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverController.h"

@interface FPViewController : UIViewController <FPPopoverControllerDelegate>
{
}


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

@end
