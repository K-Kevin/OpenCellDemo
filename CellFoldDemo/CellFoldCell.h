//
//  CellFoldCell.h
//  CellFoldDemo
//
//  Created by likai on 15/8/11.
//  Copyright (c) 2015年 likai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellFoldCell;
@protocol CellFoldCellDelegate <NSObject>

- (void)dropDownCellMethod:(CellFoldCell *)cell;

@end

@interface CellFoldCell : UITableViewCell

@property (nonatomic, weak) id <CellFoldCellDelegate> downCellDelegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIButton *downButton;

- (IBAction)downAction:(id)sender;

@end
