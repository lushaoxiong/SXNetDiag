//
//  DateTools.h
//  NanGuaDianYing
//
//  Created by 刘浩 on 2018/3/23.
//  Copyright © 2018年 穷极一生做不完一场梦 - 远子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTools : NSObject

/**
 拿到服务器给的时间戳校验 本地时间
 @param serverStamp  服务器给的时间
 */
+ (void)verifyServerTimestamp:(NSString *)serverStamp;

/**
 获取服务器校验完的时间戳
 @return
 */
+(long long)getVerifyServerTimestamp;

/**
 获取本地的时间戳

 @return
 */
+(long long)getLocalTimestamp;

/**
 转换string类型

 @param timeStr 需要转化的时间戳
 @return
 */
+ (NSString *)ConvertTimeStampStrToNstringTime:(NSString *)timeStr;
+ (NSString *)longlongToNSStringTime:(long long)time;
+ (NSString *)longlongToNSStringTime:(long long)timeStr formate:(NSString *)formate;
+ (long long)NSStringTimeTolonglong:(NSString *)timeStr formate:(NSString *)formatStr;

/**
 获取今日0时时间戳
 */
+ (long long)TodayTimeStr;
/**
 获取次日0时时间戳
 */
+ (long long)TommorrowTimeStr;

/**
 格式化时间
 */
+ (NSString *)formatServerToHm:(NSString *)text;
+ (NSString *)formatDate:(NSString *)text from:(NSString *)from toStyle:(NSString *)to;

@end

