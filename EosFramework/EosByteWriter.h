//
//  EosByteWriter.h
//  EosFramework
//
//  Created by zhouzhiwei on 2018/7/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EosByteWriter : NSObject


/**
 getBytesForSignature

 @param chainId chainId
 @param paramsDic paramsDic
 @param capacity capacity
 @return datebytes
 */
+ (NSData *)getBytesForSignature:(NSData *)chainId andParams:(NSDictionary *)paramsDic andCapacity:(int)capacity;

@end
