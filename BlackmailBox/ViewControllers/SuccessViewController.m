//
//  SuccessViewController.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/4/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()

@end

@implementation SuccessViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.successLabel setFont:[UIFont fontWithName:@"FjallaOne-Regular" size:22]];
  UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(goHome:)];
  self.navigationItem.leftBarButtonItem = leftButton;
}

-(void)goHome:(id *)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
