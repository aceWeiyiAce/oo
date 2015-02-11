//
//  MyFavoriteViewController.m
//  LingZhi
//
//  Created by boguoc on 14-2-27.
//
//

#import "MyFavoriteViewController.h"
#import "CollectCell.h"
#import "shareRemindView.h"
#import "MainViewController.h"
#import "ProductInfoModel.h"

#import "MyTrackViewController.h"
#import "CollectProductModel.h"
#import "ColorModel.h"
#import "SizeModel.h"
#import "PKBaseRequest.h"
#import "UIAlertView+ITTAdditions.h"
#import "CustomSizeButton.h"
#import "ColorButton.h"
#import "CartViewController.h"
#import "ProductDetailInfoController.h"
#import "CustomAlertView.h"

#define ColorPaddingLeft 10.0
#define ColorPaddingTop  5.0
#define ShareWidthAndHeight  62.0

#define GET_VIEW_HEIGHT(id) (id.bounds.size.height)
#define GET_VIEW_WIDTH(id) (id.bounds.size.width)

@interface MyFavoriteViewController ()<UITableViewDataSource,UITableViewDelegate,ProductDetailInfoControllerDelegate>
{
    NSMutableArray *  _collectProductArr;
    NSMutableArray * _colorArr;
    NSMutableArray * _sizeCodeArr;
    
    
    __weak IBOutlet UITableView  *_tableView;
    __weak IBOutlet UIView       *_chooseView;
    __weak IBOutlet UIScrollView *_colorScrollView;
    __weak IBOutlet UIScrollView *_sizeCodeScrollView;
    
    IBOutlet UIView  *_remindView;
    
    
    ColorButton      * _selectedColorBtn;
    CustomSizeButton * _selectedSizeBtn;
    NSString         * _selectedColor;
    NSString         * _selectedSize;
    
    ProductInfoModel * defaultProduct;
    CollectCell      * _cellForShowBuy;
    
    NSIndexPath * buyIndexPath;
}

@end

@implementation MyFavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getAllCollectProducts];
    buyIndexPath = [[NSIndexPath alloc] init];
    
    _tableView.dataSource = self;
    _tableView.delegate   = self;
}

-(void)viewWillAppear:(BOOL)animated
{
//    _collectProductArr = nil;
    _chooseView.hidden = YES;
//    [self getAllCollectProducts];
}



#pragma mark - Table view data source and delegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 137;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_collectProductArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CollectCell";
    CollectCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // Configure the cell...
    if(!cell){
        cell = [CollectCell loadFromXib];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"productInfo =  %@",_collectProductArr[indexPath.row]);
    CollectProductModel * collectModel = _collectProductArr[indexPath.row];
    
    [cell showCollectProductWithCollectModel:collectModel];
        
    //删除Cell
    cell.delBtnBlock = ^(id sender){
        
        
        [UIAlertView promptTipViewWithTitle:Nil message:@"确认删除吗" cancelBtnTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(int buttonIndex) {
            [self sendRequestTodeleteCollectInfo:indexPath.row];
//            [_collectProductArr removeObjectAtIndex:indexPath.row];
//            [_tableView beginUpdates];
//            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [_tableView endUpdates];
//            if (_collectProductArr.count < 1) {
//                _tableView.hidden = YES;
//                _remindView.hidden = NO;
//                return;
//            }
//            [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:.3f];
//            _chooseView.hidden = YES;

        } onCancel:^{
            _chooseView.hidden = YES;
        }];
        
    };
    
    //加入购物车Block
    __unsafe_unretained CollectCell * cellForShow = cell;
    cell.addInCarBtnBlock = ^(id sender){
        NSLog(@"blockBtn");
        
        //        [self showChooseView];
        _cellForShowBuy = cellForShow;
        buyIndexPath = indexPath;
        [self showChooseViewWithPageWay:collectModel];
    };
    
    NSLog(@"cell.height = %f",cell.height);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectProductModel * collectModel = _collectProductArr[indexPath.row];
    ProductDetailInfoController * prodcutVc = [[ProductDetailInfoController alloc] init];
    prodcutVc.productId = collectModel.productInfo.productId;
    prodcutVc.productIdArr = [NSArray arrayWithObjects:collectModel.productInfo.productId, nil];
    prodcutVc.delegate = self;
    [self.navigationController pushViewController:prodcutVc animated:YES];
}


#pragma mark -productDetailInfoControllerDelegate
-(void)makeCollectTableViewRefresh
{
    [self getAllCollectProducts];
}


