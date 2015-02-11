//
//  ITTHttpRequest.m
//  iTotemMinFramework
//
//  Created by Tom on 13-10-23.
//
//

#import "ITTDataRequest.h"
#import "ITTHttpRequestManager.h"
#import "ITTNetworkTrafficManager.h"
#import "ITTAFQueryStringPair.h"
#import "AFHTTPClient.h"
#import "ITTRequestJsonDataHandler.h"

@implementation ITTDataRequest

- (void)doRequestWithParams:(NSDictionary*)params
{
    __weak ITTBaseDataRequest *weakSelf = self;
    
    self.httpRequest = [[ITTHTTPRequest alloc] initRequestWithParameters:params URL:[self getRequestUrl] saveToPath:_filePath requestEncoding:[self getResponseEncoding] parmaterEncoding:self.parmaterEncoding requestMethod:[self getRequestMethod] onRequestStart:^(ITTUrlConnectionOperation *request) {
        if (_onRequestStartBlock) {
            _onRequestStartBlock(weakSelf);
        }
    } onProgressChanged:^(ITTUrlConnectionOperation *request, float progress) {
        if (_onRequestProgressChangedBlock) {
            _onRequestProgressChangedBlock(weakSelf,progress);
        }
    } onRequestFinished:^(ITTUrlConnectionOperation *request) {
//        ITTDINFO(@"*** onRequestFinished %@",[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding]);
        
        if (_filePath) {
            if (_onRequestFinishBlock) {
                _onRequestFinishBlock(weakSelf);
            }
        }else{
            [weakSelf handleResultString:[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding]];
        }
       
        [weakSelf showIndicator:NO];
        [weakSelf doRelease];
    } onRequestCanceled:^(ITTUrlConnectionOperation *request) {
        if (_onRequestCanceled) {
            _onRequestCanceled(weakSelf);
        }
        [weakSelf doRelease];
    } onRequestFailed:^(ITTUrlConnectionOperation *request, NSError *error) {
        [weakSelf notifyDelegateRequestDidErrorWithError:error];
        [weakSelf showIndicator:NO];
        [weakSelf doRelease];
    }];
    
    [self.httpRequest startRequest];
    [self showIndicator:YES];
}

- (NSStringEncoding)getResponseEncoding
{
    return NSUTF8StringEncoding;
    //return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
}

- (NSDictionary*)getStaticParams
{
	return nil;
}

- (void)doRelease
{
    [super doRelease];
    self.httpRequest = nil;
}

- (ITTRequestMethod)getRequestMethod
{
	return ITTRequestMethodGet;
}

- (NSString*)getRequestHost
{
	return DATA_ENV.urlRequestHost;
}

- (void)cancelRequest
{
    [self.httpRequest cancelRequest];
    //to cancel here

    if (_onRequestCanceled) {
        __weak ITTBaseDataRequest *weakSelf = self;
        _onRequestCanceled(weakSelf);
    }
    [self showIndicator:NO];
    ITTDINFO(@"%@ request is cancled", [self class]);
}

- (void)dealloc
{
}

@end
