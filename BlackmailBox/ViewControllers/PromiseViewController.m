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
  [self.promiseLabel setFont:[UIFont fontWithName:@"FjallaOne-Regular" size:22]];
  [self.promiseTextView setFont:[UIFont fontWithName:@"FjallaOne-Regular" size:16]];
  self.promiseTextView.delegate = self;
  placeholderText = self.promiseTextView.text;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(onClickOutsideTextView)];
  
  [self.view addGestureRecognizer:tap];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];
  self.promiseTextView.layer.borderWidth = 1.0f;
  self.promiseTextView.layer.borderColor = [[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1] CGColor];
  self.promiseTextView.layer.cornerRadius = 5.0;
}

-(void)onClickOutsideTextView {
  [self.promiseTextView resignFirstResponder];
  if([self.promiseTextView.text isEqualToString:@""])
    self.promiseTextView.text = placeholderText;
  NSLog(@"text is %@", self.promiseTextView.text);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark segue shit

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSLog(@"text at segue is %@ %@", self.promiseTextView.text, self.managedObjectContext);
  NSString *text = self.promiseTextView.text ? self.promiseTextView.text : @"";
  self.promise = [[Promise alloc] initWithAttributes:@{@"text": text}
                                           inContext:self.managedObjectContext];
  NSLog(@"Promise at segue is %@", self.promise);
  PromiseDateViewController *viewController = segue.destinationViewController;
  viewController.promise = self.promise;
  [super prepareForSegue:segue sender:sender];
}

#pragma mark UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView {
  if([self.promiseTextView.text isEqualToString:placeholderText])
    self.promiseTextView.text = @"";
}

@end
