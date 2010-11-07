//
//  ANProgressIndicator.h
//  ShrinkyBops
//
//  Created by Alex Nichol on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface ANProgressIndicator : UIView {
	UIActivityIndicatorView * indicator;
	UILabel * titleLabel;
}
- (void)setTitle:(NSString *)loadingText;
- (void)startLoading;
- (void)stopLoading;
@end
