//
//  TTCatalogPadAppDelegate.m
//  TTCatalogPad
//
//  Created by Jeff Verkoeyen on 2/13/10.
//  Copyright Jeff Verkoeyen Consulting 2010. All rights reserved.
//

#import "AppDelegate.h"

// View Controllers
#import "QuickMenuViewController.h"

// Photos
#import "PhotoBrowserViewController.h"
#import "PhotoThumbnailsViewController.h"

// Styles
#import "StyledViewsViewController.h"
#import "StyledLabelsViewController.h"

// Controls
#import "ButtonsViewController.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(UIApplication *)application {
  [TTNavigator setSharedNavigatorWithRootControllerClass:[UISplitViewController class]];
  [TTNavigator navigator].rootViewController;
  
  TTNavigator* rightSideNavigator = [[TTNavigator navigator].componentNavigators
                                     objectAtIndex:TTNavigatorSplitViewRightSide];
  TTURLMap* rightSideMap = rightSideNavigator.URLMap;
  
  rightSideNavigator.persistenceMode = TTNavigatorPersistenceModeAll;
  
  [rightSideMap from:@"*" toViewController:[TTWebController class]];
  [rightSideMap from:kPhotoBrowserURLPath toEmptyHistoryViewController:[PhotoBrowserViewController class]];
  [rightSideMap from:kPhotoThumbnailsURLPath toEmptyHistoryViewController:[PhotoThumbnailsViewController class]];
  [rightSideMap from:kStyledViewsURLPath toEmptyHistoryViewController:[StyledViewsViewController class]];
  [rightSideMap from:kStyledLabelsURLPath toEmptyHistoryViewController:[StyledLabelsViewController class]];
  [rightSideMap from:kButtonsURLPath toEmptyHistoryViewController:[ButtonsViewController class]];
  
  
  TTNavigator* leftSideNavigator = [[TTNavigator navigator].componentNavigators
                                    objectAtIndex:TTNavigatorSplitViewLeftSide];
  TTURLMap* leftSideMap = leftSideNavigator.URLMap;

  leftSideNavigator.persistenceMode = TTNavigatorPersistenceModeNone;
  
  [leftSideMap from:kQuickMenuURLPath toViewController:[QuickMenuViewController class]];
  
  [[TTNavigator navigator]
   restoreViewControllersWithDefaultURLs:[NSArray arrayWithObjects:
                                          kQuickMenuURLPath,
                                          @"http://three20.info",
                                          nil]];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
  return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
  [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
  return YES;
}


@end
