//
//  SuccessViewController.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/4/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "SuccessViewController.h"
#import "AppDelegate.h"
#import "PromisesTableViewController.h"

@interface SuccessViewController ()

@end

@implementation SuccessViewController {
  NSMutableData *responseData;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  responseData = [NSMutableData data];
  [self.successLabel setFont:[UIFont fontWithName:@"FjallaOne-Regular" size:22]];
  self.successLabel.hidden = YES;
  self.activityIndicator.hidden = NO;
  [self.activityIndicator startAnimating];
  [self uploadItAll];
  UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(goHome:)];
  self.navigationItem.leftBarButtonItem = leftButton;
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

-(void)goHome:(id *)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)uploadItAll {
  NSLog(@"PROMISE IS HERE %@", self.promise);
  NSMutableDictionary *promiseParams = [NSMutableDictionary dictionary];
  if([self.promise valueForKey:@"text"])
    [promiseParams setValue:[self.promise valueForKey:@"text"] forKey:@"description"];
  if([self.promise valueForKey:@"endDate"])
    [promiseParams setValue:[NSNumber numberWithFloat:[[self.promise valueForKey:@"endDate"] timeIntervalSince1970]] forKey:@"expiresAt"];
  
  AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"USEr IS %@", appDelegate.user);
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:
   [NSURL URLWithString:
    [NSString stringWithFormat:@"http://blackmailboxapp.com/api/users/%@/promises", [appDelegate.user valueForKey:@"id"]]
    ]];
  NSLog(@"SO YEAH UH %@", request.URL);
  [request setHTTPMethod:@"POST"];
  NSMutableData *body = [NSMutableData data];
  
  [request setHTTPBody:body];
  
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"promise": promiseParams} options:NSJSONWritingPrettyPrinted error:&error];
  NSLog(@"THE JSON DATA %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
  [body appendData:jsonData];
  [request addValue:[NSString stringWithFormat:@"%d", body.length] forHTTPHeaderField:@"Content-Length"];
  [request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
  // now lets make the connection to the web
  NSLog(@"MAKING REQUEST");
  [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSLog(@"DOING SEGUE AFTER %@", segue.destinationViewController);
}

#pragma mark NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"CONN FAILURE IN FINAL UPLOAD");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  NSLog(@"GOT SOME SHIT");
  [responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSError *error = nil;
  NSDictionary *json = [NSJSONSerialization
                        JSONObjectWithData:responseData
                        options:NSJSONReadingMutableLeaves
                        error:&error];
  self.activityIndicator.hidden = YES;
  self.successLabel.hidden = NO;
  NSLog(@"DID FINISH LOADING %@ %@", [responseData description], error);
}


@end
