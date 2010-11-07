//
//  TCPacket.m
//  GameKitTCP
//
//  Created by Alex Nichol on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TCPacket.h"


@implementation TCPacket
@synthesize packetData;
@synthesize peerID;
@synthesize uniqueID;
@synthesize blockAddress;

- (char *)packetFlags {
	return flags;
}

- (id)initWithData:(NSData *)dataPacket {
	if (self = [super init]) {
		// check the packet headers
		const char * bytes = (const char *)[dataPacket bytes];
		UInt32 dataLength = 0;
		if ([dataPacket length] < 16) {
			[self dealloc];
			return nil;
		}
		// here is where we decide the important stuff for later
		uniqueID = *(UInt32 *)bytes;
		blockAddress = *(UInt32 *)&bytes[4];
		dataLength = *(UInt32 *)&bytes[8];
		memcpy(flags, &bytes[12], 4);
		// data length should be the length of the data - 16
		if (dataLength == [dataPacket length] - 16) {
			// here we have our length, so why not use it?
			self.packetData = [NSData dataWithBytes:&bytes[16] 
											 length:dataLength];
		} else {
			[self dealloc];
			return nil;
		}
	}
	return self;
}

- (NSData *)encodeToData {
	UInt32 dataLength = [self.packetData length];
	char * str = (char *)malloc(dataLength + 17);
	const void * mBytes = [self.packetData bytes];
	memcpy(str, &uniqueID, 4);
	memcpy(&str[4], &blockAddress, 4);
	memcpy(&str[8], &dataLength, 4);
	memcpy(&str[12], flags, 4);
	memcpy(&str[16], mBytes, dataLength);
	return [NSData dataWithBytesNoCopy:str length:dataLength+16 freeWhenDone:YES];
}

- (void)dealloc {
	self.packetData = nil;
	self.peerID = nil;
	[super dealloc];
}

@end
