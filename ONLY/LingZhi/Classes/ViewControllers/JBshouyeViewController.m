//
//  JBshouyeViewController.m
//  JiuBa
//
//  Created by iFangSoft on 15/2/7.
//
//

#import "JBshouyeViewController.h"
#import "GoodsUpViewController.h"
#import "FriendsTableViewController.h"
#import "GoodsTableViewController.h"
#import "LoginHomeViewController.h"
#import "AroundViewController.h"
#import "SetAppViewController.h"
#import "JiuBaUrl.h"
#import "AFNetworking.h"
#import "PayViewController.h"
@interface JBshouyeViewController ()

@property (nonatomic , retain) GoodsUpViewController *GoodsUpVC;
@property (nonatomic , retain) FriendsTableViewController *friendsVC;
@property (nonatomic , retain) GoodsTableViewController *goodsTVC;
@property (nonatomic , retain) LoginHomeViewController *loginVC;
@property (nonatomic , retain) AroundViewController *aroundVC;
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;
@property (nonatomic , retain) NSString *sid;
@end

@implementation JBshouyeViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getuserData];
    // Do any additional setup after loading the view from its nib.
}
- (void) getuserData
{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"name"]) {
        return;
    }
    NSLog(@"=============--------------==============%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"pwd"]);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sid"];
    NSDictionary *dict = @{@"name":[[NSUserDefaults standardUserDefaults] stringForKey:@"name"], @"password":[[NSUserDefaults standardUserDefaults] stringForKey:@"pwd"]};
    // 要传递的json数据是一个字典
    
    // httpClient 的postPath就是上文中的pathStr，即你要访问的URL地址，这里是向服务器提交一个数据请求，
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:LoginUrl]];
    
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:nil
                                            parameters:dict];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:self.readingOptions error:nil];
        NSDictionary *dictionary = dic[@"status"];
        NSInteger status = [[dictionary valueForKey:@"succeed"] integerValue];
        NSDictionary *dic1 = dic[@"data"];
        NSDictionary *dic2 = dic1[@"session"];
        _sid = dic2[@"sid"];
        if (status == 1) {
            NSLog(@"登陆成功");
            [[NSUserDefaults standardUserDefaults] setObject:_sid forKey:@"sid"];

        }else{
            NSLog(@"登陆失败  原因");
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"登陆失败 : %@",error.localizedDescription);
    }];
    [operation start];
}
- (IBAction)DidGoodsUpButtonAction:(id)sender {
    _GoodsUpVC = [[GoodsUpViewController alloc]init];
    [self.navigationController pushViewController:_GoodsUpVC animated:YES];
}
- (IBAction)DidShopTimeButtonAction:(id)sender {
    PayViewController *vc = [[PayViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)DidShopButtonAction:(id)sender {
    _loginVC = [[LoginHomeViewController alloc]init];
    [self.navigationController pushViewController:_loginVC animated:YES];
    
}
- (IBAction)DidAroundFeiendsButtonAction:(id)sender {
    _aroundVC = [[AroundViewController alloc]init];
    [self.navigationController pushViewController:_aroundVC animated:YES];
}
- (IBAction)DidFriendsVIPButtonAction:(id)sender {
    _friendsVC = [[FriendsTableViewController alloc]init];
    [self.navigationController pushViewController:_friendsVC  animated:YES];
}
- (IBAction)DidFriendsButtonAction:(id)sender {
    _friendsVC = [[FriendsTableViewController alloc]init];
    [self.navigationController pushViewController:_friendsVC  animated:YES];
}
- (IBAction)DidSetAppButtonAction:(id)sender {
    SetAppViewController *setAppVC = [[SetAppViewController alloc]initWithNibName:@"SetAppViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:setAppVC animated:YES];
}
- (IBAction)DidTimeLiteButtonAction:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
