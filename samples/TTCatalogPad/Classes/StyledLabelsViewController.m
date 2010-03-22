//
//  StyledLabelsViewController.m
//  TTCatalogPad
//
//  Created by Jeff Verkoeyen on 2/13/10.
//  Copyright 2010 Jeff Verkoeyen Consulting. All rights reserved.
//

#import "StyledLabelsViewController.h"

#import "StyledLabelsStyleSheet.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation StyledLabelsViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
  if (self = [super init]) {
    [TTStyleSheet setGlobalStyleSheet:[[[StyledLabelsStyleSheet alloc] init] autorelease]];
  }
  return self;
}

- (void)dealloc {
  [TTStyleSheet setGlobalStyleSheet:nil];
  TT_RELEASE_SAFELY(_label1);
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
  [super loadView];
  
  //  NSString* kText = @"\
  //<span>Thisisareallylongwordthatshouldwrapisareallylongwordthatshouldwrapisareallylongwordthatshould\
  //wrapisareallylongwordthatshouldwrapisareallylongwordthatshouldwrap</span>";
  NSString* kText = @"This is a test of styled labels.  Styled labels support "
  @"<b>bold text</b>, <i>italic text</i>, <span class=\"blueText\">colored text</span>, "
  @"<span class=\"largeText\">font sizes</span>, "
  @"<span class=\"blueBox\">spans with backgrounds</span>, inline images "
  @"<img src=\"bundle://smiley.png\"/>, and <a href=\"http://www.google.com\">hyperlinks</a> you can "
  @"actually touch. URLs are automatically converted into links, like this: http://www.foo.com"
  @"<div>You can enclose blocks within an HTML div.</div>"
  @"Both line break characters\n\nand HTML line breaks<br/>are respected.";
  //  NSString* kText = @"\
  //<span class=\"largeText\">font sizes</span>a";
  //  NSString* kText = @"<span class=\"largeText\">bah</span><span class=\"inlineBox\">hyper links</span>";
  //  NSString* kText = @"blah blah blah black sheep blah <span class=\"inlineBox\">\
  //<img src=\"bundle://smiley.png\"/>hyperlinks</span> blah fun";
  //  NSString* kText = @"\
  //<div class=\"inlineBox\"><div class=\"inlineBox2\">You can enclose blocks within an HTML div.</div></div>";
  //  NSString* kText = @"\
  //<span class=\"inlineBox\"><span class=\"inlineBox2\">You can enclose blocks within an HTML div.</span></span>x";
  //  NSString* kText = @"<b>bold text</b> <span class=\"largeText\">font http://foo.com sizes</span>";
  //  NSString* kText = @"<a href=\"x\"><img src=\"bundle://smiley.png\"/></a> This is some text";
  //  NSString* kText = @"\
  //<img src=\"bundle://smiley.png\" class=\"floated\" width=\"50\" height=\"50\"/>This \
  //is a test of floats. This is still a test of floats.  This text will wrap itself around \
  //the image that is being floated on the left.  I repeat, this is a test of floats.";
  //  NSString* kText = @"\
  //<span class=\"floated\"><img src=\"bundle://smiley.png\" width=\"50\" height=\"50\"/></span>This \
  //is a test of floats. This is still a test of floats.  This text will wrap itself around \
  //the image that is being floated on the left.  I repeat, this is a test of floats.";
  //  NSString* kText = @"\
  //<a>Bob Bobbers</a> <span class=\"smallText\">at 4:30 pm</span><br>Testing";
  
  // XXXjoe This illustrates the need to calculate a line's descender height as well @1079
  // NSString* kText = @"<span class=\"largeText\">bah</span> <span class=\"smallText\">humbug</span>";
  
  _label1 = [[TTStyledTextLabel alloc] initWithFrame:self.view.bounds];
  _label1.font = [UIFont systemFontOfSize:17];
  _label1.text = [TTStyledText textFromXHTML:kText lineBreaks:YES URLs:YES navigator:self.responsibleNavigator];
  _label1.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
  //label1.backgroundColor = [UIColor grayColor];
  [_label1 sizeToFit];
  [self.view addSubview:_label1];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _label1.frame = self.view.bounds;
  [_label1 sizeToFit];
}


@end

