//
//  EosValidate.m
//  EosFramework
//
//  Created by zhouzhiwei on 2018/7/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "EosValidate.h"
#import "libbase58.h"
#import "sha2.h"

@implementation EosValidate

+ (BOOL)validateWif:(NSString *)wif {
    if (!(wif.length > 0)) {
        NSLog(@"parameter wif can't be nil!");
        return NO;
    }
    const char *b58 = [wif UTF8String];
    unsigned char bin[100];
    size_t binlen=37;
    b58tobin(bin, &binlen, b58, strlen(b58));
    if (bin[0] != 0x80) {
        NSLog(@"parameter wif header bytes validate failed!");
        return NO;
    }
    unsigned char hexChar[32]; // getRandomHexBytes[32]
    unsigned char digest[32];
    unsigned char result[32]; // Recieve randomHexByes hash result
    unsigned char last4Bytes[4];
    memcpy(hexChar, bin+1, 32);
    memcpy(last4Bytes, bin+33, 4);
    sha256_Raw(hexChar, 33, digest);
    sha256_Raw(digest, 32, digest);
    memcpy(result, digest, 4);
    if (!strcmp(result, last4Bytes) ) {
        NSLog(@"parameter wif hash validate failed!");
        return NO;
    }
    return YES;
}

+ (BOOL)validateAccount:(NSString *)account {
    NSString *verifyAccountNameRegex = @"^[a-z]{1}[1-5a-z]{11}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",verifyAccountNameRegex];
    BOOL isMatch = [predicate evaluateWithObject:account];
    if (!isMatch) {
        NSLog(@"account validate failed!");
    }
    return isMatch;
}

@end
