//
//  PromiseViewController.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "PromiseViewController.h"
#import "Promise.h"

@interface PromiseViewController ()

@end

@implementation PromiseViewController

NSString *placeholderText = @"";

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
  placeholderText = self.textView.text;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(onClickOutsideTextView)];
  
  [self.view addGestureRecognizer:tap];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.textView.layer.borderWidth = 1.0f;
  self.textView.layer.borderColor = [[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1] CGColor];
  self.textView.layer.cornerRadius = 5.0;
}

-(void)onClickOutsideTextView {
  [self.textView resignFirstResponder];
  if([self.textView.text isEqualToString:@""])
    self.textView.text = placeholderText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark segue shit

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView {
  if([self.textView.text isEqualToString:placeholderText])
    self.textView.text = @"";
}

@end
