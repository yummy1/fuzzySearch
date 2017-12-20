//
//  Model.m
//  SearchDemo
//
//  Created by MM on 2017/12/20.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "Model.h"

@implementation Model
+ (instancetype)initWithDictionary:(NSDictionary *)dic
{
    Model *model = [[Model alloc] init];
    model.pic = dic[@"pic"];
    model.tel = dic[@"tel"];
    model.uname = dic[@"uname"];
    model.uid = [dic[@"uid"] integerValue];
    return model;
}
@end
