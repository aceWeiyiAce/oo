//
//  ITTUrlConnectionOperation.h
//  iTotemMinFramework
//
//  Created by Tom on 13-10-14.
//
//

#import <Foundation/Foundation.h>
@class ITTUrlConnectionOperation;

enum {
    ITTHTTPRequestStateReady = 0,
    ITTHTTPRequestStateExecuting,
    ITTHTTPRequestStateFinished
};
typedef NSUInteger ITTHTTPRequestState;

enum {
	ITTHTTPRequestMethodGET = 0,
    ITTHTTPRequestMethodPOST,
    ITTHTTPRequestMethodPUT,
    ITTHTTPRequestMethodDELETE,
    ITTHTTPRequestMethodHEAD
};
typedef NSUInteger ITTHTTPRequestMethod;

typedef void (^ITTHTTPRequestCompletionHandler)(ITTUrlConnectionOperation *urlConnectionOperation,BOOL requestSuccess, NSError *error);

@protocol ITTUrlConnectionOperationDelegate <NSObject>

@end

@interface ITTUrlConnectionOperation : NSOperation
{
    void (^_onRequestStartBlock)(ITTUrlConnectionOperation *);
}

@property (nonatomic, strong) NSMutableURLRequest           *operationRequest;
@property (nonatomic, strong) NSData                        *responseData;
@property (nonatomic, strong) NSHTTPURLResponse             *operationURLResponse;
@property (nonatomic, readwrite) NSUInteger                 timeoutInterval;
@property (nonatomic, copy) ITTHTTPRequestCompletionHandler operationCompletionBlock;
@property (nonatomic, strong) NSFileHandle                  *operationFileHandle;

@property (nonatomic, strong) NSString                      *operationSavePath;

@property (nonatomic, strong) NSURLConnection               *operationConnection;
@property (nonatomic, strong) NSMutableData                 *operationData;
@property (nonatomic, assign) CFRunLoopRef                  operationRunLoop;
//@property (nonatomic, strong) NSTimer                       *timeoutTimer;
@property (nonatomic, readwrite) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (nonatomic, readwrite) ITTHTTPRequestState        state;
@property (nonatomic, readwrite) float                      expectedContentLength;
@property (nonatomic, readwrite) float                      receivedContentLength;
@property (nonatomic, copy) void (^operationProgressBlock)(float progress);

- (ITTUrlConnectionOperation *)initWithURLRequest:(NSURLRequest *)urlRequest saveToPath:(NSString*)savePath progress:(void (^)(float progress))progressBlock           onRequestStart:(void(^)(ITTUrlConnectionOperation *urlConnectionOperation))onStartBlock
  completion:(ITTHTTPRequestCompletionHandler)completionBlock;

@end
