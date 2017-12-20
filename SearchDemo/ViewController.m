//
//  ViewController.m
//  SearchDemo
//
//  Created by MM on 2017/12/20.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import "ResultViewController.h"
#import "TableViewCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>
@property(nonatomic,strong)NSArray *userArray;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) ResultViewController *resultVC;
@property(nonatomic,strong)UISearchController *svc;

@end

@implementation ViewController
- (NSArray *)userArray
{
    if (_userArray == nil) {
        NSError *error;
        // 获取文件路径
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        
        // 根据文件路径读取数据
        NSData *jdata = [[NSData alloc] initWithContentsOfFile:filePath];
        
        // 格式化成json数据
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jdata options:kNilOptions error:&error];
        
        NSArray *array = jsonObject[@"data"][@"corps"];
        NSMutableArray *mulArr = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mulArr addObject:[Model initWithDictionary:obj]];
        }];
        _userArray = [mulArr copy];
    }
    return _userArray;
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TableViewCell class])];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.userArray);
    [self.view addSubview:self.tableView];
    
    //创建两个属性实例
    self.resultVC=[[ResultViewController  alloc]init];
    self.resultVC.mainSearchController = self;
    self.svc=[[UISearchController alloc]initWithSearchResultsController:self.resultVC];
    //设置与界面有关的样式
    [self.svc.searchBar sizeToFit];   //大小调整
    self.tableView.tableHeaderView=self.svc.searchBar;
    
    //设置搜索控制器的结果更新代理对象
    self.svc.searchResultsUpdater=self;
    
    //Scope:就是效果图中那个分类选择器
//    self.svc.searchBar.scopeButtonTitles=@[@"设备",@"软件",@"其他"];
    //为了响应scope改变时候，对选中的scope进行处理 需要设置search代理
    self.svc.searchBar.delegate=self;
    
    self.definesPresentationContext=YES;   //迷之属性，打开后搜索结果页界面显示会比较好。
    //看文档貌似是页面转换模式为UIModalPresentationCurrentContext，如果该选项打开，那么就会使用当前ViewController的一个presentContenxt
    //否则就向父类中进行寻找并使用。
}
/**普通的tableview展示实现。*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.userArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class]) forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TableViewCell class]) owner:self options:nil][0];
    }
    cell.model = self.userArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}
#pragma mark - UISearchResultsUpdating
/**实现更新代理*/
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //获取scope被选中的下标
//    NSInteger selectedType=searchController.searchBar.selectedScopeButtonIndex;
    //获取到用户输入的数据
    NSString *searchText=searchController.searchBar.text;
    NSMutableArray *searchResult=[[NSMutableArray alloc]init];
    
    //加个多线程，否则数量量大的时候，有明显的卡顿现象
    //这里最好放在数据库里面再进行搜索，效率会更快一些
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        if ([self isNumberStr:searchText]) {
            NSLog(@"输入数字");
            //遍历需要搜索的所有内容，其中self.userArray为存放总数据的数组
            for (Model *model in self.userArray) {
                if ([model.tel rangeOfString:searchText options:NSCaseInsensitiveSearch].length > 0) {
                    //把搜索结果存放self.searchArray数组
                    [searchResult addObject:model];
                }
            }
        }else{
            //输入汉字或者拼音
            //遍历需要搜索的所有内容，其中self.userArray为存放总数据的数组
            for (Model *model in self.userArray) {
                NSString *tempStr = model.uname;
                //----------->把所有的搜索结果转成成拼音
                NSString *pinyin = [self transformToPinyin:tempStr];
//                NSLog(@"pinyin--%@",pinyin);
                
                if ([pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch].length > 0) {
                    //把搜索结果存放self.resultArray数组
                    [searchResult addObject:model];
                }
            }
        }
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultVC.searchResults=searchResult;
            /**通知结果ViewController进行更新*/
            [self.resultVC.tableView reloadData];
        });
    });
}
#pragma mark - UISearchBarDelegate
/**点击按钮后，进行搜索页更新*/
-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.svc];
}

- (BOOL)isNumberStr:(NSString *)str
{
    return [self match:@"^[0-9]+$" text:str];
}
- (BOOL)match:(NSString *)pattern text:(NSString *)str{
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:NULL];
    NSArray *res = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    return res.count==1;
}
#pragma mark !!!获取汉字转成拼音字符串 通讯录模糊搜索 支持拼音检索 首字母 全拼 汉字 搜索
- (NSString *)transformToPinyin:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    int count = 0;
    
    for (int  i = 0; i < pinyinArray.count; i++)
    {
        
        for(int i = 0; i < pinyinArray.count;i++)
        {
            if (i == count) {
                [allString appendString:@"#"];//区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
            
        }
        [allString appendString:@","];
        count ++;
        
    }
    
    NSMutableString *initialStr = [NSMutableString new];//拼音首字母
    
    for (NSString *s in pinyinArray)
    {
        if (s.length > 0)
        {
            
            [initialStr appendString:  [s substringToIndex:1]];
        }
    }
    
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",aString];
    
    return allString;
}

@end
