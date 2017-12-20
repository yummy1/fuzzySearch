//
//  TableViewCell.h
//  SearchDemo
//
//  Created by MM on 2017/12/20.
//  Copyright © 2017年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
@interface TableViewCell : UITableViewCell
@property (nonatomic,strong) Model *model;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@end
