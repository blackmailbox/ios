//
//  NSDictionary+NSDictionary_params.m
//  BlackmailBox
//
//  Created by Keith Norman on 3/3/13.
//  Copyright (c) 2013 BlackmailBox. All rights reserved.
//

#import "NSDictionary+NSDictionary_params.h"

@implementation NSString(CallWranglerUtilities)
- (NSString *)stringByAddingPercentEscapesForURI
{
  NSString *reserved = @":/?#[]@!$&'()*+,;=";
  CFStringRef s = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)reserved, kCFStringEncodingUTF8);
  return (__bridge NSString *)(s);
}
@end

@implementation NSDictionary (NSDictionary_params)

- (NSString *) convertDictionaryToURIParameterString {
  NSMutableArray *elements = [NSMutableArray array];
  for (NSString *k in [self keyEnumerator]) {
    NSString *escapedK = [k stringByAddingPercentEscapesForURI];
    if (![k isEqualToString: @""]) {
      NSString *escapedV = [[self objectForKey: k] stringByAddingPercentEscapesForURI];
      [elements addObject: [NSString stringWithFormat: @"%@=%@", escapedK, escapedV]];
    }
  }
  return [elements componentsJoinedByString:@"&"];
}

@end
