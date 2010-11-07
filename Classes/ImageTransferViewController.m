//
//  ImageTransferViewController.m
//  ImageTransfer
//
//  Created by Alex Nichol on 11/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ImageTransferViewController.h"
#import "ANLoadingManager.h"

#define kSessionID @"imgtrnsfr"

@implementation ImageTransferViewController

@synthesize mSession;
@synthesize tmpSession;
@synthesize peerID;
@synthesize mPicker;

- (void)makeNewConnection {
	self.mPicker = [[[GKPeerPickerController alloc] init] autorelease];
	mPicker.delegate = self;
	mPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;	
	[mPicker show];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self makeNewConnection];
}

#pragma mark Image Sending

- (IBAction)sendImage:(id)sender {
	[self presentModalViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker 
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo 
{
    [picker dismissModalViewControllerAnimated:YES];
	// use image
	[[ANLoadingManager sharedManager] startLoadingObject:nil withJobSelector:0 
												userInfo:nil];
	[self.tmpSession sendData:UIImagePNGRepresentation(image)
					   toPeer:self.peerID];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	// ignore
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma mark Peer Picking

- (IBAction)disconnect:(id)sender {
	[self.mSession disconnectFromAllPeers];
	self.tmpSession = nil;
	self.mSession = nil;
	[self makeNewConnection];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
	exit(0);
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type { 
	GKSession * session = [[GKSession alloc] initWithSessionID:kSessionID displayName:nil sessionMode:GKSessionModePeer]; 
	return [session autorelease]; // peer picker retains a reference, so autorelease ours so we don't leak.
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)_peerID toSession:(GKSession *)session {
	// Use a retaining property to take ownership of the session.
    self.mSession = session;
	self.mSession.delegate = self;
	self.tmpSession = [[[TCSession alloc] init] autorelease];
	[self.tmpSession setSession:session];
	self.tmpSession.delegate = self;
	// Remove the picker.
	self.mPicker.delegate = nil;
    [self.mPicker dismiss];
	[mPicker autorelease];
	mPicker = nil;
	self.peerID = _peerID;
}

#pragma mark GameKit and TCPacket

- (void)session:(GKSession *)session peer:(NSString *)_peerID didChangeState:(GKPeerConnectionState)state {
	switch (state)
    {
        case GKPeerStateConnected:
		{
			// great
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			[multiplayerView setAlpha:1];
			[UIView commitAnimations];
			NSLog(@"Connected.");
			break;
		}
        case GKPeerStateDisconnected:
		{
			self.tmpSession = nil;
			self.mSession = nil;
			[self makeNewConnection];
			break;
		}
    }
}

- (void)tcsession:(id)sender couldNotHandleDataFromPeer:(NSString *)peerID {
	[[ANLoadingManager sharedManager] doneTask];
}

- (void)tcsession:(id)sender recievedData:(NSData *)d fromPeer:(NSString *)peerID {
	// got an image
	[[ANLoadingManager sharedManager] doneTask];
	UIImage * image = [[UIImage alloc] initWithData:d];
	ImageViewController * ivc = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
	[ivc setImage:image];
	[self presentModalViewController:ivc animated:YES];
	[ivc release];
	[image release];
}

- (void)tcsessionFinishedSendingData:(id)sender {
	[[ANLoadingManager sharedManager] doneTask];
}

- (void)tcsession:(id)sender startGettingDataFromPeer:(NSString *)peerID {
	[[ANLoadingManager sharedManager] startLoadingObject:nil
										 withJobSelector:0 userInfo:nil];
}

#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.mPicker = nil;
	self.tmpSession = nil;
	self.mPicker = nil;
	self.peerID = nil;
    [super dealloc];
}

@end
