//
//  ANLoadingManager.m
//  ShrinkyBops
//
//  Created by Alex Nichol on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ANLoadingManager.h"


@implementation ANLoadingManager
+ (ANLoadingManager *)sharedManager {
	static ANLoadingManager * man = nil;
	if (!man) man = [[ANLoadingManager alloc] init];
	return man;
}
- (void)doneTask {
	// cancel thread
	if (currentJob) {
		// stop it
		[currentJob cancel];
		[currentJob release];
		currentJob = nil;
	}
	// animate out indicator
	[indicator stopLoading];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[indicator setTransform:CGAffineTransformMakeScale(0.75, 0.1)];
	[indicator setAlpha:0.0];
	[UIView commitAnimations];
	[indicator performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}
- (void)startLoadingObject:(id)sender withJobSelector:(SEL)selector userInfo:(id)obj {
	if (currentJob) [self doneTask];
	UIWindow * mainWindow = [[UIApplication sharedApplication] keyWindow];
	if (!indicator) {
		CGRect frmsize = [mainWindow frame];
		indicator = [[ANProgressIndicator alloc] initWithFrame:CGRectMake((frmsize.size.width / 2) - 50, (frmsize.size.height / 2) - 50, 100, 100)];
	}
	[indicator setTitle:@"Loading ..."];
	if ([indicator superview]) {
		[indicator startLoading];
	} else {
		// add it here.
		[indicator setTransform:CGAffineTransformMakeScale(0.75, 0.1)];
		[indicator setAlpha:0.0];
		[mainWindow addSubview:indicator];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		[indicator setTransform:CGAffineTransformIdentity];
		[indicator setAlpha:1.0];
		[UIView commitAnimations];
		[indicator startLoading];
	}
	if (sender) {
		currentJob = [[NSThread alloc] initWithTarget:sender selector:selector object:obj];
		[currentJob start];
	} else currentJob = [[NSThread alloc] init];
}
@end
