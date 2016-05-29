//
//  CWPickerView.m
//  UIPickerView基本用法
//
//  Created by kingcong on 16/5/29.
//  Copyright © 2016年 王聪. All rights reserved.
//

#import "CWPickerView.h"

@interface CWPickerView() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic,retain) NSArray *provinceArray;//存储所有的省的名称
@property (nonatomic,retain) NSArray *cityArray;//存储对应省份下的所有城市名
@property (nonatomic,retain) NSArray *countyArray;//存储所有的县区名

@end

@implementation CWPickerView

#pragma mark - 懒加载

- (NSArray *)provinceArray
{
    if (_provinceArray == nil) {
        _provinceArray = [NSArray array];
    }
    return _provinceArray;
}

- (NSArray *)cityArray
{
    if (_cityArray == nil) {
        _cityArray = [NSArray array];
    }
    return _cityArray;
}

- (NSArray *)countyArray
{
    if (_countyArray == nil) {
        _countyArray = [NSArray array];
    }
    return _countyArray;
}


//创建pickerView
- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        //初始化一个pickerView
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        //设置背景色
        //设置代理
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
    }
    
    return _pickerView;
}

#pragma mark - 界面初始化
/**
 *  初始化
 *
 *  @param frame frame
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

/**
 *  初始化界面
 */
- (void)setupUI
{
    // 加载数据
    [self loadData];
    
    [self addSubview: self.pickerView];
}

#pragma mark - UIPickerViewDataSource和UIPickerViewDelegate
// 设置列的返回数量
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//设置列里边组件的个数 component:组件
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //如果是第一列
    if (component == 0)
    {
        //返回省的个数
        return self.provinceArray.count;
    }
    //如果是第二列
    else if (component == 1)
    {
        //返回市的个数
        return self.cityArray.count;
    }
    else
    {
        //返回县区的个数
        return self.countyArray.count;
    }
}

//返回组件的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        // 设置第0列的标题信息
        NSDictionary *provinceDict = [self.provinceArray objectAtIndex:row];
        NSString *name = provinceDict[@"n"];
        return name;
    } else if (component == 1) {
        // 设置第1列的标题信息
        NSDictionary *cityDict = [self.cityArray objectAtIndex:row];
        NSString *name = cityDict[@"n"];
        return name;
    } else {
        // 设置第2列的标题信息
        NSDictionary *countryDict = [self.countyArray objectAtIndex:row];
        NSString *name = countryDict[@"n"];
        return name;
    }
}

//选择器选择的方法  row：被选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //选择第0列执行的方法
    if (component == 0) {
        [pickerView selectedRowInComponent:0];
        
        /**
         *  选中第0列时需要刷新第1列和第二列的数据
         */
        NSDictionary *provinceDict = [self.provinceArray objectAtIndex:row];
        self.cityArray = provinceDict[@"l"];
        [pickerView reloadComponent:1];
        
        NSDictionary *cityDict = [self.cityArray firstObject];
        self.countyArray = cityDict[@"l"];
        [pickerView reloadComponent:2];
        
    } else if (component == 1) {
        [pickerView selectedRowInComponent:1];
        
        /**
         *  选中第一列时需要刷新第二列的数据信息
         */
        NSDictionary *cityDict = [self.cityArray objectAtIndex:row];
        self.countyArray = cityDict[@"l"];
        [pickerView reloadComponent:2];
        
    } else if (component == 2) {
        [pickerView selectedRowInComponent:2];
        
    }
    
}

- (NSDictionary *)getCurrentSelectedInfo
{
    // 获取当前选中的信息
    NSInteger proviceIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger cityIndex = [self.pickerView selectedRowInComponent:1];
    NSInteger countryIndex = [self.pickerView selectedRowInComponent:2];
    
    NSString *provice = self.provinceArray[proviceIndex][@"n"];
    
    NSString *city = self.cityArray.count != 0 ? self.cityArray[cityIndex][@"n"] : @"";
    
    NSString *country = self.countyArray.count != 0 ? self.countyArray[countryIndex][@"n"] : @"";
    
    NSLog(@"%@,%@,%@",provice,city,country);
    
    NSDictionary *info = @{@"province":provice,@"city":city,@"country":country};
    return info;
}

#pragma mark - 加载数据
- (void)loadData
{
    // 从MainBundle中加载文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"data"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray  *jsonArray = [NSJSONSerialization
                           JSONObjectWithData:data options:NSJSONReadingAllowFragments
                           error:nil];
    // 取出默认的省市信息
    self.provinceArray = jsonArray;
    
    // 取出默认的城市信息
    NSDictionary *provinceDict = [self.provinceArray firstObject];
    self.cityArray = provinceDict[@"l"];
    
    // 取出默认的区信息
    NSDictionary *cityDict = [self.cityArray firstObject];
    self.countyArray = cityDict[@"l"];
}


@end
