//
//  PXView.h
//  PXWebSnapshot
//
//  Created by Calvin Kern on 6/22/15.
//  Copyright (c) 2015 Daniel Blakemore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXView : UIView

@property (nonatomic, readonly) UIImageView* snapshotImageView;
@property (nonatomic, readonly) UIActivityIndicatorView* activityIndicatorView;
@property (nonatomic, readonly) UITextField* urlTextField;
@property (nonatomic, readonly) UIButton* urlLoadButton;

@end
