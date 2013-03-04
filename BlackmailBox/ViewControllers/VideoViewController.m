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
#import "AppDelegate.h"
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
  NSMutableData *responseData;
}

int duration = 30;

- (void)viewDidLoad
{
  [super viewDidLoad];
  //self.navigationItem.title = @"Say Cheese, Muther F'er";
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mailbox.png"]];
  responseData = [[NSMutableData alloc] init];
  [self.submitBtn addTarget:self action:@selector(onSubmit:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)viewWillAppear:(BOOL)animated {
  self.nextBtn.hidden = NO;
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

-(void)onSubmit:(id *)sender {
  NSDictionary *promiseParams = @{@"promise": @{@"description": [self.promise valueForKey:@"text"], @"expiresAt": [NSNumber numberWithFloat:[[self.promise valueForKey:@"endDate"] timeIntervalSince1970]]}};
  NSLog(@"on SUBMIT %@", promiseParams);
  AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:
    [NSURL URLWithString:
     [NSString stringWithFormat:@"http://localhost:3000/api/users/%@/promises", [appDelegate.user valueForKey:@"id"]]
  ]];
  NSLog(@"SO YEAH UH %@", request.URL);
  [request setHTTPMethod:@"POST"];
  NSMutableData *body = [NSMutableData data];
  
  [request setHTTPBody:body];
  
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:promiseParams options:NSJSONWritingPrettyPrinted error:&error];
  NSLog(@"THE JSON DATA %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
  [body appendData:jsonData];
  [request addValue:[NSString stringWithFormat:@"%d", body.length] forHTTPHeaderField:@"Content-Length"];
  [request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
  // now lets make the connection to the web
  NSLog(@"MAKING REQUEST");
  [NSURLConnection connectionWithRequest:request delegate:self];
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
  [self.promise setValue:videoData forKey:@"video"];
  self.nextBtn.hidden = NO;
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

- (void) captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error {
  NSLog(@"YEA IT FAILED DUDE");
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

#pragma mark NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  NSLog(@"GOT SOME SHIT");
  [responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSError *error = nil;
  NSDictionary *json = [NSJSONSerialization
                        JSONObjectWithData:responseData
                        options:NSJSONReadingMutableLeaves
                        error:&error];
  NSLog(@"DID FINISH LOADING %@ %@", [responseData description], error);
}

@end
