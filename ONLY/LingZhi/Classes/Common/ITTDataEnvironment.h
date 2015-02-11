//
//  DataEnvironment.h
//
//  Copyright 2010 itotem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"
#import "UserInfo.h"

@interface ITTDataEnvironment : NSObject {
    NSString *_urlRequestHost;
}

@property (nonatomic,strong) NSString *urlRequestHost;
@property (nonatomic,strong) AddressModel *address;
@property (nonatomic,strong) UserInfo *userInfo;
+ (ITTDataEnvironment *)sharedDataEnvironment;

- (void)clearNetworkData;
- (void)clearCacheData;

@end
