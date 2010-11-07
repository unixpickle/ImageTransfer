//
//  ImageTransferViewController.h
//  ImageTransfer
//
//  Created by Alex Nichol on 11/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GZipper.h"
#import "TCSession.h"
#import "ImageViewController.h"

@interface ImageTransferViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, GKPeerPickerControllerDelegate, GKSessionDelegate, TCSessionDelegate> {
	GKSession * mSession;
	TCSession * tmpSession;
	NSString * peerID;
	GKPeerPickerController * mPicker;
	IBOutlet UIView * multiplayerView;
	UIImagePickerController * imagePickerController;
}
- (IBAction)sendImage:(id)sender;
- (IBAction)disconnect:(id)sender;
@property (nonatomic, retain) GKSession * mSession;
@property (nonatomic, retain) GKPeerPickerController * mPicker;
@property (nonatomic, retain) TCSession * tmpSession;
@property (nonatomic, retain) NSString * peerID;
@end

