//
//  CellFoldCell.m
//  CellFoldDemo
//
//  Created by likai on 15/8/11.
//  Copyright (c) 2015年 likai. All rights reserved.
//

#import "CellFoldCell.h"

@implementation CellFoldCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)downAction:(id)sender {
    if (self.downCellDelegate && [self.downCellDelegate respondsToSelector:@selector(dropDownCellMethod:)]) {
        [self.downCellDelegate dropDownCellMethod:self];
    }
}

@end
