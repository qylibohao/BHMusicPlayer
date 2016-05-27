//
//  BHMusicListView.m
//  BHMusicPlayer
//
//  Created by libohao on 16/5/26.
//  Copyright © 2016年 libohao. All rights reserved.
//

#import "BHMusicListView.h"
#import "MusicItem.h"
#import "BHMusicPlayerView.h"
#define COLOR_FROM_RGB(R,G,B)    [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define UIColorFromRGB(rgbValue) [UIColor \
                                    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface BHMusicListView()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _selectedIndex;
    MusicItem* _currentItem;
}
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* hideButton;
@property (nonatomic, strong) UIButton* backButton;
@end

@implementation BHMusicListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_FROM_RGB(35,43,41);
        _selectedIndex = -1;
        [self addSubview:self.tableView];
        [self addSubview:self.hideButton];
        [self addSubview:self.backButton];
    }
    return self;
}

#pragma mark - Property

- (void)setMusicArray:(NSArray *)musicArray {
    _musicArray = [musicArray copy];
    [self.tableView reloadData];
}

- (UIButton *)hideButton {
    if (!_hideButton) {
        _hideButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 44, 10, 51, 17)];
        [_hideButton setImage:[UIImage imageNamed:@"icon_hide.png"] forState:UIControlStateNormal];
    }
    return _hideButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc]initWithFrame:CGRectMake(-10, 10, 51, 17)];
        [_backButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 36, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-36) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark  - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor = indexPath.row % 2 ? COLOR_FROM_RGB(35, 43, 41) : COLOR_FROM_RGB(28, 36, 34);
    MusicItem* item = [self.musicArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    
    if (_selectedIndex == indexPath.row) {
        cell.textLabel.textColor = UIColorFromRGB(0x33c2be);
    }else {
        cell.textLabel.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndex = indexPath.row;
    
    MusicItem* item = [self.musicArray objectAtIndex:indexPath.row];
    if (_currentItem != item) {
        _currentItem = item;
        [self.playView playMusic:item];
    }
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

#pragma mark - Button func

- (void)backClicked {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake( CGRectGetWidth(self.bounds),0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }];
}

@end
