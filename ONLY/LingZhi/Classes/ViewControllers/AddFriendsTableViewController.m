//
//  AddFriendsTableViewController.m
//  JiuBa
//
//  Created by iFangSoft on 15/2/3.
//
//
#import <AddressBookUI/AddressBookUI.h>
#import "AddFriendsTableViewController.h"
#import "Paixu.h"
#import "ChineseString.h"
#import "PhoneFriends.h"
#import "AddFriendsTableViewCell.h"

@interface AddFriendsTableViewController ()

@property (nonatomic , retain) NSMutableArray *array;
@property (nonatomic , retain) NSMutableArray *imageArray;
@property (nonatomic , retain) NSMutableArray *FriendArray;
@property (nonatomic , retain) NSMutableArray *lastArray;
@property (nonatomic , retain) NSMutableArray *titleArray;

@end

@implementation AddFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _array = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    _FriendArray = [NSMutableArray array];
    _lastArray = [NSMutableArray array];
    _titleArray = [NSMutableArray array];
    [self getPhoneNumberOfPhone];
    
    for (int i = 0; i < 26; i++) {
        [_titleArray addObject:[NSString stringWithFormat:@"%c",'A'+i] ];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//获取手机通讯录

- (void)getPhoneNumberOfPhone
{
    //新建一个通讯录类
    ABAddressBookRef tmpAddressBook = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        
    {
        tmpAddressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        dispatch_release(sema);
        
    }
    
    else
        
    {
        tmpAddressBook = ABAddressBookCreate();
        
    }
    CFArrayRef contacts = ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(tmpAddressBook);
    NSLog(@"%ld",nPeople);
    for (int i = 0; i < nPeople; i++)
    {
        PhoneFriends *friends = [[PhoneFriends alloc]init];
        NSString *nameString;
        ABRecordRef person = CFArrayGetValueAtIndex(contacts, i);
        //读取联系人姓名属性
        if (ABRecordCopyValue(person, kABPersonLastNameProperty)&&(ABRecordCopyValue(person, kABPersonFirstNameProperty))== nil) {
            nameString = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        }else if (ABRecordCopyValue(person, kABPersonLastNameProperty) == nil&&(ABRecordCopyValue(person, kABPersonFirstNameProperty))){
            nameString = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        }else if (ABRecordCopyValue(person, kABPersonLastNameProperty)&&(ABRecordCopyValue(person, kABPersonFirstNameProperty))){
            
            NSString *first =(__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            NSString *last = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            nameString = [NSString stringWithFormat:@"%@%@",last,first];
        }
        if (!nameString) {
            nameString = @"No Name";
        }
        [_array addObject:nameString];
        
        //读取照片信息
        NSData *imageData = (__bridge NSData *)ABPersonCopyImageData(person);
        UIImage *myImage = [UIImage imageWithData:imageData];
        CGSize newSize = CGSizeMake(55, 55);
        UIGraphicsBeginImageContext(newSize);
        [myImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();//上诉代码实现图片压缩，可根据需要选择，现在是压缩到55*55
        
        imageData = UIImagePNGRepresentation(newImage);
        [_imageArray addObject:imageData];
        
        
        
        friends.Name = nameString;
        friends.imageData = imageData;
        [_FriendArray addObject:friends];
    }
    
    _array = [Paixu zhongWenPaiXu:_array];
    
    for (ChineseString *string in _array) {
        for (PhoneFriends *nameString in _FriendArray) {
            if ([string.string isEqualToString:nameString.Name]) {
                [_lastArray addObject:nameString];
            }
        }
    }
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
    return _array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddFriendsTableViewCell *cell;
    static NSString *identfierString = @"cell";
    [tableView dequeueReusableCellWithIdentifier:identfierString];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddFriendsTableViewCell" owner:nil options:nil];
        cell = [nib lastObject];
    }
    cell.alpha = 0.1;
    PhoneFriends *friend = _lastArray[indexPath.row];
    cell.friendImageView.image = [UIImage imageWithData:friend.imageData];
    // Configure the cell...
    cell.NameLabel.text = friend.Name;
    [cell.AddButton setTitle:@"添加" forState:UIControlStateNormal];
    cell.AddButton.backgroundColor = [UIColor blueColor];
    
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
