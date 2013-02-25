//
//  FPTouchView.m
//
//  Created by Alvise Susmel on 4/16/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//
//  https://github.com/50pixels/FPPopover

#import "FPTouchView.h"
#import "ARCMacros.h"

@implementation FPTouchView

-(void)dealloc
{
#ifdef FP_DEBUG
    NSLog(@"FPTouchView dealloc");
#endif
    
    SAFE_ARC_RELEASE(_insideBlock);
    SAFE_ARC_RELEASE(_outsideBlock);
    SAFE_ARC_SUPER_DEALLOC();
}

-(void)setTouchedOutsideBlock:(FPTouchedOutsideBlock)outsideBlock
{
#if __has_feature(objc_arc)
    _outsideBlock = outsideBlock;
#else
    _outsideBlock = [outsideBlock copy];
#endif
}

-(void)setTouchedInsideBlock:(FPTouchedInsideBlock)insideBlock
{
#if __has_feature(objc_arc)
    _insideBlock = insideBlock;
#else
    _insideBlock = [insideBlock copy];
#endif

}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *subview = [super hitTest:point withEvent:event];

    if(UIEventTypeTouches == event.type)
    {
        BOOL touchedInside = subview != self;
        if(!touchedInside)
        {
            for(UIView *s in self.subviews)
            {
                if(s == subview)
                {
                    //touched inside
                    touchedInside = YES;
                    break;
                }
            }            
        }
        
        if(touchedInside && _insideBlock)
        {
            _insideBlock();
        }
        else if(!touchedInside && _outsideBlock)
        {
            _outsideBlock();
        }
    }
    
    return subview;
}


@end
