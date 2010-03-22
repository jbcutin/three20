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
  TTNavigator* rightSideNavigator = [[TTSplitNavigator splitNavigator]
                                     navigatorAtIndex:TTNavigatorSplitViewRightSide];
  rightSideNavigator.persistenceMode = TTNavigatorPersistenceModeAll;
  
  TTURLMap* rightSideMap = rightSideNavigator.URLMap;

  [rightSideMap from:@"*" toViewController:[TTWebController class]];
  [rightSideMap from:kPhotoBrowserURLPath toEmptyHistoryViewController:[PhotoBrowserViewController class]];
  [rightSideMap from:kPhotoThumbnailsURLPath toEmptyHistoryViewController:[PhotoThumbnailsViewController class]];
  [rightSideMap from:kStyledViewsURLPath toEmptyHistoryViewController:[StyledViewsViewController class]];
  [rightSideMap from:kStyledLabelsURLPath toEmptyHistoryViewController:[StyledLabelsViewController class]];
  [rightSideMap from:kButtonsURLPath toEmptyHistoryViewController:[ButtonsViewController class]];
  
  
  TTNavigator* leftSideNavigator = [[TTSplitNavigator splitNavigator]
                                    navigatorAtIndex:TTNavigatorSplitViewLeftSide];
  leftSideNavigator.persistenceMode = TTNavigatorPersistenceModeNone;
  
  TTURLMap* leftSideMap = leftSideNavigator.URLMap;

  [leftSideMap from:kQuickMenuURLPath toViewController:[QuickMenuViewController class]];
  
  [[TTSplitNavigator splitNavigator]
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
