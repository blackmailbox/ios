//
//  PromiseDateViewController.h
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Promise.h"

@interface PromiseDateViewController : BaseViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextView *numberOfDaysField;
@property (nonatomic, retain) IBOutlet UILabel *promiseExpLabel;
@property (nonatomic, retain) IBOutlet UITextView*promiseExpTextView;

@property (nonatomic, strong) Promise *promise;

@end
