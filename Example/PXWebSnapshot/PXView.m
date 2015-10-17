//
//  PXView.m
//  PXWebSnapshot
//
//  Created by Calvin Kern on 6/22/15.
//  Copyright (c) 2015 Daniel Blakemore. All rights reserved.
//

#import "PXView.h"

@implementation PXView
{
    NSMutableArray* _constraints;
        
    UIView* _lSpace,* _tSpace,* _rSpace,* _bSpace;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }

    _constraints = [NSMutableArray array];
    
    [self addSpaces];
    
    _snapshotImageView = [[UIImageView alloc] init];
    [_snapshotImageView setTranslatesAutoresizingMaskIntoConstraints:FALSE];
    [_snapshotImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:_snapshotImageView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:FALSE];
    [_activityIndicatorView setFrame:CGRectMake(140, 236, 37, 37)];
    [_activityIndicatorView startAnimating];
    [self addSubview:_activityIndicatorView];

    _urlTextField = [[UITextField alloc] init];
    [_urlTextField setTranslatesAutoresizingMaskIntoConstraints:FALSE];
    [_urlTextField setPlaceholder:@" url"];
    [_urlTextField setBackgroundColor:[UIColor whiteColor]];
    [_urlTextField setKeyboardType:UIKeyboardTypeURL];
    [_urlTextField setReturnKeyType:UIReturnKeyGo];
    [self addSubview:_urlTextField];
    
    _urlLoadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_urlLoadButton setTranslatesAutoresizingMaskIntoConstraints:FALSE];
    [_urlLoadButton setTitle:@"Load" forState:UIControlStateNormal];
    [_urlLoadButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_urlLoadButton setBackgroundColor:[UIColor colorWithRed:0.333f green:0.937f blue:0.796f alpha:1.f]]; // Aquaish
    [self addSubview:_urlLoadButton];
    
    [self setNeedsUpdateConstraints];
    
    return self;
}

- (void)updateConstraints
{
    [self removeConstraints:_constraints];
    [_constraints removeAllObjects];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_snapshotImageView, _activityIndicatorView, _urlTextField, _urlLoadButton, _lSpace, _tSpace, _rSpace, _bSpace);
    NSDictionary* metrics = @{@"sp":@10, @"lsp":@20, @"bw":@60};
    
    // Snapshot Image View
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sp-[_snapshotImageView]-sp-|" options:0 metrics:metrics views:views]];

    // Activity Indicator View
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_lSpace(_rSpace)][_activityIndicatorView][_rSpace]|" options:0 metrics:metrics views:views]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tSpace(_bSpace)][_activityIndicatorView][_bSpace]|" options:0 metrics:metrics views:views]];

    // URL Load views
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-lsp-[_urlTextField]-sp-[_urlLoadButton(bw)]-lsp-|" options:0 metrics:metrics views:views]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-sp-[_urlTextField]-sp-[_snapshotImageView]-sp-|" options:0 metrics:metrics views:views]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_urlLoadButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_urlTextField attribute:NSLayoutAttributeHeight multiplier:1.f constant:0.f]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_urlLoadButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_urlTextField attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f]];
    
    [self addConstraints:_constraints];
    [super updateConstraints];
}

- (void)addSpaces
{
    _lSpace = [[UIView alloc] init];
    _tSpace = [[UIView alloc] init];
    _rSpace = [[UIView alloc] init];
    _bSpace = [[UIView alloc] init];

    NSArray* spaces = @[_lSpace, _tSpace, _rSpace, _bSpace];
    
    for (UIView* space in spaces) {
        [space setTranslatesAutoresizingMaskIntoConstraints:FALSE];
        [space setBackgroundColor:[UIColor clearColor]];
        [self addSubview:space];
    }
}

@end

