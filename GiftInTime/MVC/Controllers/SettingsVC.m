//
//  SettingsVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 15/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "SettingsVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToPreviousViewController:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
