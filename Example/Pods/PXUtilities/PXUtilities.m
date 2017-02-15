//
//  PXUtilities.m
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

#import "PXUtilities.h"

#import "NSString+MD5.h"

@implementation PXUtilities

+ (NSURL*)convertStringToURL:(NSString*)string
{
    if (string == nil)
    {
        return nil;
    }
    
    // find link
    static NSDataDetector * detector = nil;
    if (!detector) {
        detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL];
    }
    NSArray * matches = [detector matchesInString:string options:kNilOptions range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult * result in matches) {
        if ([result resultType] == NSTextCheckingTypeLink) {
            return [result URL];
        }
    }
    // no match found
    return nil;
}

+ (NSString*)formatDateRelativeToNow:(NSDate*)date
{
    return [PXUtilities formatDateRelativeToNow:date shortFormat:FALSE];
}

+ (NSString*)formatDateRelativeToNow:(NSDate*)date shortFormat:(BOOL)sf
{
    NSCalendar * calendar = [NSCalendar autoupdatingCurrentCalendar];

    // get years
    NSInteger yearsBetween = [[calendar components:NSCalendarUnitYear fromDate:date toDate:[NSDate date] options:0] year];
                              
    
    if (yearsBetween > 0) {
        // it's been years, say that
        if (yearsBetween == 1) {
            return sf ? NSLocalizedString(@"1y", nil) : NSLocalizedString(@"1 year ago", nil);
        }
        return [NSString stringWithFormat:sf ? NSLocalizedString(@"%dy", nil) : NSLocalizedString(@"%d years ago", nil), yearsBetween];
    }
    
    // get months
    NSInteger monthsBetween = [[calendar components:NSCalendarUnitMonth fromDate:date toDate:[NSDate date] options:0] month];

    
    if (monthsBetween > 0) {
        // it's been months, say that
        if (monthsBetween == 1) {
            return sf ? NSLocalizedString(@"1M", nil) : NSLocalizedString(@"1 month ago", nil);
        }
        return [NSString stringWithFormat:sf ? NSLocalizedString(@"%dM", nil) : NSLocalizedString(@"%d months ago", nil), monthsBetween];
    }
    
    // get weeks
    NSInteger daysBetween = [[calendar components:NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:0] day];
    
    if (daysBetween > 7) {
        // it's been weeks, say that
        if (daysBetween / 7 == 1) {
            return sf ? NSLocalizedString(@"1w", nil) : NSLocalizedString(@"1 week ago", nil);
        }
        return [NSString stringWithFormat:sf ? NSLocalizedString(@"%dw", nil) : NSLocalizedString(@"%d weeks ago", nil), daysBetween / 7];
    }
    
    // get days
    if (daysBetween > 0) {
        // it's been DAYS, say that
        if (daysBetween == 1) {
            return sf ? NSLocalizedString(@"1d", nil) : NSLocalizedString(@"1 day ago", nil);
        }
        return [NSString stringWithFormat:sf ? NSLocalizedString(@"%dd", nil) : NSLocalizedString(@"%d days ago", nil), daysBetween];
    }
    
    // get hours
    NSInteger hoursBetween = [[calendar components:NSCalendarUnitHour fromDate:date toDate:[NSDate date] options:0] hour];

    
    if (hoursBetween > 0) {
        // it's been hours, say that
        if (hoursBetween == 1) {
            return sf ? NSLocalizedString(@"1h", nil) : NSLocalizedString(@"1 hour ago", nil);
        }
        return [NSString stringWithFormat:sf ? NSLocalizedString(@"%dh", nil) : NSLocalizedString(@"%d hours ago", nil), hoursBetween];
    }
    
    // get minutes
    NSInteger minutesBetween = [[calendar components:NSCalendarUnitMinute fromDate:date toDate:[NSDate date] options:0] minute];


    if (minutesBetween > 0) {
        // it's been hours, say that
        if (minutesBetween == 1) {
            return sf ? NSLocalizedString(@"1m", nil) : NSLocalizedString(@"1 minute ago", nil);
        }
        return [NSString stringWithFormat:sf ? NSLocalizedString(@"%dm", nil) : NSLocalizedString(@"%d minutes ago", nil), minutesBetween];
    }
    
    return sf ? NSLocalizedString(@"now", nil) : NSLocalizedString(@"just now", nil);
}

+ (NSURL*)gravatarURLForEmail:(NSString*)email
{
    NSString *gravatarPath = [NSString stringWithFormat:@"http://gravatar.com/avatar/%@?&default=retro", [email md5string]];
    
    return [NSURL URLWithString:gravatarPath];
}

@end
