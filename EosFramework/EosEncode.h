//
//  EosEncode.h
//  EosFramework
//
//  Created by zhouzhiwei on 2018/7/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EosEncode : NSObject

/**
 getRandomBytesDataWithWif

 @param wif wif
 @return bytesData
 */
+ (NSData*)getRandomBytesDataWithWif:(NSString *)wif;

/**
 wif_with_random_bytes_data

 @param random_bytesData bytesData
 @return wif
 */
+ (NSString *)wif_with_random_bytes_data:(NSData *)random_bytesData;

/**
 eos_publicKey_with_wif

 @param wif wif
 @return publickKey
 */
+ (NSString *)eos_publicKey_with_wif:(NSString *)wif;



/**
 getEosKeys

 @param keys return privateKey publicKey
 */
+ (void)getEosKeys:(void(^)(NSString *privateKey,NSString *publicKey))keys;

@end
