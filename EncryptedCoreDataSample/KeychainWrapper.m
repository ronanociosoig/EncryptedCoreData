//
//  KeychainWrapper.m
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


#import "KeychainWrapper.h"
#import "SSKeychain.h"

#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"]
#define DATE_FORMAT @"YYYY-MM-dd HH:mm:ss"


@implementation KeychainWrapper

+ (NSString*) deviceId;
{
    return [SSKeychain passwordForService:APP_NAME account:APP_NAME];
}

+ (void) saveDeviceId: (NSString*) UUID
{
    [SSKeychain setPassword:UUID forService:APP_NAME account:APP_NAME];
}

+ (NSDate*) referenceDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT];
    NSString *dateString = [SSKeychain passwordForService:APP_NAME account:APP_NAME];
    return [formatter dateFromString:dateString];
}

+ (void) saveReferenceDate: (NSDate*) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT];
    NSString *dateString = [formatter stringFromDate:date];
    [SSKeychain setPassword:dateString forService:APP_NAME account:APP_NAME];
}

@end
