//
//  USEBaseRequest.m
//  LingZhi
//
//  Created by feng on 14-8-12.
//
//

#import "USEBaseRequest.h"

@implementation USEBaseRequest

-(NSString *)getRequestUrl
{
    return LoginModel_RequestUrl(@"bindCardSend");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
}

@end

@implementation CardBindingRequest

-(NSString *)getRequestUrl
{
    return LoginModel_RequestUrl(@"member/regisFromCRM");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    
}

@end
