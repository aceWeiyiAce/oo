//
//  ClassificationModel.h
//  LingZhi
//
//  Created by boguoc on 14-3-17.
//
//

#import "OnlyBaseModel.h"

@interface ClassificationModel : OnlyBaseModel

@property (nonatomic ,strong) NSString  *name;
@property (nonatomic ,strong) NSString  *classId;
@property (nonatomic ,strong) NSArray   *classArray;
@property (nonatomic ,strong) NSString  *isSelect;

@end
