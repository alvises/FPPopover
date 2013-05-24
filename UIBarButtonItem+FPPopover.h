/*
 *  UIBarButtonItem+FPPopover.h
 *  FPPopover
 *
 *  Created by Werner Altewischer on 07/05/11.
 *  Copyright (c) 2010 Werner IT Consultancy. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIBarButtonItem (FPPopover)

- (CGRect)frameInView:(UIView *)view;
- (UIView *)superview;
- (CGRect)frame;

@end
