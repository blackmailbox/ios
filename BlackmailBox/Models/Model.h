//
//  Model.h
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Model : NSManagedObject

+(BOOL)deleteAll:(NSManagedObjectContext *)context;
+(NSManagedObject *)first:(NSManagedObjectContext *)context;

-(Model *)initWithAttributes:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context;

@end
