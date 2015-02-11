//
//  HomeModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-7.
//
//

#import "HomeModel.h"

@implementation HomeModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"productClassId"  : @"categoryId",
             @"className"       : @"cname",
             @"imageUrl"        : @"imageUrl",
             @"pId"             : @"pid",
             @"productId"       : @"productId"};
}

+(id)createTestModelWithModelId:(NSString *)modelId
{
    HomeModel *home = [[HomeModel alloc]init];
    
    home.productClassId = [NSString stringWithFormat:@"%d",(arc4random()%9+1)*3];
    home.className = [NSString stringWithFormat:@"上衣%@",modelId];
    home.imageUrl = testImage;
    
    return home;
}

@end
