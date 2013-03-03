//
//  Promise.h
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Model.h"


@interface Promise : Model

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * endDate;

+(NSURL *)url;

@end
