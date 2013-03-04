//
//  BaseViewController.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSLog(@"UP IN HERE");
  if([self respondsToSelector:@selector(managedObjectContext)] &&
    [segue.destinationViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
    [segue.destinationViewController setManagedObjectContext:self.managedObjectContext];
  }
  
  if([self respondsToSelector:@selector(promise)] &&
     [segue.destinationViewController respondsToSelector:@selector(setPromise:)]) {
    [segue.destinationViewController setPromise:self.promise];
  }
}

-(void)doFBLogin:(void (^)())completionHandler {  
  AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  // get the app delegate so that we can access the session property
  // this button's job is to flip-flop the session from open to closed
  if (FBSession.activeSession.isOpen) {
    NSLog(@"IN THIS IF %@", FBSession.activeSession.accessTokenData.accessToken);
    // if a user logs out explicitly, we delete any cached token information, and next
    // time they run the applicaiton they will be presented with log in UX again; most
    // users will simply close the app or switch away, without logging out; this will
    // cause the implicit cached-token login to occur on next launch of the application
    //[FBSession.activeSession closeAndClearTokenInformation];
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
       if (!error) {
         NSLog(@"user %@", user);
         appDelegate.user = user;
         completionHandler();
       }
     }];
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
      
      [[FBRequest requestForMe] startWithCompletionHandler:
       ^(FBRequestConnection *connection,
         NSDictionary<FBGraphUser> *user,
         NSError *error) {
         NSLog(@"GOT ERROR? %@", error);
         if (!error) {
           NSLog(@"user %@", user);
           appDelegate.user = user;
           completionHandler();
         }
       }];
    }];
  }
}

@end
