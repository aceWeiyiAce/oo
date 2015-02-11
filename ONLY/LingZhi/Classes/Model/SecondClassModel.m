//
//  SecondClassModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-17.
//
//

#import "SecondClassModel.h"

@implementation SecondClassModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"productId"   : @"categoryId",
             @"name"        : @"cname",
             @"pId"         : @"pid"};
}

+(id)createTestModelWithModelId:(NSString *)modelId
{
    NSArray *array2 = [NSArray arrayWithObjects:@"针织衫",@"衬衫",@"羊绒衫",@"打底衫",@"雪纺衫",@"小西装",@"连衣裙",@"半身裙",@"雪纺连衣裙",@"蕾丝连衣裙",@"休闲裤",@"短外套",@"长外套", nil];
    SecondClassModel *model = [[SecondClassModel alloc]init];
    
    model.productId = modelId;

    model.name = [array2 objectAtIndex:[modelId integerValue]];

    
    return model;
}

+(id)createMoreModelWithModelId:(NSString *)modelId
{
    NSArray *array1 = [NSArray arrayWithObjects:@"我的足迹",@"附近门店",@"清理缓存",@"退换货服务说明",@"推送通知设置",@"关于我们",@"联系我们",@"给我评分", nil];

    SecondClassModel *model = [[SecondClassModel alloc]init];
    
    model.productId = modelId;
    model.name = [array1 objectAtIndex:[modelId integerValue]];

    return model;
}
@end
