//
//  ButtonsViewController.m
//  TTCatalogPad
//
//  Created by Jeff Verkoeyen on 2/13/10.
//  Copyright 2010 Jeff Verkoeyen Consulting. All rights reserved.
//

#import "ButtonsViewController.h"

#import "ButtonsStyleSheet.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ButtonsViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (void)layout {
  TTFlowLayout* flowLayout = [[[TTFlowLayout alloc] init] autorelease];
  flowLayout.padding = 20;
  flowLayout.spacing = 20;
  CGSize size = [flowLayout layoutSubviews:self.view.subviews forView:self.view];
  
  UIScrollView* scrollView = (UIScrollView*)self.view;
  scrollView.contentSize = CGSizeMake(scrollView.width, size.height);
}

- (void)increaseFont {
  _fontSize += 4;
  
  for (UIView* view in self.view.subviews) {
    if ([view isKindOfClass:[TTButton class]]) {
      TTButton* button = (TTButton*)view;
      button.font = [UIFont boldSystemFontOfSize:_fontSize];
      [button sizeToFit];
    }
  }
  [self layout];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
  if (self = [super init]) {
    _fontSize = 12;
    
    [TTStyleSheet setGlobalStyleSheet:[[[ButtonsStyleSheet alloc] init] autorelease]];
  }
  return self;
}

- (void)dealloc {
  [TTStyleSheet setGlobalStyleSheet:nil];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
  self.navigationItem.rightBarButtonItem
  = [[[UIBarButtonItem alloc] initWithTitle:@"Increase Font" style:UIBarButtonItemStyleBordered
                                     target:self action:@selector(increaseFont)] autorelease];
  
  UIScrollView* scrollView = [[[UIScrollView alloc] initWithFrame:TTNavigationFrame()] autorelease];
	scrollView.autoresizesSubviews = YES;
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  scrollView.backgroundColor = RGBCOLOR(216, 221, 231);
  //scrollView.backgroundColor = RGBCOLOR(119, 140, 168);
  scrollView.canCancelContentTouches = NO;
  scrollView.delaysContentTouches = NO;
  self.view = scrollView;
  
  NSArray* buttons = [NSArray arrayWithObjects:
                      [TTButton buttonWithStyle:@"toolbarButton:" title:@"Toolbar Button"],
                      [TTButton buttonWithStyle:@"toolbarRoundButton:" title:@"Round Button"],
                      [TTButton buttonWithStyle:@"toolbarBackButton:" title:@"Back Button"],
                      [TTButton buttonWithStyle:@"toolbarForwardButton:" title:@"Forward Button"],
                      
                      [TTButton buttonWithStyle:@"blackForwardButton:" title:@"Black Button"],
                      [TTButton buttonWithStyle:@"blueToolbarButton:" title:@"Blue Button"],
                      [TTButton buttonWithStyle:@"embossedButton:" title:@"Embossed Button"],
                      [TTButton buttonWithStyle:@"dropButton:" title:@"Shadow Button"],
                      nil];
  
  for (TTButton* button in buttons) {
    button.font = [UIFont boldSystemFontOfSize:_fontSize];
    [button sizeToFit];
    [scrollView addSubview:button];
  }
  
  [self layout];
}

@end

