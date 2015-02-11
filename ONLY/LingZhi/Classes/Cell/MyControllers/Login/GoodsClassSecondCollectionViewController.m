//
//  GoodsClassSecondCollectionViewController.m
//  JiuBa
//
//  Created by iFangSoft on 15/2/9.
//
//

#import "GoodsClassSecondCollectionViewController.h"
#import "GoodsListViewController.h"
#import "JiuBaUrl.h"
#import "AFNetworking.h"
#import "GoodsSecondCollectionViewCell.h"

@interface GoodsClassSecondCollectionViewController ()
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;
@property (nonatomic , retain) NSMutableArray *ClassnameArray;
@property (nonatomic , retain) NSMutableArray *ClassimageArray;
@property (nonatomic , retain) NSMutableArray *ClassIdArray;
@end

@implementation GoodsClassSecondCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _ClassnameArray = [NSMutableArray array];
    _ClassIdArray = [NSMutableArray array];
    [self ceratData];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    // Do any additional setup after loading the view.
}

- (void)ceratData
{ 
   // 要传递的json数据是一个字典
    NSDictionary *parameter = @{@"cat_id":self.IDstring};
    
    
    // httpClient 的postPath就是上文中的pathStr，即你要访问的URL地址，这里是向服务器提交一个数据请求，
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:JiuBaSecondUrl]];
    
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:nil
                                            parameters:parameter];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:self.readingOptions error:nil];
        NSLog(@"第二页数据为：%@",dic);
        NSArray *array = dic[@"data"];
        for (NSDictionary *dictionary in array) {
            NSString *string = dictionary[@"cat_name"];
            NSString *string1 = dictionary[@"cat_id"];
            [_ClassnameArray addObject:string];
            [_ClassIdArray addObject:string1];
        }
        NSLog(@"%@",_ClassnameArray);
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error);
    }];
    [operation start];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return _ClassnameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"cell";
    [collectionView registerClass:[GoodsSecondCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    GoodsSecondCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = (GoodsSecondCollectionViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"GoodsSecondCollectionViewCell" owner:self options:nil] lastObject];
    }
    NSLog(@"%@",cell);
    cell.NameLabel.text = _ClassnameArray[indexPath.row];
    cell.imageViewOfGoodsSecond.image = [UIImage imageNamed:@"Icon"];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListViewController *goodsListVC = [[GoodsListViewController alloc]initWithNibName:@"GoodsListViewController" bundle:[NSBundle mainBundle]];
    goodsListVC.IDstring = _ClassIdArray[indexPath.row];
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
