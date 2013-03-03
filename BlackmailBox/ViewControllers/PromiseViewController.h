//
//  PromiseViewController.h
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Promise.h"

@interface PromiseViewController : BaseViewController <UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UILabel *promiseLabel;
@property (nonatomic, retain) IBOutlet UITextView *promiseTextView;

@property (nonatomic, strong) Promise *promise;

@end
