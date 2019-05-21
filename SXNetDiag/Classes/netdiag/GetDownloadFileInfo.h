//
//  GetDownloadFileInfo.h
//  liuhao
//
//  Created by 刘浩 on 2018/2/24.
//  Copyright © 2018年 刘浩. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GetDownloadFileDelegate <NSObject>
- (void)endCallback:(NSMutableDictionary *)downloadFileInfo;
@end



@interface GetDownloadFileInfo : NSObject
@property (nonatomic,readwrite) id<GetDownloadFileDelegate> callbackDelegate;
- (void)downloadFileWithUrl:(NSString *) fileUrl ;
@end
