//
//  PromiseViewController.h
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "BaseViewController.h"
#import "Promise.h"

@interface PromiseViewController : BaseViewController <UITextViewDelegate, FBFriendPickerDelegate>

@property (nonatomic, retain) IBOutlet UILabel *promiseLabel;
@property (nonatomic, retain) IBOutlet UITextView *promiseTextView;
@property (nonatomic, retain) IBOutlet UIButton *addFriendsButton;

@property (nonatomic, strong) Promise *promise;

@end
