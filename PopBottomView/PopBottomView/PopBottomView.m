//
//  PopBottomView.m
//  PopBottomView
//
//  Created by deco on 2017/9/8.
//  Copyright © 2017年 deco. All rights reserved.
//


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Color_Main      UIColorFromRGB(0xe50012)     //主题颜色 红色

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "PopBottomView.h"

@interface PopBottomView()<UIGestureRecognizerDelegate>

@property (strong, nonatomic)NSString *title;

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSArray *dataArr;
@property (strong, nonatomic)NSDictionary *selectedDic;
@property (strong, nonatomic)NSMutableArray *selectedArray;
@property (strong, nonatomic)NSMutableArray *buttonArray;
@property (strong, nonatomic)UIButton *selecedBtn;
@property (strong, nonatomic)UIButton *allItemButton;
@property (assign, nonatomic)BOOL isSingleSelect;//是否单选
/** 是否显示全部按钮 */
@property (assign, nonatomic)BOOL hasAllBtn;

@end


@implementation PopBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

//多选
-(void)showFromView:(UIView *)view WithData:(NSArray *)array andTitle:(NSString *)title defaultSelectedItems:(NSArray<NSDictionary *> *)selectedArray hasAllBtn:(BOOL)hasAllBtn{
    [view addSubview:self];
    self.title = title;
    self.dataArr = array;
    self.isSingleSelect = NO;
    self.hasAllBtn = hasAllBtn;
    self.itemIdKeyStr = self.itemIdKeyStr.length?self.itemIdKeyStr:@"itemIdKeyStr";
    self.itemNameKeyStr = self.itemNameKeyStr.length?self.itemNameKeyStr:@"itemNameKeyStr";
    
    [self.selectedArray removeAllObjects];
    [self.selectedArray addObjectsFromArray:selectedArray];
    
    
    [self seutpViewWithData:array];
    self.transform=CGAffineTransformMakeScale(0.01, 0.01);;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    if (self.selectedArray.count==self.dataArr.count) {
        self.allItemButton.backgroundColor = UIColorFromRGB(0xe50012);
        self.allItemButton.selected = YES;
    }else{
        self.allItemButton.selected = NO;
        self.allItemButton.backgroundColor = [UIColor whiteColor];
    }
    
}


