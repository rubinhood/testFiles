//
//  HandWritingVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 11/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScratchPadView.h"

@interface HandWritingVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *mScratchPad
;
@property (weak, nonatomic) IBOutlet UIButton *_mEraserBtn;
@property (weak, nonatomic) IBOutlet UIButton *mDrawBtn;
@property (weak, nonatomic) IBOutlet UIButton *mUndoBtn;

@end
