//
//  VideoViewController.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "VideoViewController.h"
#import "AVCamCaptureManager.h"
#import "AVCamRecorder.h"
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoViewController ()

@end

@interface VideoViewController (AVCamCaptureManagerDelegate) <AVCamCaptureManagerDelegate, AVCamRecorderDelegate>
@end

@implementation VideoViewController {
  AVPlayerLayer *avPlayerLayer;
  AVPlayer *avPlayer;
  NSTimer *timer;
}

int duration = 30;

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.progressView setProgress:0];
  if ([self captureManager] == nil) {
		AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
		[self setCaptureManager:manager];
		
		[[self captureManager] setDelegate:self];
    
		if ([[self captureManager] setupSession]) {
      // Create video preview layer and add it to the UI
      
			AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
			UIView *view = [self video];
			CALayer *viewLayer = [view layer];
			[viewLayer setMasksToBounds:YES];
      self.captureManager.recorder.delegate = self;
			
			CGRect bounds = [view bounds];
			[newCaptureVideoPreviewLayer setFrame:bounds];
			
//			if ([self.captureManager.session]) {
//				[newCaptureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
//			}
			
			[newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
			
			[viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
			
			[self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
			
      // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[[[self captureManager] session] startRunning];
			});
    }
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSLog(@"promise now is %@", self.promise);
  [super prepareForSegue:segue sender:sender];
}

#pragma mark AVCamRecorderDelegate

-(void)recorderRecordingDidBegin:(AVCamRecorder *)recorder {
  NSLog(@"RECORDING STARTED");
  timer = [NSTimer scheduledTimerWithTimeInterval:1
                                   target:self
                                 selector:@selector(tick:)
                                 userInfo:nil
                                  repeats:YES];
}

-(void)recorder:(AVCamRecorder *)recorder recordingDidFinishToOutputFileURL:(NSURL *)outputFileURL error:(NSError *)error {
  NSLog(@"RECORDING ENDED");
  avPlayer = [AVPlayer playerWithURL:outputFileURL];
  avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
  avPlayerLayer.frame = self.view.layer.bounds;
  [self.view.layer insertSublayer:avPlayerLayer atIndex:10];
  [avPlayer play];
  [avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
  NSData *videoData = [NSData dataWithContentsOfFile:[outputFileURL path]];
  NSLog(@"THE DATA OF VID IS %@ from path %@ with original path %@", videoData, [outputFileURL path], outputFileURL);
  [self.promise setValue:videoData forKey:@"video"];
}

- (IBAction)onPressRecord:(id)sender {
  if(self.captureManager.recorder.isRecording) {
    [self.captureManager stopRecording];
    [timer invalidate];
    [self.recordBtn setTitle:@"Record" forState:UIControlStateNormal];
  }
  else {
    [self.captureManager startRecording];
    [self.recordBtn setTitle:@"Stop" forState:UIControlStateNormal];
  }
  NSLog(@"RECORD PRESSED");
}


-(void)didChange:(NSKeyValueChange)changeKind valuesAtIndexes:(NSIndexSet *)indexes forKey:(NSString *)key {
  NSLog(@"HYIO %@ %@", indexes, key);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  NSLog(@"OK DUDE %@ %@", change, object);
}

-(void)tick:aTimer {
  duration--;
  NSLog(@"DUR IS %f", ((30.0 - duration) / 30.0));
  [self.progressView setProgress:((30.0 - duration) / 30.0) animated:YES];
  if(duration <= 0) {
    [aTimer invalidate];
    [self.captureManager stopRecording];
  }
}

@end
