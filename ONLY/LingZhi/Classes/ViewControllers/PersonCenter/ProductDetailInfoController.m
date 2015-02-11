//
//  ProductDetailInfoController.m
//  LingZhi
//
//  Created by pk on 3/5/14.
//
//

#import "ProductDetailInfoController.h"
#import "CustomNavigationBar.h"
#import "PhoneView.h"
#import "MyDragView.h"
#import "MRZoomScrollView.h"
#import "MyScrollView.h"
#import "ObjectiveRecord.h"
#import "MyTrack.h"
#import "NSDate+Utilities.h"
#import "PKBaseRequest.h"
#import "ProductDetailInfoModel.h"
#import "MatchProduct.h"
#import "ColorModel.h"
#import "SizeModel.h"
#import "ColorButton.h"
#import "XLPageControl.h"
#import "CustomNewSizeButton.h"
#import "SubmitViewController.h"
#import "SubmitViewController_New.h"
#import "UMSocial.h"
#import "LoadingViewController.h"
#import "MainViewController.h"
#import "UIView+ITTAdditions.h"
#import "UILabel+ITTAdditions.h"

#define anim_time 0.5
#define EdgeHeight 68.0


#define ColorPaddingLeft 11.0
#define ColorPaddingTop  0
#define ShareWidthAndHeight  52.0
#define ColorSizeWidth 65
#define ColorSizeHeight 35

#define ShowButtonCount 4
#define RemindNotEnoughMsg(number) [NSString stringWithFormat:@"库存不足,目前只剩 %d 件",number];

#define TagOfImageScrollViewSonStart 0

#define SubViewTagOfCurrentScroll 500
#define FunctionViewHeight 53

typedef enum : NSUInteger {
    left = 0,
    middle = 1,
    right = 2,
} ScrollViewPostion;


@interface ProductDetailInfoController ()<UIScrollViewDelegate,UITextFieldDelegate,UMSocialUIDelegate>
{
    
    IBOutlet UIView *_containsView;
    
    CustomNavigationBar * _customNavigationView;
    __weak IBOutlet MyScrollView *_imageScrollView;//横向的展示scrollView
    NSMutableArray * _imagesUrlArr;
    
    
    __weak IBOutlet UIView *_viewOfMath;
    IBOutlet UIScrollView *_subviewOfMath;
    
    
    __weak IBOutlet UIView *_topView;
    IBOutlet UITapGestureRecognizer *_singleTapGesture;
    
    
    //信息
    __weak IBOutlet UIButton *_infoBtn;
    __weak IBOutlet UIView *_infoView;
    __weak IBOutlet UIView *_infoSubContentView;
    __weak IBOutlet UILabel *_info;
    __weak IBOutlet UILabel *_productNO;
    __weak IBOutlet UILabel *_price;
    __weak IBOutlet UILabel *_style;
    __weak IBOutlet UILabel *_material;
    
    //功能视图
    
    __weak IBOutlet MyDragView *_dragView;
    //    IBOutlet UIPageControl *_pageControl;
    XLPageControl * _pageControl;
    
    //图片下面的那几个功能菜单
    UIView * _containsFunctionView;
    __weak IBOutlet UIImageView *_functionView;
    __weak IBOutlet UIButton *_likeView;

    
    //选择购买视图
    IBOutlet UIView *_chooseView;
    __weak IBOutlet UIScrollView *_sizeScrollView;
    __weak IBOutlet UIScrollView *_colorScrollView;
    IBOutlet UIImageView *_BottomSanJiaoXing;
    __weak IBOutlet UIButton *_reduceBtn;
    __weak IBOutlet UIButton *_addBtn;
    
    __weak IBOutlet UITextField *_numOfBuyField;
    
    UIAlertView * _alertView;
    __weak IBOutlet UILabel *_remindLbl;
    
    NSMutableArray * _colorArr;
    NSMutableArray * _sizeCodeArr;
    NSString * _selectedColor;
    NSString * _selectedSize;
    
    //数量相关
    NSUInteger buyCount;
    NSUInteger productTotalCount;
    
    //tap 双击判断放大缩小
    BOOL isBig;
    CGPoint startDragOfContentSet;
    CGPoint endDragOfContentSet;
    
    //分享
    IBOutlet UIImageView *_shareView;
    
    ProductDetailInfoModel * _detailModel;
    ColorButton * _selectedColorBtn;
    CustomNewSizeButton * _selectedSizeBtn;
    
    BOOL isCollected;
    NSString * _recordCollectId;
    int currentPageIndex;
    
    //区分购物车和立即购买标示
    BOOL isBuyNow;
    BOOL isFirstClick;
    
    BOOL isBigThanStorageNumber;
    __weak IBOutlet UIButton *_submitBtn;
    
    
    //记录触摸的开始时间和结束时间
    NSDate * _touchStartDate;
    NSDate * _touchEndDate;
    
    
    BOOL pageIsFirstLoad;
    __weak IBOutlet UIButton *_sinaShareBtn;
    __weak IBOutlet UIButton *friendsShareBtn;
    
    //用于保存还款过程中已经取回的数据
    NSMutableArray * _productDetailArray;
    NSMutableDictionary * _productMutableDic;
   
    //记录当前屏幕上显示的scrollView
    UIScrollView * _currentScrollInScreen;
    
    //记录当前显示在屏幕上得scrollview 的横向的pageIndex
    NSUInteger hPageIndex;

    NSInteger prePage;//记录前一页
    NSInteger curPage;//记录当前页
    
    //上下滑动算法
    int page;
    CGFloat currentY;
    CGFloat heightOfImageScrollView;
    BOOL isDown;
    
    IBOutlet UIImageView *_operationView;
    __weak IBOutlet UIButton *_bottomLikeView;
    
    //记录4个操作项的top
    CGFloat chooseViewTop;
    CGFloat matchViewTop;
    CGFloat shareViewTop;
    CGFloat bottomSjxTop;
    
    
    NSInteger       _currentIndexOfTopImageScroll;
    NSMutableSet    *_recycledPages;
    NSMutableSet    *_visiblePages;
    
    UIScrollView    *_scrollView;
    BOOL isPageChanged;
    BOOL isPageFirstLoad;
    BOOL isFirstLoadOperationView;
    BOOL isLogin;
}
@property (nonatomic,assign)int currentIndexOfProductId;


- (void)updateFrame;
- (void)tilePages;
- (void)clearPages;
- (void)cancelAllDownloader;
- (void)configurePage:(UIScrollView *)pageScroll forIndex:(NSInteger)index;

- (BOOL)isDisplayingPageForIndex:(NSInteger)index;
- (BOOL)isCurrentPageIndexChanged;

- (NSInteger)getCurrentPageIndex;

- (CGRect)frameForPageAtIndex:(NSInteger)index;
- (CGSize)contentSizeForPagingScrollView;

- (UIScrollView *)dequeueRecycledPageForIndex:(NSInteger)index;


@end

@implementation ProductDetailInfoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (!self.productIdArr) {
            self.productIdArr = [NSArray array];
            _detailModel = [[ProductDetailInfoModel alloc] init];
            _productMutableDic = [[NSMutableDictionary alloc] init];
            
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化图片下面的功能菜单
    _containsFunctionView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-20, 320, FunctionViewHeight)];
    [_containsFunctionView addSubview:_functionView];
    [_containsView addSubview:_containsFunctionView];
    [_containsView bringSubviewToFront:_containsFunctionView];
    
    //20140730 修改
    //区分pid 和 pNumber 跳转的来源执行对应的方法
    if (_pNumber && ![_pNumber isEqualToString:@""]) {
        [self requestToGetProductDetailInfoBySKU];
    }
    else{
        [self requestToGetProductDetailInfo];
    }
    
    
    isBuyNow = NO;
    isFirstClick = NO;
    
    currentPageIndex = 0;
    
    [self getCurrentIndexOfProductIdInProductIdArr];
    curPage = prePage = _currentIndexOfProductId;
    _numOfBuyField.borderStyle = UITextBorderStyleNone;
    _numOfBuyField.layer.borderWidth = 0.5;
    _numOfBuyField.layer.borderColor = [UIColor colorWithWhite:0.880 alpha:1.000].CGColor;
    
    [self initImageScrollView];
    isPageFirstLoad = YES;
    isFirstLoadOperationView = YES;
    isLogin = [self isUserLogin];
}

