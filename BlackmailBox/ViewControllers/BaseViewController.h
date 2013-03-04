//
//  BaseViewController.h
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Promise.h"

@interface BaseViewController : UIViewController <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Promise *promise;

-(void)doFBLogin:(void (^)())completionHandler;

@end
