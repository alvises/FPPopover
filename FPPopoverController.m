//
//  FPPopoverController.m
//  FiftyKit
//
//  Created by Alvise Susmel on 1/5/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import "FPPopoverController.h"

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
        self.contentSize = CGSizeMake(200, 300);
        
        [_contentView addSubview:_viewController.view];
        _viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.view.clipsToBounds = NO;
    
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
    
    //view position
    _contentView.frame = [self bestViewFrameForFromPoint:self.origin];
    _contentView.relativeOrigin = [_parentView convertPoint:self.origin toView:_contentView];

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
    
    return _window.bounds.size.width;
}
-(CGFloat)parentHeight
{
    return _window.bounds.size.height;
}

-(void)presentPopoverFromPoint:(CGPoint)fromPoint
{
    self.origin = fromPoint;
    CGPoint realFromPoint = fromPoint;
    realFromPoint.x -= (self.contentSize.width/2.0 + 20);
    _contentView.relativeOrigin = [_parentView convertPoint:realFromPoint toView:_contentView];
    
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
        
        //ORIENTATION
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
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

-(void)presentPopoverFromView:(UIView*)fromView
{
    CGPoint p;
    if([_contentView arrowDirection] == FPPopoverArrowDirectionUp)
    {
        p.x = fromView.frame.origin.x + fromView.frame.size.width/2.0;
        p.y = fromView.frame.origin.y + fromView.frame.size.height;
    }
    [self presentPopoverFromPoint:p];
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
    [self setupView];
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
    CGFloat w = MIN(r.size.width, _parentView.bounds.size.width);
    CGFloat h = MIN(r.size.height,_parentView.bounds.size.height);
    r.size.width = (w == self.view.bounds.size.width) ? w-50 : w;
    r.size.height = (h == self.view.bounds.size.height) ? h-30 : h;
    
    CGFloat r_w = r.size.width;
    CGFloat r_h = r.size.height;
    
    //lm + rm
    CGFloat wm = _parentView.bounds.size.width - r_w;
    CGFloat wm_l = wm/2.0;
    CGFloat ws = r_w;
    CGFloat rm_x = wm_l + ws;
    
    CGFloat hm = _parentView.bounds.size.height - r_h;
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
            r.origin.x = wm_l;
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
