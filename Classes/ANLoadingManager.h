//
//  ANLoadingManager.h
//  ShrinkyBops
//
//  Created by Alex Nichol on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANProgressIndicator.h"


@interface ANLoadingManager : NSObject {
	NSThread * currentJob;
	ANProgressIndicator * indicator;
}
+ (ANLoadingManager *)sharedManager;
- (void)doneTask;
- (void)startLoadingObject:(id)sender withJobSelector:(SEL)selector userInfo:(id)obj;
@end
