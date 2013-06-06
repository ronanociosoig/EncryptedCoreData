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

#import <CommonCrypto/CommonCryptor.h>
#import "NSData+Encryption.h"

@implementation NSData (Encryption)

- (NSData *)transpose:(NSString *)_key forOperation:(int)operation
{
    // Make sure the key is big enough or else add zeros
    char key[kCCKeySizeAES256+1];
    bzero(key, sizeof(key));
    
	// Populate the key into the character array
	[_key getCString:key maxLength:sizeof(key) encoding:NSUTF8StringEncoding];
	
	size_t allocatedSize = self.length + kCCBlockSizeAES128;
	void *output = malloc(allocatedSize);
	
	size_t actualSize = 0;
    CCCryptorStatus resultCode = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                         key, kCCKeySizeAES256, nil,
                                         self.bytes, self.length,
                                         output, allocatedSize, &actualSize);
    if (resultCode != kCCSuccess)
    {
        // Free the output buffer
        free(output);
        return nil;
    }
    
    return [NSData dataWithBytesNoCopy:output length:actualSize];
}

- (NSData *)encryptWithKey:(NSString *)key
{
    return [self transpose:key forOperation:kCCEncrypt];
}

- (NSData *)decryptWithKey:(NSString *)key
{
    return [self transpose:key forOperation:kCCDecrypt];
}

@end
