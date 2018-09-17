//
//  NSDate+EosExt.m
//  EosFramework
//
//  Created by zhouzhiwei on 2018/7/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "NSDate+EosExt.h"

@implementation NSDate (EosExt)

+ (NSDate *)dateFromString:(NSString *)string
{
    //需要转换的字符串
    NSString *dateString = string;
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    if ([string containsString:@"."]) {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

+ (int)getTimeStampUTCWithTimeString:(NSString *)timeString{
    
    NSDate *date = [NSDate dateFromString:timeString];//format :@"2018-01-01T08:00:00"
    NSDate *date1 = [date dateByAddingTimeInterval: 8 * 60 * 60 ]; // 多加八小时
    int a = [date1 timeIntervalSince1970];
    NSLog(@"%@\n=====%@\n ====%d\n", date, date1, a);
    return a;
}

@end
