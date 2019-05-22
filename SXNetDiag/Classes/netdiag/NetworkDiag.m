//
//  NetworkDiag.m
//  liuhao
//
//  Created by 刘浩 on 2018/2/27.
//  Copyright © 2018年 刘浩. All rights reserved.
//

#import "NetworkDiag.h"
#import "GetDnsInfo.h"
#import "GetEnvInfo.h"
#import "GetDomainDnsInfo.h"
#import "LDNetPing.h"
#import "GetDownloadFileInfo.h"
//#import "Ngdy_PlayerUrlSecurityMonitoring.h"
#import "DateTools.h"

@interface NetworkDiag ()<LDNetPingDelegate,NetworkDiagDelegate>{
    LDNetPing *_netPinger;
    GetDownloadFileInfo *_getFile ;
    NSString * timestamp;
}

@end
@implementation NetworkDiag
//CDN的诊断列表
NSMutableArray *domainInfos = nil;
//所有的诊断信息 第一层数据
NSMutableDictionary *diagDict = nil;
//cdn域名与文件下载诊断信息列表 里面的第二层数据
NSMutableArray *cdnDiagInfos;

//cdn域名与文件下载诊断信息 里面的第三层数据
NSMutableDictionary * cdnDiagInfo = nil;

//处理dns列表中的数据
int cdnDomainsIndex = 0;
NSString * cdn_domain;
NSMutableArray *pingInfo;
bool *isDnsParseOK;

bool *isStopTag;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)startDiagWithUserID:(NSString *)userID userPhone:(NSString *)userPhone deviceId:(NSString *)deviceId cdnList:(NSMutableArray *)cdnInfoList moviceInfo:(NSDictionary*)moviceInfo timestamp:(NSString *)time_stamp{
     diagDict = [[NSMutableDictionary alloc]init];
    isDnsParseOK = NO;
    isStopTag = NO;
    timestamp = time_stamp;
    if (_callback == nil) {
        NSLog(@"无代理，不能回调数据");
        
        return;
    }
    //添加用户ID
    if(userID == nil){
        NSLog(@"userID is nil!");
        [diagDict setObject:@"" forKey:@"userID"];
    }else{
        [diagDict setObject:userID forKey:@"userID"];
    }
    //添加用户手机号
    if(userPhone == nil){
        NSLog(@"userPhone is nil!");
        [diagDict setObject:@"" forKey:@"userPhone"];
    }else{
        [diagDict setObject:userPhone forKey:@"userPhone"];
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        
        //添加播放信息
        if(moviceInfo == nil){
            NSLog(@"moviceInfo is nil!");
            [diagDict setObject:[[NSDictionary alloc]init] forKey:@"playInfo"];
        }else{
            [diagDict setObject:moviceInfo forKey:@"playInfo"];
        }
        
        //添加Dns域名解析信息
        isDnsParseOK = NO;
        NSString *dnsDict = [GetDnsInfo getWanIPAddressWY];
        [diagDict setObject:dnsDict forKey:@"dnsInfo"];
        [self parseDnsInfo:dnsDict];
       
        //添加设备环境信息
        NSMutableDictionary * devInfo = [[[GetEnvInfo alloc]init]getDeviceEvnInfo:deviceId];
        [diagDict setObject:devInfo forKey:@"envInfo"];
        
        cdnDomainsIndex = 0;
        cdnDiagInfos = [[NSMutableArray alloc]init];

        //开始对CND列表进行诊断。
        domainInfos = cdnInfoList;
        [self startDiagDNSList];
    });
    return ;
}

