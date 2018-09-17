//
//  EosEncode.m
//  EosFramework
//
//  Created by zhouzhiwei on 2018/7/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "EosEncode.h"
#include "sha2.h"
#include "uECC.h"
#include "libbase58.h"
#include "rmd160.h"
#include <errno.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

@implementation EosEncode

+ (NSData*)getRandomBytesDataWithWif:(NSString *)wif{
    if (!(wif.length > 0)) {
        NSLog(@"parameter wif can't be nil!");
        return nil;
    }
    const char *b58 = [wif UTF8String];
    unsigned char bin[100];
    size_t binlen=37;
    b58tobin(bin, &binlen, b58, strlen(b58));
    if (bin[0] != 0x80) {
        NSLog(@"parameter wif header bytes validate failed!");
        return nil;
    }
    unsigned char hexChar[33]; // getRandomHexBytes[33]
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
        return nil;
    }
    NSData *data = [NSData dataWithBytes:hexChar length:32];
    return data;
}

/**
 wif_with_random_bytes_data
 @param random_bytesData random_bytesData
 @return wif
 */
+ (NSString *)wif_with_random_bytes_data:(NSData *)random_bytesData{
    const char *privateKey = [random_bytesData bytes];
    //    memcpy(str, privateKey, 32);
    unsigned char result[37];
    result[0] = 0x80;
    unsigned char digest[32];
    int len;
    char wif[100];
    memcpy(result + 1 , privateKey, 32);
    sha256_Raw(result, 33, digest);
    sha256_Raw(digest, 32, digest);
    memcpy(result+33, digest, 4);
    b58enc(wif, &len, result,37);
    return [NSString stringWithUTF8String:wif];
}


/**
 eos_publicKey_with_wif
 
 @param wif wif
 @return eos_publicKey
 */
+ (NSString *)eos_publicKey_with_wif:(NSString *)wif{
    unsigned char pri[32];
    const char *baprik = [wif UTF8String];
    unsigned char result[37];
    unsigned char digest[32];
    char base[100];
    unsigned char *hash;
    size_t len = 100;
    size_t klen = 37;
    
    uint8_t pub[64];
    uint8_t cpub[33];
    
    if (b58tobin(result, &klen, baprik, wif.length)) {
        printf("success\n");
    }
    
    memcpy(pri, result+1, 32);
    
    uECC_compute_public_key(pri, pub);
    
    result[0] = 0x80;
    memcpy(result+1, pri, 32);
    sha256_Raw(result, 33, digest);
    sha256_Raw(digest, 32, digest);
    memcpy(result+33, digest, 4);
    b58enc(base, &len, result, 37);
    
    uECC_compress(pub, cpub);
    hash = RMD(cpub, 33);
    memcpy(result, cpub, 33);
    memcpy(result+33, hash, 4);
    b58enc(base, &len, result, 37);
    
    NSString *eosPubKey = [NSString stringWithFormat:@"EOS%@", [NSString stringWithUTF8String:base]];
    return eosPubKey;
}

/**
 encode uecc_publicKey --> eos_PublicKey
 @param uecc_publicKey_bytes_data uecc_publicKey_bytes_data
 @return eos_PublicKey
 */
+ (NSString *)encode_eos_PublicKey_with_uecc_publicKey_bytes_data:(NSData *)uecc_publicKey_bytes_data{
    uint8_t pub = [uecc_publicKey_bytes_data bytes];
    uint8_t cpub[33];
    char *hash;
    unsigned char reslt[37];
    char base[100];
    int len;
    uECC_compress(pub,cpub);
    hash = RMD(cpub, 33);
    memcpy(reslt, cpub, 33);
    memcpy(reslt+33, hash, 4);
    b58enc(base, &len, reslt,37);
    return [NSString stringWithFormat:@"EOS%@", [NSString stringWithUTF8String:base]];;
}

/**
 decode eos_PublicKey --> uecc_publicKey_bytes_data
 @param eos_publicKey uecc_publicKey_bytes_data
 @return uecc_publicKey_bytes_data
 */
+ (NSData *)decode_eos_publicKey:(NSString *)eos_publicKey{
    if (!(eos_publicKey.length > 0)) {
        NSLog(@"parameter eos_publicKey can't be nil!");
        return nil;
    }
    if (![eos_publicKey hasPrefix:@"EOS"]) {
        NSLog(@"parameter eos_publicKey has not prefix 'EOS'!");
        return nil;
    }
    const char *b58 = [[eos_publicKey substringFromIndex:3] UTF8String];
    unsigned char bin[100];
    size_t binlen = 37;
    unsigned char *hash;
    
    unsigned char checkValue[33];
    unsigned char validateHash[4];
    uint8_t pub[64];
    b58tobin(bin, &binlen, b58, strlen(b58));
    
    
    memcpy(checkValue, bin, 33 );
    memcpy(validateHash, bin+33, 4);
    
    
    hash = RMD(checkValue, 33);
    
    
    for(int i=0;i<4;i++){
        if(validateHash[i]!=hash[i]){
            NSLog(@"parameter eos_publicKey validate failed!");
            return nil;
        }
    }
    
    uECC_decompress(checkValue, pub);
    
    return [NSData dataWithBytes:pub length:sizeof(pub)];
}

+ (void)getEosKeys:(void (^)(NSString *, NSString *))keys {
    
    NSString *eos_private_key;
    NSString *eos_public_key;
    
    unsigned char str[32+1];
    for (int i = 0; i < 32; i += 2)
    {
        sprintf(&str[i], "%02X", arc4random() % 255);
    }
    
    //将私钥编码成wif格式
    unsigned char result[37];
    result[0] = 0x80;
    unsigned char degist[32];
    int len;
    char base[100];
    memcpy(result + 1 , str, 32);
    sha256_Raw(result, 33, degist);
    sha256_Raw(degist, 32, degist);
    memcpy(result+33, degist, 4);
    b58enc(base, &len, result,37);
    eos_private_key = [NSString stringWithUTF8String:base];
    
    uint8_t pub[64];
    uint8_t cpub[33];
    char *hash;
    // 生成公钥
    uECC_compute_public_key(str,pub);
    //
    //        printf("uECC_compute_public_key:\n");
    //        [NSObject out_Hex:pub andLength:64];
    
    //编码公钥
    uECC_compress(pub,cpub);
    hash = RMD(cpub, 33);
    memcpy(result, cpub, 33);
    memcpy(result+33, hash, 4);
    b58enc(base, &len, result,37);
    eos_public_key = [NSString stringWithFormat:@"EOS%@", [NSString stringWithUTF8String:base]];
    
    if (keys) {
        keys(eos_private_key,eos_public_key);
    }
}

@end
