//
//  GetDownloadFileInfo.m
//  liuhao
//
//  Created by 刘浩 on 2018/2/24.
//  Copyright © 2018年 刘浩. All rights reserved.
//

#import "GetDownloadFileInfo.h"
#define HTTP_STATUSCODE_SUCCESS = 200;

@implementation GetDownloadFileInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        NSLog(@"------------------0--->");
    }
    return self;
}

- (void)downloadFileWithUrl:(NSString *) fileUrl{
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:fileUrl forKey:@"downloadFileUrl"];
    
//    NSLog(@"------------------1--->");
    
    long long startTS = [[NSDate date]timeIntervalSince1970]*1000;
    fileUrl = [fileUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:fileUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSInteger httpCode = httpResponse.statusCode;
        
        
        if (httpCode == 200) {
            long long duration =[[NSDate date]timeIntervalSince1970]*1000-startTS;
            [dict setObject:@"true" forKey:@"isDownloadSuccess"];
            [dict setObject:@"" forKey:@"causeOfFailure"];
            [dict setObject:[NSString stringWithFormat:@"%llu",duration] forKey:@"fileDownloadUseTime"];
            [dict setObject:[NSString stringWithFormat:@"%llu",[response expectedContentLength]] forKey:@"fileLength"];
        }else{
            [dict setObject:@"false" forKey:@"isDownloadSuccess"];
            [dict setObject:[NSString stringWithFormat:@"httpStatusCode = %ld    errorCode = %d errorDescription = %@",(long)httpCode,error.code,error.localizedDescription] forKey:@"causeOfFailure"];
            [dict setObject:@"0" forKey:@"fileDownloadUseTime"];
            [dict setObject:@"0" forKey:@"fileLength"];
        }
        
//        NSLog(@"------------------2--->");
//        if(_delegate!=nil){
        
//        NSLog(@"_delegate  self=====>%@",_callbackDelegate);
//            NSLog(@"------------------3--->");
            [_callbackDelegate endCallback:dict];
//        }else{
//            NSLog(@"------------------4--->");
//        }
       
    }];
    
    [downloadTask resume];
    
}



@end
