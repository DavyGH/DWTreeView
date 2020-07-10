//
//  DWTreeView.m
//  DWTreeView
//
//  Created by Davy on 2020/7/9.
//  Copyright © 2020 Davy. All rights reserved.
//

#import "DWTreeView.h"
#import "DWTreeModel.h"
#import "DWTreeTableViewCell.h"

@interface DWTreeView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray <DWTreeModel *>*data;

@property(nonatomic, assign) NSInteger index; /// 记录当前点击cell的Index

@end

@implementation DWTreeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setup];
    }
    return self;
}

- (void)setup {
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = self.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    [self addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DWTreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

//构造模拟数据
- (void)initData {
    self.data = [NSMutableArray array];
    //构造父节点
    for (int i = 0; i<5; i++) {
        DWTreeModel *model = [[DWTreeModel alloc] init];
        model.name = [NSString stringWithFormat:@"%i",i];
        model.childArray = [NSMutableArray array];
        //构造子节点
        for (int j = 6; j<10; j++) {
            DWTreeModel *childModel = [[DWTreeModel alloc] init];
            childModel.name = [NSString stringWithFormat:@"  %i",j];
            childModel.childArray = [NSMutableArray array];
            //构造孙子节点
            for (int k = 11; k<14; k++) {
                DWTreeModel *grandsonModel = [[DWTreeModel alloc] init];
                grandsonModel.name = [NSString stringWithFormat:@"      %i",k];
                grandsonModel.childArray = [NSMutableArray array];
                //构造曾孙节点
                for (int l = 15; l<17; l++) {
                    DWTreeModel *grandsonSonModel = [[DWTreeModel alloc] init];
                    grandsonSonModel.name = [NSString stringWithFormat:@"          %i",l];
                     //构造曾孙节点
                    [grandsonModel.childArray addObject:grandsonSonModel];
                }
                //孙子节点
                [childModel.childArray addObject:grandsonModel];
            }
            //子节点
            [model.childArray addObject:childModel];
        }
        //父节点
        [self.data addObject:model];
    }
}

//展开所有子节点
- (void)insertData:(NSMutableArray *)array {
    for (DWTreeModel *model in array) {
        self.index++;
        [self.data insertObject:model atIndex:self.index];
        if (model.childArray && model.open) {
            [self insertData:model.childArray];
        }
    }
}

//收起所有子节点
- (void)deleteData:(NSMutableArray *)array {
    for (DWTreeModel *model in array) {
        if (model.childArray) {
            [self deleteData:model.childArray];
        }
        if ([self.data containsObject:model]) {
            self.index++;
            [self.data removeObject:model];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DWTreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.data[indexPath.row].name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DWTreeModel *model = self.data[indexPath.row];
    self.index = indexPath.row; /// 记录
    
    model.open = !model.open;
    
    if (model.open) {
        [self insertData:model.childArray];
    } else {
        [self deleteData:model.childArray];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = indexPath.row + 1; i <= self.index; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        [array addObject:path];
    }
    
    [CATransaction begin];
    [tableView beginUpdates];
    
    if (model.open) {
        [tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [tableView endUpdates];
    [CATransaction commit];
}

@end