-(void)parseDnsInfo:(NSString *)dnsStr{
    if(dnsStr == nil) return;
    
    //TODO sstring to data
    NSData *data = [dnsStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString * isOK = [dict objectForKey:@"is_match"];
    if([isOK isEqualToString:@"1"]){
        isDnsParseOK = YES;
    }else{
        isDnsParseOK = NO;
    }
    NSLog(@"------------------------------^-^--->%d",isDnsParseOK);
    

}


-(void)startDiagDNSList{
    if (isStopTag) {
        return;
    }
    if(domainInfos == nil || [domainInfos count]<=0){
        NSLog(@"dns list is nil");
        [diagDict setObject:cdnDiagInfos forKey:@"cdnInfo"];
        [_callback dataCallback:diagDict isDnsParseOK:isDnsParseOK];
        return;
    }
    
    if(cdnDomainsIndex < [domainInfos count]){
        NSMutableDictionary *domainInfo = [domainInfos objectAtIndex:cdnDomainsIndex];
        cdnDomainsIndex ++;
        if(domainInfo != nil){
            cdnDiagInfo = [[NSMutableDictionary alloc]init];
            //开始处理这路cdn诊断
            cdn_domain = [[NSString alloc]initWithFormat:@"%@",[domainInfo objectForKey:@"play_cnd_url"]];
            NSString *cdn_download_url = [NSString stringWithFormat:@"%@",[domainInfo objectForKey:@"download_cnd_url"]];
            
            //CDN解析诊断
            cdnDiagInfo = [[[GetDomainDnsInfo alloc]init] getDomainDnsINfo:[self optCdnDoaminWithUrl:cdn_domain]];
            //开始下载文件诊断
            _getFile = [[GetDownloadFileInfo alloc]init];
            _getFile.callbackDelegate = self;
            
            NSLog(@" --------- 未处理 %@",cdn_download_url);
            
            
            long long ts = [DateTools getVerifyServerTimestamp];
            //TODO:
            cdn_download_url = cdn_download_url;
            
            
            NSLog(@" -- 已处理 %@",cdn_download_url);
            if (isStopTag) {
                return;
            }
            [_getFile downloadFileWithUrl:cdn_download_url];
            
        }else{
            //开始诊断下一路CDN数据
            if (isStopTag) {
                return;
            }
            [self startDiagDNSList:domainInfos];
        }
    }else{
        //cdnlist全部处理完
        if (isStopTag) {
            return;
        }
        [diagDict setObject:cdnDiagInfos forKey:@"cdnInfo"];
        [_callback dataCallback:diagDict isDnsParseOK:isDnsParseOK];
    }
}

-(void)stopDiag{
    isStopTag = YES;
}
//下载文件的信息
- (void)endCallback:(NSMutableDictionary *)downloadFileInfo{
    if (isStopTag) {
        return;
    }
    NSLog(@"downloadFileInfo == %@",downloadFileInfo);
    [cdnDiagInfo setObject:downloadFileInfo forKey:@"fileDownloadInfo"];
    //开始Ping
    pingInfo = [[NSMutableArray alloc]init];
    _netPinger = [[LDNetPing alloc]init];
    _netPinger.delegate = self;
    
    //处理CDN Http头部信息  
    NSString *pingerCdnDomain = [self optCdnDoaminWithUrl:cdn_domain];
    [_netPinger runWithHostName:pingerCdnDomain normalPing:YES];
    
}

//去除url头部信息
-(NSString *) optCdnDoaminWithUrl:(NSString *)url{
    
    NSRange range;
    NSString *result =[[NSString alloc]init];
    range = [url rangeOfString:@"http://"];
    if (range.location != NSNotFound) {
      result =   [url substringWithRange:NSMakeRange(range.length,[url length]-range.length)];
    }else{
        range = [url rangeOfString:@"https://"];
        if (range.location != NSNotFound) {
            result=   [url substringWithRange:NSMakeRange(range.length,[url length]-range.length)];
        }else{
            result = url;
        }
    }
    return result;
}


- (void)appendPingLog:(NSString *)pingLog {
    if (isStopTag) {
        return;
    }
//    NSLog(@"appendPingLog===========>%@",pingLog);
    [pingInfo addObject:pingLog];
}

- (void)netPingDidEnd {
    if (isStopTag) {
        return;
    }
//    NSLog(@"netPingDidEnd===========>");
    [cdnDiagInfo setObject:pingInfo forKey:@"pingInfo"];
    [cdnDiagInfos addObject:cdnDiagInfo];
    [self startDiagDNSList];
}


@end
