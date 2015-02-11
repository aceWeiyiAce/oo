//
//  CollectCell.h
//  LingZhi
//
//  Created by pk on 3/3/14.
//
//

#import "ITTXibView.h"
#import "ProductInfoModel.h"
#import "CollectProductModel.h"



typedef void(^BtnAction_Block)(id sender);

//typedef void(^BtnAction_Block)();

@interface CollectCell : ITTXibCell

@property (nonatomic,copy)BtnAction_Block delBtnBlock;
@property (nonatomic,copy)BtnAction_Block addInCarBtnBlock;
@property (strong, nonatomic) IBOutlet UIImageView *inCarImageView;

@property (nonatomic,assign) BOOL isShowCheckedImage;



/**
 *  根据商品信息显示具体商品
 *  实际参数为product  待修改
 *  @param imageUrl
 *  @param proNO 
 *  @param isInCar
 */
-(void)showProductInfoWithProduct:(NSString *)imageUrl productNO:(NSString *)proNO andIsInShopCar:(BOOL)isInCar;


-(void)showCollectProductWithCollectModel:(CollectProductModel *)model;

-(void)showCheckedImageViewWithBool:(BOOL)isInShopCar;

-(void)resetCellWithIsLeft:(BOOL)isleft;

@end
