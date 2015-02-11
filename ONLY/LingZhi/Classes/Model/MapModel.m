//
//  MapModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-19.
//
//

#import "MapModel.h"

@implementation MapModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"num"         : @"num",
             @"address"     : @"address",
             @"area"        : @"area",
             @"name"        : @"name",
             @"phone"       : @"phone",
             @"latitude"    : @"latitude",
             @"longitude"   : @"longitude",
             @"city"        : @"city"};
}

+(id)createTestModelWithModelId:(NSString *)modelId
{
    NSArray *arr = [NSArray arrayWithObjects:@"新世界店",@"金鼎当代店",@"翠微牡丹园店",@"中关村店",@"回龙观店",@"新中关店",@"十里堡店",@"菜市口店",@"东方广场店",@"LG双子座店",@"国泰百货店",@"牡丹园店",@"世纪城店", nil];
    NSArray *arr1 = [NSArray arrayWithObjects:@"西城区",@"东城区",@"海淀区",@"朝阳区",@"宣武区", nil];
    MapModel *map = [[MapModel alloc]init];
    
    map.num = [NSString stringWithFormat:@"%d",[modelId integerValue]*100+4324];
    map.address = [arr objectAtIndex:[modelId integerValue]];
    map.area = [arr1 objectAtIndex:[modelId integerValue]%5];
    
    return map;
}
@end
