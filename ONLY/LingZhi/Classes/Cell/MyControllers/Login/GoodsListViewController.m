//
//  GoodsListViewController.m
//  JiuBa
//
//  Created by iFangSoft on 15/2/9.
//
//

#import "GoodsListViewController.h"
#import "LoginCollectionViewCell.h"
#import "GoodsDetailViewController.h"
#import "JiuBaUrl.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface GoodsListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic , retain) NSMutableArray *ClassnameArray;
@property (nonatomic , retain) NSMutableArray *ClassIDArray;
@property (nonatomic , retain) NSMutableArray *ClassImageArray;
@property (nonatomic , retain) NSMutableArray *ClassPayArray;
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;
@end

@implementation GoodsListViewController
static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    _ClassnameArray = [NSMutableArray array];
    _ClassIDArray = [NSMutableArray array];
    _ClassImageArray = [NSMutableArray array];
    _ClassPayArray = [NSMutableArray array];
    self.myCollectionView.dataSource = self;
    self.myCollectionView.delegate = self;
    [self ceratData];
    // Do any additional setup after loading the view from its nib.
}

- (void)ceratData
{
    // 要传递的json数据是一个字典
    NSDictionary *parameter = @{@"children":self.IDstring};
    
    
    // httpClient 的postPath就是上文中的pathStr，即你要访问的URL地址，这里是向服务器提交一个数据请求，
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:JiuBaListUrl]];
    
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:nil
                                            parameters:parameter];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:self.readingOptions error:nil];
        NSLog(@"第二页数据为：%@",dic);
        NSArray *array = dic[@"data"];
        for (NSDictionary *dictionary in array) {
            NSString *string = dictionary[@"goods_name"];
            NSString *string1 = dictionary[@"goods_id"];
            NSString *string2 = dictionary[@"goods_img"];
            NSString *string3 = dictionary[@"promote_price"];
            [_ClassnameArray addObject:string];
            [_ClassIDArray addObject:string1];
            [_ClassImageArray addObject:string2];
            [_ClassPayArray addObject:string3];
        }
        [self.myCollectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error);
    }];
    [operation start];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _ClassnameArray.count;
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
    cell.GoodsClassNameLabel.text = _ClassnameArray[indexPath.row];
    [cell.GoodsClassImageView setImageWithURL:[NSURL URLWithString:_ClassImageArray[indexPath.row]]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailViewController *goodsDetailVC = [[GoodsDetailViewController alloc]initWithNibName:@"GoodsDetailViewController" bundle:[NSBundle mainBundle]];
    goodsDetailVC.IDstring = _ClassIDArray[indexPath.row];
    goodsDetailVC.gifName = _ClassnameArray[indexPath.row];
    goodsDetailVC.gifPrice = _ClassPayArray[indexPath.row];
    goodsDetailVC.imageUrl = _ClassImageArray[indexPath.row];
    [self.navigationController  pushViewController:goodsDetailVC animated:YES];
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
