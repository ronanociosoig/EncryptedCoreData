//
//  KeyGenerator.m
//  EncryptedCoreDataSample
//
//  Created by Ronan O Ciosoig on 04/06/2013.
//  Copyright (c) 2013 Mobile Genius LLC.
//
//
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <CommonCrypto/CommonDigest.h>
#import "KeyGenerator.h"
#import "KeychainWrapper.h"

@interface KeyGenerator()

+ (NSString*) generateUUID;
+ (NSString*) MD5HexDigest:(NSString*)input;
+ (NSInteger) hexLetterToDecimal: (NSString*) letter;
+ (NSString*) reOrderString: (NSString*) source withIndex: (int) index;

@end

@implementation KeyGenerator

#define MAX_LEN 8
static const NSString *randomString = @"ag0b!fb%vsstynsSbHYMERs5&34y";


+ (NSString*) key
{
    NSString *uuid = [KeychainWrapper deviceId];
    if (uuid == nil) {
        uuid = [KeyGenerator generateUUID];
        [KeychainWrapper saveDeviceId:uuid];
    }
    
    NSDate *date = [KeychainWrapper referenceDate];
    if (date == nil) {
        date = [NSDate date];
        [KeychainWrapper saveReferenceDate:date];
    }
    
    NSString *dateString = [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    
    NSString *filteredUUID = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *last = [filteredUUID substringFromIndex:([filteredUUID length] - 1)];
    const char *lastChar = [last cStringUsingEncoding:NSASCIIStringEncoding];
    int x = (int)*lastChar;
    
    NSInteger intFromHex = [self hexLetterToDecimal:last];
    
    // repeat a few times
    NSString *combined = [NSString stringWithFormat:@"%@%@%@",filteredUUID, dateString, randomString];
    NSString *reorderedString = [KeyGenerator reOrderString:combined withIndex:x];
    NSString *reorderedString2 = [KeyGenerator reOrderString:reorderedString withIndex:intFromHex];
    NSString *reorderedString3 = [KeyGenerator reOrderString:reorderedString2 withIndex:x];
    NSString *reorderedString4 = [KeyGenerator reOrderString:reorderedString3 withIndex:x];
    return [KeyGenerator MD5HexDigest:reorderedString4];
}

+ (NSString*) generateUUID
{
    CFUUIDRef uid   = CFUUIDCreate(NULL);
    CFStringRef ref = CFUUIDCreateString(NULL, uid);
    CFRelease(uid);
    NSString *uuid = (__bridge NSString*)ref;
    CFRelease(ref);
    return uuid;
}

+ (NSString*) MD5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

+ (NSInteger) hexLetterToDecimal: (NSString*) letter
{
    if ([letter isEqualToString:@"a"]) {
        return 10;
    } else if([letter isEqualToString:@"b"]) {
        return 11;
    } else if([letter isEqualToString:@"c"]) {
        return 12;
    } else if([letter isEqualToString:@"d"]) {
        return 13;
    } else if([letter isEqualToString:@"e"]) {
        return 14;
    } else if([letter isEqualToString:@"f"]) {
        return 15;
    }
    // or it is a number.
    return [letter intValue];
}

+ (NSString*) reOrderString: (NSString*) source withIndex: (int) index
{
    NSString *retVal = nil;
    @autoreleasepool {
        NSMutableString *newString = [NSMutableString new];
        NSMutableString *buffer = [NSMutableString new];
        int sortIndex = index % MAX_LEN;
        if (sortIndex == 0) {
            sortIndex = MAX_LEN;
        }
        
        // if the index == 1 or the string length is not sufficient, then just return the
        // original string.
        if (sortIndex == 1 || [source length] < (sortIndex * 2)) {
            return source;
        }
        
        for (int i=0; i<[source length]; i++) {
            
            [buffer appendString:[source substringWithRange:NSMakeRange(i, 1)]];
            
            if (i % (sortIndex * 2) == 0) {
                int len = [buffer length];
                while (len > 0) {
                    [newString appendString:[NSString stringWithFormat:@"%C", [buffer characterAtIndex:--len]]];
                }
                
                [buffer replaceCharactersInRange:NSMakeRange(0, [buffer length]) withString:@""];
            }
        }
        
        if ([buffer length] > 0) {
            [newString appendString:buffer];
        }
        retVal = [NSString stringWithString:newString];
    }

    return retVal;
}

@end
