//
//  PromiseDateViewController.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "PromiseDateViewController.h"

@interface PromiseDateViewController ()

@end

@implementation PromiseDateViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.datePicker = [[UIDatePicker alloc] init];
  [self.datePicker addTarget:self action:@selector(onDateChanged:) forControlEvents:UIControlEventValueChanged];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(onClickOutsideTextView)];
  [self.view addGestureRecognizer:tap];
  self.textField.inputView = self.datePicker;
  self.textField.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
  NSLog(@"set date");
  [self.promise setValue:self.datePicker.date forKey:@"endDate"];
}

#pragma mark UIDatePicker actions

-(void)onDateChanged:(UIDatePicker *)sender {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MM/dd/YYYY hh:mm";
  NSString *date = [dateFormatter stringFromDate:self.datePicker.date];
  NSLog(@"DATE CHANGED %@", date);
  self.textField.text = date;
}

#pragma mark TapGesture callback

-(void)onClickOutsideTextView {
  NSLog(@"stuff %@", self.promise);
  [self.textField resignFirstResponder];
}


@end
