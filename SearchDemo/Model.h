//
//  Model.h
//  SearchDemo
//
//  Created by MM on 2017/12/20.
//  Copyright © 2017年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *tel;
@property (nonatomic,assign) NSInteger uid;
@property (nonatomic,strong) NSString *uname;
+ (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
