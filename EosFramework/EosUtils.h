//
//  EosUtils.h
//  EosFramework
//
//  Created by zhouzhiwei on 2018/7/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EosUtils : NSObject

+ (long)string_to_long:(NSString *)str;
+ (NSData *)convertHexStrToData:(NSString *)str;

@end
