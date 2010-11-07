//
//  TCPacket.h
//  GameKitTCP
//
//  Created by Alex Nichol on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TCPacket : NSObject {
	UInt32 uniqueID;
	UInt32 blockAddress;
	NSData * packetData;
	NSString * peerID;
	char flags[4]; // should be four bytes
}
- (id)initWithData:(NSData *)dataPacket;
- (NSData *)encodeToData;
@property (nonatomic, retain) NSData * packetData;
@property (nonatomic, retain) NSString * peerID;
@property (readwrite) UInt32 uniqueID;
@property (readwrite) UInt32 blockAddress;
- (char *)packetFlags;
@end
