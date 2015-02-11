//
//  CpecialReocmmendModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-17.
//
//

#import "CpecialReocmmendModel.h"

@implementation CpecialReocmmendModel

-(NSDictionary *)attributeMapDictionary
{
   return @{@"classId"  : @"classId",
            @"name"     : @"name",
            @"imageUrl" : @"imageUrl",};
}

+(id)createTestModelWithModelId:(NSString *)modelId
{
    CpecialReocmmendModel *model = [[CpecialReocmmendModel alloc]init];
    
    model.classId = modelId;
//    model.name =
    
    return model;    
}

@end
