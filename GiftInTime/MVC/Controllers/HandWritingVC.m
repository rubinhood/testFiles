//
//  HandWritingVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 11/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "HandWritingVC.h"

@interface HandWritingVC ()

@end

@implementation HandWritingVC

{
    ScratchPadView *mPad;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view layoutIfNeeded];
    mPad = [[ScratchPadView alloc] init];
    mPad.frame = _mScratchPad.bounds;
    mPad.backgroundColor = [UIColor whiteColor];
    [_mScratchPad addSubview:mPad];
    //[sPad scaleScratchUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)eraseData:(UIButton *)sender {
    sender.selected = YES;
    _mDrawBtn.selected = NO;
    _mUndoBtn.selected = NO;
    [mPad useEraser];
    
    
}

- (IBAction)undoScratch:(UIButton *)sender {

    [mPad undoLastScratch];
    
    if([mPad getCurrentColor] == SP_WHITE) {
        __mEraserBtn.selected = YES ;
        _mDrawBtn.selected = NO;
    }else {
        _mDrawBtn.selected = YES;
        __mEraserBtn.selected = NO ;

    }

}


- (IBAction)userFreeHandLines:(UIButton *)sender {
    sender.selected = YES;
    _mUndoBtn.selected = NO;
    __mEraserBtn.selected = NO ;
    [mPad userColor];
}

- (IBAction)bakcToPreviousController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveViewAsImage:(id)sender {
    UIGraphicsBeginImageContextWithOptions(_mScratchPad.bounds.size, _mScratchPad.opaque, 0.0f);
    [_mScratchPad drawViewHierarchyInRect:_mScratchPad.bounds afterScreenUpdates:NO];
    UIImage *snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

}

@end
