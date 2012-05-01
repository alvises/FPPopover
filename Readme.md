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
The default size of the content in popover is 200x300. That means the 

###Customize the tint

* FPPopoverBlackTint  (default)
* FPPopoverLightGrayTint
* FPPopoverGreenTint
* FPPopoverRedTint

    popover.tint = FPPopoverRedTint;
    

###Force the arrow direction

###Delegate messages

