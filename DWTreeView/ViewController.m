//
//  ViewController.m
//  DWTreeView
//
//  Created by Davy on 2020/7/9.
//  Copyright © 2020 Davy. All rights reserved.
//

#import "ViewController.h"
#import "DWTreeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DWTreeView *tree = [[DWTreeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tree];
}


@end
