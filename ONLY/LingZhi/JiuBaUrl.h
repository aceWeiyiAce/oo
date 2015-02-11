//
//  GiftUrl.h
//  Gifts
//
//  Created by 王向锋 on 15/1/15.
//  Copyright (c) 2015年 王向锋. All rights reserved.
//

#ifndef JiuBa_JiuBaUrl_h
#define JiuBa_JiuBaUrl_h
#pragma mark - 登陆 －
#define LoginUrl @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/user/signin"
#pragma marl - 注册 name email password－
#define RegisterUrl @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/user/signup"
#pragma mark - 礼物一级分类 -
#define JiuBaFristUrl @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/home/category"
#pragma mark - 礼物二级分类 －
#define JiuBaSecondUrl @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/category_second"
#pragma mark - 礼物商品列表 －
#define JiuBaListUrl @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/goods_list"
#pragma mark - 礼物详情页 － 
#define JiuBaDetailUrl @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/goods/desc"
#pragma mark - 创建收藏 －
#define MakeJiuBaList @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/user/collect/create"
#pragma mark - 获取收藏列表 －
#define GetJiuBaList @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/user/collect/list"
#pragma mark - 删除收藏 －
#define DeleteJiuBaList @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/user/collect/delete"

#pragma mark - 创建购物车 －
#define MakeShopList @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/cart/create"

#pragma mark - 获取购物车列表 －
#define GetShopList @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/cart/list"
#pragma mark - 修改购物车 －
#define upDataShopList @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/cart/update"
#pragma mark - 删除购物车信息－
#define DeleteShopList @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/cart/delete"

#pragma mark - 发送通讯录信息－
#define SendPhoneNumbers @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/friend/address"
#pragma mark - 获取大标签－
#define Getparent @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/lable/lable_parent"
#pragma mark - 二级标签－
#define GetparetSon @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/lable/lable_son"
#pragma mark - 加标签－
#define AddParet @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/lable/addlable"
#pragma mark - 删标签－
#define deleteParet @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/lable/del"

#pragma mark - 获取好友列表－
#define getfriendslist @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/friend/friend_list"
#pragma mark - 删好友－
#define deleteFriend @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/friend/friend_del"
#pragma mark - 添加好友－
#define AddFriends @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/friend/addfriend"




#endif
