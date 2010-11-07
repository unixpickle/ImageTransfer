//
//  ImageTransferAppDelegate.h
//  ImageTransfer
//
//  Created by Alex Nichol on 11/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageTransferViewController;

@interface ImageTransferAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ImageTransferViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ImageTransferViewController *viewController;

@end

