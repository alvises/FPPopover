Features
========

* UIPopoverController like working on iPhone and iPad
* Popover rendered using no images, only Quartz code
* Automatic orientation. It will find the best orientation and size for every situation
* MIT License (you can use it on your commercial apps)





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
The default size of the content in popover is 200x300. That means the content size will be maximum 200x300 because it could be resized to fill inside the view. If we need to change the size we can use the property 

    popover.contentSize = CGSizeMake(150,200);


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

####Know when a new popover will be displayed

    - (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController 
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController;

Use this delegate method if you want to know when a popover is displayed. If you want to dismiss the old popover, and release it, send the dismiss message inside this method.

        - (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController 
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
        {
            [visiblePopoverController dismissPopoverAnimated:YES];
            [visiblePopoverController autorelease];
        }
