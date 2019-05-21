//
//  DateTools.m
//  NanGuaDianYing
//
//  Created by 刘浩 on 2018/3/23.
//  Copyright © 2018年 穷极一生做不完一场梦 - 远子. All rights reserved.
//

#import "DateTools.h"
static long long offSet = 0;
@implementation DateTools

+ (void)verifyServerTimestamp:(NSString *)serverStamp{
    offSet =0;
    if(serverStamp==nil || serverStamp.length ==0){
//        NSLog(@"=======liuhao=======> server is null ");
        return;
    }
    
    long long serverTS=[serverStamp longLongValue];
    long long localTS = [[NSDate date]timeIntervalSince1970]*1000;
    
    offSet = serverTS-localTS;
//    NSLog(@"=======liuhao=======> offset: %llu",offSet);
//    NSLog(@"=======liuhao=======> locatTime :%@",[self longlongToNSStringTime:[self getLocalTimestamp]]);
//    NSLog(@"=======liuhao=======> serverTime:%@",[self longlongToNSStringTime:[self getVerifyServerTimestamp]]);
    
}

+ (long long)getVerifyServerTimestamp{
    long long localTS = [[NSDate date]timeIntervalSince1970]*1000;
//    NSLog(@"=======liuhao=======> offset: %llu",offSet);
    long long serverTS = localTS+offSet;
    return serverTS;
}

+ (long long)getLocalTimestamp{
    long long localTS = [[NSDate date]timeIntervalSince1970]*1000;
    return localTS;
}

+ (NSString *)ConvertTimeStampStrToNstringTime:(NSString *)timeStr
{
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
}

+ (NSString *)longlongToNSStringTime:(long long)time
{
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
    
}

+ (NSString *)longlongToNSStringTime:(long long)timeStr formate:(NSString *)formate
{
    long long time=timeStr;
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:formate];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
    
}

+ (long long)NSStringTimeTolonglong:(NSString *)timeStr formate:(NSString *)formatStr
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatStr];
    
    NSDate *date = [format dateFromString:timeStr];
    return [date timeIntervalSince1970] * 1000.0;
}

+ (long long)TodayTimeStr
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
    
    return [startDate timeIntervalSince1970] * 1000.0;
}

+ (long long)TommorrowTimeStr
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    return [endDate timeIntervalSince1970] * 1000.0;
}

+ (NSString *)formatServerToHm:(NSString *)text
{
    return [self formatDate:text from:@"yy-MM-dd HH:mm:ss" toStyle:@"HH:mm"];
}

+ (NSString *)formatDate:(NSString *)text from:(NSString *)from toStyle:(NSString *)to
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:from];
    NSDate *date = [df dateFromString:text];
    
    [df setDateFormat:to];
    NSString *str= [df stringFromDate:date];
    
    return str;
}

@end

