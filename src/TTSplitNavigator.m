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

#import "Three20/TTSplitNavigator.h"

#import "Three20/TTNavigator.h"
#import "Three20/TTSplitNavigatorWindow.h"

#import "Three20/TTGlobalUINavigator.h"

#import "Three20/TTCorePreprocessorMacros.h"
#import "Three20/TTDebug.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTSplitNavigator

@synthesize URLMap              = _URLMap;
@synthesize window              = _window;
@synthesize rootViewController  = _rootViewController;


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (TTSplitNavigator*)splitNavigator {
  static TTSplitNavigator* splitNavigator = nil;
  if (nil == splitNavigator) {
    splitNavigator = [[TTSplitNavigator alloc] init];
  }
  return splitNavigator;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init {
  if (self = [super init]) {
    _navigators = [[NSArray alloc] initWithObjects:
                   [[[TTNavigator alloc] init] autorelease],
                   [[[TTNavigator alloc] init] autorelease],
                   nil];
    for (NSInteger ix = TTNavigatorSplitViewBegin; ix < TTNavigatorSplitViewEnd; ++ix) {
      TTNavigator* navigator = [_navigators objectAtIndex:ix];
      navigator.window = self.window;
      navigator.uniquePrefix = [NSString stringWithFormat:@"TTSplitNavigator%d", ix];
    }
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
  TT_RELEASE_SAFELY(_navigators);
  TT_RELEASE_SAFELY(_rootViewController);
  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public methods


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (TTNavigator*) navigatorAtIndex:(TTNavigatorSplitView)index {
  TTDASSERT(index >= 0 && index <= 1);
  return [_navigators objectAtIndex:index];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (UIWindow*) window {
  if (nil == _window) {
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    if (nil != keyWindow) {
      _window = [keyWindow retain];

    } else {
      _window = [[TTSplitNavigatorWindow alloc] initWithFrame:TTScreenBounds()];
      [_window makeKeyAndVisible];
    }
  }
  return _window;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (UISplitViewController*) rootViewController {
  if (nil != _rootViewController) {
    return _rootViewController;
  }

  _rootViewController = [[UISplitViewController alloc] init];
  _rootViewController.viewControllers = [NSArray arrayWithObjects:
                                         [[[UINavigationController alloc] init] autorelease],
                                         [[[UINavigationController alloc] init] autorelease],
                                         nil];

  [self.window addSubview:_rootViewController.view];
  
  return _rootViewController;
}


@end