//单选
-(void)showFromView:(UIView *)view WithData:(NSArray *)array andTitle:(NSString *)title defaultSelectedItem:(NSDictionary *)selectedDic{
    [view addSubview:self];
    self.title = title;
    self.dataArr = array;
    self.selectedDic = selectedDic;
    self.isSingleSelect = YES;
    self.hasAllBtn = NO;
    
    self.itemIdKeyStr = self.itemIdKeyStr.length?self.itemIdKeyStr:@"itemIdKeyStr";
    self.itemNameKeyStr = self.itemNameKeyStr.length?self.itemNameKeyStr:@"itemNameKeyStr";
    
    
    [self seutpViewWithData:array];
    self.transform=CGAffineTransformMakeScale(0.01, 0.01);;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

//选中按钮
-(void)buttonClick:(UIButton *)button{
    
    if (self.isSingleSelect)//单选
    {
        for (int i=0; i<self.buttonArray.count; i++) {
            UIButton *btn = self.buttonArray[i];
            if (btn != button) {
                btn.selected = NO;
                btn.backgroundColor = [UIColor whiteColor];
            }
        }
        if (button.selected) {
            return;
        }else{
            button.selected = !button.selected;
            button.backgroundColor = Color_Main;
        }
        self.selecedBtn = button;
        NSInteger index = self.selecedBtn.tag;
        self.selectedDic = self.dataArr[index];
    }
    else//多选
    {
        
        button.selected = !button.selected;
        if (button.selected) {
            button.backgroundColor = Color_Main;
        }else{
            button.backgroundColor = [UIColor whiteColor];
        }
        
        [self.selectedArray removeAllObjects];
        //点击全部选择按钮
        if (button.tag == -1) {//全部选择按钮
            for (int i=0; i<self.buttonArray.count; i++) {
                UIButton *otherBtn = self.buttonArray[i];
                otherBtn.selected = button.selected;
                if (otherBtn.selected) {
                    otherBtn.backgroundColor = Color_Main;
                    [self.selectedArray addObject:self.dataArr[otherBtn.tag]];
                }else{
                    otherBtn.backgroundColor = [UIColor whiteColor];
                }
            }
            return;
        }
        
        //点击其他选择按钮
        for (int i=0; i<self.buttonArray.count; i++) {
            UIButton *btn = self.buttonArray[i];
            if (btn.selected) {
                [self.selectedArray addObject:self.dataArr[btn.tag]];
            }
        }
        if (self.selectedArray.count==self.dataArr.count) {
            self.allItemButton.backgroundColor = Color_Main;
            self.allItemButton.selected = YES;
        }else{
            self.allItemButton.selected = NO;
            self.allItemButton.backgroundColor = [UIColor whiteColor];
        }
        
        
        //最少选择一项
        //        if (!self.selectedArray.count) {
        //            button.selected = YES;
        //            button.backgroundColor = Color_Main;
        //            [self.selectedArray addObject:self.dataArr[button.tag]];
        //        }
        
    }
}

//确定按钮
-(void)selectBtnClick:(UIButton *)button{
    
    
    if (self.isSingleSelect) {//单选
        NSInteger index = self.selecedBtn.tag;
        NSDictionary *dic = self.dataArr[index];
        if (self.SureBtnDidClickBlock) {
            self.SureBtnDidClickBlock(dic);
        };
    }else{//多选
        if (self.SureButtonDidClickBlock) {
            if (self.selectedArray.count==self.dataArr.count && self.selectedArray.count>0) {
                self.SureButtonDidClickBlock(self.selectedArray, YES);
            }else{
                self.SureButtonDidClickBlock(self.selectedArray, NO);
            }
            
        };
    }
    
    [self removeFromSuperview];
    [self removeAllSubViews];
    
}

//取消按钮
-(void)canceBtnClick:(UIButton *)button{
    [self removeFromSuperview];
    
    [self removeAllSubViews];
    
    if (self.CanceBtnClickBlock) {
        self.CanceBtnClickBlock();
    }
}
-(void)removeAllSubViews{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    _selecedBtn = nil; _selectedDic = nil; _selectedArray = nil;
    
    if (self.DissmissBlock) {
        self.DissmissBlock();
    }
}


-(void)setupSelectItemsColor{
    //设置多选颜色
    if (self.selectedArray.count) {
        for (int j =0; j<self.selectedArray.count; j++) {
            NSDictionary *selectItemDic = self.selectedArray[j];
            NSString *selectItemKey = [selectItemDic objectForKey:self.itemIdKeyStr];
            for (int i =0; i<self.dataArr.count; i++) {
                NSDictionary *dic = self.dataArr[i];
                UIButton *button = self.buttonArray[i];
                NSString *itemKey = [dic objectForKey:self.itemIdKeyStr];
                if ([selectItemKey isEqualToString:itemKey]) {
                    button.backgroundColor=Color_Main;//选中颜色
                    button.selected = YES;
                }else{
                    button.backgroundColor=[UIColor whiteColor];//普通颜色
                    button.selected = NO;
                }
            }
        }
    }
    
}


//点击背景移除view
-(void)tapAvatarView:(UITapGestureRecognizer *)rotationGesture{
    UIView *bgView = (UIImageView *)rotationGesture.view;
    if (bgView.superview) {
        [bgView.superview removeFromSuperview];
    }
    [bgView removeFromSuperview];
    [self removeAllSubViews];
}

//背景
-(void)setupBgView{
    UIView* bgView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addSubview:bgView];
    bgView.backgroundColor=[UIColor blackColor];
    bgView.alpha=0.5;
    [self addSubview:bgView];
    
    //添加手势
    UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    PrivateLetterTap.numberOfTouchesRequired = 1; //手指数
    PrivateLetterTap.numberOfTapsRequired = 1; //tap次数
    PrivateLetterTap.delegate= self;
    bgView.userInteractionEnabled = YES;
    [bgView addGestureRecognizer:PrivateLetterTap];
}

