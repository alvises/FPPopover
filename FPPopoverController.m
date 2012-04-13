//
//  FPPopoverController.m
//  FiftyKit
//
//  Created by Alvise Susmel on 1/5/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import "FPPopoverController.h"

@interface FPPopoverController(Private)
-(CGPoint)originFromView:(UIView*)fromView;

@end

@implementation FPPopoverController
@synthesize delegate = _delegate;
@synthesize contentSize = _contentSize;
@synthesize origin = _origin;

-(void)addObservers
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];   
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(deviceOrientationDidChange:) 
     name:@"UIDeviceOrientationDidChangeNotification" 
     object:nil]; 
    _deviceOrientation = [UIDevice currentDevice].orientation;
}

-(void)removeObservers
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_viewController removeObserver:self forKeyPath:@"title"];
}


-(void)dealloc
{
    [self removeObservers];
    [_viewController release];
    [_contentView release];
    [_window release];
    [_parentView release];
    self.delegate = nil;
    [super dealloc];
}


-(id)initWithViewController:(UIViewController*)viewController
{
    self = [super init];
    if(self)
    {
        _contentView = [[FPPopoverView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
        _viewController = [viewController retain];

        [self.view addSubview:_contentView];
        self.contentSize = CGSizeMake(200, 300); //default size
        
        [_contentView addSubview:_viewController.view];
        _viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.view.clipsToBounds = NO;
        self.view.layer.borderColor = [UIColor redColor].CGColor;
        self.view.layer.borderWidth = 2.0;
        //setting contentview
        _contentView.title = _viewController.title;
        _contentView.clipsToBounds = NO;
        
        [_viewController addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}



#pragma mark - View lifecycle

-(void)setupView
{
    self.view.frame = _parentView.bounds;
    
    //view position
    if(_fromView) self.origin = [self originFromView:_fromView];
    _contentView.frame = [self bestViewFrameForFromPoint:self.origin];
    _contentView.relativeOrigin = [_parentView convertPoint:self.origin toView:_contentView];

    [_contentView setNeedsDisplay];
    [self.view setNeedsDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //initialize and load the content view
    [_contentView setArrowDirection:FPPopoverArrowDirectionUp];
    [_contentView addContentView:_viewController.view];

    [self setupView];
    [self addObservers];
}

#pragma mark Orientation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


#pragma mark presenting

-(CGFloat)parentWidth
{
    if(UIDeviceOrientationIsLandscape(_deviceOrientation)) return _parentView.bounds.size.height;
    else return _parentView.bounds.size.width;
}
-(CGFloat)parentHeight
{
    if(UIDeviceOrientationIsLandscape(_deviceOrientation)) return _parentView.bounds.size.width;
    else return _parentView.bounds.size.height;
}

-(void)presentPopoverFromPoint:(CGPoint)fromPoint
{
    self.origin = fromPoint;
    _contentView.relativeOrigin = [_parentView convertPoint:fromPoint toView:_contentView];

    [self.view removeFromSuperview];
    NSArray *windows = [UIApplication sharedApplication].windows;
    if(windows.count > 0)
    {
        [_window release]; [_parentView release]; _parentView=nil;
        _window = [[windows objectAtIndex:0] retain];
        //keep the first subview
        if(_window.subviews.count > 0)
        {
            [_parentView release]; 
            _parentView = [[_window.subviews objectAtIndex:0] retain];
            [_parentView addSubview:self.view];
        }
        
   }
    else
    {
        [self dismissPopoverAnimated:NO];
    }
    
    
    
    [self setupView];
    self.view.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.alpha = 1.0;
    }];
}

-(CGPoint)originFromView:(UIView*)fromView
{
    CGPoint p;
    if([_contentView arrowDirection] == FPPopoverArrowDirectionUp)
    {
        p.x = fromView.frame.origin.x + fromView.frame.size.width/2.0;
        p.y = fromView.frame.origin.y + fromView.frame.size.height;
    }
    return p;
}

-(void)presentPopoverFromView:(UIView*)fromView
{
    [_fromView release]; _fromView = [fromView retain];
    [self presentPopoverFromPoint:[self originFromView:_fromView]];
}

-(void)dismissPopover
{
    [self.view removeFromSuperview];
    if([self.delegate respondsToSelector:@selector(popoverControllerDidDismissPopover:)])
    {
        [self.delegate popoverControllerDidDismissPopover:self];
    }
    [_window release]; _window=nil;
    [_parentView release]; _parentView=nil;
}

-(void)dismissPopoverAnimated:(BOOL)animated
{
    if(animated)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self dismissPopover];
        }];
    }
    else
    {
        [self dismissPopover];
    }
         
}

-(void)setOrigin:(CGPoint)origin
{
    _origin = origin;
}

#pragma mark observing

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismissPopoverAnimated:YES];
}
-(void)deviceOrientationDidChange:(NSNotification*)notification
{
    [UIView animateWithDuration:0.2 animations:^{
        _deviceOrientation = [UIDevice currentDevice].orientation;
        [self setupView]; 
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == _viewController && [keyPath isEqualToString:@"title"])
    {
        _contentView.title = _viewController.title;
        [_contentView setNeedsDisplay];
    }
}


#pragma mark Space management
/* This methods helps the controller to found a proper way to display the view.
 * If the "from point" will be on the left, the arrow will be on the left and the 
 * view will be move on the right of the from point.
 *
 * Consider only x direction
 *
 *  |--lm--|-----s-----|--rm--|
 *
 * s is the frame of our view (s < screen width). 
 * if our origin point is in lm or rm we move s
 * if the origin point is in s we move the arrow
 */
-(CGRect)bestViewFrameForFromPoint:(CGPoint)point
{
    //content view size
    CGRect r;
    r.size = self.contentSize;
    r.size.width += 20;
    r.size.height += 50;
    
    //size limits
    CGFloat w = MIN(r.size.width, [self parentWidth]);
    CGFloat h = MIN(r.size.height,[self parentHeight]);
    r.size.width = (w == [self parentWidth]) ? [self parentWidth]-50 : w;
    r.size.height = (h == [self parentHeight]) ? [self parentHeight]-30 : h;
    
    CGFloat r_w = r.size.width;
    CGFloat r_h = r.size.height;
    
    //lm + rm
    CGFloat wm = [self parentWidth] - r_w;
    CGFloat wm_l = wm/2.0;
    CGFloat ws = r_w;
    CGFloat rm_x = wm_l + ws;
    
    CGFloat hm = [self parentHeight] - r_h;
    CGFloat hm_t = hm/2.0; //top
    CGFloat hs = r_h;
    CGFloat hm_b = hm_t + hs; //bottom
    
    if(wm > 0)
    {
        //s < lm + rm
        //our content size is smaller then width
        
        if(point.x <= wm_l)
        {
            //move the popup to the left, with the left side near the origin point
            r.origin.x = point.x;
        }
        else if(point.x > rm_x)
        {
            //move the popup to the right, with the right side near the origin point
            r.origin.x = point.x - ws;
        }
        
        else
        {
            //the point is in the "s" zone and then I will move only the arrow
            //put in the x center the popup
            r.origin.x = wm_l-12;
            
            //12px are the number of point from the border to the arrow when the
            //arrow is totally at left
            //I have considered a standard border of 2px
        }
    }
    
    
    if(hm > 0)
    {
        if(point.y <= hm_t)
        {
            r.origin.y = point.y;            
        }
        else if(point.y > hm_b)
        {
            r.origin.y = point.y - hs;
        }
        
        else
        {
            //center in y the popup
            r.origin.y = hm_t;
        }
    }

    return r;
}

@end
