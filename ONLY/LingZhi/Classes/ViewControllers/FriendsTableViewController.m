//
//  FriendsTableViewController.m
//  LingZhi
//
//  Created by iFangSoft on 15/1/28.
//
//

#import <AddressBookUI/AddressBookUI.h>
#import "FriendsTableViewController.h"
#import "FriendsTableViewCell.h"
#import "Paixu.h"
#import "ChineseString.h"
#import "AddFriendsTableViewController.h"
#import "JiuBaUrl.h"
#import "AFNetworking.h"


@interface FriendsTableViewController ()
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;
@property (nonatomic , retain) NSMutableArray *array;
@property (nonatomic , retain) NSMutableArray *imageArray;
@property (nonatomic , retain) NSMutableArray *FriendArray;
@property (nonatomic , retain) NSMutableArray *lastArray;
@property (nonatomic , retain) NSMutableArray *titleArray;

@property (nonatomic , retain) NSMutableArray *dayArray;
@property (nonatomic , retain) NSMutableArray *ueridArray;
@property (nonatomic , retain) NSMutableArray *isgiveArray;
@property (nonatomic , retain) NSMutableArray *uernameArray;

@end

@implementation FriendsTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.title = @"好友" ;
    
    _array = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    _FriendArray = [NSMutableArray array];
    _lastArray = [NSMutableArray array];
    _titleArray = [NSMutableArray array];
    
    _dayArray = [NSMutableArray array];
    _ueridArray = [NSMutableArray array];
    _uernameArray = [NSMutableArray array];
    _isgiveArray = [NSMutableArray array];
    [self getfriendsOfApp];
    
    for (int i = 0; i < 26; i++) {
        [_titleArray addObject:[NSString stringWithFormat:@"%c",'A'+i] ];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//获取好友通讯录

- (void)getfriendsOfApp
{
    //解析获取到的好友信息
    // 要传递的json数据是一个字典
    NSDictionary *parameter = @{@"session[sid]":[[NSUserDefaults standardUserDefaults] stringForKey:@"sid"],@"session[uid]":[[NSUserDefaults standardUserDefaults]stringForKey:@"uid"],@"relation_id":@"0"};
    
    NSLog(@"sssssssss%@",parameter);
    // httpClient 的postPath就是上文中的pathStr，即你要访问的URL地址，这里是向服务器提交一个数据请求，
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:getfriendslist]];
    
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:nil
                                            parameters:parameter];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:self.readingOptions error:nil];
        NSLog(@"%@",dic);
        NSArray *array = dic[@"data"];
        for (NSDictionary *dictionary in array) {
            [_isgiveArray addObject:dictionary[@"is_give"]];
            [_uernameArray addObject:dictionary[@"user_name"]];
            [_ueridArray addObject:dictionary[@"user_id"]];
            [_dayArray addObject:dictionary[@"birthday"]];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [operation start];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        View.backgroundColor = [UIColor whiteColor];
        UIButton *Phonebutton = [UIButton buttonWithType:UIButtonTypeSystem];
        Phonebutton.frame = CGRectMake(60, 0, 200, 20);
        Phonebutton.backgroundColor = [UIColor blueColor];
        Phonebutton.layer.masksToBounds = YES;
        Phonebutton.layer.cornerRadius = 5.0;
        [Phonebutton setTitle:@"手机通讯录" forState:UIControlStateNormal];
        [Phonebutton addTarget:self action:@selector(DidClickphoneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [View addSubview:Phonebutton];
        return View;
        
        
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
//        label.backgroundColor = [UIColor whiteColor];
//        label.text = @"手机通讯录";
//        label.textAlignment = NSTextAlignmentCenter;
//        [View addSubview:label];
//        return View;
    }
    else
    {
        return nil;
    }
}

- (void)DidClickphoneButtonAction:(id)sender
{
    //从手机通讯录中添加好友
    AddFriendsTableViewController *addfriendsViewController = [[AddFriendsTableViewController alloc]initWithNibName:@"AddFriendsTableViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:addfriendsViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (_uernameArray.count == 0) {
        return 1;
    }else
    return _uernameArray.count;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _titleArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (_uernameArray.count == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = @"暂时还没有好友";
        return cell;
    }else{
    
    FriendsTableViewCell *cell;
    static NSString *identfierString = @"cell";
    [tableView dequeueReusableCellWithIdentifier:identfierString];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendsTableViewCell" owner:nil options:nil];
        cell = [nib lastObject];
    }
    // Configure the cell...
    cell.FriendsNameLabel.text = _uernameArray[indexPath.row];
    return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_uernameArray.count == 0) {
        return 486;
    }else
    {
        return 44;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
