//
//  QuickMenuViewController.m
//  TTCatalogPad
//
//  Created by Jeff Verkoeyen on 2/13/10.
//  Copyright 2010 Jeff Verkoeyen Consulting. All rights reserved.
//

#import "QuickMenuViewController.h"



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation QuickMenuViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init {
  if (self = [super init]) {
    self.title = @"Quick Menu";
    //self.variableHeightRows = YES;
    self.tableViewStyle = UITableViewStyleGrouped;

    self.dataSource =
      [TTSectionedDataSource dataSourceWithObjects:
       @"Photos",
       [TTTableTextItem itemWithText:@"Photo Browser" URL:kPhotoBrowserURLPath],
       [TTTableTextItem itemWithText:@"Photo Thumbnails" URL:kPhotoThumbnailsURLPath],
       @"Styles",
       [TTTableTextItem itemWithText:@"Styled Views" URL:kStyledViewsURLPath],
       [TTTableTextItem itemWithText:@"Styled Labels" URL:kStyledLabelsURLPath],
       @"Controls",
       [TTTableTextItem itemWithText:@"Buttons" URL:kButtonsURLPath],
       nil];
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)contentSizeForViewInPopoverView {
  return CGSizeMake(320.0, 600.0);
}


@end

