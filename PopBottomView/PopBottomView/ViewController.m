//
//  ViewController.m
//  PopBottomView
//
//  Created by deco on 2017/9/8.
//  Copyright © 2017年 deco. All rights reserved.
//

#import "ViewController.h"
#import "PopBottomView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = UIColorFromRGB(0xedeff4);
    self.title = @"底部弹出选择框";
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"单选" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 setFrame:CGRectMake(0, 100, ScreenWidth, 40)];
    [btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"多选1-有全部按钮" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 setFrame:CGRectMake(0, 180, ScreenWidth, 40)];
    [btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setTitle:@"多选2-无全部按钮" forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor orangeColor];
    [btn3 setFrame:CGRectMake(0, 260, ScreenWidth, 40)];
    [btn3 addTarget:self action:@selector(btn3Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
}


//单选
-(void)btn1Click{
    [self SelectTypeView];
}

//多选
-(void)btn2Click{
    [self SelectTypeView2];
}

//多选
-(void)btn3Click{
    [self SelectTypeView3];
}




//选择类型使用列子---单选
-(void)SelectTypeView{
    
    //————————————————————————假数据————————————————————————start
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<7; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"dataCfgName"] = [NSString stringWithFormat:@"类型%d",i];
        dic[@"dataCfgId"] = [NSString stringWithFormat:@"%d",i];
        [arr addObject:dic];
    }
    //————————————————————————假数据————————————————————————end
    
    
    PopBottomView *selectTypeView = [[PopBottomView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    selectTypeView.itemIdKeyStr = @"dataCfgId";//指定字典的key，不指定为默认key---itemIdKeyStr
    selectTypeView.itemNameKeyStr = @"dataCfgName";
    
    [selectTypeView showFromView:self.view WithData:arr andTitle:@"选择订单类型(单选)" defaultSelectedItem:nil];
    selectTypeView.SureBtnDidClickBlock = ^(NSDictionary *dic) {
        NSLog(@"===%@",dic);
    };
}


//选择类型使用列子---多选
-(void)SelectTypeView2{
    
    PopBottomView *selectTypeView = [[PopBottomView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    //不指定字典的key，默认key---itemIdKeyStr，itemNameKeyStr
    
    //————————————————————————假数据————————————————————————start
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<7; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"itemNameKeyStr"] = [NSString stringWithFormat:@"类型%d",i];
        dic[@"itemIdKeyStr"] = [NSString stringWithFormat:@"%d",i];
        [arr addObject:dic];
    }
    NSDictionary *itemDic = arr[1];
    NSDictionary *itemDic2 = arr[5];
    NSDictionary *itemDic3 = arr[6];
    NSArray *selectedArr = @[itemDic,itemDic2,itemDic3];//默认选中的数组项，没有就传nil
    //————————————————————————假数据————————————————————————end
    
    //    selectTypeView.hasAllBtn = YES;//是否有选择全部按钮
    selectTypeView.allItemName = @"选择全部类型";//全部按钮的文字--不传默认为：全部
    
    [selectTypeView showFromView:self.view WithData:arr andTitle:@"选择订单类型（多选）" defaultSelectedItems:selectedArr hasAllBtn:YES];
    selectTypeView.SureButtonDidClickBlock = ^(NSArray *selectedArray, BOOL selectedAll) {
        if (selectedAll) {
            NSLog(@"全部都选择了");
        }
        for (int i=0; i<selectedArray.count; i++) {
            NSLog(@"===%@",selectedArray[i]);
        }
    };
}



//选择类型使用列子---多选
-(void)SelectTypeView3{
    
    PopBottomView *selectTypeView = [[PopBottomView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    //不指定字典的key，默认key---itemIdKeyStr，itemNameKeyStr
    
    //————————————————————————假数据————————————————————————start
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<7; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"itemNameKeyStr"] = [NSString stringWithFormat:@"类型%d",i];
        dic[@"itemIdKeyStr"] = [NSString stringWithFormat:@"%d",i];
        [arr addObject:dic];
    }
    NSDictionary *itemDic = arr[1];
    NSDictionary *itemDic2 = arr[5];
    NSDictionary *itemDic3 = arr[6];
    NSArray *selectedArr = @[itemDic,itemDic2,itemDic3];//默认选中的数组项，没有就传nil
    //————————————————————————假数据————————————————————————end
    
    [selectTypeView showFromView:self.view WithData:arr andTitle:@"选择订单类型（多选）" defaultSelectedItems:selectedArr hasAllBtn:NO];
    selectTypeView.SureButtonDidClickBlock = ^(NSArray *selectedArray, BOOL selectedAll) {
        if (selectedAll) {
            NSLog(@"全部都选择了");
        }
        for (int i=0; i<selectedArray.count; i++) {
            NSLog(@"===%@",selectedArray[i]);
        }
    };
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
