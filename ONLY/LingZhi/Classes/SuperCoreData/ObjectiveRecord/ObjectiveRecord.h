#import "NSManagedObject+ActiveRecord.h"
#import "NSManagedObject+Mappings.h"

#pragma mark - 进行全局设置
NS_INLINE void CoreDataManagerGlobalSetting(NSString *modelName, NSString *databaseName)
{
    [CoreDataManager sharedManager].modelName = modelName;
    [CoreDataManager sharedManager].databaseName = databaseName;
}

/*
https://github.com/mneorr/ObjectiveRecord
https://github.com/mneorr/ObjectiveSugar

1. 首先需要导入 CoreData.framework
2. #import "ObjectiveRecord.h"
3. 调用方法 CoreDataManagerGlobalSetting(NSString *modelName, NSString *databaseName)
设置Model名字,设置数据库的名字(数据库保存在Document文件夹下).

//创建/保存/删除
Person *john = [Person create];
john.name = @"John";
[john save];
[john delete];
[Person create:@{
                 @"name" : @"John",
                 @"age" : @12,
                 @"member" : @NO
                 }];

//排序
NSArray *sortedPeople = [Person allWithOrder:@"surname"];
//过滤+排序
NSArray *reversedPeople = [Person where:@{@"name" : @"John"}
                                  order:@{@"surname" : @"DESC"}];
//组合排序
NSArray *morePeople = [Person allWithOrder:@[@{@"surname" : @"ASC"},
                                             @{@"name" : @"DESC"}]];
//限制排序
NSArray *fivePeople = [Person where:@"name == 'John'"
                              order:@{@"surname" : @"ASC"}
                              limit:@(5)];
*/