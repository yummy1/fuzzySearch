//
//  ResultViewController.m
//  SearchDemo
//
//  Created by MM on 2017/12/20.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "ResultViewController.h"
#import "Model.h"
#import "TableViewCell.h"

@interface ResultViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ResultViewController
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
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class]) forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TableViewCell class]) owner:self options:nil][0];
    }
    cell.model = self.searchResults[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *newVC = [[UIViewController alloc] init];
    Model *p=self.searchResults[indexPath.row];
    newVC.title = p.uname;
    newVC.view.backgroundColor = [UIColor lightGrayColor];
    [self.mainSearchController.navigationController pushViewController:newVC animated:YES];
}

@end
