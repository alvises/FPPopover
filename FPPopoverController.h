//
//  FPPopoverController.h
//
//  Created by Alvise Susmel on 1/5/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//
//  https://github.com/50pixels/FPPopover

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ARCMacros.h"

#import "FPPopoverView.h"
#import "FPTouchView.h"


@class FPPopoverController;
@protocol FPPopoverControllerDelegate <NSObject>

@optional
- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController;
- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController 
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController;
@end

@interface FPPopoverController : UIViewController

//ARC-enable and disable support
#if __has_feature(objc_arc)
    @property(nonatomic,assign) id<FPPopoverControllerDelegate> delegate;
#else
    @property(nonatomic,assign) id<FPPopoverControllerDelegate> delegate;
#endif

/** @brief FPPopoverArrowDirectionAny, FPPopoverArrowDirectionVertical or FPPopoverArrowDirectionHorizontal for automatic arrow direction.
 **/

/** @brief allow reading in order to integrate other open-source **/
@property(nonatomic,readonly) FPTouchView* touchView;
@property(nonatomic,readonly) FPPopoverView* contentView;

@property(nonatomic,assign) FPPopoverArrowDirection arrowDirection;

@property(nonatomic,assign) CGSize contentSize;
@property(nonatomic,assign) CGPoint origin;
@property(nonatomic,assign) CGFloat alpha;

/** @brief The tint of the popover. **/
@property(nonatomic,assign) FPPopoverTint tint;

/** @brief Popover border, default is YES **/
@property(nonatomic, assign) BOOL border;

/** @brief Initialize the popover with the content view controller
 **/
-(id)initWithViewController:(UIViewController*)viewController;
-(id)initWithViewController:(UIViewController*)viewController
				   delegate:(id<FPPopoverControllerDelegate>)delegate;

/** @brief Presenting the popover from a specified view **/
-(void)presentPopoverFromView:(UIView*)fromView;

/** @brief Presenting the popover from a specified point **/
-(void)presentPopoverFromPoint:(CGPoint)fromPoint;

/** @brief Dismiss the popover **/
-(void)dismissPopoverAnimated:(BOOL)animated;

/** @brief Dismiss the popover with completion block for post-animation cleanup **/
typedef void (^FPPopoverCompletion)();
-(void)dismissPopoverAnimated:(BOOL)animated completion:(FPPopoverCompletion)completionBlock;

/** @brief Hide the shadows to get better performances **/
-(void)setShadowsHidden:(BOOL)hidden;




@end
