//
//  NetworkDiag.h
//  liuhao
//
//  Created by 刘浩 on 2018/2/27.
//  Copyright © 2018年 刘浩. All rights reserved.
//

#import <Foundation/Foundation.h>
//数据回调接口
@protocol NetworkDiagDelegate <NSObject>
- (void)dataCallback:(NSMutableDictionary *)diagInfo isDnsParseOK:(bool)isOK;
@end

@interface NetworkDiag : NSObject


//数据回调接口
@property (nonatomic, weak, readwrite) id<NetworkDiagDelegate> callback;

//获取用户实便的方法
+(NetworkDiag *)sharedInstance;

//开始网络诊断的方法
-(void)startDiagWithUserID:(NSString *)userID userPhone:(NSString *)userPhone deviceId:(NSString *)deviceId cdnList:(NSMutableArray *)CdnInfoList moviceInfo:(NSDictionary*)moviceInfo timestamp:(NSString *)time_stamp;

//停止网络诊断的方法
-(void)stopDiag;

//处理CDN列表的方法
-(void)startDiagDNSList:(NSMutableArray *)domainInfos;

@end
