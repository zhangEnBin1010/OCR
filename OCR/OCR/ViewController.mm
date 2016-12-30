//
//  ViewController.m
//  OCR
//
//  Created by zeb－Apple on 16/11/24.
//  Copyright © 2016年 zeb－Apple. All rights reserved.
//

#import "ViewController.h"
#import "ScanCardViewController.h"
#import "IDCardViewController.h"
#import "IdInfo.h"
#import "EasyPRViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL * bundleurl=[[NSBundle mainBundle] resourceURL];
    NSString * bundlePath=[[NSBundle mainBundle] resourcePath];
    
}
- (IBAction)idcard:(id)sender {
    
    IDCardViewController *svc = [[IDCardViewController alloc] init];
   
    [self.navigationController pushViewController:svc animated:YES];
}

- (IBAction)bankcard:(id)sender {
    ScanCardViewController *svc = [[ScanCardViewController alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [svc passValue:^(NSString *cardNo,NSString *bank) {
        
        [weakSelf getCardNum:cardNo bank:bank];
    }];
    [self.navigationController pushViewController:svc animated:YES];
    
}
- (void)getCardNum:(NSString *)cardNo bank:(NSString *)bank{
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:bank message:cardNo preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];

    [alertController addAction:action1];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)carCard:(id)sender {
    
    EasyPRViewController *easyPR = [[EasyPRViewController alloc] init];
    [self.navigationController pushViewController:easyPR animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
