//
//  GetEnvInfo.m
//  liuhao
//
//  Created by 刘浩 on 2018/2/1.
//  Copyright © 2018年 刘浩. All rights reserved.
//

#import "GetEnvInfo.h"
#import <UIKit/UIKit.h>
#import "LDNetGetAddress.h"

@implementation GetEnvInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSMutableDictionary *)getDeviceEvnInfo:(NSString *)withDeviceID {
    NSMutableDictionary * result = [[NSMutableDictionary alloc]init];
    
    //应用版本号 数值
    NSString *appCurVersionNum = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [result setObject:appCurVersionNum forKey:@"appVersionCode"];
    
    //应用版本名称 字符串
    NSString *strAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [result setObject:strAppVersion forKey:@"appVersionString"];
    
    //应用名称
    NSString *strAppName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    [result setObject:[NSString stringWithFormat:@"%@", strAppName] forKey:@"appName"];
    
    //设备id
    [result setObject:withDeviceID forKey:@"deviceID"];
    
    //设备品牌
    [result setObject:@"Apple" forKey:@"devBrand"];
    
    //设备制造商
    [result setObject:@"Apple" forKey:@"devManufacturer"];
    
    //设备类型
    [result setObject:[[UIDevice currentDevice] model] forKey:@"devModel"];
    
    //系统版本号
    NSString *strSysVersion =  [[UIDevice currentDevice] systemVersion];
    [result setObject:strSysVersion forKey:@"devSystemVersion"];
    
    //网络类型：UNKNOWN 2G 3G 4G WAP WIFI
    NSArray *typeArr = [NSArray arrayWithObjects:@"2G", @"3G", @"4G", @"5G", @"wifi",@"UNKNOWN", nil];
    NETWORK_TYPE  _curNetType = [LDNetGetAddress getNetworkTypeFromStatusBar];
    if(_curNetType > 0&& _curNetType < 6){
        [result setObject:[NSString stringWithFormat:@"%@" ,[typeArr objectAtIndex:_curNetType - 1]] forKey:@"networkType"];
    }else{
        [result setObject: [NSString stringWithFormat:@"%@" ,[typeArr objectAtIndex:[typeArr count]-1]] forKey:@"networkType"];
    }
    
    //本地IP
    NSString *_localIp = [LDNetGetAddress deviceIPAdress];
    [result setObject:_localIp forKey:@"localIP"];
    
    //本地网关
    NSString *_gatewayIp;
    if (_curNetType == NETWORK_TYPE_WIFI) {
        _gatewayIp = [LDNetGetAddress getGatewayIPAddress];
    } else {
        _gatewayIp = @"";
    }
    [result setObject:_gatewayIp forKey:@"localGateway"];
    
    //本地DNS1
    NSArray *_dnsServers = [NSArray arrayWithArray:[LDNetGetAddress outPutDNSServers]];
    [result setObject:[_dnsServers componentsJoinedByString:@", "] forKey:@"localDNS"];
    
    return result;
}

@end
