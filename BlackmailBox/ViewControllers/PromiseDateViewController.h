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

@property (nonatomic, strong) Promise *promise;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, weak) IBOutlet UITextField *textField;

@end
