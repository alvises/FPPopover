//
//  FPPopoverKeyboardResponsiveController.m
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 09/06/2013.
//  Copyright (c) 2013 Fifty Pixels Ltd. All rights reserved.
//

#import "FPPopoverKeyboardResponsiveController.h"



@implementation FPPopoverKeyboardResponsiveController




-(CGFloat)parentHeight
{
    return _parentView.bounds.size.height - self.keyboardHeight;
}



@end