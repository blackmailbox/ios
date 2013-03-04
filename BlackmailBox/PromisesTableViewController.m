//
//  PromisesTableViewController.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/3/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "PromisesTableViewController.h"
#import "AppDelegate.h"
#import "ShowPromiseViewController.h"

@interface PromisesTableViewController ()

@end

@implementation PromisesTableViewController {
  NSMutableData *responseData;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self hideStartScreen];
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mailbox.png"]];
  [self.startLabel setFont:[UIFont fontWithName:@"FjallaOne-Regular" size:22]];
  responseData = [[NSMutableData alloc] init];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self loadData];
  responseData = [[NSMutableData alloc] init];
  self.promises = [NSMutableArray array];
}

-(void)hideStartScreen {
  self.startBtn.hidden = YES;
  self.startLabel.hidden = YES;
}

-(void)showStartScreen {
  self.startBtn.hidden = NO;
  self.startLabel.hidden = NO;
}

-(void)initTable {
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  self.tableView.separatorColor = [UIColor blackColor];
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(void)loadData {
  NSLog(@"loading data");
  [self doFBLogin:^{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSLog(@"SESSION IS %d", FBSession.activeSession.isOpen);
    NSLog(@"USER IS %@", appDelegate.user);
    [request setURL:
     [NSURL URLWithString:
      [NSString stringWithFormat:@"http://blackmailboxapp.com/api/users/%@/promises", [appDelegate.user valueForKey:@"id"]]
      ]];
    NSLog(@"SO YEAH UH %@", request.URL);
    [request setHTTPMethod:@"GET"];
    // now lets make the connection to the web
    NSLog(@"MAKING REQUEST");
    [NSURLConnection connectionWithRequest:request delegate:self];
  }];
}
#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.promises.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *promise = [self.promises objectAtIndex:indexPath.row];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromiseCell"];
  
  if(!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PromiseCell"];
  }
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[promise valueForKey:@"expiresAt"] doubleValue]];
  NSLog(@"THE DATE IS %@ %f", date, [date timeIntervalSinceDate:[NSDate date]] / 60 / 60 / 24);
  NSTimeInterval timeInterval = [date timeIntervalSinceDate:[NSDate date]];
  NSString *dateString;
  // years
  if(timeInterval < 0) {
    dateString = @"Expired";
  }
  else if(timeInterval > 365 * 24 * 60 * 60) {
    double interval = timeInterval / 60 / 60 / 24 / 365.2425;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    [formatter setMaximumFractionDigits:0];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:interval]];
    NSString *suffix = interval > 365 * 2 ? @" years left" : @" year left";
    dateString = [numberString stringByAppendingString:suffix];
  }
  // months
  else if(timeInterval > 180 * 24 * 60 * 60) {
    double interval = timeInterval / 60 / 60 / 24 / 30;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    [formatter setMaximumFractionDigits:0];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:interval]];
    NSString *suffix = interval > 45 ? @" months left" : @" month left";
    dateString = [numberString stringByAppendingString:suffix];
  }
  // weeks
  else if(timeInterval > 30 * 24 * 60 * 60) {
    double interval = timeInterval / 60 / 60 / 24 / 7;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    [formatter setMaximumFractionDigits:0];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:interval]];
    NSString *suffix = interval >  1.5 ? @" weeks left" : @" week left";
    dateString = [numberString stringByAppendingString:suffix];
  }
  // days
  else if(timeInterval > 24 * 60 * 60) {
    double interval = timeInterval / 60 / 60 / 24;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    [formatter setMaximumFractionDigits:0];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:interval]];
    NSString *suffix = interval > 1.5 ? @" days left" : @" day left";
    dateString = [numberString stringByAppendingString:suffix];
  }
  // minutes
  else {
    double interval = timeInterval / 60 / 60;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    [formatter setMaximumFractionDigits:0];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:interval]];
    NSString *suffix = interval > 1.5 ? @" minutes left" : @" minute left";
    dateString = [numberString stringByAppendingString:suffix];
  }
  promise = [promise mutableCopy];
  [promise setValue:dateString forKey:@"dateString"];
  [self.promises replaceObjectAtIndex:indexPath.row withObject:promise];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.detailTextLabel.text = dateString;
  UIView *selectionColor = [[UIView alloc] init];
  selectionColor.backgroundColor = [UIColor colorWithRed:(125/255.0) green:(125/255.0) blue:(125/255.0) alpha:1];
  cell.selectedBackgroundView = selectionColor;
  cell.detailTextLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
  cell.textLabel.font = [UIFont fontWithName:@"FjallaOne-Regular" size:18];
  cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
  cell.textLabel.numberOfLines = 3; // 0 means no max.;
  cell.textLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
  cell.textLabel.shadowColor = [UIColor blackColor];
  cell.textLabel.shadowOffset = CGSizeMake(0, 5.0);
  cell.textLabel.text = [promise valueForKey:@"description"];
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self performSegueWithIdentifier:@"showPromise" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if([segue.identifier isEqualToString:@"showPromise"]) {
    ShowPromiseViewController *viewController = [segue destinationViewController];
    NSDictionary *promiseAttributes = [self.promises objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    viewController.promiseAttributes = promiseAttributes;
    [super prepareForSegue:segue sender:sender];
  }
}

#pragma mark NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  NSLog(@"DID GET SOME DATA");
  [responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"DID FAIL SOME REASONS");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSError *error = nil;
  NSDictionary *json = [NSJSONSerialization
                        JSONObjectWithData:responseData
                        options:NSJSONReadingMutableLeaves
                        error:&error];
  if(!error) {
    self.promises = [[json valueForKey:@"promises"] mutableCopy];
    if(self.promises.count > 0) {
      NSLog(@"GOT DATA AAND SUCH");
      [self hideStartScreen];
      [self initTable];
      NSLog(@"FINISHED UP %@ %@", self.promises, error);
      [self.tableView reloadData];
    }
    else
      [self showStartScreen];
  }
  else
    [self loadData];
}

@end
