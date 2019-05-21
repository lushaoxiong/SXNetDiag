//
//  GetDnsInfo.m
//  liuhao
//
//  Created by 刘浩 on 2018/2/7.
//  Copyright © 2018年 刘浩. All rights reserved.
//

#import "GetDnsInfo.h"
#import "DetailsObject.h"

@implementation GetDnsInfo
#define ADDRESSIPWY @"http://nstool.netease.com/"
#define C_Start @"<br>";


+ (NSString*)getWanIPAddressWY {
    NSString *returnStr = [[NSString alloc] initWithString:@"dns error!"];
    
    
    NSMutableArray * conpfArr1 =  [[DetailsObject shareStartPlayDicKey] hasBeenFinishedFmPaths:nil plistName:AppConpf];
    NSString * cdn_test_tool = @"";
    for (NSDictionary * confDic1 in conpfArr1) {
        cdn_test_tool = [confDic1 objectForKey:@"cdn_test_tool"];
    }
    if (cdn_test_tool == nil || [cdn_test_tool isEqualToString:@""]) {
        cdn_test_tool = ADDRESSIPWY;
    }
    
    
    NSLog_Ngdy(@"==============liu==============>%@",cdn_test_tool);
    
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc]initWithString: cdn_test_tool] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error == nil) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        NSString *responseStr = [[NSString alloc] initWithData:data encoding:enc];
        NSLog_Ngdy(@"==============liu==============>%@",responseStr);
        return responseStr;
    } else {
        return returnStr;
    }
    return returnStr;
}
@end