#pragma mark - Button Method

- (IBAction)backToMainPageAction:(id)sender
{
    if (_productController) {
        [self.navigationController popToViewController:_productController animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)backToRootAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)closechooseViewAction:(id)sender {
    
    _chooseView.hidden = YES;
    
}

- (IBAction)submitChooseAction:(id)sender {
    
    NSLog(@"提交中.....");
    
    NSString * pnumber9 = [defaultProduct.num substringWithRange:NSMakeRange(0, 9)];
    NSString * pnumber15 = [pnumber9 stringByAppendingFormat:@"%@%@",_selectedColorBtn.color.number,_selectedSizeBtn.size.snumber];
    [self RequestStorgeNumberByPnumber:pnumber15];
    
//    [self requestToAddProductInShopCarWithPNumber:pnumber15 buyCount:1];
    
    
}

#pragma mark - 显示购买视图

/**
 *  显示选择视图，其中ScrollView采用翻页方式
 */
- (void)showChooseViewWithPageWay:(CollectProductModel *)collect
{
    [_colorScrollView removeAllSubviews];
    if (!_colorArr) {
        _colorArr = [NSMutableArray array];
    }
    if (!_sizeCodeArr) {
        _sizeCodeArr = [NSMutableArray array];
    }
    
    _colorArr = (NSMutableArray *)collect.cModel;
    
    _sizeCodeArr = (NSMutableArray *)collect.zModel;
    
    defaultProduct = collect.productInfo;
    
    NSLog(@"defaultProduct = %@",defaultProduct);
    
    [UIView animateWithDuration:0.4 animations:^{
        _chooseView.hidden = NO;
    }];
    
    _colorScrollView.pagingEnabled = YES;
    _colorScrollView.showsVerticalScrollIndicator = NO;
    _colorScrollView.showsHorizontalScrollIndicator = NO;
    
    for (NSUInteger idx=0; idx<[_colorArr count]; idx++) {
        ColorModel *colorM =_colorArr[idx];
        
        NSUInteger beishu = idx/4;
        ColorButton * lblBtn = [ColorButton buttonWithType:UIButtonTypeCustom];
        lblBtn.color = colorM;
        lblBtn.tag = [colorM.number intValue];
        [lblBtn setTitle:colorM.name forState:UIControlStateNormal];
        lblBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        lblBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        //设置边框 背景色
        [lblBtn setBackgroundImage:[UIImage imageNamed:@"blackEnabledEdge.png"] forState:UIControlStateNormal];
        [lblBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [lblBtn addTarget:self action:@selector(getColorWhenColorPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [_colorScrollView addSubview:lblBtn];
        
        NSUInteger caseNum = idx - (idx/4)*4;
        
        switch (caseNum) {
            case 0:
                lblBtn.frame = CGRectMake(GET_VIEW_WIDTH(_colorScrollView)*beishu + ColorPaddingLeft ,  ColorPaddingTop, ShareWidthAndHeight, ShareWidthAndHeight);
                //                NSLog(@"lbl.frame = %@",NSStringFromCGRect(lbl.frame));
                break;
                
            case 1:
                
                lblBtn.frame = CGRectMake(GET_VIEW_WIDTH(_colorScrollView)*beishu + 2*ColorPaddingLeft + ShareWidthAndHeight , ColorPaddingTop, ShareWidthAndHeight, ShareWidthAndHeight);
                break;
            case 2:
                lblBtn.frame = CGRectMake(GET_VIEW_WIDTH(_colorScrollView)*beishu + ColorPaddingLeft ,  ColorPaddingTop*2 + ShareWidthAndHeight , ShareWidthAndHeight, ShareWidthAndHeight);
                break;
            case 3:
                lblBtn.frame = CGRectMake(GET_VIEW_WIDTH(_colorScrollView)*beishu + 2*ColorPaddingLeft + ShareWidthAndHeight ,ColorPaddingTop*2 + ShareWidthAndHeight, ShareWidthAndHeight, ShareWidthAndHeight);
                break;
            default:
                break;
        }
        [lblBtn.titleLabel setTextColor:[UIColor blackColor]];
        if ([defaultProduct.color isEqualToString: colorM.name]) {
            [lblBtn setBackgroundImage:[UIImage imageNamed:@"redEdge.png"] forState:UIControlStateNormal];
            [lblBtn.titleLabel setTextColor:[UIColor whiteColor]];
            _selectedColorBtn = lblBtn;
        }
        
    }
    
    NSUInteger num = [_colorScrollView.subviews count];
    CGFloat totalWidth = (num > 4 && num %4!=0)? (num/4+1)* GET_VIEW_WIDTH(_colorScrollView):num/4*GET_VIEW_WIDTH(_colorScrollView);
    _colorScrollView.contentSize =CGSizeMake(totalWidth, GET_VIEW_HEIGHT(_colorScrollView));
    
    [self updateShowSizeButtons];
  
    
    
}

-(void)updateShowSizeButtons
{
    [_sizeCodeScrollView removeAllSubviews];
    
    BOOL defaultSelected = NO;
    
    for (NSUInteger idx=0; idx<[_sizeCodeArr count]; idx++) {
        
        NSLog(@"_sizeCodeArr = %@",_sizeCodeArr);
        
        SizeModel * sModel =_sizeCodeArr[idx];
        NSUInteger beishu = idx/4;
        CustomSizeButton * lbl = [[CustomSizeButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        lbl.size = sModel;
        lbl.codeLbl.text = sModel.name;
        lbl.sizeLbl.text = sModel.pName;
        //设置边框 背景色
        if ([sModel.active intValue]==1) {
            
            [lbl setBackgroundImage:[UIImage imageNamed:@"blackEnabledEdge.png"] forState:UIControlStateNormal];
        }else{
            lbl.enabled = NO;
            [lbl setBackgroundImage:[UIImage imageNamed:@"collectUnEnabledBtn.png"] forState:UIControlStateNormal];
        }
        [lbl setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [lbl addTarget:self action:@selector(getSizeWhenSizePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [_sizeCodeScrollView addSubview:lbl];
        
        NSUInteger caseNum = idx - (idx/4)*4;
        
        switch (caseNum) {
            case 0:
                lbl.frame = CGRectMake(GET_VIEW_WIDTH(_sizeCodeScrollView)*beishu + ColorPaddingLeft ,  ColorPaddingTop, ShareWidthAndHeight, ShareWidthAndHeight);
                break;
                
            case 1:
                
                lbl.frame = CGRectMake(GET_VIEW_WIDTH(_sizeCodeScrollView)*beishu + 2*ColorPaddingLeft + ShareWidthAndHeight , ColorPaddingTop, ShareWidthAndHeight, ShareWidthAndHeight);
                break;
            case 2:
                lbl.frame = CGRectMake(GET_VIEW_WIDTH(_sizeCodeScrollView)*beishu + ColorPaddingLeft ,  ColorPaddingTop*2 + ShareWidthAndHeight , ShareWidthAndHeight, ShareWidthAndHeight);
                break;
            case 3:
                lbl.frame = CGRectMake(GET_VIEW_WIDTH(_sizeCodeScrollView)*beishu + 2*ColorPaddingLeft + ShareWidthAndHeight ,ColorPaddingTop*2 + ShareWidthAndHeight, ShareWidthAndHeight, ShareWidthAndHeight);
                break;
            default:
                break;
        }
        [lbl.titleLabel setTextColor:[UIColor blackColor]];
        if (!defaultSelected && [sModel.active intValue]==1) {
            //默认选中第一个可选项
            [lbl setBackgroundImage:[UIImage imageNamed:@"redEdge.png"] forState:UIControlStateNormal];
            lbl.codeLbl.textColor = [UIColor whiteColor];
            lbl.sizeLbl.textColor = [UIColor whiteColor];
            _selectedSizeBtn = lbl;
            defaultSelected = YES;
            
        }
        
        
        
    }
    
    NSUInteger sizeNum = [_sizeCodeScrollView.subviews count];
    CGFloat totalWidthOfSize = (sizeNum > 4 && sizeNum %4!=0)? (sizeNum/4+1)* GET_VIEW_WIDTH(_sizeCodeScrollView):sizeNum/4*GET_VIEW_WIDTH(_sizeCodeScrollView);
    _sizeCodeScrollView.contentSize =CGSizeMake(totalWidthOfSize, GET_VIEW_HEIGHT(_sizeCodeScrollView));
}

-(void)getColorWhenColorPressed:(id)sender
{
    ColorButton * btn = (ColorButton *)sender;
    [btn setBackgroundImage:[UIImage imageNamed:@"redEdge.png"] forState:UIControlStateNormal];
    _selectedColor = btn.currentTitle;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSLog(@"_selectedColor = %@",_selectedColor);
    
    
    if (_selectedColorBtn != btn && _selectedColorBtn !=Nil) {
        [_selectedColorBtn setBackgroundImage:[UIImage imageNamed:@"blackEnabledEdge.png"] forState:UIControlStateNormal];
        [_selectedColorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    _selectedColorBtn = btn;
    
    [self requestToGetAllSizeByProductNumber:btn.color.number];
}


-(void)getSizeWhenSizePressed:(id)sender
{
    
    CustomSizeButton * btn = (CustomSizeButton *)sender;
    [btn setBackgroundImage:[UIImage imageNamed:@"redEdge.png"] forState:UIControlStateNormal];
    _selectedSize = btn.codeLbl.text;
    btn.codeLbl.textColor = [UIColor whiteColor];
    btn.sizeLbl.textColor = [UIColor whiteColor];
    NSLog(@"_selectedSize = %@",_selectedSize);
    
    
    if (_selectedSizeBtn != btn && _selectedSizeBtn !=Nil) {
        [_selectedSizeBtn setBackgroundImage:[UIImage imageNamed:@"blackEnabledEdge.png"] forState:UIControlStateNormal];
        _selectedSizeBtn.codeLbl.textColor = [UIColor blackColor];
        _selectedSizeBtn.sizeLbl.textColor = [UIColor darkGrayColor];
        
    }
    _selectedSizeBtn = btn;
    
}


/**
 *  显示选择试图，其中ScrollView的为上下滑动
 */
- (void)showChooseView
{
    [UIView animateWithDuration:0.4 animations:^{
        _chooseView.hidden = NO;
    }];
    
    _colorScrollView.showsVerticalScrollIndicator = NO;
    _colorScrollView.showsHorizontalScrollIndicator = NO;
    
    for (NSUInteger idx=0; idx<[_colorArr count]; idx++) {
        NSString * value = _colorArr[idx];
        NSUInteger beishu = idx/4;
        UILabel * lbl = [[UILabel alloc] init];
        lbl.text            = value;
        lbl.backgroundColor = [UIColor greenColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        
        [_colorScrollView addSubview:lbl];
        
        NSUInteger caseNum = idx - (idx/4)*4;
        
        switch (caseNum) {
            case 0:
                lbl.frame = CGRectMake( ColorPaddingLeft , GET_VIEW_HEIGHT(_colorScrollView)*beishu + ColorPaddingTop, ShareWidthAndHeight, ShareWidthAndHeight);
                break;
                
            case 1:
                
                lbl.frame = CGRectMake( 2*ColorPaddingLeft + ShareWidthAndHeight ,GET_VIEW_HEIGHT(_colorScrollView)*beishu + ColorPaddingTop, ShareWidthAndHeight, ShareWidthAndHeight);
                break;
            case 2:
                lbl.frame = CGRectMake( ColorPaddingLeft , GET_VIEW_HEIGHT(_colorScrollView)*beishu + ColorPaddingTop*2 + ShareWidthAndHeight , ShareWidthAndHeight, ShareWidthAndHeight);
                break;
            case 3:
                lbl.frame = CGRectMake( 2*ColorPaddingLeft + ShareWidthAndHeight  , GET_VIEW_HEIGHT(_colorScrollView)*beishu + ColorPaddingTop*2 + ShareWidthAndHeight, ShareWidthAndHeight, ShareWidthAndHeight);
                break;
            default:
                break;
        }
        
        
    }
    
    NSUInteger num = [_colorScrollView.subviews count];
    CGFloat totalheight = (num > 4 && num %4!=0)? (num/4+1)* GET_VIEW_HEIGHT(_colorScrollView):num/4*GET_VIEW_HEIGHT(_colorScrollView);
    _colorScrollView.contentSize =CGSizeMake(_colorScrollView.bounds.size.width, totalheight);
    
    
    _sizeCodeScrollView.showsVerticalScrollIndicator = NO;
    _sizeCodeScrollView.showsHorizontalScrollIndicator = NO;
    
    for (NSUInteger idx=0; idx<[_sizeCodeArr count]; idx++) {
        NSString * value = _sizeCodeArr[idx];
        NSUInteger beishu = idx/4;
        UILabel * lbl = [[UILabel alloc] init];
        lbl.text            = value;
        lbl.backgroundColor = [UIColor greenColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        
        [_sizeCodeScrollView addSubview:lbl];
        
        NSUInteger caseNum = idx - (idx/4)*4;
        
        switch (caseNum) {
            case 0:
                lbl.frame = CGRectMake( ColorPaddingLeft , GET_VIEW_HEIGHT(_sizeCodeScrollView)*beishu + ColorPaddingTop, ShareWidthAndHeight, ShareWidthAndHeight);
                break;
                
            case 1:
                
                lbl.frame = CGRectMake( 2*ColorPaddingLeft + ShareWidthAndHeight ,GET_VIEW_HEIGHT(_sizeCodeScrollView)*beishu + ColorPaddingTop, ShareWidthAndHeight, ShareWidthAndHeight);
                break;
            case 2:
                lbl.frame = CGRectMake( ColorPaddingLeft , GET_VIEW_HEIGHT(_sizeCodeScrollView)*beishu + ColorPaddingTop*2 + ShareWidthAndHeight , ShareWidthAndHeight, ShareWidthAndHeight);
                break;
            case 3:
                lbl.frame = CGRectMake( 2*ColorPaddingLeft + ShareWidthAndHeight  , GET_VIEW_HEIGHT(_sizeCodeScrollView)*beishu + ColorPaddingTop*2 + ShareWidthAndHeight, ShareWidthAndHeight, ShareWidthAndHeight);
                break;
            default:
                break;
        }
        
        
    }
    
    NSUInteger sizeNum = [_sizeCodeScrollView.subviews count];
    CGFloat totalHeightOfSize = (sizeNum > 4 && sizeNum %4!=0)? (sizeNum/4+1)* GET_VIEW_HEIGHT(_sizeCodeScrollView):sizeNum/4*GET_VIEW_HEIGHT(_sizeCodeScrollView);
    _sizeCodeScrollView.contentSize =CGSizeMake(_sizeCodeScrollView.bounds.size.width, totalHeightOfSize);
    
}

- (void)del:(id)sender
{
    
}


#pragma mark - request methods
- (void)getAllCollectProducts
{
    if (!_collectProductArr) {
        _collectProductArr = [[NSMutableArray alloc]init];
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    //新增系统标签参数 at 20140704 by Pk
    [parameter setObject:AppSystemId forKey:@"brandCode"];
    
    [GetFavoriteListRequest requestWithParameters:parameter
                                withIndicatorView:self.view
                                withCancelSubject:@"GetFavoriteListRequest"
                                   onRequestStart:nil
                                onRequestFinished:^(ITTBaseDataRequest *request) {
                                    if ([request isSuccess]) {
                                        
                                        [_collectProductArr removeAllObjects];
                                        [_collectProductArr addObjectsFromArray:request.handleredResult[@"keyModel"]];
                                        //当没有收藏的商品时，显示提示信息
                                        if([_collectProductArr count]==0 || _collectProductArr==Nil){
                                            _remindView.hidden = NO;
                                            _tableView.hidden = YES;
                                        }else{
                                            _remindView.hidden = YES;
                                            _tableView.hidden = NO;
                                            [_tableView reloadData];
                                        }
                                        
                                    }
                                    
                                } onRequestCanceled:nil
                                  onRequestFailed:^(ITTBaseDataRequest *request) {
                                      _remindView.hidden = NO;
                                      _tableView.hidden = YES;
                                  }];
    
}

/**
 *  给服务器发送请求，删除收藏信息
 *
 *  @param index 索引值
 */
-(void)sendRequestTodeleteCollectInfo:(int)index
{
    CollectProductModel * model = _collectProductArr[index];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    [parameter setObject:model.collectId forKey:@"collectId"];
    [parameter setObject:model.productInfo.num forKey:@"pnumber"];
    
    [DeleteFavoriteRequest requestWithParameters:parameter
                               withIndicatorView:nil
                               withCancelSubject:@"DeleteFavoriteRequest"
                                  onRequestStart:nil
                               onRequestFinished:^(ITTBaseDataRequest *request) {
                                   if (request.isSuccess) {
                                       [_collectProductArr removeObjectAtIndex:index];
                                       NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                                       [_tableView beginUpdates];
                                       [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                       [_tableView endUpdates];
                                       if (_collectProductArr.count < 1) {
                                           _tableView.hidden = YES;
                                           _remindView.hidden = NO;
                                           return;
                                       }
                                       [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:.3f];
                                       _chooseView.hidden = YES;
                                   }
                               } onRequestCanceled:nil
                                 onRequestFailed:^(ITTBaseDataRequest *request) {
                                     
                                 }];
    
}


/**
 *  根据12位的pnumber获取对应的尺码
 *
 *  @param colorNum
 */
-(void)requestToGetAllSizeByProductNumber:(NSString * )colorNum
{
    
    NSString * numPara = [defaultProduct.num substringWithRange:NSMakeRange(0, 9)];
    NSLog(@"numPara = %@",numPara);
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    NSString * value = [numPara stringByAppendingString:colorNum];
    NSLog(@"value =  %@",value);
    
    [parameter setObject:value forKey:@"pnumber12"];
    
    [RequestToGetSizeArrayByColor requestWithParameters:parameter
                                      withIndicatorView:nil
                                      withCancelSubject:@"RequestToGetSizeArrayByColor"
                                         onRequestStart:nil
                                      onRequestFinished:^(ITTBaseDataRequest *request) {
                                          
                                          if ([request isSuccess]) {
                                              _sizeCodeArr = request.handleredResult[@"keyModel"];
                                              
                                              NSLog(@"data = %@",request.handleredResult[@"data"]);
                                              NSLog(@"_sizeCodeArr = %@",_sizeCodeArr);
                                              [self updateShowSizeButtons];
                                          }else{
                                              NSLog(@"失败");
                                          }
                                          
                                          
                                      } onRequestCanceled:nil
                                        onRequestFailed:^(ITTBaseDataRequest *request) {
                                            
                                        }];
}

/**
 *  根据商品编号查询对应的库存量
 *
 *  @param index 索引值
 */
-(void)RequestStorgeNumberByPnumber:(NSString *)pnumber
{
    
    if (!pnumber || [pnumber isEqualToString:@""]) {
        return;
    }
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:pnumber forKey:@"pnumber"];
    
    [RequestToGetStorageNum requestWithParameters:parameter
                                withIndicatorView:nil
                                withCancelSubject:@"RequestToGetStorageNum"
                                   onRequestStart:nil
                                onRequestFinished:^(ITTBaseDataRequest *request) {
                                    if ([request isSuccess]) {
                                        ProductInfoModel * product = [[ProductInfoModel alloc] initWithDataDic:request.handleredResult[@"data"]];
                                        if ([product.state isEqualToString:@"-1"]||[product.state isEqualToString:@"2"]) {
                                            [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"商品已下架" inSeconds:2];
                                            return;
                                        }else{
                                            [self requestToAddProductInShopCarWithPNumber:pnumber buyCount:1];
                                        }
                                    }
                                } onRequestCanceled:nil
                                  onRequestFailed:^(ITTBaseDataRequest *request) {
                                      
                                  }];
    
}



/**
 *  加入购物车
 *
 *  @param pnumber  拼接的15位pnumber
 *  @param buyCount 购买数量,默认 1 件
 */
-(void)requestToAddProductInShopCarWithPNumber:(NSString *)pnumber buyCount:(int)buyCount
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    [parameter setObject:defaultProduct.productId forKey:@"productId"];
    [parameter setObject:pnumber forKey:@"pnumber"];
    [parameter setObject:[NSNumber numberWithInt:buyCount] forKey:@"count"];
    //新增系统标签参数 at 20140704 by Pk
    [parameter setObject:AppSystemId forKey:@"brandCode"];
    
    [AddCartRequest requestWithParameters:parameter
                        withIndicatorView:nil
                        withCancelSubject:@"AddCartRequest"
                           onRequestStart:nil
                        onRequestFinished:^(ITTBaseDataRequest *request) {
                            
                            if ([request isSuccess]) {
                                
//                                CartViewController * cartVc = [[CartViewController alloc] init];
//                                [self.navigationController pushViewController:cartVc animated:YES];
                                
                                CollectCell * cell = (CollectCell *)[_tableView cellForRowAtIndexPath:buyIndexPath];
                                [cell showCheckedImageViewWithBool:YES];
                                [cell resetCellWithIsLeft:NO];
                                
                                CollectProductModel * modelPro = _collectProductArr[buyIndexPath.row];
                                modelPro.isInShopCar = @"1";
                                modelPro.hasDelete = @"0";

//                                
//                                [_cellForShowBuy showCheckedImageViewWithBool:YES];
//                                [_cellForShowBuy resetCellWithIsLeft:NO];
                                _chooseView.hidden = YES;
                                

                            }else{
                                [UIAlertView promptTipViewWithTitle:Nil message:request.handleredResult[@"messg"] cancelBtnTitle:@"确认" otherButtonTitles:Nil onDismiss:^(int buttonIndex) {
                                    
                                } onCancel:^{
                                    
                                }];
                            }
                            
                            
                        } onRequestCanceled:nil
                          onRequestFailed:^(ITTBaseDataRequest *request) {
                              
                          }];
}



@end
