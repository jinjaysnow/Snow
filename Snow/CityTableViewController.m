//
//  CityTableViewController.m
//  Snow
//
//  Created by 靳杰 on 14-4-27.
//  Copyright (c) 2014年 JinJay. All rights reserved.
//

#import "CityTableViewController.h"
#import "FirstViewController.h"
#import "WeatherModel.h"
#import "AppDelegate.h"

static NSArray *citys;
static NSString *currentCity = @"北京";

@interface CityTableViewController ()
@property (nonatomic, retain)FirstViewController *f_delegate;
+ (NSString *)getCurrentCity;// 类方法，返回当前城市名
-(void)goTopAction:(id)sender;          //回到顶部
-(void)dismissSelf:(id)sender;          //消失当前视图
-(BOOL)isSaved:(NSString *)cityID;      //判断是否已经存储了
@end

@implementation CityTableViewController
@synthesize citylist,savedCitylist;
@synthesize resultCitylist;
@synthesize searchDC;
@synthesize searchBar;
@synthesize hud;
// TODO:
-(BOOL)isSaved:(NSString *)cityID {
    BOOL flag = NO;
    return flag;
}
// 回到顶部
-(void)goTopAction:(id)sender{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
// TODO:
-(void)dismissSelf:(id)sender{
    NSLog(@"回到第一视图");
    AppDelegate *appD = [[UIApplication sharedApplication] delegate];
    [appD changeToFirst];
    FirstViewController *f = [FirstViewController getInstance];
    [f updateDate:f];
}
// 单例模式
static CityTableViewController* instance = nil;
+ (id)getInstance{
    if (instance == nil) {
//        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        instance = (CityTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"TableView"];
        instance = [[CityTableViewController alloc] init];
        instance.tabBarItem.title = @"设置";
        instance.tabBarItem.image = [UIImage imageNamed:@"settings2-32.png"];
    }
    return instance;
}
// 设置当前城市
+ (void)setCurrentCity:(NSString *)cityName {
    currentCity = cityName;
}
// 类方法，返回当前城市名
+ (NSString *)getCurrentCity{
    return currentCity;
}
// 构造方法
- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Make sure your segue name in storyboard is the same as this line
}
-(void)reloadSavedCitylist {
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}
-(void)loadView {
    [super loadView];
    
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"回到顶部" style:UIBarButtonItemStyleBordered target:self action:@selector(goTopAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissSelf:)];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [searchBar setTintColor:[UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0]];
    searchBar.placeholder = @"请在此输入您要查找的城市名称";
    [self.tableView setTableHeaderView:self.searchBar];
    
    self.searchDC = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    [self.searchDC setDelegate:self];
    [self.searchDC setSearchResultsDelegate:self];
    [self.searchDC setSearchResultsDataSource:self];
}
// 加载完成视图后的初始化代码
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
//    NSArray *testA = [NSArray arrayWithContentsOfFile:@"Snow-Info.plist"];
    
    citys = [[NSArray alloc] initWithObjects:@"北京",@"朝阳",@"顺义",@"怀柔",@"通州",@"昌平",@"延庆",@"丰台",@"石景山",@"大兴",@"房山",@"密云",@"门头沟",@"平谷",@"八达岭",@"佛爷顶",@"汤河口",@"密云上甸子",@"斋堂",@"霞云岭",@"北京城区",@"海淀",@"天津",@"宝坻",@"东丽",@"西青",@"北辰",@"蓟县",@"汉沽",@"静海",@"津南",@"塘沽",@"大港",@"武清",@"宁河",@"上海",@"宝山",@"嘉定",@"南汇",@"浦东",@"青浦",@"松江",@"奉贤",@"崇明",@"徐家汇",@"闵行",@"金山",@"石家庄",@"张家口",@"承德",@"唐山",@"秦皇岛",@"沧州",@"衡水",@"邢台",@"邯郸",@"保定",@"廊坊",@"郑州",@"新乡",@"许昌",@"平顶山",@"信阳",@"南阳",@"开封",@"洛阳",@"商丘",@"焦作",@"鹤壁",@"濮阳",@"周口",@"漯河",@"驻马店",@"三门峡",@"济源",@"安阳",@"合肥",@"芜湖",@"淮南",@"马鞍山",@"安庆",@"宿州",@"阜阳",@"亳州",@"黄山",@"滁州",@"淮北",@"铜陵",@"宣城",@"六安",@"巢湖",@"池州",@"蚌埠",@"杭州",@"舟山",@"湖州",@"嘉兴",@"金华",@"绍兴",@"台州",@"温州",@"丽水",@"衢州",@"宁波",@"重庆",@"合川",@"南川",@"江津",@"万盛",@"渝北",@"北碚",@"巴南",@"长寿",@"黔江",@"万州天城",@"万州龙宝",@"涪陵",@"开县",@"城口",@"云阳",@"巫溪",@"奉节",@"巫山",@"潼南",@"垫江",@"梁平",@"忠县",@"石柱",@"大足",@"荣昌",@"铜梁",@"璧山",@"丰都",@"武隆",@"彭水",@"綦江",@"酉阳",@"秀山",@"沙坪坝",@"永川",@"福州",@"泉州",@"漳州",@"龙岩",@"晋江",@"南平",@"厦门",@"宁德",@"莆田",@"三明",@"兰州",@"平凉",@"庆阳",@"武威",@"金昌",@"嘉峪关",@"酒泉",@"天水",@"武都",@"临夏",@"合作",@"白银",@"定西",@"张掖",@"广州",@"惠州",@"梅州",@"汕头",@"深圳",@"珠海",@"佛山",@"肇庆",@"湛江",@"江门",@"河源",@"清远",@"云浮",@"潮州",@"东莞",@"中山",@"阳江",@"揭阳",@"茂名",@"汕尾",@"韶关",@"南宁",@"柳州",@"来宾",@"桂林",@"梧州",@"防城港",@"贵港",@"玉林",@"百色",@"钦州",@"河池",@"北海",@"崇左",@"贺州",@"贵阳",@"安顺",@"都匀",@"兴义",@"铜仁",@"毕节",@"六盘水",@"遵义",@"凯里",@"昆明",@"红河",@"文山",@"玉溪",@"楚雄",@"普洱",@"昭通",@"临沧",@"怒江",@"香格里拉",@"丽江",@"德宏",@"景洪",@"大理",@"曲靖",@"保山",@"呼和浩特",@"乌海",@"集宁",@"通辽",@"阿拉善左旗",@"鄂尔多斯",@"临河",@"锡林浩特",@"呼伦贝尔",@"乌兰浩特",@"包头",@"赤峰",@"南昌",@"上饶",@"抚州",@"宜春",@"鹰潭",@"赣州",@"景德镇",@"萍乡",@"新余",@"九江",@"吉安",@"武汉",@"黄冈",@"荆州",@"宜昌",@"恩施",@"十堰",@"神农架",@"随州",@"荆门",@"天门",@"仙桃",@"潜江",@"襄樊",@"鄂州",@"孝感",@"黄石",@"咸宁",@"成都",@"自贡",@"绵阳",@"南充",@"达州",@"遂宁",@"广安",@"巴中",@"泸州",@"宜宾",@"内江",@"资阳",@"乐山",@"眉山",@"凉山",@"雅安",@"甘孜",@"阿坝",@"德阳",@"广元",@"攀枝花",@"银川",@"中卫",@"固原",@"石嘴山",@"吴忠",@"西宁",@"黄南",@"海北",@"果洛",@"玉树",@"海西",@"海东",@"海南",@"济南",@"潍坊",@"临沂",@"菏泽",@"滨州",@"东营",@"威海",@"枣庄",@"日照",@"莱芜",@"聊城",@"青岛",@"淄博",@"德州",@"烟台",@"济宁",@"泰安",@"西安",@"延安",@"榆林",@"铜川",@"商洛",@"安康",@"汉中",@"宝鸡",@"咸阳",@"渭南",@"太原",@"临汾",@"运城",@"朔州",@"忻州",@"长治",@"大同",@"阳泉",@"晋中",@"晋城",@"吕梁",@"乌鲁木齐",@"石河子",@"昌吉",@"吐鲁番",@"库尔勒",@"阿拉尔",@"阿克苏",@"喀什",@"伊宁",@"塔城",@"哈密",@"和田",@"阿勒泰",@"阿图什",@"博乐",@"克拉玛依",@"拉萨",@"山南",@"阿里",@"昌都",@"那曲",@"日喀则",@"林芝",@"台北县",@"高雄",@"台中",@"海口",@"三亚",@"东方",@"临高",@"澄迈",@"儋州",@"昌江",@"白沙",@"琼中",@"定安",@"屯昌",@"琼海",@"文昌",@"保亭",@"万宁",@"陵水",@"西沙",@"南沙岛",@"乐东",@"五指山",@"琼山",@"长沙",@"株洲",@"衡阳",@"郴州",@"常德",@"益阳",@"娄底",@"邵阳",@"岳阳",@"张家界",@"怀化",@"黔阳",@"永州",@"吉首",@"湘潭",@"南京",@"镇江",@"苏州",@"南通",@"扬州",@"宿迁",@"徐州",@"淮安",@"连云港",@"常州",@"泰州",@"无锡",@"盐城",@"哈尔滨",@"牡丹江",@"佳木斯",@"绥化",@"黑河",@"双鸭山",@"伊春",@"大庆",@"七台河",@"鸡西",@"鹤岗",@"齐齐哈尔",@"大兴安岭",@"长春",@"延吉",@"四平",@"白山",@"白城",@"辽源",@"松原",@"吉林",@"通化",@"沈阳",@"鞍山",@"抚顺",@"本溪",@"丹东",@"葫芦岛",@"营口",@"阜新",@"辽阳",@"铁岭",@"盘锦",@"大连",@"锦州", nil];
    self.citylist = [[NSMutableArray alloc] initWithArray:citys];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// 选中某一个列表项后的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    currentCity = cellText;
    NSLog(@"选中的城市：%@\n",currentCity);
    // 清除掉对当前的城市的标记
    for (UITableViewCell *cell in [tableView visibleCells]) {
        if (cell != selectedCell && cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    if(selectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// tableView要求实现的协议方法
#pragma mark - Table view data source

// 多少个表项
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
//    return 0;
    return 1;
}
// 所有的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if([tableView isEqual:searchDC.searchResultsTableView])
    {
        return [self.resultCitylist count];
    }
    return [self.citylist count];
}
// 设置表的显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CMainCell = @"CMaincell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
                            
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CMainCell] ;
    }
    
    // Configure the cell...
    if([tableView isEqual:searchDC.searchResultsTableView]) {
        cell.textLabel.text = [self.resultCitylist objectAtIndex:indexPath.row];
    }
    else{
        cell.textLabel.text = [self.citylist objectAtIndex:indexPath.row];
    }
    return cell;
}
#pragma market - SearchDisplayBar的委托
// 搜索框的搜索功能，将搜索结果存入resultCitylist
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchString];
    self.resultCitylist = [self.citylist filteredArrayUsingPredicate:predicate];
    return YES;
}
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    controller.searchBar.showsCancelButton = YES;//显示cancel button
    NSLog(@"开始搜索");
    for (UIView *subView in self.searchDisplayController.searchBar.subviews) {
//        if ([subView isKindOfClass:NSClassFromString(@"UIButton")]) // 或者[UIButton class]
//        {
//            cancelButton = (UIButton*)subView;
//            // 在这里修改属性
//            NSLog(@"Find the cancel button");
//            [cancelButton setTitle:@"完成" forState:UIControlStateNormal];
//        }
        NSLog(@"%@",subView.description);
    }
}

@end
