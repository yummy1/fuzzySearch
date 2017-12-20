//
//  TableViewCell.m
//  SearchDemo
//
//  Created by MM on 2017/12/20.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation TableViewCell
- (void)setModel:(Model *)model
{
    _model = model;
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    _name.text = model.uname;
    _tel.text = model.tel;
}


@end
