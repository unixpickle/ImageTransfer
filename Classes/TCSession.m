//
//  TCSession.m
//  GameKitTCP
//
//  Created by Alex Nichol on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TCSession.h"
#import "GZipper.h"


@implementation TCSession

@synthesize delegate;

- (id)init {
	if (self = [super init]) {
		files = [[NSMutableArray alloc] init];
		requests = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)setSession:(GKSession *)_session {
	session = _session;
	//[session setDelegate:self];
	[session setDataReceiveHandler:self withContext:NULL];
}
- (GKSession *)session {
	return session;
}
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
	// alright so here we read the packet, and basically send it to our
	// other method for handling packets themselves.
	TCPacket * packet = [[TCPacket alloc] initWithData:data];
	if (packet) {
		packet.peerID = peer;
		[self handlePacket:packet];
		[packet release];
	} else {
		if ([(id)delegate respondsToSelector:@selector(tcsession:couldNotHandleDataFromPeer:)]) {
			[delegate tcsession:self couldNotHandleDataFromPeer:peer];
		}
	}
}
- (void)sendData:(NSData *)d toPeer:(NSString *)peerID {
	// jeeze we have a lot to do
	// let's send a header packet
	// we need to compress our data first, so let's do that
	NSData * compressed = [d gzipDeflate];
	
	UInt32 uniqueID = arc4random();
	UInt32 totalSize = [compressed length];
	// send over the uniqueID, and total size
	TCPacket * packet = [[TCPacket alloc] init];
	packet.packetData = [NSData dataWithBytes:&totalSize length:4];
	packet.peerID = peerID;
	packet.uniqueID = uniqueID;
	packet.blockAddress = 0;
	char * flags = [packet packetFlags];
	memset(flags, 0, 4);
	flags[0] = flags[0] | 1;
	NSData * packetData = [packet encodeToData];
	// send the packet asking for confirmation
	[[self session] sendData:packetData toPeers:[NSArray arrayWithObject:peerID]
				withDataMode:GKSendDataReliable
					   error:nil];
	// add the uniqueID and sending data to the list of pending
	// requests.  this will be used later
	NSDictionary * bookmark = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithLong:uniqueID], @"uid",
						   compressed, @"data", nil];
	[requests addObject:bookmark];
	[bookmark release];
	[packet release];
}
- (void)handlePacket:(TCPacket *)packet {
	NSLog(@"Recieved packet.");
	// respond to the sent data.
	// we will read the packet UniqueID
	// and flags to get information
	char * flags = [packet packetFlags];
	UInt8 isFirst = flags[0] & 2; // check for 2nd flag
	UInt8 isRequest = flags[0] & 1;
	if (isFirst) {
		NSLog(@"First incoming packet.  Now sending data.");
		// so we got our response. 
		// now how about we go into some
		// action
		NSDictionary * findDict = nil;;
		for (NSDictionary * dict in requests) {
			if ((UInt32)[[dict objectForKey:@"uid"] longValue] == [packet uniqueID]) {
				// we found the dictionary, now let's break!
				findDict = [dict retain];
			}
		}
		if (findDict) {
			// send a letter of graditude
			NSData * data = [findDict objectForKey:@"data"];
			UInt32 uniqueID = (UInt32)[[findDict objectForKey:@"uid"] longValue];
			//NSArray * blocks = [TCFile blocksWithDataLength:[data length]];
			int csize = 0;
			while (csize < [data length]) {
				int blockSize = kTCFileBufferSize;
				if (blockSize + csize > [data length]) {
					blockSize = [data length] - csize;
				}
				int indexNumber = csize;
				
				NSLog(@"Sending block index: %d", indexNumber);
				NSLog(@"%d-%d out of %d", indexNumber, blockSize, [data length]);
				TCPacket * _packet = [[TCPacket alloc] init];
				_packet.uniqueID = uniqueID;
				_packet.blockAddress = indexNumber;
				const void * bytes = &(((const char *)[data bytes])[indexNumber]);
				_packet.packetData = [NSData dataWithBytesNoCopy:(void *)bytes length:blockSize freeWhenDone:NO];
				memset([_packet packetFlags], 0, 4);
				NSLog(@"Configured packet, launching!");
				NSAutoreleasePool * saveMe = [[NSAutoreleasePool alloc] init];
				[[self session] sendData:[_packet encodeToData] 
								 toPeers:[NSArray arrayWithObject:packet.peerID]
							withDataMode:GKSendDataReliable error:nil];
				[saveMe drain];
				[_packet release];
				
				csize += blockSize;
			}
			if ([(id)delegate respondsToSelector:@selector(tcsessionFinishedSendingData:)]) {
				[delegate tcsessionFinishedSendingData:self];
			}
			[requests removeObject:findDict];
			[findDict release];
		} else {
			NSLog(@"Bogus confirmation packet!");
			return;
		}
	} else if (isRequest) {
		NSLog(@"Request for sending data.");
		// create confirmation packet back
		// and setup our file
		UInt32 length = *(UInt32 *)[[packet packetData] bytes];
		NSLog(@"Length: %d", length);
		TCFile * file = [[TCFile alloc] initWithDataLength:length
												  uniqueID:[packet uniqueID]];
		[file setPeerID:[packet peerID]];
		[files addObject:file];
		[file release];
		
		TCPacket * _packet = [[TCPacket alloc] init];
		_packet.packetData = [NSData dataWithBytes:"ok  " length:4];
		_packet.peerID = packet.peerID;
		_packet.uniqueID = packet.uniqueID;
		_packet.blockAddress = 0;
		char * flags = [_packet packetFlags];
		memset(flags, 0, 4);
		flags[0] = flags[0] | 2;
		NSData * packetData = [_packet encodeToData];
		[_packet release];
		NSLog(@"About to send actual DATA!");
		//printf("Peer id %s\n", [[packet peerID] UTF8String]);
		fflush(stdout);
		[[self session] sendData:packetData
						 toPeers:[NSArray arrayWithObject:[packet peerID]] 
					withDataMode:GKSendDataReliable error:nil];
		if ([(id)delegate respondsToSelector:@selector(tcsession:startGettingDataFromPeer:)]) {
			[delegate tcsession:self startGettingDataFromPeer:[packet peerID]];
		}
	} else {
		NSLog(@"Appending file here.");
		// append to the file here
		TCFile * file = nil;
		for (int i = 0; i < [files count]; i++) {
			if ([[files objectAtIndex:i] uniqueID] == [packet uniqueID]) {
				file = [files objectAtIndex:i];
				break;
			}
		}
		if (file) {
			NSLog(@"Total Bytes: %d", [[file totalData] length]);
			NSLog(@"Got %d bytes at index %d", [[packet packetData] length], [packet blockAddress]);
			[[file totalData] replaceBytesInRange:NSMakeRange([packet blockAddress], [[packet packetData] length]) withBytes:((const char *)([[packet packetData] bytes]))];
			[[file blocks] removeObject:[NSNumber numberWithInt:[packet blockAddress]]];
			NSLog(@"%d blocks remaining", [[file blocks] count]);
			if ([[file blocks] count] <= 0) {
				NSLog(@"Recieved file.");
				if ([(id)delegate respondsToSelector:@selector(tcsession:recievedData:fromPeer:)]) {
					NSData * unzipped = [[file totalData] gzipInflate];
					NSLog(@"Unzipped of %p = %p", [file totalData], unzipped);
					if (unzipped) {
						[delegate tcsession:self recievedData:unzipped fromPeer:[file peerID]];
					} else {
						[delegate tcsession:self recievedData:[file totalData] fromPeer:[file peerID]];
					}
				}
				[files removeObject:file];
			}
		} else {
			NSLog(@"No file with id: %d", [packet uniqueID]);
		}
	}
}

- (void)dealloc {
	// clean up
	[requests release];
	[files release];
	[[self session] setDelegate:nil];
	[[self session] setDataReceiveHandler:nil withContext:NULL];
	[self setSession:nil];
	[super dealloc];
}

@end
