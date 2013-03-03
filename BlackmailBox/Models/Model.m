//
//  Model.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/2/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "Model.h"

@implementation Model

+(NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context {
  return [self respondsToSelector:@selector(entityInManagedObjectContext:)] ?
  [self performSelector:@selector(entityInManagedObjectContext:) withObject:context] :
  [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
}

+(NSManagedObject *)first:(NSManagedObjectContext *)context {
  NSEntityDescription *entity = [self entityDescriptionInContext:context];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = entity;
  NSError *error = nil;
  request.fetchLimit = 1;
  NSArray *objects = [context executeFetchRequest:request error:&error];
  return objects.count > 0 ? [objects objectAtIndex:0] : nil;
}

+(BOOL)deleteAll:(NSManagedObjectContext *)context {
  NSLog(@"DELETE ALL FOR NAME %@", [[self entityDescriptionInContext:context] name]);
  NSEntityDescription *entity = [self entityDescriptionInContext:context];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = entity;
  NSError *error = nil;
  NSArray *objects = [context executeFetchRequest:request error:&error];
  for(NSManagedObject *obj in objects) {
    [context deleteObject:obj];
  }
  return error ? NO : YES;
}

-(Model *)initWithAttributes:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context {
  NSEntityDescription *entity = [self.class entityDescriptionInContext:context];
  Model *model = [NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:context];
  NSArray *availableKeys = [[model.entity attributesByName] allKeys];
  NSLog(@"available keys are %@", availableKeys);
  [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if([availableKeys containsObject:key]) {
      NSLog(@"setting val for %@ to key %@", obj, key);
      [model setValue:obj forKey:key];
    }
  }];
  return model;
}

@end
