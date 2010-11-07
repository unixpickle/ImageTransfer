//
//  ANProgressIndicator.m
//  ShrinkyBops
//
//  Created by Alex Nichol on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ANProgressIndicator.h"


@interface ANProgressIndicator (hidden)
- (void)loadUI;
@end

@implementation ANProgressIndicator (hidden)

- (void)loadUI {
	indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	CGPoint centre = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
	//centre.y -= 20;
	[indicator setCenter:centre];
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 30, self.frame.size.width - 20, 30)];
	[titleLabel setTextAlignment:UITextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[titleLabel setTextColor:[UIColor whiteColor]];
	[self addSubview:titleLabel];
	[titleLabel setText:@"Waiting ..."];
	[self addSubview:indicator];
	[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
	[[self layer] setCornerRadius:10];
}

@end


@implementation ANProgressIndicator



- (void)setTitle:(NSString *)loadingText {
	[titleLabel setText:loadingText];
}
- (void)startLoading {
	[indicator startAnimating];
}
- (void)stopLoading {
	[indicator stopAnimating];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self loadUI];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self loadUI];
	}
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
