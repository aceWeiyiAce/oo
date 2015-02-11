//
//  ClassificationModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-17.
//
//

#import "ClassificationModel.h"
#import "SecondClassModel.h"

@implementation ClassificationModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"name"        : @"cname",
             @"classId"     : @"categoryId",
             @"classArray"  : @"classArray",
             @"isSelect"    : @"isSelect"};
}

+(id)createTestModelWithModelId:(NSString *)modelId
{
    NSArray *array = [[NSArray alloc]initWithObjects:@"特别推荐",@"新品上市",@"牛仔裤", @"针织衫&毛衣", @"面料裤", @"皮衣/卫衣", @"风衣/皮草", @"外套/西装", @"羽绒/棉服",@"衬衫", @"T恤/上衣", @"配饰", @"更多", nil];
    
    ClassificationModel *model = [[ClassificationModel alloc]init];
    
    model.name = [array objectAtIndex:[modelId integerValue]];
    model.classId = modelId;
    model.isSelect = @"0";
    if ([modelId integerValue] == 12) {
        model.classArray = [SecondClassModel createMoreModels];
    } else {
        model.classArray = [SecondClassModel createTestModels];
    }
    
    return model;
}
@end