-(void)viewWillAppear:(BOOL)animated
{

//    _containsFunctionView.frame = CGRectMake(0, SCREEN_HEIGHT, 320, FunctionViewHeight);
    
    if (!_pNumber || [_pNumber length]!=0) {
        [self tilePages];
    }
    
    NSLog(@"_imageScrollView.frame = %@",NSStringFromCGRect(_imageScrollView.frame));
    heightOfImageScrollView = GET_VIEW_HEIGHT(_imageScrollView);
    
    
    if (isFirstLoadOperationView) {
        chooseViewTop = _chooseView.top;
        matchViewTop  = _viewOfMath.top;
        shareViewTop  = _shareView.top;
        bottomSjxTop  = _BottomSanJiaoXing.top;
        isFirstLoadOperationView = NO;
        _containsFunctionView.top = heightOfImageScrollView;
    }else{
        
    }

    if (isLogin != [self isUserLogin]) {
        //重新加载当前页数据便更新操作区
        if (!_pNumber || ![_pNumber length]) {
             [self requestDetailInfoAgainWhenUserLoginStateChanged];
        }else{
            //重新加载
            self.productId = _detailModel.productInfo.productId;
            [self requestDetailInfoAgainWhenUserLoginStateChanged];
        }
       
    }
    
    
    
    [self resetAllOperateViews];
  
    _BottomSanJiaoXing.hidden = YES;
//    _colorArr    = nil;
//    _sizeCodeArr = nil;
//    [_colorScrollView removeAllSubviews];
//    [_sizeScrollView removeAllSubviews];
    //20140730 修改
    //区分pid 和 pNumber 跳转的来源执行对应的方法
//    if (_pNumber && ![_pNumber isEqualToString:@""]) {
//        [self requestToGetProductDetailInfoBySKU];
//        return;
//    }
//    [self requestToGetProductDetailInfo];

    _chooseView.hidden  = YES;
    isFirstClick        = NO;
    _submitBtn.enabled  = YES;


    _numOfBuyField.text = @"1";
    [self changeProductDetailModelWithCurrentIdx];
    NSLog(@"_containsFunctionView.frame = %@",NSStringFromCGRect(_containsFunctionView.frame));

}

-(void)autoLayoutMaterialLabel
{
    NSString * strContent = [_detailModel.productInfo.productInfo stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    _material.top = 97.0;
    _infoView.height = 180.0;
    _material.height = 21;
    CGFloat height = [UILabel layoutLabelHeightText:strContent font:[UIFont systemFontOfSize:10.0] width:252.0 ];
    CGFloat deltaHeight = height - _material.height + 10;
    NSLog(@"_infoView.frame = %@",NSStringFromCGRect(_infoView.frame));
    _infoView.height = _infoView.height + deltaHeight;
    NSLog(@"_infoView.frame = %@",NSStringFromCGRect(_infoView.frame));
    _material.numberOfLines = 0;
    _material.text = strContent;
    _material.height = height;
    //    _material.top += 5.0;
}

-(void)viewWillDisappear:(BOOL)animated
{
    _submitBtn.enabled = YES;
}

/**
 *  更新界面显示
 */
-(void)updateSubviewShow
{
    //update at 20140731
    _pageControl = nil;
    _pageControl = [[XLPageControl alloc] init];

    
    //修改
    _customNavigationView = [[CustomNavigationBar alloc] initWithFrame:self.view.bounds];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    
    NSLog(@"url =  %@",_imagesUrlArr[0]);
    ProductInfoModel * productM = _detailModel.productInfo;
    productM.imageUrl = ([_detailModel.imageUrlArr count] >= 3)?_detailModel.imageUrlArr[2]:[_detailModel.imageUrlArr firstObject];
//    [self addProductInMyTrackWithProduct:_detailModel.productInfo];
    
//    [self addDetailImageScrollView];
    [self addDetailImageScrollViewWithThree];

    
    //添加matchView
    [self addMatchViewToScrollView];
    
    [_containsView bringSubviewToFront:_infoBtn];
    
    _containsFunctionView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, FunctionViewHeight)];
    
    [_containsFunctionView addSubview:_functionView];
    [_containsView addSubview:_containsFunctionView];
    [_containsView bringSubviewToFront:_containsFunctionView];
    
    //delegate
    _numOfBuyField.delegate = self;
    
    _imageScrollView.delegate = self;
    _imageScrollView.pagingEnabled = YES;
    [_containsView addSubview:_pageControl];

    _pageControl.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    
    /* Commit the animation */
    [UIView commitAnimations];
    //    NSLog(@"pageControl.frame = %@",NSStringFromCGRect(_pageControl.frame));
    _pageControl.frame = CGRectMake(0,150, 37, 200);
    //设置滑动手势
    
    [_containsView addSubview:_dragView];
    _dragView.animotionAction = ^(){
        [UIView animateWithDuration:0.5f animations:^{
            _containsFunctionView.frame = CGRectMake(0, GET_VIEW_HEIGHT(_containsView)-GET_VIEW_HEIGHT(_containsFunctionView), 320, FunctionViewHeight);
            [_containsView bringSubviewToFront:_containsFunctionView];
        }];
    };
    [_containsView bringSubviewToFront:_dragView];
    productTotalCount = [_detailModel.productInfo.storeCount intValue];
    [self showLikeButtonByIsCollectd];
    if (!_infoView.hidden) {
        [_containsView bringSubviewToFront:_infoView];
        _pageControl.hidden = YES;
    }else{
        _pageControl.hidden = NO;
    }
    [_containsView bringSubviewToFront:_infoView];
    
    //自动适应材料
    [self autoLayoutMaterialLabel];
}


/**
 *  增加详细图片的scrollview显示,用于左右换款
 */
-(void)addDetailImageScrollViewWithThree
{
    [_imageScrollView removeAllSubviews];
    CGPoint offSet = CGPointMake(320*_currentIndexOfProductId, 0);
    
    _imageScrollView.contentOffset = offSet;
    _imagesUrlArr = nil;
    
    if (!_imagesUrlArr) {
        
        _imagesUrlArr = [NSMutableArray arrayWithArray:_detailModel.imageUrlArr];
    }
}


/**
 *  根据上品详细信息 给指定的scrollView添加图片
 *
 *  @param scrollView
 *  @param productDetail
 */
-(void)createImageViewToScrollView:(UIScrollView *)scrollView withProductDetailInfo:(ProductDetailInfoModel *)productDetail
{
    [scrollView removeAllSubviews];
    NSArray * array = productDetail.imageUrlArr;

    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MRZoomScrollView * imageView ;
        if (SCREEN_HEIGHT==480) {
            imageView = [[MRZoomScrollView alloc] initWithFrame:CGRectMake(0, 460*idx, 320, 460)];
        }
        if (SCREEN_HEIGHT==568) {
            imageView = [[MRZoomScrollView alloc] initWithFrame:CGRectMake(0, 548*idx,320, 548)];
        }
        
        //根据URL 请求图片
        [imageView.imageView loadImage:(NSString *)obj];
        imageView.tag = SubViewTagOfCurrentScroll + idx;
        
        [scrollView addSubview:imageView];
        // 双击手势确定监测失败才会触发单击手势的相应操作
        [_singleTapGesture requireGestureRecognizerToFail:imageView.doubleTapGesture];
        
    }];
    
    
    if ([array count]!=0) {
        UIImageView * _viewOfOperate = [[UIImageView alloc] initWithFrame:CGRectMake(0, array.count*heightOfImageScrollView, 320, GET_VIEW_HEIGHT(_functionView))];
        _viewOfOperate.tag = SubViewTagOfCurrentScroll + array.count;
        if (_pNumber) {
            [_viewOfOperate addSubview:_operationView];
        }
        [_viewOfOperate addSubview:_operationView];
        [scrollView addSubview:_viewOfOperate];
        [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,(SCREEN_HEIGHT-20)*[productDetail.imageUrlArr count] + 53)];
    }

}

-(void)addMatchViewToScrollView
{
    [_detailModel.macthProducts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ProductInfoModel * product = (ProductInfoModel *)obj;
        int beishu = idx/3;
        
        
        MatchProduct * match = [[MatchProduct alloc] init];
        match.frame = CGRectMake(GET_VIEW_WIDTH(_subviewOfMath)*beishu  + (idx - beishu*3)*15 + 97*(idx%3), 0,97, GET_VIEW_HEIGHT(_subviewOfMath));
        [match showImageWithUrl:product.imageUrl  andPrice:product.price andProductId:product.productId];
        
        match.tapClick = ^(NSString * pid){
            ProductDetailInfoController * pdvc = [[ProductDetailInfoController alloc] init];
            pdvc.productId = pid;
            pdvc.productIdArr = [NSArray arrayWithObjects:pid, nil];
            pdvc.delegate = self.delegate;
            [self.navigationController pushViewController:pdvc animated:YES];
        };
        [_subviewOfMath addSubview:match];
        
    }];
    
    int num = [_detailModel.macthProducts count];
    
    CGFloat totalWidth = (num > 4 && num %4!=0)? (num/4+1)* GET_VIEW_WIDTH(_subviewOfMath):num/4*GET_VIEW_WIDTH(_subviewOfMath);
    _subviewOfMath.contentSize =CGSizeMake(totalWidth, GET_VIEW_HEIGHT(_subviewOfMath));
    
}

-(void)showLikeButtonByIsCollectd
{
    if (isCollected) {
        _likeView.selected = YES;
    }else{
        _likeView.selected = NO;
    }
    _bottomLikeView.selected = _likeView.selected;
}
#pragma mark - buttonMethods

- (IBAction)backToPreviousPageAction:(id)sender {
    
    NSLog(@"self.navigationController.viewControllers count= %d",[self.navigationController.viewControllers count]);
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Class cla = (Class)obj;
        NSLog(@"cla.desc = %@",[cla description]);
    }];
    
    
    NSLog(@"isScanPush = %d",_isScanPush);
    if (_isScanPush) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)twoTapClick:(id)sender {
    
    _infoView.hidden = YES;
    _BottomSanJiaoXing.hidden = YES;
    [self hideOtherView];
    _pageControl.hidden = !_infoView.hidden;
    [self.view bringSubviewToFront:_pageControl];
    
    //    UIView *view = [_imageScrollView subviews][0];
    _topView.hidden = !_topView.hidden;
    //    _viewOfMath.hidden = !_viewOfMath.hidden;
    
    
    [_containsView bringSubviewToFront:_viewOfMath];
    [_containsView bringSubviewToFront:_topView];

    
}

