//
//  ITTHttpRequest.h
//  iTotemMinFramework
//
//  Created by Tom on 13-10-23.
//
//

#import <Foundation/Foundation.h>
#import "ITTBaseDataRequest.h"
#import "ITTHttpRequestManager.h"
#import "ITTHTTPRequest.h"

@interface ITTDataRequest : ITTBaseDataRequest

@property (nonatomic, strong) ITTHTTPRequest *httpRequest;

@end
