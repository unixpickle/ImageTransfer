//
//  TCSession.h
//  GameKitTCP
//
//  Created by Alex Nichol on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "TCFile.h"
#import "TCPacket.h"

@protocol TCSessionDelegate

- (void)tcsession:(id)sender recievedData:(NSData *)d fromPeer:(NSString *)peerID;
- (void)tcsession:(id)sender couldNotHandleDataFromPeer:(NSString *)peerID;
- (void)tcsessionFinishedSendingData:(id)sender;
- (void)tcsession:(id)sender startGettingDataFromPeer:(NSString *)peerID;
@end


@interface TCSession : NSObject <GKSessionDelegate> {
	GKSession * session;
	NSMutableArray * files;
	NSMutableArray * requests;
	id<TCSessionDelegate> delegate;
}

@property (nonatomic, assign) id<TCSessionDelegate> delegate;
- (void)setSession:(GKSession *)_session;
- (GKSession *)session;
- (void)handlePacket:(TCPacket *)packet;
- (void)sendData:(NSData *)d toPeer:(NSString *)peerID;
@end
