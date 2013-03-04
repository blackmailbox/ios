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

@implementation PromiseViewController {
  NSArray *taggedUsers;
}

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
  [self.addFriendsButton addTarget:self action:@selector(showFriendsPicker) forControlEvents:UIControlEventTouchUpInside];
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

-(void)showFriendsPicker {
  [self doFBLogin:^ {
    NSLog(@"DONE LOGGED IN NOW");
    // Initialize the friend picker
    FBFriendPickerViewController *friendPickerController =
    [[FBFriendPickerViewController alloc] init];
    // Set the friend picker title
    friendPickerController.title = @"Pick Friends";
    friendPickerController.delegate = self;
    // Load the friend data
    [friendPickerController loadData];
    // Show the picker modally
    [friendPickerController presentModallyFromViewController:self animated:YES handler:nil];
  }];
}

#pragma mark segue shit

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSLog(@"text at segue is %@ %@", self.promiseTextView.text, self.managedObjectContext);
  NSString *text = self.promiseTextView.text ? self.promiseTextView.text : @"";
  NSDictionary *attributes = @{@"text": text};
  if(taggedUsers.count > 0) {
    [attributes setValue:taggedUsers forKey:@"taggedUsers"];
  }
  self.promise = [[Promise alloc] initWithAttributes:attributes inContext:self.managedObjectContext];
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

#pragma mark FBFriendPickerDelegat

-(void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker {
  NSLog(@"Current friend selections: %@", friendPicker.selection);
}

-(void)facebookViewControllerDoneWasPressed:(id)sender {
  FBFriendPickerViewController *friendPickerController =
  (FBFriendPickerViewController*)sender;
  NSLog(@"Selected friends: %@", friendPickerController.selection);
  // Dismiss the friend picker
  if(friendPickerController.selection.count > 0) {
    [self.addFriendsButton setImage:[UIImage imageNamed:@"add-friends-active.png"] forState:UIControlStateNormal];
  }
  else {
    [self.addFriendsButton setImage:[UIImage imageNamed:@"add-friends.png"] forState:UIControlStateNormal];
  }
  taggedUsers = friendPickerController.selection;
  [[sender presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
