//
//  GetDnsInfo.m
//  liuhao
//
//  Created by 刘浩 on 2018/2/7.
//  Copyright © 2018年 刘浩. All rights reserved.
//

#import "GetDnsInfo.h"

@implementation GetDnsInfo
#define ADDRESSIPWY @"http://nstool.netease.com/"
#define C_Start @"<br>";


+ (NSString*)getWanIPAddressWY {
    NSString *returnStr = [[NSString alloc] initWithString:@"dns error!"];
    
    
    NSMutableArray * conpfArr1 =  [self hasBeenFinishedFmPaths:nil plistName:@"appConf.plist"];
    NSString * cdn_test_tool = @"";
    for (NSDictionary * confDic1 in conpfArr1) {
        cdn_test_tool = [confDic1 objectForKey:@"cdn_test_tool"];
    }
    if (cdn_test_tool == nil || [cdn_test_tool isEqualToString:@""]) {
        cdn_test_tool = ADDRESSIPWY;
    }
    
    
    NSLog(@"==============liu==============>%@",cdn_test_tool);
    
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc]initWithString: cdn_test_tool] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error == nil) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        NSString *responseStr = [[NSString alloc] initWithData:data encoding:enc];
        NSLog(@"==============liu==============>%@",responseStr);
        return responseStr;
    } else {
        return returnStr;
    }
    return returnStr;
}

+ (NSMutableArray *)hasBeenFinishedFmPaths:(NSMutableArray *)arr plistName:(NSString *)plistName
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:plistName];
    if (![fm fileExistsAtPath:plistPath]) {
        [fm createFileAtPath:plistPath contents:nil attributes:nil];
    }
    //        NSLog(@" 内容 - - plistPath == // %@",plistPath);
    if(nil == arr)
        return [NSMutableArray arrayWithContentsOfFile:plistPath];
    else
        [arr writeToFile:plistPath atomically:YES];
    
    return arr;
}
@end
