//
//  ITTHttpRequest.m
//  iTotemMinFramework
//
//  Created by Tom on 13-10-14.
//
//

#import "ITTHttpRequestManager.h"
#import "ITTObjectSingleton.h"

@implementation ITTHttpRequestManager

ITTOBJECT_SINGLETON_BOILERPLATE(ITTHttpRequestManager, sharedHttpRequestManager)

- (id)init
{
    self = [super init];
	if (self) {
        self.connectionQueue  = [[NSOperationQueue alloc] init];
        [self.connectionQueue setMaxConcurrentOperationCount:4];
	}
	return self;
}

- (ITTUrlConnectionOperation *)requestWithURLRequest:(NSMutableURLRequest *)request saveToPath:(NSString *)filePath onRequestStart:(void(^)(ITTUrlConnectionOperation *request))onStartBlock
            onProgressChanged:(void(^)(ITTUrlConnectionOperation *request,float progress))onProgressChangedBlock
            onRequestFinished:(void(^)(ITTUrlConnectionOperation *request))onFinishedBlock
            onRequestFailed:(void(^)(ITTUrlConnectionOperation *request ,NSError *error))onFailedBlock

{
    if (onStartBlock) {
        _onRequestStartBlock = [onStartBlock copy];
    }
    if (onFinishedBlock) {
        _onRequestFinishBlock = [onFinishedBlock copy];
    }
    if (onFailedBlock) {
        _onRequestFailedBlock = [onFailedBlock copy];
    }
    if (onProgressChangedBlock) {
        _onRequestProgressChangedBlock = [onProgressChangedBlock copy];
    }
    
    __block ITTUrlConnectionOperation *operation =  [[ITTUrlConnectionOperation alloc] initWithURLRequest:request saveToPath:filePath progress:^(float progress) {
        if (_onRequestProgressChangedBlock) {
            _onRequestProgressChangedBlock(operation,progress);
        }
   } onRequestStart:^(ITTUrlConnectionOperation *urlConnectionOperation) {
       if (_onRequestStartBlock) {
           _onRequestStartBlock(operation);
       }
   } completion:^(ITTUrlConnectionOperation *urlConnectionOperation, BOOL requestSuccess, NSError *error) {
       if (requestSuccess) {
           if (_onRequestFinishBlock) {
               _onRequestFinishBlock(operation);
           }
       }else{
           if (_onRequestFailedBlock) {
               _onRequestFailedBlock(operation,error);
           }
       }
   }];
    [self.connectionQueue addOperation:operation];
    
    return operation;
}

@end
