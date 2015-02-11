//
//  ITTHTTPRequest.h
//  iTotemMinFramework
//
//  Created by Tom on 13-11-4.
//
//

#import <Foundation/Foundation.h>
#import "ITTHttpRequestManager.h"
#import "ITTBaseDataRequest.h"
#import "ITTNetwork.h"

@interface ITTHTTPRequest : NSObject
{
    void (^_onRequestStartBlock)(ITTUrlConnectionOperation *);
    void (^_onRequestFinishBlock)(ITTUrlConnectionOperation *);
    void (^_onRequestCanceled)(ITTUrlConnectionOperation *);
    void (^_onRequestFailedBlock)(ITTUrlConnectionOperation *, NSError *);
    void (^_onRequestProgressChangedBlock)(ITTUrlConnectionOperation *, float);
}

@property (nonatomic, strong) NSString                  *requestURL;
@property (nonatomic, strong) NSMutableDictionary       *requestParameters;
@property (nonatomic, assign) ITTRequestMethod          requestMethod;
@property (nonatomic, assign) NSStringEncoding          requestEncoding;
@property (nonatomic, strong) NSMutableURLRequest       *request;
@property (nonatomic, strong) NSMutableData             *bodyData;
@property (nonatomic, strong) ITTUrlConnectionOperation *urlConnectionOperation;
@property (nonatomic, strong) NSString                  *filePath;
@property (nonatomic, assign) ITTParameterEncoding      parmaterEncoding;

- (ITTHTTPRequest *)initRequestWithParameters:(NSDictionary *)parameters URL:(NSString *)url saveToPath:(NSString *)filePath requestEncoding:(NSStringEncoding)requestEncoding parmaterEncoding:(ITTParameterEncoding)parameterEncoding  requestMethod:(ITTRequestMethod)requestMethod
                               onRequestStart:(void(^)(ITTUrlConnectionOperation *request))onStartBlock
                            onProgressChanged:(void(^)(ITTUrlConnectionOperation *request,float progress))onProgressChangedBlock
                            onRequestFinished:(void(^)(ITTUrlConnectionOperation *request))onFinishedBlock
                            onRequestCanceled:(void(^)(ITTUrlConnectionOperation *request))onCanceledBlock
                              onRequestFailed:(void(^)(ITTUrlConnectionOperation *request ,NSError *error))onFailedBlock;

- (void)setTimeoutInterval:(NSTimeInterval)seconds;
- (void)addPostForm:(NSString *)key value:(NSString *)value;
- (void)addPostData:(NSString *)key data:(NSString *)data;
- (void)setRequestHeaderField:(NSString *)field value:(NSString *)value;
- (void)cancelRequest;
- (void)startRequest;

@end
