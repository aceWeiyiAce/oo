//
//  GoodsDetailViewController.m
//  JiuBa
//
//  Created by iFangSoft on 15/2/9.
//
//
#import <AlipaySDK/AlipaySDK.h>
#import "GoodsDetailViewController.h"
#import "SVProgressHUD.h"
#import "JiuBaUrl.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface GoodsDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *GifImageView;
@property (weak, nonatomic) IBOutlet UILabel *gifNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gifPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *shopCartButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *collectbutton;

@property (nonatomic , retain) NSDictionary *detailDictionary;
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;
@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shareButton.layer.masksToBounds = YES;
    _shareButton.layer.cornerRadius = 3.0;
    _shopCartButton.layer.masksToBounds = YES;
    _shopCartButton.layer.cornerRadius = 3.0;
    _buyButton.layer.masksToBounds = YES;
    _buyButton.layer.cornerRadius = 3.0;
    // Do any additional setup after loading the view from its nib.
    [self coft];
    [self createData];
}

- (void)coft
{
    [self.GifImageView setImageWithURL:[NSURL URLWithString:_imageUrl]];
    self.gifNameLabel.text = _gifName;
    self.gifPriceLabel.text = [NSString stringWithFormat:@"$%@", _gifPrice];
    
    self.detailDictionary = @{@"goods_id":_IDstring,@"gif_name":_gifName,@"gif_price":_gifPrice,@"gif_img":_imageUrl};
}

- (void)createData
{
    // 要传递的json数据是一个字典
    NSDictionary *parameter = @{@"goods_id":self.IDstring};
    
    
    // httpClient 的postPath就是上文中的pathStr，即你要访问的URL地址，这里是向服务器提交一个数据请求，
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:JiuBaDetailUrl]];
    
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:nil
                                            parameters:parameter];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:self.readingOptions error:nil];
        self.detailLabel.text = dic[@"data"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
    [operation start];
}

#pragma mark - buttonAction -

- (IBAction)DidclickCollectButtonAction:(id)sender {
    // 要传递的json数据是一个字典
    NSDictionary *parameter = @{@"session[sid]":[[NSUserDefaults standardUserDefaults] stringForKey:@"sid"],@"session[uid]":[[NSUserDefaults standardUserDefaults] stringForKey:@"uid"],@"goods_id":self.IDstring};
    
    
    // httpClient 的postPath就是上文中的pathStr，即你要访问的URL地址，这里是向服务器提交一个数据请求，
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:MakeJiuBaList]];
    
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:nil
                                            parameters:parameter];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:self.readingOptions error:nil];
        NSDictionary *dictionary = dic[@"status"];
        int cont = [dictionary[@"succeed"] intValue];
        if (cont == 0) {
            [SVProgressHUD showErrorWithStatus:@"已收藏" duration:1];
        }else
            [SVProgressHUD showSuccessWithStatus:@"加入收藏成功" duration:1];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error);
    }];
    [operation start];
    
}
- (IBAction)DidClickAddShopCartBtuuonAction:(id)sender {
    // 要传递的json数据是一个字典
    NSDictionary *parameter = @{@"session[sid]":[[NSUserDefaults standardUserDefaults] stringForKey:@"sid"],@"session[uid]":[[NSUserDefaults standardUserDefaults] stringForKey:@"uid"],@"goods_id":self.IDstring,@"number":@"1"};
    
    
    // httpClient 的postPath就是上文中的pathStr，即你要访问的URL地址，这里是向服务器提交一个数据请求，
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:MakeShopList]];
    
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:nil
                                            parameters:parameter];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:self.readingOptions error:nil];
        NSDictionary *dictionary = dic[@"status"];
        int cont = [dictionary[@"succeed"] intValue];
        if (cont == 0) {
            [SVProgressHUD showErrorWithStatus:@"已加入购物车" duration:1];
        }else
            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功" duration:1];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error);
    }];
    [operation start];
}
- (IBAction)DidclickPayForButtonAction:(id)sender {
    
    
}
- (IBAction)DidCickShareButtonAction:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
