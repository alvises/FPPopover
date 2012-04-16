//
//  FPPopoverView.h
//  FiftyKit
//
//  Created by Alvise Susmel on 1/4/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    FPPopoverArrowDirectionUp = 1UL << 0,
    FPPopoverArrowDirectionDown = 1UL << 1,
    FPPopoverArrowDirectionLeft = 1UL << 2,
    FPPopoverArrowDirectionRight = 1UL << 3,

    FPPopoverArrowDirectionVertical = FPPopoverArrowDirectionUp | FPPopoverArrowDirectionDown,
    FPPopoverArrowDirectionHorizontal = FPPopoverArrowDirectionLeft | FPPopoverArrowDirectionRight,
    
    FPPopoverArrowDirectionAny = FPPopoverArrowDirectionUp | FPPopoverArrowDirectionDown | 
    FPPopoverArrowDirectionLeft | FPPopoverArrowDirectionRight
    
} FPPopoverArrowDirection;


@interface FPPopoverView : UIView
{
    //default FPPopoverArrowDirectionUp
    FPPopoverArrowDirection _arrowDirection;
    UIView *_contentView;
    UILabel *_titleLabel;
}
@property(nonatomic,retain) NSString *title;
@property(nonatomic,assign) CGPoint relativeOrigin;

-(void)setArrowDirection:(FPPopoverArrowDirection)arrowDirection;
-(FPPopoverArrowDirection)arrowDirection;

-(void)addContentView:(UIView*)contentView;
@end
