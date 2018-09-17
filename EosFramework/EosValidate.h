//
//  EosValidate.h
//  EosFramework
//
//  Created by zhouzhiwei on 2018/7/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EosValidate : NSObject


/**
 validateWif

 @param wif wif
 @return validate
 */
+ (BOOL)validateWif:(NSString *)wif;


/**
 validateAccount

 @param account account
 @return validate
 */
+ (BOOL)validateAccount:(NSString *)account;

@end