- (IBAction)_showProductInfoAction:(id)sender {
    if (!_detailModel) {
        _detailModel = _productMutableDic[_productIdArr[_currentIndexOfTopImageScroll]];
    }
     _infoView.hidden = !_infoView.hidden;
    
    _viewOfMath.hidden = YES;
    _chooseView.hidden = YES;
    _BottomSanJiaoXing.hidden = YES;
    [self.view bringSubviewToFront:_infoView];
    _info.text = _detailModel.productInfo.info;
    _productNO.text = _detailModel.productInfo.num;
    _price.text = _detailModel.productInfo.price;
//    _style.text = _detailModel.productInfo.style;
    _material.text = _detailModel.productInfo.material;

    if (!_infoView.hidden) {
        _infoView.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
             [self.view bringSubviewToFront:_infoView];
            _infoView.alpha =1.0;
        }];
        _pageControl.hidden = YES;
    }else{
        _pageControl.hidden = NO;
    }
    [self autoLayoutMaterialLabel];
}

- (IBAction)closeInfoViewAction:(id)sender {
    _infoView.hidden = YES;
    _pageControl.hidden = NO;
}


-(void)updateColorAndSizeScrollView
{
    _colorScrollView.pagingEnabled = YES;
    _colorScrollView.showsVerticalScrollIndicator = NO;
    _colorScrollView.showsHorizontalScrollIndicator = NO;
    [_colorScrollView removeAllSubviews];
    [_sizeScrollView removeAllSubviews];
    
    if ([_detailModel.colorArr count] <=5) {
        _colorScrollView.pagingEnabled = NO;
    }
    
    for (NSUInteger idx=0; idx<[_detailModel.colorArr count];  idx++) {
        
        //        NSString * value = _colorArr[idx];
        
        ColorModel * colorM = _detailModel.colorArr[idx];
        
        NSLog(@"colorM = %@",colorM);
        
        NSUInteger beishu = idx/ShowButtonCount;
        ColorButton * lblBtn = [ColorButton buttonWithType:UIButtonTypeCustom];
        lblBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        lblBtn.color = colorM;
        lblBtn.tag = [colorM.number intValue];
        [lblBtn setTitle:colorM.name forState:UIControlStateNormal];
        lblBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //设置边框 背景色
        [lblBtn setBackgroundImage:[UIImage imageNamed:@"canSelectBg.png"] forState:UIControlStateNormal];
        [lblBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [lblBtn addTarget:self action:@selector(getColorWhenColorPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [_colorScrollView addSubview:lblBtn];
        
        if (beishu == 0) {
            lblBtn.frame = CGRectMake((ColorPaddingLeft + ColorSizeWidth)*idx ,  ColorPaddingTop, ColorSizeWidth, ColorSizeHeight);
        }else
        {
            lblBtn.frame = CGRectMake(GET_VIEW_WIDTH(_colorScrollView)*beishu + (ColorPaddingLeft + ColorSizeWidth)*(idx - beishu*ShowButtonCount),  ColorPaddingTop, ColorSizeWidth, ColorSizeHeight);
        }
        
        [lblBtn.titleLabel setTextColor:[UIColor blackColor]];
        if ([_detailModel.productInfo.color isEqualToString:colorM.name] ) {
            [lblBtn setBackgroundImage:[UIImage imageNamed:@"selectedBgImage.png"] forState:UIControlStateNormal];
            [lblBtn.titleLabel setTextColor:[UIColor whiteColor]];
            _selectedColorBtn = lblBtn;
            [self getColorWhenColorPressed:_selectedColorBtn];
        }
        
    }
    
    NSUInteger num = [_colorScrollView.subviews count];
    CGFloat totalWidth = (num > ShowButtonCount && num %ShowButtonCount!=0)? (num/ShowButtonCount+1)* GET_VIEW_WIDTH(_colorScrollView):num/ShowButtonCount*GET_VIEW_WIDTH(_colorScrollView);
    _colorScrollView.contentSize =CGSizeMake(totalWidth, GET_VIEW_HEIGHT(_colorScrollView));
    
    _sizeCodeArr = nil;
    if (!_sizeCodeArr) {
        _sizeCodeArr = [NSMutableArray arrayWithArray:_detailModel.sizeArr];
    }
    
    [self updateShowSizeButtons];
}


-(void)updateShowSizeButtons
{
    currentPageIndex = 0;
    [_sizeScrollView removeAllSubviews];
    BOOL defaultSelected = NO;
    
    for (NSUInteger idx=0; idx<[_sizeCodeArr count]; idx++) {
        SizeModel * sModel = _sizeCodeArr[idx];
        NSUInteger beishu = idx/ShowButtonCount;
        CustomNewSizeButton * lblBtn = [[CustomNewSizeButton alloc] init];
        
        //设置边框 背景色
        lblBtn.size = sModel;
        lblBtn.codeLbl.text = sModel.name;
        lblBtn.sizeLbl.text = sModel.pName;
        //设置边框 背景色
        if ([sModel.active intValue]==1) {
            
            [lblBtn setBackgroundImage:[UIImage imageNamed:@"canSelectBg.png"] forState:UIControlStateNormal];
        }else{
            lblBtn.enabled = NO;
            [lblBtn setBackgroundImage:[UIImage imageNamed:@"canNotSelectBg.png"] forState:UIControlStateNormal];
        }
        [lblBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [lblBtn addTarget:self action:@selector(getSizeWhenSizePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [_sizeScrollView addSubview:lblBtn];
        if (beishu == 0) {
            lblBtn.frame = CGRectMake((ColorPaddingLeft + ColorSizeWidth)*idx ,  ColorPaddingTop, ColorSizeWidth, ColorSizeHeight);
        }else
        {
            lblBtn.frame = CGRectMake(GET_VIEW_WIDTH(_colorScrollView)*beishu + (ColorPaddingLeft + ColorSizeWidth)*(idx - beishu*ShowButtonCount),  ColorPaddingTop, ColorSizeWidth, ColorSizeHeight);
        }
        [lblBtn.titleLabel setTextColor:[UIColor blackColor]];
        if (!defaultSelected && [sModel.active intValue]==1) {
            //默认选中第一个可选项
            [lblBtn setBackgroundImage:[UIImage imageNamed:@"selectedBgImage.png"] forState:UIControlStateNormal];
            lblBtn.codeLbl.textColor = [UIColor whiteColor];
            lblBtn.sizeLbl.textColor = [UIColor whiteColor];
            _selectedSizeBtn = lblBtn;
            defaultSelected = YES;
            [self getSizeWhenSizePressed:_selectedSizeBtn];
        }
        
    }
    
    NSUInteger sizeNum = [_sizeScrollView.subviews count];
    CGFloat totalWidthOfSize = (sizeNum > ShowButtonCount && sizeNum %ShowButtonCount!=0)? (sizeNum/ShowButtonCount+1)* GET_VIEW_WIDTH(_sizeScrollView):sizeNum/ShowButtonCount*GET_VIEW_WIDTH(_sizeScrollView);
    _sizeScrollView.contentSize =CGSizeMake(totalWidthOfSize, GET_VIEW_HEIGHT(_sizeScrollView));
}


-(void)getColorWhenColorPressed:(id)sender
{
    ColorButton * btn = (ColorButton *)sender;
    [btn setBackgroundImage:[UIImage imageNamed:@"selectedBgImage.png"] forState:UIControlStateNormal];
    _selectedColor = btn.currentTitle;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSLog(@"_selectedColor = %@",_selectedColor);
    
    if (_selectedColorBtn != btn && _selectedColorBtn !=Nil) {
        [_selectedColorBtn setBackgroundImage:[UIImage imageNamed:@"canSelectBg.png"] forState:UIControlStateNormal];
        [_selectedColorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    _selectedColorBtn = btn;
    [self requestToGetAllSizeByProductNumber:btn.color.number];
}

-(void)getSizeWhenSizePressed:(id)sender
{
    
    CustomNewSizeButton * btn = (CustomNewSizeButton *)sender;
    [btn setBackgroundImage:[UIImage imageNamed:@"selectedBgImage.png"] forState:UIControlStateNormal];
    _selectedSize = btn.codeLbl.text;
    btn.codeLbl.textColor = [UIColor whiteColor];
    btn.sizeLbl.textColor = [UIColor whiteColor];
    NSLog(@"_selectedSize = %@",_selectedSize);
    
    if (_selectedSizeBtn != btn && _selectedSizeBtn !=Nil) {
        [_selectedSizeBtn setBackgroundImage:[UIImage imageNamed:@"canSelectBg.png"] forState:UIControlStateNormal];
        _selectedSizeBtn.codeLbl.textColor = [UIColor blackColor];
        _selectedSizeBtn.sizeLbl.textColor = [UIColor darkGrayColor];
        
    }
    _selectedSizeBtn = btn;
    _numOfBuyField.text =@"1";
    NSLog(@"---------------snumber = %@",_selectedSizeBtn.size.snumber);
    
    NSString * pnum9 = [[_detailModel.productInfo.num substringWithRange:NSMakeRange(0, 9)] stringByAppendingFormat:@"%@%@",_selectedColorBtn.color.number,_selectedSizeBtn.size.snumber];
    [self RequestStorgeNumberByPnumber:pnum9];
}

- (IBAction)closeMatchViewAction:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        [self resetAllOperateViews];
    }completion:^(BOOL finished) {
        if (finished) {
            _viewOfMath.hidden = YES;
            _BottomSanJiaoXing.hidden = YES;
        }
    }];
}

- (IBAction)likeAction:(id)sender {
    NSLog(@"喜欢........");
    
    if (![self judgeUserIsLogin]) {
        return;
    }

    if (isCollected) {
        [self sendRequestTodeleteCollectInfo];
    }else{
        [self sendRequestToAddProductInCollect];
    }
    
}

- (IBAction)showChooseViewAction:(id)sender {
    NSLog(@"购买........");
    
    if (_chooseView.top == chooseViewTop && _BottomSanJiaoXing.left == 25) {
        [UIView animateWithDuration:0.5 animations:^{
           [self resetAllOperateViews];
        }];
        return;
    }
    
    [self resetAllOperateViews];
    _infoView.hidden = YES;
    _viewOfMath.hidden = YES;
    _shareView.hidden = YES;
    _BottomSanJiaoXing.left = 25;
    _BottomSanJiaoXing.hidden = NO;
    isBuyNow = NO;
    _numOfBuyField.text = @"1";
    [self showColorAndSizeView];
    [UIView animateWithDuration:0.5 animations:^{
        _chooseView.top = chooseViewTop;
        _BottomSanJiaoXing.top = bottomSjxTop;
    }];
}


/**
 *  显示颜色和尺码
 */
-(void)showColorAndSizeView
{
    if (![self judgeUserIsLogin]) {
        return;
    }
    
    NSLog(@"_totalCount = %d",productTotalCount);
    
    if ([_numOfBuyField.text intValue] == 1) {
        _reduceBtn.enabled = NO;
    }
    
    if ([_numOfBuyField.text intValue] == productTotalCount) {
        _addBtn.enabled = NO;
    }
    _chooseView.hidden = NO;
    [_containsView addSubview:_chooseView];
    [_containsView bringSubviewToFront:_chooseView];
}


- (IBAction)showShareView:(id)sender {
    NSLog(@"分享........");
    if (_shareView.top == shareViewTop) {
        [UIView animateWithDuration:0.5 animations:^{
            [self resetAllOperateViews];
        }];
        return;
    }
    
    [self resetAllOperateViews];
    _viewOfMath.hidden = YES;
    _chooseView.hidden = YES;
    _BottomSanJiaoXing.left = 283;
    _BottomSanJiaoXing.hidden = NO;
    _shareView.hidden = NO;
    [_containsView bringSubviewToFront:_shareView];
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.top = shareViewTop;
        _BottomSanJiaoXing.top = bottomSjxTop;
    }];
}

#pragma mark 分享到新浪
- (IBAction)shareSinaPressAction:(id)sender {
    NSLog(@"url = %@",_detailModel.productInfo.shareUrl);
    /*************** 直接分享内容到新浪 *************/
    /*
    [[UMSocialDataService defaultDataService] setSocialData:[UMSocialData defaultData]];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                        _detailModel.productInfo.imageUrl];
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_detailModel.productInfo.info]]];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",_detailModel.productInfo.info,_detailModel.productInfo.shareUrl] image:image location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        btn.enabled = YES;
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"分享成功" inSeconds:1];
        }else{
            [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"分享失败" inSeconds:1];
        }
    }];
    */
    
    
      /*************** 带编辑页分享到到新浪 *************/
    
    
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop];
    UMSocialData * socialData = [UMSocialData defaultData];
    socialData.urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                              _detailModel.productInfo.imageUrl];
    socialData.shareImage =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_detailModel.productInfo.info]]];
    socialData.shareText = [NSString stringWithFormat:@"%@\n%@\n",_detailModel.productInfo.info,_detailModel.productInfo.shareUrl];
    __unsafe_unretained ProductDetailInfoController * productController = self;
    
    UMSocialControllerService * umSvc = [[UMSocialControllerService defaultControllerService] initWithUMSocialData:socialData];
    
    umSvc.socialUIDelegate = productController;
    
