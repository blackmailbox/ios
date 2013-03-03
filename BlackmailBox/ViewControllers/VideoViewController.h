//
//  VideoViewController.h
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"

@class AVCamCaptureManager, AVCamPreviewView, AVCaptureVideoPreviewLayer;

@interface VideoViewController : BaseViewController

@property (nonatomic, retain) IBOutlet UIView *video;
@property (nonatomic, retain) IBOutlet UIButton *recordBtn;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;

@property (nonatomic,retain) AVCamCaptureManager *captureManager;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

- (IBAction)onPressRecord:(id)sender;

@end
