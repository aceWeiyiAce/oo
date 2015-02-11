//
//  HomeViewController.m
//  JiuBa
//
//  Created by iFangSoft on 15/2/2.
//
//

#import "HomeViewController.h"
#import "LoadingViewController.h"
#import "GoodsUpViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    //update by pk at 20140611
    //    if (_isBackFromProductDetail) {
    //        _isBackFromProductDetail = NO;
    //        return;
    //    }
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self DefualtLoading];
    // Do any additional setup after loading the view from its nib.
}

- (void)DefualtLoading
{
    if (![self isLogin]) {
        //        [[PersonCenterView loadFromXib] showPersonCenterViewWithView:_contentView delegate:self];
        LoadingViewController *loadViewController = [[LoadingViewController alloc]initWithNibName:@"LoadingViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:loadViewController animated:YES];
        //        _homeModel = [[HomeModel alloc] init];
        //        _homeModel.pId = @"0";
        //        _homeModel.productClassId = _classificationModel.classId;
        //        _productPage = 1;
        //
        //        ProductListViewController *product = [[ProductListViewController alloc]init];
        //        _isBackFromProductDetail = YES;
        //        product.home = _homeModel;
        //
        //        [self.navigationController pushViewController:product animated:NO];
    }else
    {
        GoodsUpViewController *goodsUpViewController = [[GoodsUpViewController alloc]initWithNibName:@"GoodsUpViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:goodsUpViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isLogin
{
    if ([USER_DEFAULT valueForKey:UserNameKey]!=Nil && [USER_DEFAULT valueForKey:PWDKey]!=Nil) {
        return YES;
    }
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
