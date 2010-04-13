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

#import "Three20/TTNavigator.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 30200

/**
 * Enumeration of the split view sides. For use with [TTNavigator navigatorAtIndex:]
 */
typedef enum {
  TTNavigatorSplitViewLeftSide  = 0,  // In a split view, the left-side navigator
  TTNavigatorSplitViewRightSide,      // In a split view, the right-side navigator
} TTNavigatorSplitView;

@interface TTSplitNavigator : TTNavigator <UISplitViewControllerDelegate> {
  NSArray*                tt_navigators;
  BOOL                    tt_showPopoverButton;
  NSString*               tt_popoverButtonTitle;
  UIPopoverController*    tt_popoverController;
  UIBarButtonItem*        tt_popoverButton;
}

/**
 * Whether or not to displaly the popover button when the split view controller flips to landscape
 * mode.
 *
 * @default YES
 */
@property (nonatomic,assign) BOOL showPopoverButton;

/**
 * The title of the popover button. If not specified, uses the title of the left-side controller.
 *
 * @default nil
 */
@property (nonatomic,copy) NSString* popoverButtonTitle;

@property (nonatomic,retain) UIPopoverController* popoverController;
@property (nonatomic,retain) UIBarButtonItem* popoverButton;

@end

#endif
