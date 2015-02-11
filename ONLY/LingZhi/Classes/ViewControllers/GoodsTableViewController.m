//
//  GoodsTableViewController.m
//  LingZhi
//
//  Created by iFangSoft on 15/1/28.
//
//

#import "GoodsTableViewController.h"
#import "GoodsTableViewCell.h"

@interface GoodsTableViewController ()

@property (nonatomic , retain) NSMutableArray *NameArray;
@property (nonatomic , retain) NSMutableArray *sexArray;
@property (nonatomic , retain) NSMutableArray *aroundArray;

@end

@implementation GoodsTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.title = @"附近";
    _NameArray = [NSMutableArray array];
    _sexArray = [NSMutableArray array];
    _aroundArray = [NSMutableArray array];
    [_NameArray addObjectsFromArray:@[@"赵小姐",@"张东",@"王皓",@"李玉",@"张柏芝",@"周杰伦"]];
    [_sexArray addObjectsFromArray:@[@"",@"男",@"女",@"男",@"女",@"女"]];
    [_aroundArray addObjectsFromArray:@[@"500米",@"1公里",@"500米",@"2公里",@"1公里",@"200米"]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsTableViewCell *cell;
    static NSString *identfier = @"GoodsCell";
    cell = (GoodsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identfier];
    if (!cell) {
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:nil options:nil];
        //将Custom.xib中的所有对象载入
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodsCell" owner:nil options:nil];
        //第一个对象就是CustomCell了
        cell = array[0];
    }
    cell.alpha = 0.1;
    cell.image = @"Icon";
    cell.name = _NameArray[indexPath.row];
    cell.sex = _sexArray[indexPath.row];
    cell.around = _aroundArray[indexPath.row];
    cell.time = @"3小时";
    cell.islin = @"在线";
    
    // Configure the cell...
    
    return cell;
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
