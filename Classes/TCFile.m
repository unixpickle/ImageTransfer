//
//  TCFile.m
//  GameKitTCP
//
//  Created by Alex Nichol on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TCFile.h"


@implementation TCFile

@synthesize peerID;
@synthesize blocks;
@synthesize totalData;
@synthesize totalLength;
@synthesize uniqueID;

+ (NSMutableArray *)blocksWithDataLength:(int)length {
	NSMutableArray * indices = [[NSMutableArray alloc] init];
	int rlength = length;
	int index = 0;
	while (rlength > 0) {
		int subsize = kTCFileBufferSize;
		if (rlength - subsize < 0) {
			subsize = rlength;
		}
		[indices addObject:[NSNumber numberWithInt:index]];
		index += subsize;
		rlength -= subsize;
	}
	return [indices autorelease];
}
- (id)initWithDataLength:(UInt32)length uniqueID:(UInt32)uid {
	if (self = [super init]) {
		self.totalLength = length;
		self.uniqueID = uid;
		self.totalData = [[[NSMutableData alloc] initWithLength:length] autorelease];
		self.blocks = [TCFile blocksWithDataLength:length];
	}
	return self;
}

- (void)dealloc {
	self.blocks = nil;
	self.totalData = nil;
	self.peerID = nil;
	[super dealloc];
}

@end
