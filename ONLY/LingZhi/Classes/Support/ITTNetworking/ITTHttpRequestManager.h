//
//  ITTHttpRequest.h
//  iTotemMinFramework
//
//  Created by Tom on 13-10-14.
//
//

#import <Foundation/Foundation.h>
#import "ITTUrlConnectionOperation.h"
@protocol ITTHttpRequestManagerDelegate <NSObject>



@end
@interface ITTHttpRequestManager : NSObject
{
    void (^_onRequestStartBlock)(ITTUrlConnectionOperation *);
    void (^_onRequestFinishBlock)(ITTUrlConnectionOperation *);
    void (^_onRequestCanceled)(ITTUrlConnectionOperation *);
    void (^_onRequestFailedBlock)(ITTUrlConnectionOperation *, NSError *);
    void (^_onRequestProgressChangedBlock)(ITTUrlConnectionOperation *, float);
}

@property (nonatomic,strong) NSOperationQueue *connectionQueue;

+ (ITTHttpRequestManager *)sharedHttpRequestManager;


- (ITTUrlConnectionOperation *)requestWithURLRequest:(NSMutableURLRequest *)request saveToPath:(NSString *)filePath onRequestStart:(void(^)(ITTUrlConnectionOperation *request))onStartBlock
            onProgressChanged:(void(^)(ITTUrlConnectionOperation *request,float progress))onProgressChangedBlock
            onRequestFinished:(void(^)(ITTUrlConnectionOperation *request))onFinishedBlock
              onRequestFailed:(void(^)(ITTUrlConnectionOperation *request ,NSError *error))onFailedBlock;


@end
