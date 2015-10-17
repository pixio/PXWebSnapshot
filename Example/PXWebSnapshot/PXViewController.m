//
//  PXViewController.m
//  PXWebSnapshot
//
//  Created by Daniel Blakemore on 05/01/2015.
//  Copyright (c) 2014 Daniel Blakemore. All rights reserved.
//

#import "PXView.h"
#import "PXViewController.h"
#import <PXWebSnapshot/PXWebSnapshot.h>

@interface PXViewController () <UITextFieldDelegate>

@end

@implementation PXViewController

- (PXView*)contentView
{
    return (PXView*)[self view];
}

- (void)loadView
{
    [self setView:[[PXView alloc] init]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    PXWebSnapshot* snapshot = [PXWebSnapshot sharedSnapshotter];
    CGSize size = [[self contentView] snapshotImageView].bounds.size;    
    [snapshot snapshotURLString:@"pixio.com" withSize:size completion:^(UIImage *image, NSString *url, NSString *pageTitle) {
        [[[self contentView] snapshotImageView] setImage:image];
        [[[self contentView] activityIndicatorView] removeFromSuperview];
        
        [[[self contentView] urlLoadButton] setUserInteractionEnabled:TRUE];
        [[[self contentView] urlLoadButton] setAlpha:1.f];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setTitle:@"PX Web Snapshot"];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    // Set the textfield delegate
    [[[self contentView] urlTextField] setDelegate:self];
    
    // Setup button
    [[[self contentView] urlLoadButton] addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [[[self contentView] urlLoadButton] setUserInteractionEnabled:FALSE];
    [[[self contentView] urlLoadButton] setAlpha:0.5f];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard
{
    [[self contentView] endEditing:TRUE];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self click];
}

- (BOOL)click
{
    NSString* url = [[self contentView] urlTextField].text;
    if (![url containsString:@".com"] && ![url containsString:@".net"]) {
        return NO;
    }

    [self hideKeyboard];
    [[[self contentView] urlLoadButton] setUserInteractionEnabled:FALSE];
    [[[self contentView] urlLoadButton] setAlpha:0.5f];
    
    [[self contentView] addSubview:[[self contentView] activityIndicatorView]];

    PXWebSnapshot* snapshot = [PXWebSnapshot sharedSnapshotter];
    [snapshot snapshotURLString:url withSize:[[self contentView] snapshotImageView].bounds.size completion:^(UIImage *image, NSString *url, NSString *pageTitle) {
        [[[self contentView] snapshotImageView] setImage:image];
        [[[self contentView] activityIndicatorView] removeFromSuperview];
        
        [[[self contentView] urlLoadButton] setUserInteractionEnabled:TRUE];
        [[[self contentView] urlLoadButton] setAlpha:1.f];
    }];
    
    [[self contentView] setNeedsUpdateConstraints];
    
    return YES;
}

@end
