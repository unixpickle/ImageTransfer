//
//  ImageViewController.m
//  ImageTransfer
//
//  Created by Alex Nichol on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageViewController.h"


@implementation ImageViewController

- (void)setImage:(UIImage *)_image {
	if (!imageView) {
		image = [_image retain];
	} else {
		[imageView setImage:_image];
	}
}

- (void)doneSave {
	UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Done" message:@"The photo was saved to your library!" delegate:nil
										cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[av show];
	[av release];
}

- (IBAction)done:(id)sender {
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Done" message:@"The photo was saved to your library!" delegate:nil
										cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[av show];
	[av release];
}
- (IBAction)saveImage:(id)sender {
	// save image here
	UIImageWriteToSavedPhotosAlbum([imageView image], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if (image) {
		[imageView setImage:image];
		[image release];
		image = nil;
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
