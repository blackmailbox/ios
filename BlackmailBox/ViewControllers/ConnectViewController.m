//
//  ConnectViewController.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/3/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "ConnectViewController.h"
#import "AppDelegate.h"

@interface ConnectViewController () {
  NSMutableData *responseData;
}

@end

@implementation ConnectViewController

- (void)viewDidLoad
{
  NSLog(@"OK DUDE MAN");
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mailbox.png"]];
  responseData = [[NSMutableData alloc] init];
  //[FBSession.activeSession closeAndClearTokenInformation];
  [super viewDidLoad];
  
  [self.connectLabel setFont:[UIFont fontWithName:@"FjallaOne-Regular" size:22]];
  // create a fresh session object
  [FBSession setActiveSession:[[FBSession alloc] init]];
  
  // if we don't have a cached token, a call to open here would cause UX for login to
  // occur; we don't want that to happen unless the user clicks the login button, and so
  // we check here to make sure we have a token before calling open
  if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
    // even though we had a cached token, we need to login to make the session usable
    [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
      // we recurse here, in order to update buttons and labels
      NSLog(@"CREATE SESSION");
    }];
  }
  [self.connectLabel setFont:[UIFont fontWithName:@"FjallaOne-Regular" size:22]];
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)populateUserDetails {
  AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  if (FBSession.activeSession.isOpen) {
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
       if (!error) {
         NSLog(@"user %@", user);
         appDelegate.user = user;
         [self persistUserDataToServer];
         [self performSegueWithIdentifier:@"successSegue" sender:self];
       }
     }];
  }
}

-(void)persistUserDataToServer {
  AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:@"http://blackmailboxapp.com/api/users"]];
  [request setHTTPMethod:@"POST"];
  NSMutableData *body = [NSMutableData data];

  [request setHTTPBody:body];
  
  NSDictionary *user = appDelegate.user;
  NSError *error = nil;
  [user setValue:FBSession.activeSession.accessTokenData.accessToken forKey:@"accessToken"];
  NSDictionary *userParams = @{@"user": @{@"accessToken": [user valueForKey:@"accessToken"], @"name": [user valueForKey:@"name"], @"id": [user valueForKey:@"id"], @"username": [user valueForKey:@"username"]}};
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userParams options:NSJSONWritingPrettyPrinted error:&error];
  NSLog(@"THE JSON DATA %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
  [body appendData:jsonData];
  [request addValue:[NSString stringWithFormat:@"%d", body.length] forHTTPHeaderField:@"Content-Length"];
  [request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
  // now lets make the connection to the web
  NSLog(@"MAKING REQUEST");
  [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark IBAction

-(IBAction)onPressConnect:(id)sender {
  // get the app delegate so that we can access the session property
  // this button's job is to flip-flop the session from open to closed
  if (FBSession.activeSession.isOpen) {
    NSLog(@"IN THIS IF %@", FBSession.activeSession.accessTokenData.accessToken);
    [self populateUserDetails];
    // if a user logs out explicitly, we delete any cached token information, and next
    // time they run the applicaiton they will be presented with log in UX again; most
    // users will simply close the app or switch away, without logging out; this will
    // cause the implicit cached-token login to occur on next launch of the application
    //[FBSession.activeSession closeAndClearTokenInformation];
    
  } else {
    NSLog(@"IN THIS ELSE");
    if (FBSession.activeSession.state != FBSessionStateCreated) {
      // Create a new, logged out session.
      FBSession.activeSession = [[FBSession alloc] init];
    }
    NSLog(@"START SESSION %d", FBSession.activeSession.isOpen);
    // if the session isn't open, let's open it now and present the login UX to the user
    [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
      // and here we make sure to update our UX according to the new session state
      NSLog(@"DID STUFF %@", session.accessTokenData.accessToken);
      [self populateUserDetails];
    }];
  }
}

#pragma mark NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  NSLog(@"GOT DONE HERE");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  NSLog(@"GOT SOME DATA");
  [responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"CONN FAILURE");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSError *error = nil;
  NSDictionary *json = [NSJSONSerialization
                        JSONObjectWithData:responseData
                        options:NSJSONReadingMutableLeaves
                        error:&error];
  AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  [appDelegate.user setValue:[[json valueForKey:@"user"] valueForKey:@"id"] forKey:@"_id"];
  NSLog(@"DID FINISH LOADING %@ %@", [responseData description], error);
}


@end
