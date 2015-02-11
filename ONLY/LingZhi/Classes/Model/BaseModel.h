//
//  BaseModel.h
//  LingZhi
//
//  Created by boguoc on 14-3-3.
//
//

#import "ITTBaseModelObject.h"

@interface BaseModel : ITTBaseModelObject

+ (id)createTestModelWithModelId:(NSString *)modelId;
+ (id)createMoreModelWithModelId:(NSString *)modelId;
+ (NSArray *)createTestModels;
+ (NSArray *)createMoreModels;
//地址编辑页
+ (NSArray *)createAddressModelsWithArray:(NSArray *)array;
+ (id)createAddressModelWithModelId:(NSString *)modelId addressArr:(NSArray *)array;

@end
