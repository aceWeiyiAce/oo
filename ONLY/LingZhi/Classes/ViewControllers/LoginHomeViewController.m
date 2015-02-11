//
//  LoginHomeViewController.m
//  JiuBa
//
//  Created by iFangSoft on 15/2/2.
//
//

#import "LoginHomeViewController.h"
#import "LoadingViewController.h"
#import "GoodsUpViewController.h"
#import "LoginHomeTableViewCell.h"
#import "ProductListViewController.h"
#import "GoodsClassTableViewCell.h"
#import "LoginCollectionViewCell.h"
#import "GoodsClassSecondCollectionViewController.h"
#import "JiuBaUrl.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface LoginHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *LoginCollectionView;
@property (nonatomic , retain) NSMutableArray *ClassNameArray;
@property (nonatomic , retain) NSMutableArray *ClassIdArray;




@end

@implementation LoginHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    _ClassNameArray = [NSMutableArray array];
    _ClassIdArray = [NSMutableArray array];
    self.LoginCollectionView.delegate = self;
    self.LoginCollectionView.dataSource = self;
    [self creatData];
    //判断登陆
//    [self DefualtLoading];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)creatData
{
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:JiuBaFristUrl]];
//    
//    NSURLRequest * request = [client requestWithMethod:@"GET"
//                                                  path:nil
//                                            parameters:nil];
//    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"%@",responseObject);
//        NSArray *array = responseObject[@"data"];
//        for (NSDictionary *dic in array) {
//            NSString *string = dic[@"name"];
//            //            [_ClassNameArray addObject:string];
//            NSString *string1 = dic[@"id"];
//            //            [_ClassIdArray addObject:string1];
//        }
//        [self.LoginCollectionView reloadData];
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"faild , error == %@ ", error);
//    }];
//    
//    [operation start];
    NSString *str=[NSString stringWithFormat:JiuBaFristUrl];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    从URL获取json数据
    AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary* JSON) {
        NSLog(@"获取到的数据为：%@",JSON);
        NSArray *array = JSON[@"data"];
        for (NSDictionary *dic in array) {
            NSString *string = dic[@"name"];
            [_ClassNameArray addObject:string];
            NSString *string1 = dic[@"id"];
            [_ClassIdArray addObject:string1];
        }
        [self.LoginCollectionView reloadData];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id data) {
        NSLog(@"发生错误！%@",error);
    }];
    [operation1 start];
}

//判断登陆
- (void)DefualtLoading
{
    if (![self isLogin]) {
        LoadingViewController *loadViewController = [[LoadingViewController alloc]initWithNibName:@"LoadingViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:loadViewController animated:NO];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _ClassNameArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    [collectionView registerClass:[LoginCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    LoginCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = (LoginCollectionViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"LoginCollectionViewCell" owner:self options:nil] lastObject];
    }
    NSLog(@"%@",cell);
    cell.GoodsClassNameLabel.text = _ClassNameArray[indexPath.row];
    cell.GoodsClassImageView.image = [UIImage imageNamed:@"Icon"];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsClassSecondCollectionViewController *goodsClassSecondVC = [[GoodsClassSecondCollectionViewController alloc]initWithNibName:@"GoodsClassSecondCollectionViewController" bundle:[NSBundle mainBundle]];
    goodsClassSecondVC.IDstring = _ClassIdArray[indexPath.row];
    [self.navigationController pushViewController:goodsClassSecondVC animated:YES];
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
