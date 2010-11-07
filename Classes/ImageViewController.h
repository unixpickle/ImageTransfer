//
//  ImageViewController.h
//  ImageTransfer
//
//  Created by Alex Nichol on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageViewController : UIViewController {
	IBOutlet UIImageView * imageView;
	UIImage * image;
}
- (void)setImage:(UIImage *)_image;
- (IBAction)done:(id)sender;
- (IBAction)saveImage:(id)sender;
@end
