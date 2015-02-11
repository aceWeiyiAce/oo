//
//  BaseModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-3.
//
//

#import "BaseModel.h"

@implementation BaseModel

+ (id)createTestModelWithModelId:(NSString *)modelId
{
    return nil;
}

+ (id)createMoreModelWithModelId:(NSString *)modelId
{
    return nil;
}

+ (id)createAddressModelWithModelId:(NSString *)modelId addressArr:(NSArray *)array
{
    return nil;
}

+ (NSArray *)createTestModels
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i=0; i<7; i++) {
        [array addObject:[self createTestModelWithModelId:[NSString stringWithFormat:@"%d",i]]];
    }
    return array;
}

+ (NSArray *)createMoreModels
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i=0; i<7; i++) {
        [array addObject:[self createMoreModelWithModelId:[NSString stringWithFormat:@"%d",i]]];
    }
    return array;
}

+ (NSArray *)createAddressModelsWithArray:(NSArray *)array
{
    NSMutableArray *data = [[NSMutableArray alloc]init];
    for (int i=0; i<7; i++) {
        [data addObject:[self createAddressModelWithModelId:[NSString stringWithFormat:@"%d",i] addressArr:array]];
    }
    return data;
}

@end
