//
//  TTSplitNavigator.m
//  Three20
//
//  Created by Sixten Otto on 4/13/10.
//  Copyright 2010 Results Direct. All rights reserved.
//

#import "Three20/TTSplitNavigator.h"
#import "Three20/TTNavigatorPrivate.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 30200

#import "Three20/TTURLAction.h"

#import "Three20/TTURLMap.h"

#import "Three20/TTGlobalUINavigator.h"
#import "Three20/TTGlobalCore.h"


@implementation TTSplitNavigator

@synthesize showPopoverButton   = tt_showPopoverButton;
@synthesize popoverButtonTitle  = tt_popoverButtonTitle;
@synthesize popoverController   = tt_popoverController;
@synthesize popoverButton       = tt_popoverButton;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init {
  if (self = [super init]) {
    NSMutableArray* navigators = [[NSMutableArray alloc] initWithCapacity:2];
    for (NSUInteger ix = 0; ix < 2; ++ix) {
      TTNavigator* navigator = [[TTNavigator alloc] init];
      navigator.parentNavigator = self;
      navigator.window = self.window;
      navigator.uniquePrefix = [NSString stringWithFormat:@"TTSplitNavigator%d", ix];
      [navigators addObject:navigator];
      [navigator release];
    }
    
    tt_navigators = navigators;
    tt_showPopoverButton = YES;
  }
  
  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
  TT_RELEASE_SAFELY(tt_navigators);
  TT_RELEASE_SAFELY(tt_popoverButtonTitle);
  TT_RELEASE_SAFELY(tt_popoverController);
  TT_RELEASE_SAFELY(tt_popoverButton);
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
  if (!tt_showPopoverButton) {
    return;
  }
  
  NSString* title = TTIsStringWithAnyText(tt_popoverButtonTitle)
                    ? tt_popoverButtonTitle
                    : [[self.componentNavigators objectAtIndex:TTNavigatorSplitViewLeftSide] rootViewController].title;
  
  // No title means this button isn't going to display at all. Consider setting popoverButtonTitle
  // if you can't guarantee that your navigation view will have a title.
  TTDASSERT(nil != title);
  barButtonItem.title = title;
  
  TTNavigator* rightSideNavigator = [self.componentNavigators objectAtIndex:TTNavigatorSplitViewRightSide];
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
  [tt_popoverButton release];
  tt_popoverButton = barButtonItem;
  self.popoverController = pc;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) splitViewController: (UISplitViewController*)svc
      willShowViewController: (UIViewController*)aViewController
   invalidatingBarButtonItem: (UIBarButtonItem*)barButtonItem {
  TTNavigator* rightSideNavigator = [self.componentNavigators objectAtIndex:TTNavigatorSplitViewRightSide];
  UIViewController* viewController = rightSideNavigator.rootViewController;
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController* navController = (UINavigationController*)viewController;
    [navController.navigationBar.topItem setLeftBarButtonItem:nil animated:YES];
    
  } else {
    // Not implemented
    TTDASSERT(NO);
  }
  
  TT_RELEASE_SAFELY(tt_popoverButton);
  TT_RELEASE_SAFELY(tt_popoverController);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public methods


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (UIViewController*) rootViewController {
  if (nil != [super rootViewController]) {
    return [super rootViewController];
  }
  
  UISplitViewController* rootViewController = [[UISplitViewController alloc] init];
  self.rootViewController = rootViewController;
  
  if (self.showPopoverButton) {
    // Currently the only thing the delegate is used for is displaying the popover.
    rootViewController.delegate = self;
  }
  
  return rootViewController;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (TTURLMap*)URLMap {
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (void) restoreViewControllersWithDefaultURLs:(NSArray*)urls {
  NSUInteger count = [self.componentNavigators count];
  NSMutableArray* viewControllers = [[NSMutableArray alloc] initWithCapacity:count];
  
  for (NSUInteger ix = 0; ix < count; ++ix) {
    TTNavigator* navigator = [self.componentNavigators objectAtIndex:ix];
    [navigator restoreViewControllersWithDefaultURL: [urls objectAtIndex:ix]];
    [viewControllers addObject:navigator.rootViewController];
  }
  
  ((UISplitViewController*)self.rootViewController).viewControllers = viewControllers;
  
  //[self.window addSubview:self.rootViewController.view];
  
  TT_RELEASE_SAFELY(viewControllers);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (NSArray*)componentNavigators {
  return tt_navigators;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (TTNavigator*)navigatorForURLPath:(NSString*)urlPath {
  for (TTNavigator* navigator in self.componentNavigators) {
    if ([navigator.URLMap isURLPathSupported:urlPath]) {
      return navigator;
    }
  }
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (void)componentNavigator:(TTNavigator*)navigator
        didDisplayNewRootController:(UIViewController*)rootViewController {
  NSUInteger ix = [self.componentNavigators indexOfObject:navigator];
  if (ix == NSNotFound) return;
  
  UISplitViewController* splitViewController = (UISplitViewController*)self.rootViewController;
  NSMutableArray* viewControllers = [splitViewController.viewControllers mutableCopy];
  [viewControllers replaceObjectAtIndex:ix withObject:rootViewController];
  splitViewController.viewControllers = viewControllers;
  
  if (ix == TTNavigatorSplitViewRightSide) {
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
      UINavigationController* navController = (UINavigationController*)rootViewController;
      UINavigationItem* topItem = navController.navigationBar.topItem;
      [topItem setLeftBarButtonItem:self.popoverButton animated:NO];
    }
  }
  
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (void)reload {
  for (TTNavigator* nav in self.componentNavigators) {
    [nav reload];
  }
}

@end

#endif
