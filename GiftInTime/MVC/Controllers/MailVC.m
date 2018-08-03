//
//  MailVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 12/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "MailVC.h"
#import "MailCell.h"

@interface MailVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mMailTable.delegate = self;
    _mMailTable.dataSource = self;
    _mMailTable.estimatedRowHeight =  10;
    _mMailTable.rowHeight = UITableViewAutomaticDimension;
    _mMailTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell creation...
    MailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailCell"];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"MailCell" bundle:nil] forCellReuseIdentifier:@"MailCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MailCell"];
    }
    cell.alpha = 0.8;
    
    // display names based on section....
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}



-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MailCell *cell = [_mMailTable cellForRowAtIndexPath:indexPath];
    CGFloat height = cell.frame.size.height;
    
    UITableViewRowAction *muteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"         " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"Action to perform with MuteAction");
                                    }];
    
    UIImage *im = [self getImage:[UIColor lightGrayColor] withIcon:[UIImage imageNamed:@"mail1.png"] withCellHeight:height];
    muteAction.backgroundColor = [UIColor colorWithPatternImage:im]; //arbitrary color
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"         " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         NSLog(@"Action to perform with DeleteAction");
                                     }];
    UIImage *im1 = [self getImage:[UIColor redColor] withIcon:[UIImage imageNamed:@"mail-delete.png"] withCellHeight:height];
    deleteAction.backgroundColor = [UIColor colorWithPatternImage:im1]; //
    
    return @[deleteAction, muteAction]; //array with all the buttons you want. 1,2,3, etc...
}

-(UIImage *) getImage:(UIColor *) color withIcon:(UIImage *) image  withCellHeight:(CGFloat) height{
    
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 74, height)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 40, 40);
    imageView.center = myView.center;
    myView.backgroundColor = color ;
    [myView addSubview:imageView];
    
    CGRect rect = [myView bounds];
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [myView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // you need to implement this method too or nothing will work:
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; //tableview must be editable or nothing will work...
}
- (IBAction)backToPreviousController:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
