//
//  PXUtilities.h
//
//  Created by Daniel Blakemore on 5/12/14.
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
 *  A small collection of useful functions that didn't really belong anywhere else.
 */
@interface PXUtilities : NSObject

/**
 *  Use a data detector to build an @c NSURL from an @c NSString presumably containing a URL-looking thing.
 *
 *  @param string the string to convert to a URL
 *
 *  @return an @c NSURL for the url that was in the string or @c nil if there wasn't a URL in the string
 */
+ (NSURL*)convertStringToURL:(NSString*)string;

/**
 *  Formats a date into a string relative to now: "5 minutes ago", "10 years ago", "just now", etc..
 *
 *  @param date        the date to format
 *
 *  @return a string indicating how long ago the date specified is relative to now.
 */
+ (NSString*)formatDateRelativeToNow:(NSDate*)date;

/**
 *  Formats a date into a string relative to now: "5 minutes ago" or "5m", "10 years ago" or "10y", "now" or "just now", etc..
 *
 *  @param date        the date to format
 *  @param shortFormat whether or not to use the abbreviated version of the format (5 minutes ago vs 5m)
 *
 *  @return a string indicating how long ago the date specified is relative to now.
 */
+ (NSString*)formatDateRelativeToNow:(NSDate*)date shortFormat:(BOOL)shortFormat;

/**
 *  Generates a URL for a gravatar for a given email.
 *
 *  @param email the email address as a string
 *
 *  @return the gravatar URL for that email.
 */
+ (NSURL*)gravatarURLForEmail:(NSString*)email;

@end
