//
//  AroundViewController.m
//  JiuBa
//
//  Created by iFangSoft on 15/1/29.
//
//

#import "AroundViewController.h"
#import "GoodsTableViewCell.h"

@interface AroundViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , retain) NSMutableArray *NameArray;
@property (nonatomic , retain) NSMutableArray *sexArray;
@property (nonatomic , retain) NSMutableArray *aroundArray;
@property (weak, nonatomic) IBOutlet UIButton *RangeButton;
@property (weak, nonatomic) IBOutlet UIButton *TimeInButton;
@property (weak, nonatomic) IBOutlet UIButton *ChooseSexButton;
@property (weak, nonatomic) IBOutlet UITableView *SexChooseTableView;
@property (weak, nonatomic) IBOutlet UIButton *ChooseManButton;
@property (weak, nonatomic) IBOutlet UIButton *ChooseWomanButton;



@end

@implementation AroundViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self.SexChooseTableView.hidden = YES;
    self.ChooseManButton.hidden = YES;
    self.ChooseWomanButton.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近";
    self.view.backgroundColor = [UIColor orangeColor];
    _NameArray = [NSMutableArray array];
    _sexArray = [NSMutableArray array];
    _aroundArray = [NSMutableArray array];
    [_NameArray addObjectsFromArray:@[@"赵女士",@"张东",@"王皓",@"李玉",@"张柏芝",@"周杰伦"]];
    [_sexArray addObjectsFromArray:@[@"女",@"男",@"女",@"男",@"女",@"女"]];
    [_aroundArray addObjectsFromArray:@[@"500米",@"1公里",@"500米",@"2公里",@"1公里",@"200米"]];
    _AroundTableView.delegate = self;
    _AroundTableView.dataSource = self;
    
    self.ChooseSexButton.tag = 100000;
    [self.ChooseSexButton addTarget:self action:@selector(ChooseSexButtonAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - ButtonAction - 

-(void) ChooseSexButtonAction
{
    if (self.ChooseSexButton.tag == 100000) {
        self.SexChooseTableView.hidden = NO;
        self.ChooseManButton.hidden = NO;
        self.ChooseWomanButton.hidden = NO;
        self.ChooseSexButton.tag = 100001;
    }else
    {
        self.SexChooseTableView.hidden = YES;
        self.ChooseManButton.hidden = YES;
        self.ChooseWomanButton.hidden = YES;
        self.ChooseSexButton.tag = 100000;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
