//
//  CellFoldViewController.m
//  CellFoldDemo
//
//  Created by likai on 15/8/11.
//  Copyright (c) 2015年 likai. All rights reserved.
//

#import "CellFoldViewController.h"
#import "CellFoldCell.h"
#import "CellDownFoldCell.h"
#import "PlistUtil.h"

@interface CellFoldViewController ()<CellFoldCellDelegate> {
    BOOL _multyFlag;//是否可多行展开
}

@property (nonatomic, strong) NSMutableArray *contents;

@property (nonatomic, strong) NSMutableSet *openCell;//展开的section index集合

@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;

@end

@implementation CellFoldViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.openCell=[[NSMutableSet alloc] initWithCapacity:1];
        _multyFlag = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableList.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.title = @"current:single";
    
    [self setExtraCellLineHidden:self.tableList];
    
    self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contents.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //如果cell打开，则多显示一个cell
    return [self.openCell count]>0&&[self.openCell containsObject:[NSNumber numberWithInt:(int)section]] ? (self.contents.count + 1):1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 55.f;
    }
    else {
        return 60.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellFoldCellIdentifer = @"CellFoldCell";
    static NSString *cellDownFoldCellIdentifer = @"CellDownFoldCell";
    if (indexPath.row == 0) {
        CellFoldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellFoldCellIdentifer];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CellFoldCell" owner:nil options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.downCellDelegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.titleLbl.text = self.contents[indexPath.section][0][@"section"];
        cell.descLbl.text = @"anyway";
        
        return cell;
    }
    else {
        CellDownFoldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDownFoldCellIdentifer];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CellDownFoldCell" owner:nil options:nil] objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.titleLbl.text = self.contents[indexPath.section][indexPath.row - 1][@"title"];
        cell.titleLbl.text = self.contents[indexPath.section][indexPath.row - 1][@"desc"];
        
        return cell;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
}

#pragma mark - DropDownCellDelegate

//点击展开下拉cell方法
- (void)dropDownCellMethod:(CellFoldCell *)cell {
    if (_multyFlag) {
        //允许展开多行
        NSInteger index =[self.tableList indexPathForCell:cell].section;
        if([self.openCell count]>0){//有cell已经展开
            if ([self.openCell containsObject:[NSNumber numberWithInt:(int)index]]) { //展开的cell和当前点击的一致，操作为收起cell
                [self.openCell removeObject:[NSNumber numberWithInt:(int)index]];
                [self deleteActionCell:index tableView:self.tableList];
            }
            else {//操作:展开新的cell
                [self.openCell addObject:[NSNumber numberWithInt:(int)index]];
                [self insertActionCell:index tableView:self.tableList];
            }
        }
        else {
            //没有cell展开，只需展开当前cell即可
            [self.openCell addObject:[NSNumber numberWithInt:(int)index]];
            [self insertActionCell:index tableView:self.tableList];
        }
    }
    else {
        //只允许展开一行
        NSInteger index =[self.tableList indexPathForCell:cell].section;
        NSNumber *previous=[self.openCell anyObject];
        if([self.openCell count]>0){//有cell已经展开
            [self.openCell removeAllObjects];
            if ([previous integerValue] == index) { //展开的cell和当前点击的一致，操作为收起cell
                [self deleteActionCell:[previous integerValue] tableView:self.tableList];
            }else{//操作:展开新的cell,收起旧的cell
                [self deleteActionCell:[previous integerValue] tableView:self.tableList];
                [self.openCell addObject:[NSNumber numberWithInt:(int)index]];
                [self insertActionCell:index tableView:self.tableList];
            }
        }else{
            //没有cell展开，只需展开当前cell即可
            [self.openCell addObject:[NSNumber numberWithInt:(int)index]];
            [self insertActionCell:index tableView:self.tableList];
        }
    }
}

#pragma mark - Custom Methods

- (void)multiAction {
    _multyFlag = !_multyFlag;
    [self updateButtonsToMatchTableState:_multyFlag];
    [self.openCell removeAllObjects];
    [self.tableList reloadData];
}

- (void)updateButtonsToMatchTableState:(BOOL)flag {
    self.title = _multyFlag ? @"current:multi" : @"current:single";
    self.rightButtonItem.title = _multyFlag ? @"单行展开" : @"多行展开";
}

- (void)insertActionCell:(NSInteger)section tableView:(UITableView *)tableView
{
    NSIndexPath *cellPath=[NSIndexPath indexPathForRow:0 inSection:section];
    CellFoldCell *cell=(CellFoldCell*)[tableView cellForRowAtIndexPath:cellPath];
    [cell.downButton setImage:[UIImage imageNamed:@"ic_home_dropDown_up"] forState:UIControlStateNormal];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSInteger currentCount = [self.contents[section] count];
    for (int i = 0; i < currentCount; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i + 1 inSection:section]];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentCount inSection:section];
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    [tableView endUpdates];
    [self.tableList scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionNone
                                  animated:YES];
}

- (void)deleteActionCell:(NSInteger)section tableView:(UITableView *)tableView{
    NSIndexPath *cellPath=[NSIndexPath indexPathForRow:0 inSection:section];
    CellFoldCell *cell=(CellFoldCell*)[tableView cellForRowAtIndexPath:cellPath];
    [cell.downButton setImage:[UIImage imageNamed:@"ic_home_dropDown_down"] forState:UIControlStateNormal];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSInteger currentCount = [self.contents[section] count];
    for (int i = 0; i < currentCount; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i + 1 inSection:section]];
    }
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
}

//去除tableview无信息cell
-(void)setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - Getters and Setters

- (NSMutableArray *)contents {
    if (!_contents) {
        _contents = [[NSMutableArray alloc] init];
        [_contents addObjectsFromArray:[PlistUtil arrayForPlistFile:@"QuickLinks"]];
    }
    return _contents;
}

- (UIBarButtonItem *)rightButtonItem {
    if (!_rightButtonItem) {
        _rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"多行展开" style:UIBarButtonItemStylePlain target:self action:@selector(multiAction)];
    }
    return _rightButtonItem;
}

@end
