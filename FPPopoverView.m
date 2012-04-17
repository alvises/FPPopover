//
//  FPPopoverView.m
//  FiftyKit
//
//  Created by Alvise Susmel on 1/4/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import "FPPopoverView.h"
@interface FPPopoverView(Private)
-(void)setupViews;
@end


@implementation FPPopoverView
@synthesize title;
@synthesize relativeOrigin;

-(void)dealloc
{
    self.title = nil;
    [_contentView release];
    [_titleLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //we need to set the background as clear to see the view below
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        self.layer.shadowOpacity = 0.7;
        self.layer.shadowRadius = 5;
        self.layer.shadowOffset = CGSizeMake(-3, 3);

        //to get working the animations
        self.contentMode = UIViewContentModeRedraw;
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        
        [self addSubview:_titleLabel];
        [self setupViews];
    }
    return self;
}

#pragma mark setters
-(void)setArrowDirection:(FPPopoverArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self setNeedsDisplay];
}

-(FPPopoverArrowDirection)arrowDirection
{
    return _arrowDirection;
}
-(void)addContentView:(UIView *)contentView
{
    if(_contentView != contentView)
    {
        [_contentView removeFromSuperview];
        [_contentView release];
        _contentView = [contentView retain];
        [self addSubview:_contentView];
    }
    [self setupViews];
}

#pragma mark drawing

//the content with the arrow
-(CGPathRef)createContentPathWithBorderWidth:(CGFloat)borderWidth arrowDirection:(FPPopoverArrowDirection)direction
{
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat ah = 20.0; //is the height of the triangle of the arrow
    CGFloat aw = 10.0; //is the 1/2 of the base of the arrow
    CGFloat ax = w/2.0 - aw; //FPPopoverArrowDirectionUp and Down
    CGFloat radius = 10;
    CGFloat b = borderWidth;
    
    CGRect rect;
    if(direction == FPPopoverArrowDirectionUp)
    {
        
        rect.size.width = w - 2*b;
        rect.size.height = h - ah - 2*b;
        rect.origin.x = b;
        rect.origin.y = ah + b;        
    }
    else if(direction == FPPopoverArrowDirectionDown)
    {
        rect.size.width = w - 2*b;
        rect.size.height = h - ah - 2*b;
        rect.origin.x = b;
        rect.origin.y = b;                
    }
    
    //the arrow will be near the origin
    ax = self.relativeOrigin.x - aw;
    if(ax < aw + b) ax = aw + b;
    else if (ax +2*aw + 2*b> self.bounds.size.width) ax = self.bounds.size.width - 2*aw - 2*b;

    
    //ROUNDED RECT
    // arrow UP
    CGRect innerRect = CGRectInset(rect, radius, radius);
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;

    
    //drawing the border with arrow
    CGMutablePathRef path = CGPathCreateMutable();

    CGPathMoveToPoint(path, NULL, innerRect.origin.x, outside_top);
 
    //top arrow
    if(direction == FPPopoverArrowDirectionUp)
    {
        CGPathAddLineToPoint(path, NULL, ax, ah+b);
        CGPathAddLineToPoint(path, NULL, ax+aw, b);
        CGPathAddLineToPoint(path, NULL, ax+2*aw, ah+b);
        
    }

	CGPathAddLineToPoint(path, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(path, NULL, outside_right, outside_top, outside_right, inside_top, radius);
	CGPathAddLineToPoint(path, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(path, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);

    //down arrow
    if(direction == FPPopoverArrowDirectionDown)
    {
        NSLog(@"DOWN");
        CGPathAddLineToPoint(path, NULL, ax+2*aw, outside_bottom);
        CGPathAddLineToPoint(path, NULL, ax+aw, outside_bottom + ah);
        CGPathAddLineToPoint(path, NULL, ax, outside_bottom);
    }

	CGPathAddLineToPoint(path, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(path, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(path, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(path, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);

    
    CGPathCloseSubpath(path);
    
    return path;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // make a gradient
    CGFloat colors[8];
    colors[0] = colors[1] = colors[2] = 0.6;
    colors[4] = colors[5] = colors[6] = 0.1;
    colors[3] = colors[7] = 1.0;

    if(_arrowDirection == FPPopoverArrowDirectionDown)
    {
        colors[0] = colors[1] = colors[2] = 0.4;
        colors[4] = colors[5] = colors[6] = 0.1;
        colors[3] = colors[7] = 1.0;
    }

    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);

    
    CFRelease(colorSpace);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();    
    CGContextSaveGState(ctx);
    
    //content fill
    CGPathRef contentPath = [self createContentPathWithBorderWidth:2.0 arrowDirection:_arrowDirection];
    
    CGContextAddPath(ctx, contentPath);    
    CGContextClip(ctx);

    //  Draw a linear gradient from top to bottom
    CGPoint start = CGPointMake(self.bounds.size.width/2.0, 0);
    CGPoint end = CGPointMake(self.bounds.size.width/2.0,40);
    if(_arrowDirection == FPPopoverArrowDirectionDown)
    {
        end.y = 20;
    }
    CGContextDrawLinearGradient(ctx, gradient, start, end, 0);
    CGGradientRelease(gradient);
    //fill the other part of path
    CGContextSetRGBFillColor(ctx, 0.1, 0.1, 0.1, 1.0);
    CGContextFillRect(ctx, CGRectMake(0, end.y, self.bounds.size.width, self.bounds.size.height-end.y));
    //internal border
    CGContextBeginPath(ctx);
    CGContextAddPath(ctx, contentPath);
    CGContextSetRGBStrokeColor(ctx, 0.7, 0.7, 0.7, 1.0);
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx,kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextStrokePath(ctx);
    CGPathRelease(contentPath);

    //external border
    CGPathRef externalBorderPath = [self createContentPathWithBorderWidth:1.0 arrowDirection:_arrowDirection];
    CGContextBeginPath(ctx);
    CGContextAddPath(ctx, externalBorderPath);
    CGContextSetRGBStrokeColor(ctx, 0.4, 0.4, 0.4, 1.0);
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx,kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextStrokePath(ctx);
    CGPathRelease(externalBorderPath);

    //3D border of the content view
    CGRect cvRect = _contentView.frame;
    //firstLine
    CGContextSetRGBStrokeColor(ctx, 0.7, 0.7, 0.7, 1.0);
    CGContextStrokeRect(ctx, cvRect);
    //secondLine
    cvRect.origin.x -= 1; cvRect.origin.y -= 1; cvRect.size.height += 2; cvRect.size.width += 2;
    CGContextSetRGBStrokeColor(ctx, 0.4, 0.4, 0.4, 1.0);
    CGContextStrokeRect(ctx, cvRect);
    
    
    
    CGContextRestoreGState(ctx);
}

-(void)setupViews
{
    //content posizion and size
    CGRect contentRect = _contentView.frame;
    contentRect.size = CGSizeMake(self.bounds.size.width-20, self.bounds.size.height-70);

    if(_arrowDirection == FPPopoverArrowDirectionUp)
    {
        contentRect.origin = CGPointMake(10, 60);        
        _titleLabel.frame = CGRectMake(10, 30, self.bounds.size.width-20, 20);        
    }
    else if(_arrowDirection == FPPopoverArrowDirectionDown)
    {
        contentRect.origin = CGPointMake(10, 40);        
        _titleLabel.frame = CGRectMake(10, 10, self.bounds.size.width-20, 20);           
    }
    
    _contentView.frame = contentRect;
    _titleLabel.text = self.title;    
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setupViews];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setupViews];
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self setupViews];
}
@end
