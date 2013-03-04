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
  [self.promiseExpLabel setFont:[UIFont fontWithName:@"FjallaOne-Regular" size:22]];
  [self.promiseExpTextView setFont:[UIFont fontWithName:@"FjallaOne-Regular" size:120]];
  self.numberOfDaysField.layer.borderWidth = 1.0f;
  self.numberOfDaysField.layer.borderColor = [[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1] CGColor];
  self.numberOfDaysField.layer.cornerRadius = 5.0;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
}

#pragma mark UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
  NSLog(@"set date");
  //[self.promise setValue:self.datePicker.date forKey:@"endDate"];
}

#pragma mark UIDatePicker actions

-(void)onDateChanged:(UIDatePicker *)sender {
  //NSString *date = [self formattedDate:self.datePicker.date];
  //NSLog(@"DATE CHANGED %@", date);
}

-(NSString *)formattedDate:(NSDate *)date {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MM/dd/YYYY hh:mm";
  NSString *dateString = [dateFormatter stringFromDate:date];
  return dateString;
}


@end
