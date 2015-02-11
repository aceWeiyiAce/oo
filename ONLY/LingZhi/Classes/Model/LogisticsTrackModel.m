//
//  LogisticsTrackModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-12.
//
//

#import "LogisticsTrackModel.h"

@implementation LogisticsTrackModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"company"     : @"areaName",
             @"number"      : @"areaCode",
             @"time"        : @"time",
             @"date"        : @"day",
             @"detail"      : @"context",
             @"status"      : @"status",
             @"dealTime"    : @"dealTime",
             @"line"        : @"line"};
}

+(id)createTestModelWithModelId:(NSString *)modelId
{
    LogisticsTrackModel *model= [[LogisticsTrackModel alloc]init];
    
    model.dealTime = [NSString stringWithFormat:@"2014.02.%@",model];
    model.company = @"申峰快递";
    model.number = [NSString stringWithFormat:@"%d",[modelId integerValue]* 2121212];
    model.time = @"31135311321223";
    model.date = @"31135311321223";
    model.detail = @"扫描装袋子呢别着急扫描装袋子呢别着急扫描装袋子呢别着急扫描装袋子呢别着急扫描装袋子呢别着急";
    model.status = [modelId integerValue]== 0
                    ?@"1":@"0";
    
    return model;
}
@end