//    [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",_detailModel.productInfo.info,_detailModel.productInfo.shareUrl] shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_detailModel.productInfo.info]]] socialUIDelegate:productController];
    
    //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"分享成功" inSeconds:1];
    }else{
        [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"分享失败" inSeconds:1];
    }

}


- (IBAction)shareFriendsPressAction:(id)sender {
    
    NSLog(@"朋友圈分享");
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = _detailModel.productInfo.shareUrl;
    UMSocialUrlResource * urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_detailModel.productInfo.imageUrl];
    
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_detailModel.productInfo.info]]];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_detailModel.productInfo.info image:image location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"分享成功" inSeconds:1];
        }else{
            [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"分享失败" inSeconds:1];
        }
    }];
    
}

- (IBAction)closeShareViewAction:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self resetAllOperateViews];
    }completion:^(BOOL finished) {
        if (finished) {
            [self hideShareView];
        }
    }];
}


- (IBAction)buyNowAction:(id)sender {
    
    //update by pk at 20140505
    if (_chooseView.top == chooseViewTop &&_BottomSanJiaoXing.left == 70) {
        [UIView animateWithDuration:0.5 animations:^{
            [self resetAllOperateViews];
        }];
        return;
    }
    
    [self resetAllOperateViews];
    _infoView.hidden = YES;
    _viewOfMath.hidden = YES;
    _shareView.hidden = YES;
    _BottomSanJiaoXing.left = 70;
    _BottomSanJiaoXing.hidden = NO;
    
    isBuyNow = YES;
    _numOfBuyField.text = @"1";
    [self showColorAndSizeView];
    [UIView animateWithDuration:0.5 animations:^{
        _chooseView.top = chooseViewTop;
        _BottomSanJiaoXing.top = bottomSjxTop;
    }];
}

- (IBAction)closeChooseShopCarViewAction:(id)sender {

    [UIView animateWithDuration:0.5 animations:^{
        [self resetAllOperateViews];
    } completion:^(BOOL finished) {
        if (finished) {
                [_chooseView removeFromSuperview];
        }
    }];
    
    _BottomSanJiaoXing.hidden = YES;
}

-(void)resetAllOperateViews
{
    _chooseView.top   = heightOfImageScrollView;
    _viewOfMath.top   = heightOfImageScrollView;
    _shareView.top    = heightOfImageScrollView;
    _BottomSanJiaoXing.top = heightOfImageScrollView;
}


- (IBAction)reduceProductAction:(id)sender {
    
    if ([_numOfBuyField.text intValue]<=1)
        return;
    buyCount = [_numOfBuyField.text intValue];
    buyCount--;
    _numOfBuyField.text = [NSString stringWithFormat:@"%d",buyCount];
    if (buyCount == 1) {
        _reduceBtn.enabled = NO;
    }
    _addBtn.enabled = YES;
}

- (IBAction)addProductAction:(id)sender {
    
    NSLog(@"addBtn click");
    
    buyCount = [_numOfBuyField.text intValue];
    if (buyCount >= productTotalCount) {
        
        NSString *msg = [NSString stringWithFormat:@"库存不足，目前只剩 %d 件",productTotalCount];
        [self showPromotMsgView:msg];
        _numOfBuyField.text = [NSString stringWithFormat:@"%d",productTotalCount];
        _addBtn.enabled = NO;
        if ([_numOfBuyField.text intValue] <=1) {
            _numOfBuyField.text = @"1";
            _reduceBtn.enabled = NO;
        }
        return ;
    }
    
    buyCount++;
    _numOfBuyField.text = [NSString stringWithFormat:@"%d",buyCount];
    if (buyCount>1) {
        _reduceBtn.enabled = YES;
    }
    if (buyCount == productTotalCount) {
        _addBtn.enabled = NO;
    }
}

/**
 *  显示提示框
 */
- (void)showPromotMsgView:(NSString *)msg
{
    //update by pk at 20140509
//    _remindLbl.center = self.view.center;
    _remindLbl.text = msg;
    
    [UIView animateWithDuration:0.3 animations:^{
        _remindLbl.hidden = NO;
        [_containsView bringSubviewToFront:_remindLbl];
    }];
    
     [self performSelector:@selector(makeAlertDismiss) withObject:Nil afterDelay:2.0f];
}

-(void)makeAlertDismiss
{
//    [_alertView dismissWithClickedButtonIndex:[_alertView cancelButtonIndex] animated:YES];
    _remindLbl.hidden = YES;
    [_containsView sendSubviewToBack:_remindLbl];
}

- (IBAction)submitBuyAction:(id)sender {
    if ([self.product.state isEqualToString:@"-1"] || [self.product.state isEqualToString:@"2"]) {
        [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"商品已下架" inSeconds:1.5];
        return;
    }
    
    NSLog(@"submitBtn click");
    NSString * pnum9 = [[_detailModel.productInfo.num substringWithRange:NSMakeRange(0, 9)] stringByAppendingFormat:@"%@%@",_selectedColorBtn.color.number,_selectedSizeBtn.size.snumber];
    [self RequestStorgeByPnumber:pnum9];
}

