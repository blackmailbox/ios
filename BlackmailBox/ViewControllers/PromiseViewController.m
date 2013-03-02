//
//  PromiseViewController.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "PromiseViewController.h"

@interface PromiseViewController ()

@end

@implementation PromiseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.textView.delegate = self;
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.textView.layer.borderWidth = 1.0f;
  self.textView.layer.borderColor = [[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1] CGColor];
  self.textView.layer.cornerRadius = 5.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView {
  self.textView.text = @"";
}

@end
