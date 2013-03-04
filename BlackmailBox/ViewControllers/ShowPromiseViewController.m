//
//  ShowPromiseViewController.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/4/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "ShowPromiseViewController.h"

@interface ShowPromiseViewController ()

@end

@implementation ShowPromiseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.theTitle.text = [self.promiseAttributes valueForKey:@"description"];
  self.timeLeft.text = [self.promiseAttributes valueForKey:@"dateString"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
