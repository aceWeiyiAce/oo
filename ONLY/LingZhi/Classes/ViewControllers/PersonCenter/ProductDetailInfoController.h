//
//  ProductDetailInfoController.h
//  LingZhi
//
//  Created by pk on 3/5/14.
//
//

#import <UIKit/UIKit.h>
#import "ProductInfoModel.h"

@protocol ProductDetailInfoControllerDelegate <NSObject>

@optional
/**
 *  根据重新获取的收藏列表更新收藏夹
 *
 *  @param collectArr
 */
-(void)makeCollectTableViewRefresh;

-(void)makeMyOrderListRefresh;

@end


@interface ProductDetailInfoController : UIViewController

@property (nonatomic,strong)ProductInfoModel *product;
@property (nonatomic,strong)NSString * productId;

@property (nonatomic,strong)NSString * imageUrl;
@property (nonatomic,strong)NSString * pNumber;

@property (nonatomic,assign)BOOL isScanPush;

@property (nonatomic,assign)id<ProductDetailInfoControllerDelegate> delegate;

@property (nonatomic,strong)NSArray * productIdArr;


@end
