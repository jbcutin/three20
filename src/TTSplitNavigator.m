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

#if defined(__IPHONE_3_2) && __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED

#import "Three20/TTNavigator.h"
#import "Three20/TTSplitNavigatorWindow.h"
#import "Three20/TTURLAction.h"

#import "Three20/TTURLMap.h"

#import "Three20/TTGlobalUINavigator.h"
#import "Three20/TTGlobalCore.h"

#import "Three20/TTCorePreprocessorMacros.h"
#import "Three20/TTDebug.h"

static TTSplitNavigator* gSplitNavigator = nil;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTSplitNavigator

@synthesize URLMap              = _URLMap;
@synthesize window              = _window;
@synthesize rootViewController  = _rootViewController;
@synthesize showPopoverButton   = _showPopoverButton;
@synthesize popoverButtonTitle  = _popoverButtonTitle;
@synthesize popoverController   = _popoverController;
@synthesize popoverButton       = _popoverButton;


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (TTSplitNavigator*)splitNavigator {
  if (nil == gSplitNavigator) {
    gSplitNavigator = [[TTSplitNavigator alloc] init];
  }
  return gSplitNavigator;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isSplitNavigatorActive {
  return nil != gSplitNavigator;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init {
  if (self = [super init]) {
    _showPopoverButton = YES;

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
  TT_RELEASE_SAFELY(_popoverButtonTitle);
  TT_RELEASE_SAFELY(_popoverController);
  TT_RELEASE_SAFELY(_popoverButton);
  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UISplitViewControllerDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) splitViewController: (UISplitViewController*)svc
      willHideViewController: (UIViewController*)aViewController
           withBarButtonItem: (UIBarButtonItem*)barButtonItem
        forPopoverController: (UIPopoverController*)pc {
  if (!_showPopoverButton) {
    return;
  }

  NSString* title = TTIsStringWithAnyText(_popoverButtonTitle)
                    ? _popoverButtonTitle
                    : [[self navigatorAtIndex:TTNavigatorSplitViewLeftSide]
                       rootViewController].title;
  // No title means this button isn't going to display at all. Consider setting popoverButtonTitle
  // if you can't guarantee that your navigation view will have a title.
  TTDASSERT(nil != title);
  barButtonItem.title = title;

  TTNavigator* rightSideNavigator = [self navigatorAtIndex:TTNavigatorSplitViewRightSide];
  UIViewController* viewController = rightSideNavigator.rootViewController;
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController* navController = (UINavigationController*)viewController;
    if ([navController.viewControllers count] == 1) {
      [navController.navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:YES];
    }

  } else {
    // Not implemented
    TTDASSERT(NO);
  }

  [barButtonItem retain];
  [_popoverButton release];
  _popoverButton = barButtonItem;
  self.popoverController = pc;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) splitViewController: (UISplitViewController*)svc
      willShowViewController: (UIViewController*)aViewController
   invalidatingBarButtonItem: (UIBarButtonItem*)barButtonItem {
  TTNavigator* rightSideNavigator = [self navigatorAtIndex:TTNavigatorSplitViewRightSide];
  UIViewController* viewController = rightSideNavigator.rootViewController;
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController* navController = (UINavigationController*)viewController;
    [navController.navigationBar.topItem setLeftBarButtonItem:nil animated:YES];

  } else {
    // Not implemented
    TTDASSERT(NO);
  }

  TT_RELEASE_SAFELY(_popoverButton);
  TT_RELEASE_SAFELY(_popoverController);
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
- (TTNavigator*)navigatorForURLPath:(NSString*)urlPath {
  TTNavigator* navigator = nil;

  for (NSInteger ix = TTNavigatorSplitViewEnd - 1; ix >= TTNavigatorSplitViewBegin; --ix) {
    TTNavigator* navigatorIter = [_navigators objectAtIndex:ix];
    if ([navigatorIter.URLMap isURLPathSupported:urlPath]) {
      navigator = navigatorIter;
      break;
    }
  }

  return navigator;
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

  if (_showPopoverButton) {
    // Currently the only thing the delegate is used for is displaying the popover.
    _rootViewController.delegate = self;
  }

  return _rootViewController;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (void) restoreViewControllersWithDefaultURLs:(NSArray*)urls {
  NSMutableArray* viewControllers = [[NSMutableArray alloc]
                                     initWithCapacity:TTNavigatorSplitViewCount];

  for (NSInteger ix = TTNavigatorSplitViewBegin; ix < TTNavigatorSplitViewEnd; ++ix) {
    TTNavigator* navigator = [_navigators objectAtIndex:ix];
    NSString* url = [urls objectAtIndex:ix];
    if (![navigator restoreViewControllers]) {
      [navigator openURLAction:[TTURLAction actionWithURLPath:url]];
    }
    [viewControllers addObject:navigator.rootViewController];
  }

  self.rootViewController.viewControllers = viewControllers;

  [self.window addSubview:self.rootViewController.view];

  TT_RELEASE_SAFELY(viewControllers);
}


@end

#endif
