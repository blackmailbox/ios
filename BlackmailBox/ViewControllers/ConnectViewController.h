//
//  ConnectViewController.h
//  BlackmailBox
//
//  Created by Keith Norman on 3/3/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ConnectViewController : BaseViewController <NSURLConnectionDataDelegate>

@property (nonatomic, retain) IBOutlet UILabel *connectLabel;


- (IBAction)onPressConnect:(id)sender;

@end
