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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TTNavigator;

/**
 * An internal implementation of the UIWindow object that provides a custom addSubview method.
 */
@interface TTNavigatorWindow : UIWindow {
  UIViewController*  tt_rootViewController;
}

/**
 * The controller that is at the root of the view controller hierarchy, always a split view
 * controller.
 */
@property (nonatomic,retain) UIViewController* rootViewController;

@end
