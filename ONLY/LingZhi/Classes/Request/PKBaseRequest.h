//
//  PKBaseRequest.h
//  LingZhi
//
//  Created by boguoc on 14-3-25.
//
//

#import "ITTAFNBaseDataRequest.h"




@interface PKBaseRequest : ITTAFNBaseDataRequest

@end

//@interface proListRequest : ITTAFNBaseDataRequest
//
//@end




/**
 *  根据商品颜色，获取对应的尺码
 */
@interface RequestToGetSizeArrayByColor : ITTAFNBaseDataRequest

@end



/**
 *  增加收藏
 */
@interface AddFavoriteRequest : ITTAFNBaseDataRequest

@end

/**
 *  删除收藏
 */
@interface DeleteFavoriteRequest : ITTAFNBaseDataRequest

@end

/**
 *  收藏列表
 */
@interface GetFavoriteListRequest : ITTAFNBaseDataRequest

@end


/**
 *  加入购物车
 */
@interface AddCartRequest : ITTAFNBaseDataRequest


@end

/**
 *  登录
 */
@interface LoginRequest : ITTAFNBaseDataRequest

@end


/**
 *  注册
 */
@interface RegisterRequest : ITTAFNBaseDataRequest

@end

/**
 *  验证码
 */
@interface RegisterCodeRequest : ITTAFNBaseDataRequest

@end



/**
 *  忘记密码获取验证码
 */
@interface ForgetPassToGetCodeRequest : ITTAFNBaseDataRequest

@end


/**
 *  修改密码
 */
@interface UpdatePasswordRequest : ITTAFNBaseDataRequest

@end


/**
 *  已登陆修改密码
 */
@interface loginToUpdatePasswordRequest : ITTAFNBaseDataRequest

@end

/**
 *  获取订单列表
 */
@interface RequestOrderList : ITTAFNBaseDataRequest

@end

/**
 *  获取订单详细信息
 */
@interface RequestOrderDetailInfo : ITTAFNBaseDataRequest

@end


/**
 *  取消订单
 */
@interface RequestCancelOrder : ITTAFNBaseDataRequest

@end

/**
 *  将商品重新放回购物车
 */
@interface RequestToReturnProductInShopCar:ITTAFNBaseDataRequest

@end

/**
 *  确认收货
 */
@interface RequestToConfirmReceiveOrder : ITTAFNBaseDataRequest

@end

/**
 *  保存收获地址
 */
@interface RequestToSaveReceiceAddress : ITTAFNBaseDataRequest

@end

/**
 *  获取快递公司
 */
@interface RequestToGetPostCompany : ITTAFNBaseDataRequest

@end

/**
 *  更新快递配送公司和支付方式
 */
@interface RequestToUpdatePostAndPayCompany : ITTAFNBaseDataRequest

@end

/**
 *  更新订单状态
 */
@interface RequestToUpdateOrderState : ITTAFNBaseDataRequest

@end


/**
 *  获取商品详情
 */
@interface RequestToGetProdeuctDetailInfo : ITTAFNBaseDataRequest

@end

/**
 *  根据SKU获取商品详情
 */
@interface RequestToGetProdeuctDetailInfoBySkuCode : ITTAFNBaseDataRequest

@end

/**
 *  通过13位的条形码获取SKU码
 */
@interface RequestToGetProductSKUByBarCode_13 : ITTAFNBaseDataRequest

@end

/**
 *  查询SKU码对应的商品是否存在
 */
@interface RequestToFindProductBySKU : ITTAFNBaseDataRequest

@end

/**
 *  根据商品编号获取库存量
 */
@interface RequestToGetStorageNum : ITTAFNBaseDataRequest

@end

/**
 *  直接购买，跳转支付
 */
@interface RequestToCreateOrderAndGoToPay : ITTAFNBaseDataRequest

@end


/**
 *  获取关于我们的所有信息
 */
@interface RequestToGetAboutUsInfo : ITTAFNBaseDataRequest

@end


/**
 *  获取联系我们的电话
 */
@interface RequestToGetContactTel : ITTAFNBaseDataRequest

@end


/**
 * 银联支付接口,获取支付流水号
 */
@interface RequestToGetUnionPayTN : ITTAFNBaseDataRequest

@end

#pragma mark -------------------  1.4 ------------------------
/**
 * 获取个人信息
 */
@interface RequestToFindMemberInfo : ITTAFNBaseDataRequest

@end

/**
 * 保存个人信息
 */
@interface RequestToaddMember : ITTAFNBaseDataRequest

@end

/**
 * 支付成功生成二维码页面
 */
@interface RequestTopaySuccessInfo : ITTAFNBaseDataRequest

@end

/**
 * 导购绑定
 */
@interface RequestToAddGuidBinder : ITTAFNBaseDataRequest

@end





