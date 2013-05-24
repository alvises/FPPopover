/*
 *  UIBarButtonItem+FPPopover.m
 *  FPPopover
 *
 *  Created by Werner Altewischer on 07/05/11.
 *  Copyright (c) 2010 Werner IT Consultancy. All rights reserved.
 *
 */

#import "UIBarButtonItem+FPPopover.h" 

@implementation UIBarButtonItem (FPPopover)

- (CGRect)frameInView:(UIView *)aView {
	
	UIView *theView = self.customView;
	if (!theView && [self respondsToSelector:@selector(view)]) {
		theView = [self performSelector:@selector(view)];
	}
	
	UIView *parentView = theView.superview;
	NSArray *subviews = parentView.subviews;
	
	NSUInteger indexOfView = [subviews indexOfObject:theView];
	NSUInteger subviewCount = subviews.count;
	
	if (subviewCount > 0 && indexOfView != NSNotFound) {
		UIView *button = [parentView.subviews objectAtIndex:indexOfView];
		return [button convertRect:button.bounds toView:aView];
	} else {
		return CGRectZero;
	}
}

- (UIView *)superview {
    
	UIView *theView = self.customView;
	if (!theView && [self respondsToSelector:@selector(view)]) {
		theView = [self performSelector:@selector(view)];
	}
	
	UIView *parentView = theView.superview;
	return parentView;
}

- (CGRect)frame {
    return [self frameInView:self.superview];
}

@end