- (IBAction)showMathViewAction:(id)sender {
   
    if (_viewOfMath.top == matchViewTop) {
        [UIView animateWithDuration:0.5 animations:^{
            [self resetAllOperateViews];
        }];
        return;
    }

    [self resetAllOperateViews];
  
    _BottomSanJiaoXing.hidden = YES;
    if (_detailModel.macthProducts.count == 0) {
        [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"暂无搭配商品" inSeconds:1.0];
        return;
    }
    
    _infoView.hidden = YES;
    _chooseView.hidden = YES;
    _shareView.hidden = YES;
    _viewOfMath.hidden = NO;
    _BottomSanJiaoXing.left = 183;
    _BottomSanJiaoXing.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        _viewOfMath.top = matchViewTop;
        _BottomSanJiaoXing.top = bottomSjxTop;
    }];
}

#pragma mark - textFieldDelegateMethod

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    isBigThanStorageNumber =  NO;
    if ([textField.text intValue]> productTotalCount) {
        NSString *msg = [NSString stringWithFormat:@"库存不足，目前只剩 %d 件",productTotalCount];
        [self showPromotMsgView:msg];
        isBigThanStorageNumber = YES;
        textField.text = [NSString stringWithFormat:@"%d",productTotalCount];
    }
    if ([textField.text intValue]== 0) {
        textField.text = @"1";
    }
    if ([_numOfBuyField.text intValue] == 1) {
        _reduceBtn.enabled = NO;
        //_reduceBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
    if ([_numOfBuyField.text intValue] == productTotalCount) {
        _addBtn.enabled = NO;
        //_addBtn.backgroundColor = [UIColor lightGrayColor];
        if ([_numOfBuyField.text intValue] != 1) {
            _reduceBtn.enabled = YES;
            //_reduceBtn.backgroundColor = [UIColor blackColor];
        }
    }else{
        _addBtn.enabled = YES;
        //_addBtn.backgroundColor = [UIColor blackColor];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self clearCache];
}

#pragma mark - scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSLog(@"_currentScrollInScreen.frame = %@",NSStringFromCGRect(_currentScrollInScreen.frame));
    if (_imageScrollView == scrollView) {
        
        if ([self isCurrentPageIndexChanged]) {
            [self.view sendSubviewToBack:_containsFunctionView];
            [self hideAllViewWhenSwipeTOLeftOrRight];
            [self resetAllOperateViews];
            [self tilePages];

        }
        isPageChanged = YES;
        return;
    }
    //根据当前的坐标获取当前屏幕显示的scrollView对象
    
    NSLog(@"_currentScrollInScreen.frame = %@",NSStringFromCGRect(_currentScrollInScreen.frame));
    if (scrollView == _currentScrollInScreen) {
        if (isPageChanged) {
            isPageChanged = NO;
            return;
        }
        int temp = scrollView.contentOffset.y / heightOfImageScrollView;
        UIView * view = [_currentScrollInScreen viewWithTag:SubViewTagOfCurrentScroll + _detailModel.imageUrlArr.count];
        [view addSubview:_operationView];
        page = temp + 1;
        _pageControl.currentPage = temp;
        
        //   450 - 拉起高度（scroll高度 - y）如果小于150就是超过半屏
        float scrollScreen = heightOfImageScrollView * page - (scrollView.contentOffset.y + heightOfImageScrollView);
        //下划
        if (currentY > scrollView.contentOffset.y || scrollView.contentOffset.y <= 1) {
            isDown = YES;
            
            //正好到一屏时候
            CGFloat ht = 0;
            if (IOS7) {
                ht =SCREEN_HEIGHT - GET_VIEW_HEIGHT(_containsFunctionView);
            }else{
                ht =SCREEN_HEIGHT - GET_VIEW_HEIGHT(_containsFunctionView) - 20;
            }
            
            NSLog(@"ht = %f",ht);
            if (1 > scrollScreen && -1 < scrollScreen ) {
                
                _containsFunctionView.top = ht;
                NSLog(@"opreateView.frame = %@",NSStringFromCGRect(_containsFunctionView.frame));
                if (![self.view.subviews containsObject:_containsFunctionView]) {
                    [self.view addSubview:_containsFunctionView];
                }
            }             
        } else {    //上划
            isDown = NO;
            //超过半屏
            if (heightOfImageScrollView/2 < heightOfImageScrollView - ((page * heightOfImageScrollView) - scrollView.contentOffset.y)) {
                [self layoutAllViewFrame:NO];
            } else {
                [self layoutAllViewFrame:YES];
            }
        }
        currentY = scrollView.contentOffset.y;
    }
}


//滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_imageScrollView == scrollView) {
        _currentIndexOfTopImageScroll = [self getCurrentPageIndex];
        self.productId = _productIdArr[_currentIndexOfTopImageScroll];
        
        return;
    }
    int index = fabs(scrollView.contentOffset.y) / scrollView.frame.size.height;   //当前是第几个视图
   
    _pageControl.currentPage = index;
    [self setPostionForScrollViewByPageControl];
}


//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    if (scrollView == _imageScrollView) {
        return;
    }

    startDragOfContentSet = scrollView.contentOffset;
    [self hideOtherView];
    [_numOfBuyField resignFirstResponder];
    
    //记录时间
    _touchStartDate = nil;
    _touchStartDate = [NSDate date];
}

//第一种方式
//完成拖拽

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _imageScrollView) {
        if ([self isCurrentPageIndexChanged]) {
//            [self tilePages];
           
        }
        return;
    }
    [self setPostionForScrollViewByPageControl];
}


#pragma mark - 其他方法
/**
 *  隐藏搭配、选择、分享视图
 */
-(void)hideOtherView
{
    [_numOfBuyField resignFirstResponder];
    [self resetAllOperateViews];
}

-(void)showFunctionView
{
    
    [UIView animateWithDuration:0.2 animations:^{
        _containsFunctionView.hidden = NO;
        _containsFunctionView.frame = CGRectMake(0, GET_VIEW_HEIGHT(_containsView)-GET_VIEW_HEIGHT(_containsFunctionView), 320, FunctionViewHeight);
        [_containsView bringSubviewToFront:_containsFunctionView];
    }];
    
}

-(void)hideFunctionView
{
    [UIView animateWithDuration:0.2 animations:^{
        _containsFunctionView.hidden = YES;
        _containsFunctionView.frame = CGRectMake(0, heightOfImageScrollView, 320, FunctionViewHeight);
    }];
}


-(void)hideShareView
{
    _containsFunctionView.hidden = NO;
    _BottomSanJiaoXing.hidden = YES;
    _shareView.hidden = YES;
    [_containsView sendSubviewToBack:_shareView];
}


#pragma mark  增加我的足迹
-(void)addProductInMyTrackWithProduct:(ProductInfoModel *)productInfo
{
    if (!productInfo) {
        return;
    }
    CoreDataManagerGlobalSetting(@"SqlModel", @"coreData.sqlite");
    //查询所有足迹，有相同productId 的商品更新对应的时间 ，没有则创建一个新的
    
    MyTrack * track = [MyTrack find:@{@"productId":productInfo.productId }];
    if (track) {
        track.imageUrl = productInfo.imageUrl;
        track.productInfo = productInfo.info;
        track.productPrice = productInfo.price;
        track.date = [NSDate date];
        [track save];
    }else{
        MyTrack * instance = [MyTrack create];
        instance.productId = productInfo.productId;
        instance.imageUrl = productInfo.imageUrl;
        instance.productInfo = productInfo.info;
        instance.productPrice = productInfo.price;
        instance.date = [NSDate date];
        [instance save];
    }
}



#pragma mark - request methods

