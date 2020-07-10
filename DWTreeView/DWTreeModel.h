//
//  DWTreeModel.h
//  DWTreeView
//
//  Created by Davy on 2020/7/9.
//  Copyright © 2020 Davy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DWTreeModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL open;

@property (nonatomic, strong) NSMutableArray <DWTreeModel *>*childArray;

@end

NS_ASSUME_NONNULL_END
