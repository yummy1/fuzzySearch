//
//  ResultViewController.h
//  SearchDemo
//
//  Created by MM on 2017/12/20.
//  Copyright © 2017年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *searchResults;

//在MySearchResultViewController添加一个指向展示页的【弱】引用属性。
@property (nonatomic, weak) UIViewController *mainSearchController;
@end
