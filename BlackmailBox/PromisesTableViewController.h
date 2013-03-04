//
//  PromisesTableViewController.h
//  BlackmailBox
//
//  Created by Keith Norman on 3/3/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PromisesTableViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *startLabel;

@property (nonatomic, strong) NSMutableArray *promises;

@end
