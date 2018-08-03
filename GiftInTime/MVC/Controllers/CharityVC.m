//
//  CharityVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 15/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "CharityVC.h"
#import "MenuCell.h"

@interface CharityVC () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation CharityVC

{
    NSMutableArray  *mMenuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mMenuItems = [[NSMutableArray alloc] init];
    [self getRefreshMenuTable];
    //mMenuItems = [[NSMutableArray alloc] initWithObjects:@"50 Points",@"50 Points",@"100 Points",@"150 Points",@"200 Points",@"250 Points", nil];
    _mMenuVu.delegate = self;
    _mMenuVu.dataSource  = self;
    _mMenuVu.estimatedRowHeight = 20;
    _mMenuVu.rowHeight = UITableViewAutomaticDimension;
    
    [_mMenuVu reloadData];
    [_mMenuVu layoutIfNeeded];

    _mMenuHeight.constant = _mMenuVu.contentSize.height;
    
    [self hideMenu];
    
}

-(void)getRefreshMenuTable {
    int count = DataInstance.mGiftPoints / 50 ;
    if(count == 0) {
        [ _mPointsBtn setTitle:[NSString stringWithFormat:@"%d Points",(DataInstance.mGiftPoints % 50)] forState:UIControlStateNormal];
        _mPointsBtn.userInteractionEnabled = NO;
        return ;
    }
    for (int i = 0; i <  count; i++) {
        [mMenuItems addObject:[NSString stringWithFormat:@"%d Points",i *50]];
    }
    [_mMenuVu reloadData];
    [self hideMenu];
    [ _mPointsBtn setTitle:[mMenuItems objectAtIndex:0] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backToPreviousViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showMenuView:(id)sender {
    [self showMenu];

}


- (IBAction)hideMenuView:(id)sender {
    [self hideMenu];
    
}

-(void) hideMenu {
    _mDropSideImage.highlighted = NO;
    _mMenuHeight.constant = 0 ;
    [self.view sendSubviewToBack:_mMainMenuVu];

}

-(void) showMenu {
    [self.view bringSubviewToFront:_mMainMenuVu];
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _mMenuHeight.constant = _mMenuVu.contentSize.height ;
        _mDropSideImage.highlighted = YES;
        [_mMenuVu.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        nil;
    }];
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mMenuItems count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell creation...
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    }
    
    cell.mMenuItemName.text = [mMenuItems objectAtIndex:indexPath.row];
    // display names based on section....
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self hideMenu];
    [ _mPointsBtn setTitle:[mMenuItems objectAtIndex:indexPath.row] forState:UIControlStateNormal];

    
}




@end
