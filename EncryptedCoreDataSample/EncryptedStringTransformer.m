//
// From the book Pro Core Data for iOS, 2nd Edition
// Michael Privat and Rob Warner
// Published by Apress, 2011
// Source released under the Eclipse Public License
// http://www.eclipse.org/legal/epl-v10.html
// 
// Contact information:
// Michael: @michaelprivat -- http://michaelprivat.com -- mprivat@mac.com
// Rob: @hoop33 -- http://grailbox.com -- rwarner@grailbox.com
//

#import "EncryptedStringTransformer.h"
#import "NSData+Encryption.h"
#import "AppUser.h"

@interface EncryptedStringTransformer()
{
    AppUser *appUser;
}

@end

@implementation EncryptedStringTransformer

+ (Class)transformedValueClass 
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation 
{
    return YES;
}

- (id)transformedValue:(id)value 
{
    if (value == nil)
        return nil;
    
    NSData *clearData = [value dataUsingEncoding:NSUTF8StringEncoding];
    return [clearData encryptWithKey:[[AppUser sharedAppUser] access]];
}

- (id)reverseTransformedValue:(id)value 
{
    if (value == nil)
        return nil;
    
    NSData *data = [value decryptWithKey:[[AppUser sharedAppUser] access]];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
