//
//  PXWebSnapshot.m
//
//  Created by Daniel Blakemore on 5/9/14.
//
//  Copyright (c) 2015 Pixio
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "PXWebSnapshot.h"

#import <PXUtilities/PXUtilities.h>
#import <UIVIew-Screenshot/UIView+Screenshot.h>

#define kPageLoadedScheme "pageloaded"

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define JS_STRING(text) @ STRINGIZE2(text)
NSString *const injectionJavascript = JS_STRING
(
 (function () {
 var script = document.createElement('script');
 script.type = 'text/javascript';
 script.text = function DOMReady() {
     document.location.href = kPageLoadedScheme + ":" + document.location.href;
 };
 if (document.readyState == "complete") {
     document.location.href = kPageLoadedScheme + ":" + document.location.href;
 }
 document.getElementsByTagName('head')[0].appendChild(script);
 document.addEventListener('load', DOMReady, false);
 })();
);

@interface PXWebSnapshot () <UIWebViewDelegate>

@end

@implementation PXWebSnapshot
{
    BOOL _javascriptInjected;
    UIWebView * _webview;
    NSDataDetector * _linkDetector;
    void(^_completion)(UIImage * image, NSString * url, NSString * pageTitle);
}

+ (instancetype)sharedSnapshotter
{
    static PXWebSnapshot * singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [PXWebSnapshot new];
    });
    return singleton;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        NSError *error = nil;
        _linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
        // should probably check error here.  Not gonna.
        
        _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        [_webview setDelegate:self];
    }
    return self;
}

- (void)snapshotURLString:(NSString*)urlString completion:(void(^)(UIImage * image, NSString * url, NSString * pageTitle))completion
{
    [self snapshotURLString:urlString withAspectRatio:(16.0f / 9.0f) completion:completion];
}

- (void)snapshotURLString:(NSString*)urlString withAspectRatio:(CGFloat)aspectRatio completion:(void(^)(UIImage * image, NSString * url, NSString * pageTitle))completion
{
    [self snapshotURLString:urlString withSize:CGSizeMake(568, 568 / aspectRatio) completion:completion];
}

- (void)snapshotURLString:(NSString*)urlString withSize:(CGSize)size completion:(void(^)(UIImage * image, NSString * url, NSString * pageTitle))completion
{
    NSURL * url = [PXUtilities convertStringToURL:urlString];
    [self snapshotURL:url withSize:size completion:completion];
}

- (void)snapshotURL:(NSURL*)url completion:(void(^)(UIImage * image, NSString * url, NSString * pageTitle))completion
{
    [self snapshotURL:url withAspectRatio:(16.0f / 9.0f) completion:completion];
}

- (void)snapshotURL:(NSURL*)url withAspectRatio:(CGFloat)aspectRatio completion:(void(^)(UIImage * image, NSString * url, NSString * pageTitle))completion
{
    [self snapshotURL:url withSize:CGSizeMake(568, 568 / aspectRatio) completion:completion];
}

- (void)snapshotURL:(NSURL*)url withSize:(CGSize)size completion:(void(^)(UIImage * image, NSString * url, NSString * pageTitle))completion
{
    // save completion for later
    __weak typeof(self) weakSelf = self;
    _completion = ^(UIImage * image, NSString * url, NSString * pageTitle) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"got snapshot");
        if (completion) {
            completion(image, url, pageTitle);
        }
        
        // clean up
        strongSelf->_webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        [strongSelf->_webview setDelegate:strongSelf];
    };
    
    NSLog(@"getting snapshot");
    
    // calculate size of webview
    CGRect webFrame = {.origin=CGPointMake(0, 0), .size=size};
    [_webview setFrame:webFrame];
    
    if (url) {
        [_webview loadRequest:[NSURLRequest requestWithURL:url]];
    } else {
        // no valid link found, make sure to clean up
        _completion(nil, nil, nil);
        _completion = nil;
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@", [request URL]);
    if([[[request URL] scheme] isEqualToString:@kPageLoadedScheme]){
        // reset state
        _javascriptInjected = NO;
        
        NSString * url = [[request URL] absoluteString];
        url = [url substringFromIndex:([[[request URL] scheme] length] + 1)];
        NSString * pageTitle = [_webview stringByEvaluatingJavaScriptFromString:@"document.title"];
        
        _completion([webView screenshot], url, pageTitle);
        _completion = nil;
        
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(!_javascriptInjected) {
        _javascriptInjected = YES;
        NSLog(@"%p finished load", [webView stringByEvaluatingJavaScriptFromString:injectionJavascript]);
        NSString * pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        
        NSString * url = [[[webView request] URL] absoluteString];
        _completion([webView screenshot], url, pageTitle);
        _completion = nil;
    } else {
        _javascriptInjected = NO;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // failed to load
    if ([error code] != -999) {
        _completion(nil, nil, nil);
        _completion = nil;
    }
}

@end
