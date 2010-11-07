//
//  TCFile.h
//  GameKitTCP
//
//  Created by Alex Nichol on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTCFileBufferSize 512

@interface TCFile : NSObject {
	UInt32 uniqueID;
	UInt32 totalLength;
	NSString * peerID;
	NSMutableArray * blocks;
	NSMutableData * totalData;
}
+ (NSMutableArray *)blocksWithDataLength:(int)length;
- (id)initWithDataLength:(UInt32)length uniqueID:(UInt32)uid;
@property (nonatomic, retain) NSString * peerID;
@property (nonatomic, retain) NSMutableArray * blocks;
@property (nonatomic, retain) NSMutableData * totalData;
@property (readwrite) UInt32 totalLength;
@property (readwrite) UInt32 uniqueID;
@end
