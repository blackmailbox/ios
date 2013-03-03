//
//  BaseViewController.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSLog(@"UP IN HERE");
  if([self respondsToSelector:@selector(managedObjectContext)] &&
    [segue.destinationViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
    [segue.destinationViewController setManagedObjectContext:self.managedObjectContext];
  }
}

@end
