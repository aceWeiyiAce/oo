//
//  BaseDataInitManager.m
//  LingZhi
//
//  Created by boguoc on 14-4-2.
//
//

#import "BaseDataInitManager.h"
#import "LYBaseRequest.h"

@interface BaseDataInitManager ()
{
    
}
@end

@implementation BaseDataInitManager

+ (BOOL)isMoreArray
{
    return [[ITTDataCacheManager sharedManager]hasObjectInCacheByKey:@"moreArray"];
}

+ (NSArray *)getCategoryListRequest
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"0" forKey:@"state"];
    [GetCategoryListRequest requestWithParameters:dic
                                withIndicatorView:nil
                                withCancelSubject:@"GetCategoryListRequest"
                                   onRequestStart:nil
                                onRequestFinished:^(ITTBaseDataRequest *request) {
                                    if ([request isSuccess]) {
                                        [array addObjectsFromArray: request.handleredResult[@"keyModel"]];
                                    }
                                }
                                onRequestCanceled:nil
                                  onRequestFailed:^(ITTBaseDataRequest *request) {
                                      
                                  }];
    return array;
}

@end
