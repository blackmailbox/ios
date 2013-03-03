//
//  PromisesTableViewController.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/3/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "PromisesTableViewController.h"

@interface PromisesTableViewController ()

@end

@implementation PromisesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  self.promises = [NSMutableArray array];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

-(NSInteger *)numberOfSectionsInTableView:(UITableView *)tableView {
  return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromiseCell"];
  
  if(!cell) {
    cell = [[UITableViewCell alloc] init];
  }
  
  cell.textLabel.text = [self.promises objectAtIndex:indexPath.row];
  return cell;
}

@end
