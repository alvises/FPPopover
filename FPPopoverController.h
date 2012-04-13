//
//  FPPopoverController.h
//  FiftyKit
//
//  Created by Alvise Susmel on 1/5/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "FPPopoverView.h"

@class FPPopoverController;
@protocol FPPopoverControllerDelegate <NSObject>

@optional
- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController;
@end

@interface FPPopoverController : UIViewController
{
    FPPopoverView *_contentView;
    UIViewController *_viewController;
    UIWindow *_window;
    UIView *_parentView;
    UIDeviceOrientation _deviceOrientation;
}
@property(nonatomic,assign) id<FPPopoverControllerDelegate> delegate;

@property(nonatomic,assign) CGSize contentSize;
@property(nonatomic,assign) CGPoint origin;

/** @brief Initialize the popover with the content view controller
 **/
-(id)initWithViewController:(UIViewController*)viewController;

-(void)presentPopoverFromPoint:(CGPoint)fromPoint;
-(void)presentPopoverFromView:(UIView*)fromView;
-(void)dismissPopoverAnimated:(BOOL)animated;

-(CGFloat)parentWidth;
-(CGFloat)parentHeight;


#pragma mark Space management
/* This methods helps the controller to found a proper way to display the view.
 * If the "from point" will be on the left, the arrow will be on the left and the 
 * view will be move on the right of the from point.
 */
-(CGRect)bestViewFrameForFromPoint:(CGPoint)point;


@end
