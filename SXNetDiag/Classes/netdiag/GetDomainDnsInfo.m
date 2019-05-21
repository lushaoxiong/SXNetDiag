//
//  GetDomainDnsInfo.m
//  liuhao
//
//  Created by 刘浩 on 2018/2/1.
//  Copyright © 2018年 刘浩. All rights reserved.
//

#import "GetDomainDnsInfo.h"
#import "LDNetGetAddress.h"

@implementation GetDomainDnsInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


-(NSMutableDictionary *)getDomainDnsINfo:(NSString *)domain{
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    long long startTS = [[NSDate date]timeIntervalSince1970]*1000;
    NSArray *ipArray =[NSArray arrayWithArray:[LDNetGetAddress getDNSsWithDormain:domain]];
    long long duration =[[NSDate date]timeIntervalSince1970]*1000-startTS;
    
    if(ipArray ==nil || [ipArray count] == 0){//解析域名失败
        [result setObject:domain forKey:@"domain"];
        [result setObject:@"false" forKey:@"isDomainParseResult"];
        [result setObject:@"" forKey:@"domain2Ip"];
        [result setObject:@"0" forKey:@"domainParseTime"];
    }else{//解析域名成功
        [result setObject:domain forKey:@"domain"];
        [result setObject:@"true" forKey:@"isDomainParseResult"];
        [result setObject:[ipArray componentsJoinedByString:@","] forKey:@"domain2Ip"];
        [result setObject:[NSString stringWithFormat:@"%llu",duration] forKey:@"domainParseTime"];
    }
    return result;
}
@end
