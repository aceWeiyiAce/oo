//
//  EditAddressModel.h
//  LingZhi
//
//  Created by boguoc on 14-3-11.
//
//

#import "OnlyBaseModel.h"

@interface EditAddressModel : OnlyBaseModel

@property (nonatomic ,strong) NSString      *content;
@property (nonatomic ,strong) NSString      *holder;
@property (nonatomic ,strong) NSString      *isError;
@property (nonatomic ,strong) NSIndexPath   *indexPath;
@property (nonatomic ,strong) NSString      *isPicker;

@end
