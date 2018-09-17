//
//  EosUtils.m
//  EosFramework
//
//  Created by zhouzhiwei on 2018/7/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "EosUtils.h"

@implementation EosUtils

+ (long)string_to_long:(NSString *)str {
    if (str == NULL ) {
        return 0L;
    }
    
    NSUInteger len = str.length;
    long value = 0;
    int MAX_NAME_IDX = 12;
    for (int i = 0; i <= MAX_NAME_IDX; i++) {
        long c = 0;
        
        if( i < len && i <= MAX_NAME_IDX) c = [self char_to_symbol:[str characterAtIndex:i] ];
        
        if( i < MAX_NAME_IDX) {
            c &= 0x1f;
            c <<= 64-5*(i+1);
        }
        else {
            c &= 0x0f;
        }
        value |= c;
    }
    return value;
}

+ (Byte)char_to_symbol:(char)c{
    if( c >= 'a' && c <= 'z' )
        return (Byte)((c - 'a') + 6);
    if( c >= '1' && c <= '5' )
        return (Byte)((c - '1') + 1);
    return (Byte)0;
}

+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

@end
