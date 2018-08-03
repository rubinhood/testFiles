//
//  SliderMenuVC.m
//  TaxiApp
//
//  Created by Quick on 9/29/16.
//  Copyright © 2016 Quick Technosoft Pvt. Ltd. All rights reserved.
//

#import "SliderMenuVC.h"
#import "SlidmenuCell.h"
#import "AppDelegate.h"
//#import "ProfileVC.h"

@interface SliderMenuVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *menuArray, *menuImgArray, *menuImgArray_H;
    NSIndexPath *selectionIndex;
}
@end

@implementation SliderMenuVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    menuArray = [[NSArray alloc] initWithObjects:@"Home",@"Profile", @"Mail",  @"Shop",  @"Wish List", @"Charity", @"Settings",@"Logout",nil];
    
    menuImgArray = [[NSArray alloc] initWithObjects:@"menu-home.png", @"menu-profile.png",  @"menu-mail.png",  @"menu-cart.png"  ,@"menu-wishlist.png",@"charity.png",@"setting.png", @"logout.png",nil];
    
   
    // delegates adding...
    self.table_view.delegate = self;
    self.table_view.dataSource = self;
    self.table_view.estimatedRowHeight =  10;
    self.table_view.rowHeight = UITableViewAutomaticDimension;
    
    //[self.table_view reloadData];
    // add single tap gesture to instruction menu...
    UISwipeGestureRecognizer *swipeLeftOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftOrange.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftOrange];
    
    // add single tap gesture to instruction menu...
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    singleTap.numberOfTapsRequired = 1;
    [self.black_view addGestureRecognizer:singleTap];

    
}
- (void)tapGesture:(UISwipeGestureRecognizer *)sender {
    AppDelegate *appdelegate = [AppDelegate appDelegate];
    [appdelegate sliderMenuAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers
- (void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)sender {
    AppDelegate *appdelegate = [AppDelegate appDelegate];
    [appdelegate sliderMenuAction];
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       return [menuArray count];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell creation...
    SlidmenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SlidmenuCell"];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"SlidmenuCell" bundle:nil] forCellReuseIdentifier:@"SlidmenuCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"SlidmenuCell"];
    }
    cell.mInfoLabel.alpha = 0;

    // display names based on section....
    
    cell.title_lbl.text = [menuArray objectAtIndex:indexPath.row];
    cell.img_view.image = [UIImage imageNamed:[menuImgArray objectAtIndex:indexPath.row]];
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectionIndex = indexPath;
    [tableView reloadData];
    
    // Calling home Screen....
    if ([self.delegate respondsToSelector:@selector(sliderMenu_clickedIndexPath:)]) {
        
            [self.delegate sliderMenu_clickedIndexPath:[menuArray objectAtIndex:indexPath.row]];
        }
}



@end