-(void)seutpViewWithData:(NSArray *)array{
    
    [self setupBgView];
    
    NSInteger itemCount = self.hasAllBtn ? array.count+1 : array.count;
    
    CGFloat viewWight = ScreenWidth;
    //     总行数 能整除就取结果，不能整除就取结果+1
    NSUInteger rows = itemCount / 3;
    if (itemCount % 3) { // 不能整除, + 1
        rows++;
    }
    CGFloat viewHeight = 45+20+rows*50+20;
    UIView *showView=[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-viewHeight, viewWight, viewHeight)];
    showView.backgroundColor = [UIColor whiteColor];
    showView.layer.cornerRadius=3;
    [self addSubview:showView];
    
    //标题 以及按钮
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, showView.frame.size.width, 45)];
    titleView.backgroundColor = UIColorFromRGB(0xedeff4);
    [showView addSubview:titleView];
    UILabel *titleLB = [[UILabel alloc] init];
    titleLB.textAlignment=NSTextAlignmentCenter;
    titleLB.text=self.title;
    titleLB.textColor=UIColorFromRGB(0x333333);
    titleLB.font=[UIFont boldSystemFontOfSize:15.0];
    titleLB.frame = CGRectMake(0, 0, showView.frame.size.width, 45);
    [titleView addSubview:titleLB];
    UIButton *sureBtn = [self buttonWithFrame:CGRectMake(ScreenWidth-75, 7.5,60, 30) Title:@"确定" backgroundColor: UIColorFromRGB(0xF25D22) action:@selector(selectBtnClick:)];
    UIButton *canceBtn = [self buttonWithFrame:CGRectMake(15, 7.5, 60, 30) Title:@"取消" backgroundColor:UIColorFromRGB(0xcccccc) action:@selector(canceBtnClick:)];
    
    [titleView addSubview:sureBtn];
    [titleView addSubview:canceBtn];
    //横线1
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, showView.frame.size.width, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xDBDDE1);
    [showView addSubview:line];
    
    // 中间n个按钮
    int maxCols = 3;
    CGFloat buttonW = (viewWight-40) / 3;
    CGFloat buttonH = 40;
    CGFloat buttonStartY = 70;
    CGFloat buttonStartX = 10;
    CGFloat Margin = 10;
    
    [self.buttonArray removeAllObjects];
    for (int i = 0; i<itemCount; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        
        button.tag = self.hasAllBtn ? i-1 : i;
        
        
        if (button.tag == -1) {
            self.allItemButton = button;
        }else{
            [self.buttonArray addObject:button];
        }
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [showView addSubview:button];
        // 设置内容
        //        NSDictionary *dic = self.dataArr[i];
        //        NSString *btnStr = dic[self.itemNameKeyStr];
        
        
        NSString *btnStr = @"";
        if (self.hasAllBtn) {
            if (i==0) {
                if (self.allItemName.length) {
                    btnStr = self.allItemName;
                }else{
                    btnStr = @"全部";
                }
                
            }else{
                NSDictionary *dic = self.dataArr[i-1];
                btnStr = dic[self.itemNameKeyStr];
            }
        }else{
            NSDictionary *dic = self.dataArr[i];
            btnStr = dic[self.itemNameKeyStr];
        }
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:btnStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button.layer setBorderWidth:0.5];
        button.backgroundColor=[UIColor whiteColor];//普通颜色
        
        NSString *itemKey = @"";
        if (self.hasAllBtn) {
            if (i>0) {
                NSDictionary *itemDic = array[i-1];
                itemKey = [itemDic objectForKey:self.itemIdKeyStr];
            }
        }else{
            NSDictionary *itemDic = array[i];
            itemKey = [itemDic objectForKey:self.itemIdKeyStr];
        }
        
        //设置单选颜色
        if (self.selectedDic) {
            NSString *selectItemKey = [self.selectedDic objectForKey:self.itemIdKeyStr];
            if ([selectItemKey isEqualToString:itemKey]) {
                button.backgroundColor=Color_Main;//选中颜色
                button.selected = YES;
            }else{
                button.selected = NO;
                button.backgroundColor=[UIColor whiteColor];//普通颜色
            }
        }
        
        //设置多选颜色
        if (self.selectedArray) {
            BOOL isBtnSelected = NO;
            if (self.selectedArray.count) {
                for (int j =0; j<self.selectedArray.count; j++) {
                    NSDictionary *selectItemDic = self.selectedArray[j];
                    NSString *selectItemKey = [selectItemDic objectForKey:self.itemIdKeyStr];
                    if ([selectItemKey isEqualToString:itemKey]) {
                        isBtnSelected = YES;
                    }
                }
            }
            if (isBtnSelected) {
                button.backgroundColor=Color_Main;//选中颜色
                button.selected = YES;
            }else{
                button.selected = NO;
                button.backgroundColor=[UIColor whiteColor];//普通颜色
            }
        }
        
        [button.layer setBorderColor:UIColorFromRGB(0XD6D6D6).CGColor];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        
        // 计算X\Y
        int row = i / maxCols;
        int col = i % maxCols;
        
        CGFloat buttonX = buttonStartX + col * (Margin + buttonW);
        CGFloat buttonY = buttonStartY + row * (buttonH + Margin);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        
    }
    
}

/**
 * 按钮
 */
-(UIButton *)buttonWithFrame:(CGRect)frame Title:(NSString *)title backgroundColor:(UIColor *)backgroundColor action:(SEL)action{
    UIButton *button = [[UIButton alloc] init];
    button.frame = frame;
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:15.0];
    button.backgroundColor = backgroundColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return  _selectedArray;
}

-(NSMutableArray *)buttonArray{
    if (_buttonArray==nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}



@end
