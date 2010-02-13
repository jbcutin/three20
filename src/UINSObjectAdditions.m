//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "Three20/UINSObjectAdditions.h"

#import "Three20/TTNavigator.h"
#import "Three20/TTURLMap.h"

#ifdef __IPHONE_3_2
#import "Three20/TTSplitNavigator.h"
#endif

/**
 * Additions.
 */
@implementation NSObject (TTCategory)

- (NSString*)URLValue {
#ifdef __IPHONE_3_2
  if ([TTSplitNavigator isSplitNavigatorActive]) {
    for (NSInteger ix = TTNavigatorSplitViewEnd - 1; ix >= TTNavigatorSplitViewBegin; --ix) {
      TTNavigator* navigator = [[TTSplitNavigator splitNavigator] navigatorAtIndex:ix];
      NSString* urlPath = [navigator.URLMap URLForObject:self];
      if (nil != urlPath) {
        return urlPath;
      }
    }
    return nil;
  } else {
    return [[TTNavigator navigator].URLMap URLForObject:self];
  }
#else
  return [[TTNavigator navigator].URLMap URLForObject:self];
#endif
}

- (NSString*)URLValueWithName:(NSString*)name {
#ifdef __IPHONE_3_2
  if ([TTSplitNavigator isSplitNavigatorActive]) {
    for (NSInteger ix = TTNavigatorSplitViewEnd - 1; ix >= TTNavigatorSplitViewBegin; --ix) {
      TTNavigator* navigator = [[TTSplitNavigator splitNavigator] navigatorAtIndex:ix];
      NSString* urlPath = [navigator.URLMap URLForObject:self withName:name];
      if (nil != urlPath) {
        return urlPath;
      }
    }
    return nil;
  } else {
    return [[TTNavigator navigator].URLMap URLForObject:self withName:name];
  }
#else
  return [[TTNavigator navigator].URLMap URLForObject:self withName:name];
#endif
}

@end
