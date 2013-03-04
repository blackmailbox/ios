//
//  SuccessViewController.h
//  BlackmailBox
//
//  Created by Keith Norman on 3/4/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SuccessViewController : BaseViewController <NSURLConnectionDataDelegate>

@property (nonatomic, retain) IBOutlet UILabel *successLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
