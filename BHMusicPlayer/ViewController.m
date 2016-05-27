//
//  ViewController.m
//  BHMusicPlayer
//
//  Created by libohao on 16/5/25.
//  Copyright © 2016年 libohao. All rights reserved.
//

#import "ViewController.h"
#import "BHMusicPlayerView.h"
#import "MusicItem.h"

@interface ViewController ()

@property (nonatomic, strong) BHMusicPlayerView* playerView;
@property (nonatomic, strong) UIButton* flowButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self.view addSubview:self.flowButton];
    
    MusicItem* musicItem1 = [[MusicItem alloc]init];
    musicItem1.name = @"musicer";
    musicItem1.url = @"http://sc1.111ttt.com/2015/1/11/02/104020653295.mp3";
    musicItem1.artist = @"artiest";
    
    MusicItem* musicItem2 = [[MusicItem alloc]init];
    musicItem2.name = @"musicer2";
    musicItem2.url = @"http://sc1.111ttt.com/2014/1/11/15/4150339161.mp3";
    musicItem2.artist = @"artiest";
    
    MusicItem* musicItem3 = [[MusicItem alloc]init];
    musicItem3.name = @"musicer3";
    musicItem3.url = @"http://sc.111ttt.com/up/mp3/164559/51349A87C7007BED8C3A2177A618B360.mp3";
    musicItem3.artist = @"artiest";
    
    
    NSMutableArray *musicArray = [NSMutableArray arrayWithObjects:musicItem1,musicItem2,musicItem3, nil];
    self.playerView.musicArray = musicArray;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)flowButton {
    if (!_flowButton) {
        _flowButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 50, 100, 50, 50)];
        _flowButton.backgroundColor = [UIColor redColor];
        [_flowButton addTarget:self action:@selector(flowButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flowButton;
}

- (BHMusicPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[BHMusicPlayerView alloc] initWithFrame:CGRectMake(0, 0, 240, 300)];;
        //_playerView.center = self.view.center;
        _playerView.center = CGPointMake(CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds), 0);
        _playerView.layer.affineTransform = CGAffineTransformScale(_playerView.layer.affineTransform, 0.1, 0.1);
        
        __weak __typeof(&*self) weakSelf = self;
        _playerView.CloseBlock = ^() {
            //weakSelf.playerView = nil;
        };
        [self.view addSubview:_playerView];
    }
    return _playerView;
}

- (void)flowButtonClicked {
    [self.playerView showPlayerView];
}

@end
