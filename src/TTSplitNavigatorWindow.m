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

#import "Three20/TTSplitNavigatorWindow.h"

#if defined(__IPHONE_3_2) && __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED

#import "Three20/TTSplitNavigator.h"
#import "Three20/TTNavigator.h"

#import "Three20/TTDebug.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTSplitNavigatorWindow


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
  if (event.type == UIEventSubtypeMotionShake) {

    // Enumerate through the available navigator and check if they need to be reloaded.
    for (NSInteger ix = TTNavigatorSplitViewBegin; ix < TTNavigatorSplitViewEnd; ++ix) {
      TTNavigator* navigator = [[TTSplitNavigator splitNavigator] navigatorAtIndex:ix];
      if (navigator.supportsShakeToReload) {
        [navigator reload];
      }
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setController:(UIViewController *)controller forNavigator:(TTNavigator*)navigator {
  [[TTSplitNavigator splitNavigator].popoverController dismissPopoverAnimated:NO];

  NSInteger ix;
  for (ix = TTNavigatorSplitViewBegin; ix < TTNavigatorSplitViewEnd; ++ix) {
    TTNavigator* navigatorIter = [[TTSplitNavigator splitNavigator] navigatorAtIndex:ix];
    if (navigatorIter == navigator) {
      break;
    }
  }

  TTDASSERT(ix >= TTNavigatorSplitViewBegin && ix < TTNavigatorSplitViewEnd);
  if (ix >= TTNavigatorSplitViewBegin && ix < TTNavigatorSplitViewEnd) {
    // Found a valid TTNavigator index.
    UISplitViewController* splitViewController = [[TTSplitNavigator splitNavigator]
                                                  rootViewController];
    NSMutableArray* viewControllers = [splitViewController.viewControllers mutableCopy];
    [viewControllers replaceObjectAtIndex:ix withObject:controller];
    splitViewController.viewControllers = viewControllers;

    if (ix == TTNavigatorSplitViewRightSide) {
      UIViewController* viewController = [[TTSplitNavigator splitNavigator] navigatorAtIndex:ix].rootViewController;
      if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navController = (UINavigationController*)viewController;
        UINavigationItem* topItem = navController.navigationBar.topItem;
        [topItem setLeftBarButtonItem:[TTSplitNavigator splitNavigator].popoverButton animated:NO];
      }
    }
  }
}


@end

#endif
