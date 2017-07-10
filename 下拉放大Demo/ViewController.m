//
//  ViewController.m
//  下拉放大Demo
//
//  Created by wupeng on 16/3/11.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import "ViewController.h"

static CGFloat kImageHeight = 240.0;
static NSString *kCellID = @"cellID";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    UIImageView *_headImage;//需要形变的图片视图
    
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createTableView];
    //造假数据
    [self createDataSource];
}

-(void)createDataSource
{
    _dataSource = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        NSString *title = [NSString stringWithFormat:@"标题%d",i];
        [_dataSource addObject:title];
    }
    
}

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //设置tableView的内偏移量
    _tableView.contentInset = UIEdgeInsetsMake(kImageHeight, 0, 0, 0);
    //注册cell
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
    
    [self.view addSubview:_tableView];
    
    //设置图片
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kImageHeight, self.view.bounds.size.width, kImageHeight)];
    _headImage.image = [UIImage imageNamed:@"LaraCroft@2x"];
    //将图片加到tableView上，注意是加到tableView上而不是加到self.view上，好处是当tableView滚动时，这个imageView可以随tableView滚动而滚动而不需要在代理方法里重写坐标位置
    [_tableView addSubview:_headImage];
    
}

#pragma mark - tableView的代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - 滚动视图的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffSet = scrollView.contentOffset.y;//滚动y值
    //图片宽高比
    CGFloat scale = [UIScreen mainScreen].bounds.size.width*1.0/kImageHeight;
//    NSLog(@"%f",scale);
    
    NSLog(@"滚动y值是:%f",yOffSet);
    if (yOffSet < -kImageHeight) {
        CGRect imageRect = _headImage.frame;
        imageRect.origin.y = yOffSet;
        imageRect.size.height =  -yOffSet;
        imageRect.size.width = scale * imageRect.size.height;
        imageRect.origin.x = - (imageRect.size.width - [UIScreen mainScreen].bounds.size.width)/2;
        _headImage.frame = imageRect;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
