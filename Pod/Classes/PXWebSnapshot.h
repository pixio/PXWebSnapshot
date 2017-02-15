//
//  PXWebSnapshot.h
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

#import <Foundation/Foundation.h>

/**
 *  A class for generating screenshots of webviews at a particular URL.
 */
@interface PXWebSnapshot : NSObject

/**
 *  The shared singleton of the web snapshot generator.
 *
 *  @return shared singleton of PXWebSnapshot
 */
+ (nonnull instancetype)sharedSnapshotter;

/**
 *  Get a snapshot of the website at urlString and call the specified block with the snapshot.
 *  The snapshot is taken in 16:9 aspect ratio with the longest dimmension being the 568pt wide.
 *
 *  @param urlString  a string of the url of the site to snapshot
 *  @param completion a block to call when the image is retrieved
 */
- (void)snapshotURLString:(nullable  NSString*)urlString completion:(nullable void(^)(UIImage * _Nullable image, NSString * _Nullable url, NSString * _Nullable pageTitle))completion;

/**
 *  Get a snapshot with the given aspect ratio of the website at urlString and call the specified block with the snapshot.
 *  The width of the image is fixed to 568pt (well, what should it be?).
 *
 *  @param urlString   a string of the url of the site to snapshot
 *  @param aspectRatio the desired aspect ratio of the snapshot
 *  @param completion  a block to call when the image is retrieved
 */
- (void)snapshotURLString:(nullable  NSString*)urlString withAspectRatio:(CGFloat)aspectRatio completion:(nullable void(^)(UIImage * _Nullable image, NSString * _Nullable url, NSString * _Nullable pageTitle))completion;

/**
 *  Get a snapshot with the given resolution of the website at urlString and call the specified block with the snapshot.
 *  The resolution is specified in points rather than pixels for better rendering on retina devices.
 *
 *  @param urlString  a string of the url of the site to snapshot
 *  @param size       the desired resolution of the snapshot in points.
 *  @param completion a block to call when the image is retrieved
 */
- (void)snapshotURLString:(nullable  NSString*)urlString withSize:(CGSize)size completion:(nullable void(^)(UIImage * _Nullable image, NSString * _Nullable url, NSString * _Nullable pageTitle))completion;

/**
 *  Get a snapshot of the website at urlString and call the specified block with the snapshot.
 *  The snapshot is taken in 16:9 aspect ratio with the longest dimmension being the 568pt wide.
 *
 *  @param url        the url of the site to snapshot
 *  @param completion a block to call when the image is retrieved
 */
- (void)snapshotURL:(nullable NSURL*)url completion:(nullable void(^)(UIImage * _Nullable image, NSString * _Nullable url, NSString * _Nullable pageTitle))completion;

/**
 *  Get a snapshot with the given aspect ratio of the website at urlString and call the specified block with the snapshot.
 *  The width of the image is fixed to 568pt (well, what should it be?).
 *
 *  @param url         the url of the site to snapshot
 *  @param aspectRatio the desired aspect ratio of the snapshot
 *  @param completion  a block to call when the image is retrieved
 */
- (void)snapshotURL:(nullable NSURL*)url withAspectRatio:(CGFloat)aspectRatio completion:(nullable void(^)(UIImage * _Nullable image, NSString * _Nullable url, NSString * _Nullable pageTitle))completion;

/**
 *  Get a snapshot with the given resolution of the website at urlString and call the specified block with the snapshot.
 *  The resolution is specified in points rather than pixels for better rendering on retina devices.
 *
 *  @param url        the url of the site to snapshot
 *  @param size       the desired resolution of the snapshot in points.
 *  @param completion a block to call when the image is retrieved
 */
- (void)snapshotURL:(nullable NSURL*)url withSize:(CGSize)size completion:(nullable void(^)(UIImage * _Nullable image, NSString * _Nullable url, NSString * _Nullable pageTitle))completion;

@end
