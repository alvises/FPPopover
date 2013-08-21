//
//  UIBarButtonItem+FPPopover.m
//  FPPopoverDemo
//
//  Created by Kamil Badyla on 21.08.2013.
//  Copyright (c) 2013 Fifty Pixels Ltd. All rights reserved.
//

#import "UIBarButtonItem+FPPopover.h"

@implementation UIBarButtonItem (FPPopover)

- (CGRect)frameInView:(UIView *)v {
	
	UIView *mainView = self.customView;
	if (!mainView && [self respondsToSelector:@selector(view)]) {
		mainView = [self performSelector:@selector(view)];
	}
	NSUInteger indexOfView = [mainView.superview.subviews indexOfObject:mainView];
	if (mainView.superview.subviews.count > 0 && indexOfView != NSNotFound) {
		UIView *button = [mainView.superview.subviews objectAtIndex:indexOfView];
		return [button convertRect:button.bounds toView:v];
	}
    else {
		return CGRectZero;
	}
}

@end
