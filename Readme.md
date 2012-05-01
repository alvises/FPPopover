FPPopover
========
This library provides an alternative to the native iOS UIPopoverController, 
adding support for iPhone and additional opportunities to customize the look and feel of the popovers.


Features
========

* Works like UIPopoverController.
* Runs on both iPhone and iPad.
* Popover rendered using no images, only Quartz code.
* Customize the look of popovers (color, dimensions).
* Automatic orientation. It will find the best orientation and size for every situation.
* MIT License (you can use it for commercial apps, edit and redistribute).


What you need
---

To use FPPopoverController you only need

* FPPopoverController.m and .h    (the controller)
* FPPopoverView.m and .h
* FPTouchView.m and .m

That's it.




How to use it
---  

Let's start with a simple example
    
    -(IBAction)buttonClicked:(UIButton*)okButton
    {
        //the view controller you want to present as popover
        YourViewController *controller = [[YourViewController alloc] init]; 

        //our popover
        FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller]; 
        
        //the popover will be presented from the okButton view 
        [popover presentPopoverFromView:okButton]; 
    
        //release
        [controller release];
    }
    
This will display a black popover with automatic arrow positioning and a maximum of 200x300 content size and no delegate messages.

The title of YourViewController (controller.title) will be presented on the top.

###Customize the size
Default content size is 200x300. This can be set using the following property

    popover.contentSize = CGSizeMake(150,200);

This property defines a maximum boundary for content, but the actual content area displayed may
vary according to the what is found to be the optimal size to fit the popover on the screen (e.g. when adjusting the layout from portrait to landscape mode).

###Customize the tint

* FPPopoverBlackTint  (default)
* FPPopoverLightGrayTint
* FPPopoverGreenTint
* FPPopoverRedTint

        popover.tint = FPPopoverRedTint;
    
Contact us if you need more tints!

###Force the arrow direction
If you need to force the arrow direction use the arrowDirection property

        popover.arrowDirection = FPPopoverArrowDirectionUp;


###Delegate messages

Set your delegate
    
        YourViewController *controller = [[YourViewController alloc] init]; 
        FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller]; 
        popover.delegate = controller;
        ....
        
In this case we are setting up the YourViewController as our popover delegate.

####Know when a new popover is displayed

    - (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController 
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController;

Use this delegate method to know when a new different popover is displayed. If you want to dismiss the old popover, and release it, send the dismiss message inside this method.

        - (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController 
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
        {
            [visiblePopoverController dismissPopoverAnimated:YES];
            [visiblePopoverController autorelease];
        }

####Know when the popover is dismissed

    - (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController;

Use this delegate method to know when the popover is dismissed. This could happen when the user taps outside the popover or when a dismiss message is sent by other actions.