-(void)requestDetailInfoAgainWhenUserLoginStateChanged
{
    if (!_productId || [_productId isEqualToString:@""]) {
        return ;
    }
    
    NSLog(@"productId = %@",_productId);
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    
    [parameter setObject:_productId forKey:@"productId"];
    
    
    //    [parameter setObject:@"181" forKey:@"productId"];
    if (DATA_ENV.userInfo.userId) {
        [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    }
    
    [RequestToGetProdeuctDetailInfo requestWithParameters:parameter
                                        withIndicatorView:nil
                                        withCancelSubject:@"RequestToGetProdeuctDetailInfo"
                                           onRequestStart:nil
                                        onRequestFinished:^(ITTBaseDataRequest *request) {
                                            if ([request isSuccess]) {
                                                _detailModel = request.handleredResult[@"keyModel"];
                                                self.product = _detailModel.productInfo;
                                                NSLog(@"_detailModel = %@",_detailModel);
                                                [_productMutableDic setObject:_detailModel forKey:_detailModel.productInfo.productId];
                                                [self changeProductDetailModelWithCurrentIdx];
                                            }
                                            
                                            
                                        } onRequestCanceled:nil
                                          onRequestFailed:^(ITTBaseDataRequest *request) {
                                              _infoBtn.hidden = YES;
                                          }];
}

-(void)requestToGetProductDetailInfo
{
    if (!_productId || [_productId isEqualToString:@""]) {
        return ;
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    
    [parameter setObject:_productId forKey:@"productId"];
    
    
    //    [parameter setObject:@"181" forKey:@"productId"];
    if (DATA_ENV.userInfo.userId) {
            [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    }

    [RequestToGetProdeuctDetailInfo requestWithParameters:parameter
                                        withIndicatorView:nil
                                        withCancelSubject:@"RequestToGetProdeuctDetailInfo"
                                           onRequestStart:nil
                                        onRequestFinished:^(ITTBaseDataRequest *request) {
                                            if ([request isSuccess]) {
                                                _detailModel = request.handleredResult[@"keyModel"];
                                                self.product = _detailModel.productInfo;
                                                NSLog(@"_detailModel = %@",_detailModel);
                                                [_productMutableDic setObject:_detailModel forKey:_detailModel.productInfo.productId];
                                                [self updateSubviewShow];
                                                [self changeProductDetailModelWithCurrentIdx];
                                            }
                                            
                                            
                                        } onRequestCanceled:nil
                                          onRequestFailed:^(ITTBaseDataRequest *request) {
                                              _infoBtn.hidden = YES;
                                          }];
    
}

-(void)requestToGetProductDetailInfoBySKU
{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    
    [parameter setObject:_pNumber forKey:@"pnumber"];
    
    if (DATA_ENV.userInfo.userId) {
        [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    }
    
    [RequestToGetProdeuctDetailInfoBySkuCode requestWithParameters:parameter
                                        withIndicatorView:self.view
                                        withCancelSubject:@"RequestToGetProdeuctDetailInfoBySkuCode"
                                           onRequestStart:nil
                                        onRequestFinished:^(ITTBaseDataRequest *request) {
                                            
                                            if ([request isSuccess]) {
                                                _detailModel = request.handleredResult[@"keyModel"];
                                                self.product = _detailModel.productInfo;
                                                NSLog(@"_detailModel = %@",_detailModel);
                                                _recordCollectId = request.handleredResult[@"data"][@"collectId"];
                                                NSLog(@"_recordCollectId = %@",_recordCollectId);
                                                
                                                if (![(request.handleredResult[@"data"][@"collectId"]) isEqualToString:@""]) {
                                                    isCollected = YES;
                                                }
                                                [_productMutableDic setObject:_detailModel forKey:_detailModel.productInfo.productId];
                                                [self updateSubviewShow];
                                                [self updateColorAndSizeScrollView];
                                                UIScrollView * scr = [[UIScrollView alloc] initWithFrame:_imageScrollView.bounds];
                                                scr.delegate =self;
                                                _currentScrollInScreen = scr;
                                                
                                                [self fillImageForImageScrollViewWithProductDetailInfo:_detailModel andSupView:scr];
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
    NSString * numPara = [_detailModel.productInfo.num substringWithRange:NSMakeRange(0, 9)];
    NSLog(@"numPara = %@",numPara);
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    NSString * value = [numPara stringByAppendingString:colorNum];
    NSLog(@"value =  %@",value);
    
    [parameter setObject:value forKey:@"pnumber12"];
    
    //update by pk at 20140505 for test
    
//    [parameter setObject:_detailModel.productInfo.num forKey:@"pnumber"];
//    [parameter setObject:colorNum forKey:@"cnumber"];
    
    
    [RequestToGetSizeArrayByColor requestWithParameters:parameter
                                      withIndicatorView:nil
                                      withCancelSubject:@"RequestToGetSizeArrayByColor"
                                         onRequestStart:nil
                                      onRequestFinished:^(ITTBaseDataRequest *request) {
                                          
                                          if ([request isSuccess]) {
                                              
                                              _sizeCodeArr = nil;
                                            
                                              _sizeCodeArr = [NSMutableArray arrayWithArray:request.handleredResult[@"keyModel"]];
                                              
                                              NSLog(@"data = %@",request.handleredResult[@"data"]);
                                              NSLog(@"_sizeCodeArr = %@",_sizeCodeArr);
                                              [self updateShowSizeButtons];
                                          }
                                          
                                          
                                      } onRequestCanceled:nil
                                        onRequestFailed:^(ITTBaseDataRequest *request) {
                                            
                                        }];
}


/**
 *  给服务器发送请求，删除收藏信息
 *
 *  @param index 索引值
 */
-(void)sendRequestTodeleteCollectInfo
{
    if (!_recordCollectId || [_recordCollectId intValue]==-1) {
        return;
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    [parameter setObject:_recordCollectId forKey:@"collectId"];
    
    [DeleteFavoriteRequest requestWithParameters:parameter
                               withIndicatorView:nil
                               withCancelSubject:@"DeleteFavoriteRequest"
                                  onRequestStart:nil
                               onRequestFinished:^(ITTBaseDataRequest *request) {
                                   
                                   if ([request isSuccess]) {
                                       isCollected = NO;
                                       [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"已取消收藏" inSeconds:1.0];
                                       [self showLikeButtonByIsCollectd];
                                       _detailModel.collectId = @"";
                                       [_productMutableDic setObject:_detailModel forKey:_detailModel.productInfo.productId];
                                       if ([_delegate respondsToSelector:@selector(makeCollectTableViewRefresh)]) {
                                           [_delegate makeCollectTableViewRefresh];
                                       }
                                   }
                                   
                               } onRequestCanceled:nil
                                 onRequestFailed:^(ITTBaseDataRequest *request) {
                                     
                                 }];
    
}

/**
 *  给服务器发送请求，增加收藏信息
 *
 *  @param index 索引值
 */
-(void)sendRequestToAddProductInCollect
{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    [parameter setObject:_detailModel.productInfo.num forKey:@"pnumber"];
    [parameter setObject:_detailModel.productInfo.productId forKey:@"productId"];
    //新增系统标签参数 at 20140704 by Pk
    [parameter setObject:AppSystemId forKey:@"brandCode"];

    
    [AddFavoriteRequest requestWithParameters:parameter
                            withIndicatorView:nil
                            withCancelSubject:@"AddFavoriteRequest"
                               onRequestStart:nil
                            onRequestFinished:^(ITTBaseDataRequest *request) {
                                if ([request isSuccess]) {
                                    isCollected = YES;
                                    [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"收藏成功" inSeconds:1.0];
                                    [self showLikeButtonByIsCollectd];
                                    _recordCollectId = [NSString stringWithFormat:@"%@",request.handleredResult[@"data"]];
                                    _detailModel.collectId =_recordCollectId;
                                    [_productMutableDic setObject:_detailModel forKey:_detailModel.productInfo.productId];
                                    if ([_delegate respondsToSelector:@selector(makeCollectTableViewRefresh)]) {
                                        [_delegate makeCollectTableViewRefresh];
                                    }
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
                                        self.product = nil;
                                        self.product = [[ProductInfoModel alloc] initWithDataDic:request.handleredResult[@"data"]];
                                        productTotalCount = [self.product.storeCount intValue];
                                        
                                        if ([_numOfBuyField.text intValue] == 1) {
                                            _reduceBtn.enabled = NO;
                                        }
                                        if ([_numOfBuyField.text intValue] == productTotalCount) {
                                            _addBtn.enabled = NO;
                                        }else{
                                            _addBtn.enabled = YES;
                                        }
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
-(void)RequestStorgeByPnumber:(NSString *)pnumber
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
                                        self.product = nil;
                                        self.product = [[ProductInfoModel alloc] initWithDataDic:request.handleredResult[@"data"]];
                                        productTotalCount = [self.product.storeCount intValue];
                                        
                                        if ([_numOfBuyField.text intValue] == 1) {
                                            _reduceBtn.enabled = NO;
                                            //_reduceBtn.backgroundColor = [UIColor lightGrayColor];
                                        }
                                        
                                        if ([_numOfBuyField.text intValue] == productTotalCount) {
                                            _addBtn.enabled = NO;
                                            //_addBtn.backgroundColor = [UIColor lightGrayColor];
                                        }else{
                                            _addBtn.enabled = YES;
                                            //_addBtn.backgroundColor = [UIColor blackColor];
                                        }
                                        
                                        //update at 20140529
                                        if (productTotalCount == 0 || [_numOfBuyField.text intValue]>productTotalCount) {
                                            NSString *msg = [NSString stringWithFormat:@"抱歉,此件商品库存不足"];
                                            
                                            _numOfBuyField.text = [NSString stringWithFormat:@"%d",productTotalCount];
                                            [_numOfBuyField resignFirstResponder];
                                            [self showPromotMsgView:msg];
                                            return ;
                                        }
                                        
                                        NSString * pnumber = [[_detailModel.productInfo.num substringWithRange:NSMakeRange(0, 9)] stringByAppendingFormat:@"%@%@",_selectedColorBtn.color.number,_selectedSizeBtn.size.snumber];
                                        
                                        if (isBuyNow) {
                                            
                                            if (!isFirstClick) {
                                                isFirstClick = YES;
                                                _submitBtn.enabled = NO;
                                                NSString * plist = [NSString stringWithFormat:@"%@_%@",pnumber,_numOfBuyField.text];
                                                [self requestToGoToPay:plist];
                                            }
                                            
                                        }else{
                                            [self requestToAddProductInShopCarWithPNumber:pnumber];
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
-(void)requestToAddProductInShopCarWithPNumber:(NSString *)pnumber {
  
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    [parameter setObject:_detailModel.productInfo.productId forKey:@"productId"];
    [parameter setObject:pnumber forKey:@"pnumber"];
//    [parameter setObject:[NSNumber numberWithInt:buyCount] forKey:@"count"];
    [parameter setObject:_numOfBuyField.text forKey:@"count"];
    //新增系统标签参数 at 20140704 by Pk
    [parameter setObject:AppSystemId forKey:@"brandCode"];
    
    [AddCartRequest requestWithParameters:parameter
                        withIndicatorView:nil
                        withCancelSubject:@"AddCartRequest"
                           onRequestStart:nil
                        onRequestFinished:^(ITTBaseDataRequest *request) {
                            
                            if ([request isSuccess]) {
                                [[ActivityRemindView loadFromXib] showActivityViewInView:self.view withMsg:@"添加成功" inSeconds:1.0];
                                [self hideOtherView];
                            }else{
                                [UIAlertView promptTipViewWithTitle:Nil message:request.handleredResult[@"messg"] cancelBtnTitle:@"确认" otherButtonTitles:Nil onDismiss:^(int buttonIndex) {
                                } onCancel:^{
                                    
                                }];
                            }
                        } onRequestCanceled:nil
                          onRequestFailed:^(ITTBaseDataRequest *request) {
                              
                          }];
}

/**
 *  立刻购买
 */
-(void)requestToGoToPay:(NSString *)plist
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    
    [parameter setObject:@0 forKey:@"isShopcarts"];
    [parameter setObject:plist forKey:@"plist"];
    //新增系统标签参数 at 20140704 by Pk
    [parameter setObject:AppSystemId forKey:@"brandCode"];
    
    [RequestToCreateOrderAndGoToPay requestWithParameters:parameter
                        withIndicatorView:nil
                        withCancelSubject:@"RequestToCreateOrderAndGoToPay"
                           onRequestStart:nil
                        onRequestFinished:^(ITTBaseDataRequest *request) {
                            isFirstClick = NO;
                            if ([request isSuccess]) {
                                
                                OrderDetailInfoModel * Model = request.handleredResult[@"keyModel"];
                                NSLog(@"detailModel = %@",Model);
                                
                                SubmitViewController_New * sbVc = [[SubmitViewController_New alloc] init];
                                sbVc.orderDetail = Model;
                                
                                [self.navigationController pushViewController:sbVc animated:YES];
                                if (_delegate && [_delegate respondsToSelector:@selector(makeMyOrderListRefresh)]) {
                                    [_delegate makeMyOrderListRefresh];
                                }
                                
                                [self hideOtherView];
                            }else{
                                
                                [UIAlertView promptTipViewWithTitle:Nil message:request.handleredResult[@"messg"] cancelBtnTitle:@"确认" otherButtonTitles:Nil onDismiss:^(int buttonIndex) {
                                    
                                } onCancel:^{
                                    
                                }];
                            }
                            
                        } onRequestCanceled:nil
                          onRequestFailed:^(ITTBaseDataRequest *request) {
                              
                          }];

}


-(BOOL)isUserLogin
{
    BOOL hasLogin = NO;
    NSString * userId = DATA_ENV.userInfo.userId;
    NSLog(@"userId= %@",userId);
    if (userId || [userId length]) {
        hasLogin = YES;
    }
    return hasLogin;
}

/**
 *  判断没有登陆就跳转到登陆也进行登陆
 */
-(BOOL)judgeUserIsLogin
{
    NSString * userId = DATA_ENV.userInfo.userId;
    NSLog(@"userId= %@",userId);
    if (!userId) {
        LoadingViewController * loginVc = [[LoadingViewController alloc] init];
        [self.navigationController pushViewController:loginVc animated:YES];
        return NO;
    }
    return YES;
}

#pragma - mark 左右换款的相关算法



- (void)updateFrame
{
//    [_imageScrollView setContentSize:[self contentSizeForPagingScrollView]];
    CGFloat offsetX = floorf(_imageScrollView.contentOffset.x/_scrollView.width)*_scrollView.width;
    [_imageScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)tilePages
{
	int firstIndex = 0;
	int lastIndex = [_productIdArr count] - 1;
	// Calculate which pages are visible
    NSInteger pageIndexNow = [self getCurrentPageIndex];
    _currentIndexOfTopImageScroll = pageIndexNow;
    
	int previousPageIndex = pageIndexNow - 1;
	int nextPageIndex = pageIndexNow + 1;
	
	previousPageIndex = MAX(previousPageIndex, firstIndex);
	nextPageIndex  = MIN(nextPageIndex, lastIndex);
	
	// Recycle no-longer-visible pages
	for (UIScrollView *pageScroll in _visiblePages) {
        NSInteger index = pageScroll.tag;
        if (index < previousPageIndex || index > nextPageIndex){
			ITTDINFO(@"image at index %d is recycled", index);
            pageScroll.tag = NSNotFound;
            [pageScroll removeAllSubviews];
			[_recycledPages addObject:pageScroll];
			[pageScroll removeFromSuperview];
		}
	}
	[_visiblePages minusSet:_recycledPages];
	
	//relayout visible pages
    for (NSInteger pageIndex = previousPageIndex; pageIndex <= nextPageIndex; pageIndex++) {
        UIScrollView *pageOfVisible = nil;
        if (![self isDisplayingPageForIndex:pageIndex]) {
            pageOfVisible = [self dequeueRecycledPageForIndex:pageIndex];
            if(!pageOfVisible){
				pageOfVisible = [[UIScrollView alloc] initWithFrame:_imageScrollView.bounds];
            }
            pageOfVisible.tag = pageIndex;
            [_imageScrollView addSubview:pageOfVisible];
            [_visiblePages addObject:pageOfVisible];
//            [self createImageViewForScrollViewWithProductId:_productIdArr[pageIndex] andSupView:pageOfVisible];
        }
        else {
            pageOfVisible = [self visiblePageAtIndex:pageIndex];
        }
        ITTDINFO(@"layout index %d", pageIndex);
        [self configurePage:pageOfVisible forIndex:pageIndex];
    }

    for (UIScrollView *obj in _visiblePages) {
//        obj.contentOffset = CGPointZero;
        if (obj.tag == _currentIndexOfTopImageScroll) {
            NSLog(@"pidIndex = %d",[self getCurrentIndexInProductIdArrWithProId:_productId]);
            NSLog(@"obj.tag = %d",obj.tag);
            _detailModel = _productMutableDic[_productIdArr[_currentIndexOfTopImageScroll]];
            _currentScrollInScreen = obj;
            [obj setContentSize:CGSizeMake(_imageScrollView.width, heightOfImageScrollView*_detailModel.imageUrlArr.count + 53)];
//            UIView * sub = [_currentScrollInScreen viewWithTag:SubViewTagOfCurrentScroll + _detailModel.imageUrlArr.count];
//            [sub addSubview:_operationView];
            [self changeProductDetailModelWithCurrentIdx];
        }
    }
}

- (void)clearPages
{
    for (UIScrollView *pageOfScroll in _visiblePages) {
        pageOfScroll.tag = NSNotFound;
        [pageOfScroll removeAllSubviews];
        [_recycledPages addObject:pageOfScroll];
        [pageOfScroll removeFromSuperview];
	}
	[_visiblePages minusSet:_recycledPages];
}

- (UIScrollView *)dequeueRecycledPageForIndex:(int)index
{
    UIScrollView * pageOfScroll = [_recycledPages anyObject];
    if (pageOfScroll) {
        [_recycledPages removeObject:pageOfScroll];
    }
    return pageOfScroll;
}

- (BOOL)isDisplayingPageForIndex:(NSInteger)index
{
	BOOL found = NO;
	for (UIScrollView * obj in _visiblePages) {
		int pageIndex = obj.tag;
		if (pageIndex == index) {
			found = YES;
			break;
		}
	}
	return found;
}

- (BOOL)isCurrentPageIndexChanged
{
    NSInteger curPageIndex = [self getCurrentPageIndex];
    return _currentIndexOfTopImageScroll != curPageIndex;
}

- (UIScrollView *)visiblePageAtIndex:(NSInteger)pageIndex
{
	UIScrollView *foundPage = nil;
	for (UIScrollView *pageOfVis in _visiblePages) {
		int index = pageOfVis.tag;
		if (index == pageIndex) {
            foundPage = pageOfVis;
			break;
		}
	}
	return foundPage;
}

- (void)configurePage:(UIScrollView *)pageScroll forIndex:(NSInteger)index
{
    pageScroll.delegate = self;
//    NSString *proId = _productIdArr[index];
//    ITTDINFO(@"page %d proId  %@", index, proId);
    pageScroll.tag = index;
    pageScroll.frame = [self frameForPageAtIndex:index];

    [self createImageViewForScrollViewWithProductId:_productIdArr[index] andSupView:pageScroll];
//    [self fillImageForImageScrollViewWithProductDetailInfo:_productMutableDic[_productIdArr[index]] andSupView:pageScroll];
}

- (void)cancelAllDownloader
{
    [_visiblePages enumerateObjectsUsingBlock:^(id object, BOOL *stop){
        [object cancelCurrentImageRequest];
    }];
    [_recycledPages enumerateObjectsUsingBlock:^(id object, BOOL *stop){
        [object cancelCurrentImageRequest];
    }];
}




-(void)initImageScrollView
{
    _recycledPages = [[NSMutableSet alloc] init];
    _visiblePages  = [[NSMutableSet alloc] init];
//    _imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
//    _imageScrollView.clipsToBounds = NO;
    _imageScrollView.delegate = self;
    _imageScrollView.frame = _containsView.bounds;
    _imageScrollView.contentSize=[self contentSizeForPagingScrollView];

    
    
}

- (NSInteger)getCurrentPageIndex
{
    
	CGRect visibleBounds = _imageScrollView.bounds;
	NSInteger currentIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    if (isPageFirstLoad) {
        currentIndex = [self getCurrentIndexInProductIdArrWithProId:self.productId];
        isPageFirstLoad = NO;
    }
	currentIndex = MAX(currentIndex, 0);
	currentIndex = MIN(currentIndex, [_productIdArr count] - 1);
    return currentIndex;
}

- (CGRect)frameForPageAtIndex:(NSInteger)index
{
	CGRect bounds = _imageScrollView.bounds;
	CGRect pageFrame = bounds;
	pageFrame.origin.x = (bounds.size.width * index);
	return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView
{
	return CGSizeMake(_imageScrollView.bounds.size.width * [_productIdArr count] , _imageScrollView.height);
}

- (void)clearCache
{
	[_recycledPages removeAllObjects];
}



/**
 *  得到当前页在productIdArr中得索引
 */
-(void)getCurrentIndexOfProductIdInProductIdArr
{
    
    [_productIdArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([self.productId isEqualToString:obj]) {
            self.currentIndexOfProductId = idx;
        }
    }];
    ITTDPRINT(@"当前所点击的款式,在数组中的位置为:_currentIndexOfProductId= %d",_currentIndexOfProductId);
    hPageIndex = (self.currentIndexOfProductId == 0 ? 0 : 1);
}


-(NSInteger)getCurrentIndexInProductIdArrWithProId:(NSString *)pid
{
    __block NSInteger index;
    [_productIdArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([self.productId isEqualToString:obj]) {
            index = idx;
        }
    }];
    return index;
}


#pragma mark - 左右还款 相关算法
/**
 *  根据 proId 判断可变字典中是否存在上品详情
 *
 *  @param proId 商品Id
 *
 *  @return bool
 */
-(BOOL)isProductMutableDicContainsProductId:(NSString *)proId
{
    
    if (_productMutableDic && _productMutableDic.allKeys.count != 0) {
        return [[_productMutableDic allKeys] containsObject:proId];
    }
    return NO;
}

/**
 *  左右滑动还款时，掩藏页面上显示的所有的子视图
 */
-(void)hideAllViewWhenSwipeTOLeftOrRight
{
    _BottomSanJiaoXing.hidden = YES;
    _infoView.hidden = YES;
    _viewOfMath.hidden = YES;
    _shareView.hidden = YES;
    _chooseView.hidden = YES;
    UIView * view = [_currentScrollInScreen viewWithTag:SubViewTagOfCurrentScroll + _detailModel.imageUrlArr.count];
    [view addSubview:_operationView];
    _pageControl.hidden = NO;
    [self.view sendSubviewToBack:_containsFunctionView];
}



-(void)createImageViewForScrollViewWithProductId:(NSString *)strPid andSupView:(UIScrollView *)scroll
{
//    if ([_productMutableDic objectForKey:strPid]) {
//        [self fillImageForImageScrollViewWithProductDetailInfo:[_productMutableDic objectForKey:strPid] andSupView:scroll];
//        return;
//    }
    
    NSLog(@"strPid = %@",strPid);
//    self.productId = strPid;
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:strPid forKey:@"productId"];
    if (DATA_ENV.userInfo.userId) {
        [parameter setObject:DATA_ENV.userInfo.userId forKey:@"userId"];
    }
    
    [RequestToGetProdeuctDetailInfo requestWithParameters:parameter
                                        withIndicatorView:nil
                                        withCancelSubject:@"RequestToGetProdeuctDetailInfo"
                                           onRequestStart:nil
                                        onRequestFinished:^(ITTBaseDataRequest *request) {
                                            
                                            if ([request isSuccess]) {
                                                ProductDetailInfoModel * model = request.handleredResult[@"keyModel"];
                                                NSLog(@"model = %@",model);
                                                [_productMutableDic setObject:model forKey:strPid];
                                                [self fillImageForImageScrollViewWithProductDetailInfo:model andSupView:scroll];
                                            }
                                        } onRequestCanceled:nil
                                          onRequestFailed:^(ITTBaseDataRequest *request) {
                                              
                                          }];
    
    
}

-(void)fillImageForImageScrollViewWithProductDetailInfo:(ProductDetailInfoModel *)model andSupView:(UIScrollView *)supView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [supView removeAllSubviews];
            [supView removeFromSuperview];
            supView.delegate = self;
            supView.showsHorizontalScrollIndicator = NO;
            supView.showsVerticalScrollIndicator = NO;
            supView.contentOffset =CGPointZero;
            [self createImageViewToScrollView:supView withProductDetailInfo:model];
            [_imageScrollView addSubview:supView];

        });
        
    });
    
}


/**
 *  根据当前显示的商品品的 idx 改变detailModel的值
 */
-(void)changeProductDetailModelWithCurrentIdx
{
       if (_pNumber && ![_pNumber isEqualToString:@""]) {
        return;
    }
    NSString * pKey = _productIdArr[_currentIndexOfTopImageScroll];
    _detailModel = _productMutableDic[pKey];
    if (!_detailModel) {
        return;
    }
    _pageControl.numberOfPages = 0;
    _pageControl.numberOfPages = _detailModel.imageUrlArr.count;
    _pageControl.currentPage = 0;

    //添加足迹
     _detailModel.productInfo.imageUrl = ([_detailModel.imageUrlArr count] >= 3)?_detailModel.imageUrlArr[2]:[_detailModel.imageUrlArr firstObject];
    NSLog(@"*******************************");
    NSLog(@"_detailModel.productInfo = %@",_detailModel.productInfo);
    [self addProductInMyTrackWithProduct:_detailModel.productInfo];
    isCollected = _detailModel.isCollected;
    _recordCollectId = _detailModel.collectId;
    [self showLikeButtonByIsCollectd];
    [self updateColorAndSizeScrollView];
}



#pragma mark - 上下滑动 算法
- (void)layoutAllViewFrame:(BOOL)flag
{
    int imagesCount = _detailModel.imageUrlArr.count;
    if (flag) {
        _containsFunctionView.top = page * heightOfImageScrollView;
        NSLog(@"page = %d",page);
        for (int i = 0; i < imagesCount - page; i++) {
            UIView *view = [_currentScrollInScreen viewWithTag:i + SubViewTagOfCurrentScroll + page];
            [UIView animateWithDuration:.3 animations:^{
                view.top = (page + i) * heightOfImageScrollView + FunctionViewHeight;
            } completion:^(BOOL finished) {
                [_currentScrollInScreen addSubview:_containsFunctionView];
                [_currentScrollInScreen sendSubviewToBack:_containsFunctionView];
            }];
        }
    } else {
        
        [_currentScrollInScreen sendSubviewToBack:_containsFunctionView];
        for (int i = 0; i< imagesCount - page; i++) {
            UIView *view = [_currentScrollInScreen viewWithTag:i + SubViewTagOfCurrentScroll + page];
            [UIView animateWithDuration:.3 animations:^{
                NSLog(@"opreateView.top = %f",_containsFunctionView.top);
                view.top = (page + i) * heightOfImageScrollView;
            } completion:^(BOOL finished) {
                if (finished) {
//                    [_containsFunctionView removeFromSuperview];
                }
            }];
        }
    }
}

/**
 *  根据pageControl的currentIndex实现scrollView的卡屏效果
 */
-(void)setPostionForScrollViewByPageControl
{
    int index = _pageControl.currentPage;
    //下一张的imageView的frame
    UIScrollView  * scroll = (UIScrollView *)[_currentScrollInScreen viewWithTag:index + 1 + SubViewTagOfCurrentScroll];

    if (_currentScrollInScreen.contentOffset.y<1) {
        return;
    }
    
    if (scroll.origin.y > page*heightOfImageScrollView) {
        CGPoint offSet = CGPointMake(0, (index)*heightOfImageScrollView + GET_VIEW_HEIGHT(_containsFunctionView));
        [UIView animateWithDuration:.4 animations:^{
            _currentScrollInScreen.contentOffset = offSet;
        } completion:^(BOOL finished) {
        }];
    }else{
        if (!isDown) {
            return;
        }
        CGFloat ht = 0;
        if (IOS7) {
            ht =SCREEN_HEIGHT - GET_VIEW_HEIGHT(_containsFunctionView);
        }else{
            ht =SCREEN_HEIGHT - GET_VIEW_HEIGHT(_containsFunctionView) - 20;
        }
        _containsFunctionView.top = ht;
        NSLog(@"opreateView.frame = %@",NSStringFromCGRect(_containsFunctionView.frame));
        if (![self.view.subviews containsObject:_containsFunctionView]) {
             [self.view addSubview:_containsFunctionView];
        }

    }
}


@end
