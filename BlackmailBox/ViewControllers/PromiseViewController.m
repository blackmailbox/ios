//
//  PromiseViewController.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "PromiseViewController.h"
#import "Promise.h"
#import "PromiseDateViewController.h"

@interface PromiseViewController ()

@end

@implementation PromiseViewController

NSString *placeholderText = @"";

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.PromiseLabel setFont:[UIFont fontWithName:@"FjallaOne-Regular" size:22]];
  [self.PromiseTextView setFont:[UIFont fontWithName:@"FjallaOne-Regular" size:16]];
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
  NSLog(@"text is %@", self.textView.text);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark segue shit

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSLog(@"text at segue is %@", self.textView.text);
  self.promise = [[Promise alloc] initWithAttributes:@{@"text": self.textView.text}
                                           inContext:self.managedObjectContext];
  NSLog(@"Promise at segue is %@", self.promise);
  PromiseDateViewController *viewController = segue.destinationViewController;
  viewController.promise = self.promise;
  [super prepareForSegue:segue sender:sender];
}

#pragma mark UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView {
  if([self.textView.text isEqualToString:placeholderText])
    self.textView.text = @"";
}

@end
