//
//  ShowPromiseViewController.h
//  BlackmailBox
//
//  Created by Keith Norman on 3/4/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ShowPromiseViewController : BaseViewController

@property (nonatomic, retain) IBOutlet UILabel *theTitle;
@property (nonatomic, retain) IBOutlet UILabel *timeLeft;
@property (nonatomic, retain) IBOutlet UILabel *peopleInvolved;
@property (nonatomic, retain) IBOutlet UIButton *completeBtn;

@property (nonatomic, strong) NSDictionary *promiseAttributes;

@end
