//
//  EosSignature.m
//  EosFramework
//
//  Created by zhouzhiwei on 2018/7/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "EosSignature.h"
#import "EosByteWriter.h"
#import "uECC.h"
#import "rmd160.h"
#import "libbase58.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface EosSign ()
@end

@implementation EosSign

- (instancetype)initWithData:(NSData *)bytesData
{
    self = [super init];
    if (self) {
        
        uint8_t digest[CC_SHA256_DIGEST_LENGTH];
        CC_SHA256(bytesData.bytes, (CC_LONG)bytesData.length, digest);
        _mHashBytesData = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
        
        NSMutableString* outputSha256_Digest = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
        
        for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++){
            [outputSha256_Digest appendFormat:@"%02x", digest[i]];
        }
        _sha256 = outputSha256_Digest;
    }
    return self;
}

@end

@implementation EosSignature

+ (NSString *)initWithbytesForSignature:(NSData *)bytesForSignature privateKey:(int8_t *)privateKey{
    return [self getSignatureStr:bytesForSignature privateKey:privateKey];
}

+ (NSString *)getSignatureStr:(NSData *)bytesForSignature privateKey:(int8_t *)privateKey {
    EosSign *signatur = [[EosSign alloc] initWithData:bytesForSignature];
    int8_t signature[uECC_BYTES*2];
    int recId = uECC_sign_forbc(privateKey, signatur.mHashBytesData.bytes, signature);
    if (recId == -1 ) {
        printf("could not find recid. Was this data signed with this key?\n");
    }else{
        unsigned char bin[65+4] = { 0 };
        unsigned char *rmdhash = NULL;
        int binlen = 65+4;
        int headerBytes = recId + 27 + 4;
        bin[0] = (unsigned char)headerBytes;
        memcpy(bin + 1, signature, uECC_BYTES * 2);
        
        unsigned char temp[67] = { 0 };
        memcpy(temp, bin, 65);
        memcpy(temp + 65, "K1", 2);
        
        rmdhash = RMD(temp, 67);
        memcpy(bin + 1 +  uECC_BYTES * 2, rmdhash, 4);
        
        char sigbin[100] = { 0 };
        size_t sigbinlen = 100;
        b58enc(sigbin, &sigbinlen, bin, binlen);
        
        return [NSString stringWithFormat:@"SIG_K1_%@", [NSString stringWithUTF8String:sigbin]];
    }
    
    return nil;
}

@end
