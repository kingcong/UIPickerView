//
//  ViewController.m
//  UIPickerView基本用法
//
//  Created by kingcong on 16/5/27.
//  Copyright © 2016年 王聪. All rights reserved.
//

#import "ViewController.h"
#import "CWPickerView.h"

@interface ViewController ()

@property (nonatomic, strong) CWPickerView *pickerView; // pickerView

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation ViewController

// 作为TextField的弹出视图的工具条
- (UIToolbar *)toolbar
{
    if (_toolbar == nil) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
        
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *certain = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(certain)];

        _toolbar.items = @[cancel,flexibleSpace,certain];
    }
    return _toolbar;
}

// 点击了取消
- (void)cancel
{
    [self.textField resignFirstResponder];
}

// 点击了确定
- (void)certain
{
    // 获取当前选中的信息
    NSDictionary *info = [self.pickerView getCurrentSelectedInfo];
    // 获取当前选中的信息
    NSString *provice = info[@"province"];
    
    NSString *city = info[@"city"];
    
    NSString *country = info[@"country"];
    
    // 弹出提示
    NSString *message = [NSString stringWithFormat:@"您选择的是:%@-%@-%@",provice,city,country];
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return;
    }];
    [alertVc addAction:cancel];
    
    [self presentViewController:alertVc animated:YES completion:nil];


}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CWPickerView *pickerView = [[CWPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    self.pickerView = pickerView;
    // 将pickerView作为UITextFiled的输出View
    self.textField.inputView = pickerView;
    
    // 将toolBar作为textField的弹出视图
    self.textField.inputAccessoryView = self.toolbar;
}


@end
