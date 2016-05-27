//
//  MusicPlayerView.m
//  BHMusicPlayer
//
//  Created by libohao on 16/5/25.
//  Copyright © 2016年 libohao. All rights reserved.
//

#import "BHMusicPlayerView.h"
#import "YDSlider.h"
#import "BHMusicListView.h"
#import "EKAudioQueueTool.h"

typedef enum : NSUInteger {
    BHAudioPlayStatePlay,  //循环播放
    BHAudioPlayStatePause,  //随机播放
} BHAudioPlayState;


#define COLOR_FROM_RGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

@interface BHMusicPlayerView()
{
    NSInteger _nowMusicLocal;
    
}
@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* desLabel;
@property (nonatomic, strong) YDSlider* slider;

@property (nonatomic, strong) UILabel* currentTimeLabel;
@property (nonatomic, strong) UILabel* totoalTimeLabel;

@property (nonatomic, strong) UIButton* playButton;
@property (nonatomic, strong) UIButton* pauseButton;

@property (nonatomic, strong) UIButton* preButton;
@property (nonatomic, strong) UIButton* nextButton;
@property (nonatomic, strong) UIButton* randomButton;
@property (nonatomic, strong) UIButton* listButton;
@property (nonatomic, strong) UIButton* hideButton;
@property (nonatomic, strong) UIButton* backButton;

@property (nonatomic, strong) BHMusicListView* listView;
@property (nonatomic, strong) EKAudioQueueTool* audioTool;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, assign) BOOL touchDownFlag;

@end

@implementation BHMusicPlayerView

+ (BHMusicPlayerView *)sharePlayerView {
//    static BHMusicPlayerView* sharePlayerView;
//    static dispatch_once_t predicate;
//    
//    dispatch_once(&predicate, ^{
//        sharePlayerView = [[self alloc] initWithFrame:CGRectMake(0, 0, 240, 300)];
//        
//    });
//    
//    return sharePlayerView;
    return [[self alloc] initWithFrame:CGRectMake(0, 0, 240, 300)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _audioTool = [[EKAudioQueueTool alloc] init];
        _nowMusicLocal = 0;
        
        self.backgroundColor = COLOR_FROM_RGB(35,43,41);
        self.layer.masksToBounds = YES;
        [self addSubview:self.avatarImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.desLabel];
        [self addSubview:self.slider];
        [self addSubview:self.currentTimeLabel];
        [self addSubview:self.totoalTimeLabel];
        
        [self addSubview:self.playButton];
        [self addSubview:self.pauseButton];
        [self addSubview:self.preButton];
        [self addSubview:self.nextButton];
        [self addSubview:self.randomButton];
        [self addSubview:self.listButton];
        [self addSubview:self.hideButton];
        [self addSubview:self.backButton];
        [self addSubview:self.listView];
    }
    return self;
}

#pragma mark - Property

- (void)setMusicArray:(NSArray *)musicArray {
    if (musicArray && musicArray.count) {
        _musicArray = [musicArray mutableCopy];
        
        _currentMusicItem = [musicArray objectAtIndex:_nowMusicLocal];
    }
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 28, 100, 100)];
        _avatarImageView.layer.cornerRadius = 50;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.center = CGPointMake(self.center.x, _avatarImageView.center.y);
        _avatarImageView.backgroundColor = [UIColor whiteColor];
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 17)];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = @"music";
        _nameLabel.center = CGPointMake(_avatarImageView.center.x, CGRectGetMaxY(_avatarImageView.frame)+ 15);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 17)];
        _desLabel.font = [UIFont systemFontOfSize:14];
        _desLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1];
        _desLabel.text = @"music2";
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.center = CGPointMake(_nameLabel.center.x, CGRectGetMaxY(_nameLabel.frame)+ 10);

    }
    return _desLabel;
}

- (YDSlider *)slider {
    if (!_slider) {
        _slider = [[YDSlider alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(_desLabel.frame) + 15, CGRectGetWidth(self.bounds) - 10, 10)];
        _slider.minimumTrackTintColor = COLOR_FROM_RGB(51, 195, 189);
        _slider.middleTrackTintColor = COLOR_FROM_RGB(119, 119, 119);
        _slider.maximumTrackTintColor = COLOR_FROM_RGB(76, 76, 76);
        _slider.thumbTintColor = COLOR_FROM_RGB(51, 195, 189);
        [_slider addTarget:self action:@selector(sliderTouchupInside:) forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];

    }
    return _slider;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.slider.frame) + 6, 200, 17)];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14];
        _currentTimeLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1];
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _currentTimeLabel;
}

- (UILabel *)totoalTimeLabel {
    if (!_totoalTimeLabel) {
        _totoalTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 210, CGRectGetMaxY(self.slider.frame) + 6, 200, 17)];
        _totoalTimeLabel.font = [UIFont systemFontOfSize:14];
        _totoalTimeLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1];
        _totoalTimeLabel.text = @"00:00";
        _totoalTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totoalTimeLabel;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 51, 51)];
        [_playButton setImage:[UIImage imageNamed:@"icon_play.png"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"icon_play2.png"] forState:UIControlStateHighlighted];
        _playButton.center = CGPointMake(self.center.x, CGRectGetMaxY(self.slider.frame) + 45);
        [_playButton addTarget:self action:@selector(playClicked) forControlEvents:UIControlEventTouchUpInside];

    }
    return _playButton;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 51, 51)];
        [_pauseButton setImage:[UIImage imageNamed:@"icon_pause.png"] forState:UIControlStateNormal];
        [_pauseButton setImage:[UIImage imageNamed:@"icon_pause.png"] forState:UIControlStateHighlighted];
        _pauseButton.center = CGPointMake(self.center.x, CGRectGetMaxY(self.slider.frame) + 45);
        [_pauseButton addTarget:self action:@selector(pauseClicked:) forControlEvents:UIControlEventTouchUpInside];
        _pauseButton.hidden = YES;
    }
    return _pauseButton;
}

- (UIButton *)preButton {
    if (!_preButton) {
        _preButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 51, 51)];
        [_preButton setImage:[UIImage imageNamed:@"icon_pre.png"] forState:UIControlStateNormal];
        [_preButton setImage:[UIImage imageNamed:@"icon_pre2.png"] forState:UIControlStateHighlighted];
        _preButton.center = CGPointMake(self.center.x - 60, CGRectGetMaxY(self.slider.frame) + 45);
    }
    return _preButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 51, 51)];
        [_nextButton setImage:[UIImage imageNamed:@"icon_next.png"] forState:UIControlStateNormal];
        [_nextButton setImage:[UIImage imageNamed:@"icon_next2.png"] forState:UIControlStateHighlighted];
        _nextButton.center = CGPointMake(self.center.x + 60, CGRectGetMaxY(self.slider.frame) + 45);
    }
    return _nextButton;
}

- (UIButton *)randomButton {
    if (!_randomButton) {
        _randomButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 44, CGRectGetMinY(self.slider.frame) - 35, 51, 30)];
        [_randomButton setImage:[UIImage imageNamed:@"icon_random.png"] forState:UIControlStateNormal];
        [_randomButton addTarget:self action:@selector(playTypeClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _randomButton;
}

- (UIButton *)listButton {
    if (!_listButton) {
        _listButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 44, CGRectGetHeight(self.bounds) - 27, 51, 17)];
        [_listButton setImage:[UIImage imageNamed:@"icon_list.png"] forState:UIControlStateNormal];
        [_listButton addTarget:self action:@selector(listViewClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listButton;
}

- (UIButton *)hideButton {
    if (!_hideButton) {
        _hideButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 44, 10, 51, 17)];
        [_hideButton setImage:[UIImage imageNamed:@"icon_hide.png"] forState:UIControlStateNormal];
        [_hideButton addTarget:self action:@selector(hideClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc]initWithFrame:CGRectMake(-10, 10, 51, 17)];
        [_backButton setImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(closeClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (BHMusicListView *)listView {
    if (!_listView) {
        _listView = [[BHMusicListView alloc]initWithFrame:self.bounds];
        _listView.frame = CGRectOffset(_listView.frame, CGRectGetWidth(_listView.bounds), 0);
        _listView.playView = self;
    }
    return _listView;
}

#pragma mark - Timer
-(void) startTimer {
    if (self.timer != nil) {
        [self releaseTimer];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changedTimeProgress) userInfo:nil repeats:YES];
}

-(void) releaseTimer {
    if (self.timer == nil) {
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"release timer");
}

- (void)changedTimeProgress {
    double progress = self.audioTool.playProgress;
    double duration = self.audioTool.duration;
    //BOOL isWaitingData = [self.audioTool isWaitData];
    if (duration >= progress && duration != 0) {
        //self.timeLabel.text = [NSString stringWithFormat:@"%d/%d s", (int) progress, (int) duration];
        //self.progressView.progress = progress / duration;
        if (!self.touchDownFlag && [self.audioTool isPlaying]) {
            self.slider.value = progress / duration;
        }
        
        self.totoalTimeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d",(int)duration/60,(int)duration % 60];
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d",(int)progress/60,(int)progress % 60];
    }
    
    double downloadPercent = self.audioTool.downLoadPercent;
    if (downloadPercent >= 1 && [self.audioTool isPaused]) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
    
    if ([self.audioTool isFinishPlaySuccessfully]) {
        NSLog(@"finish play successfully");
        
        [self setPlayState:BHAudioPlayStatePause];
        
    }
    
}

#pragma mark - Play Method

- (void)setPlayState:(BHAudioPlayState)state {
    if (state == BHAudioPlayStatePlay) {
        self.pauseButton.hidden = NO;
        self.playButton.hidden = YES;
        [self startTimer];
        
    }else if (state == BHAudioPlayStatePause) {
        self.pauseButton.hidden = YES;
        self.playButton.hidden = NO;
        [self releaseTimer];
    }
}

#pragma mark - Button func

- (void)sliderTouchupInside:(id)slider {
    if([self.audioTool isIdle]) {
        [self playClicked];
    }else {
        double seekTimeInSecond = self.audioTool.duration * ((UISlider*)slider).value;
        //double seekTimeInSecond = self.audioTool.duration * self.slider.value;
        [self.audioTool playOnlineAudioWithURL:[NSURL URLWithString:@"http://sc1.111ttt.com/2015/1/11/02/104020653295.mp3"] seekTime:seekTimeInSecond];
    }
    
//    double seekTimeInSecond = self.audioTool.duration * ((UISlider*)slider).value;
//    //double seekTimeInSecond = self.audioTool.duration * self.slider.value;
//    [self.audioTool playOnlineAudioWithURL:[NSURL URLWithString:@"http://sc1.111ttt.com/2015/1/11/02/104020653295.mp3"] seekTime:seekTimeInSecond];
    
    
//    [self startTimer];
//    self.touchDownFlag = NO;
}

- (void)sliderTouchDown:(id)sender {
    self.touchDownFlag = YES;
}

- (void)listViewClicked {
    self.listView.musicArray = self.musicArray ;

    [UIView animateWithDuration:0.25 animations:^{
        self.listView.frame = CGRectMake(0, 0, CGRectGetWidth(self.listView.bounds), CGRectGetHeight(self.listView.bounds));
    }];
}

- (void)playClicked {
    _currentMusicItem = [self.musicArray objectAtIndex:_nowMusicLocal];
    [self playMusic:_currentMusicItem];
}

- (void)playMusic:(MusicItem *)musicItem {
    if([self.audioTool isIdle]) {
        [self.audioTool playOnlineAudioWithURL:[NSURL URLWithString:musicItem.url]];
    }else {
//        if (_currentMusicItem != musicItem) {
//            if ([self.audioTool isPlaying]) {
//                [self.audioTool pause];
//                [self.audioTool playOnlineAudioWithURL:[NSURL URLWithString:musicItem.url]];
//            }
//            
//        }else {
//            [self resume];
//        }
        [self.audioTool pause];
        [self.audioTool playOnlineAudioWithURL:[NSURL URLWithString:musicItem.url] seekTime:0];
    }
    
    _currentMusicItem = musicItem;
    
   // [self releaseTimer];
   // [self setPlayState:BHAudioPlayStatePlay];
}

- (void)resume {
    double seekTimeInSecond = self.audioTool.playProgress;
    //double seekTimeInSecond = self.audioTool.duration * self.slider.value;
    _currentMusicItem = [self.musicArray objectAtIndex:_nowMusicLocal];
    [self.audioTool playOnlineAudioWithURL:[NSURL URLWithString:_currentMusicItem.url] seekTime:seekTimeInSecond];
}

- (void)pauseClicked:(id)sender {
    if ([self.audioTool isIdle]) {
        return;
    }
    if([self.audioTool isPaused] && self.timer.isValid) { //resume timer
        [self.timer setFireDate:[NSDate distantPast]];
    } else {
        if (self.audioTool.downLoadPercent >= 1) {
            [self.timer setFireDate:[NSDate distantFuture]]; // pause timer
        }
    }
    [self.audioTool pause];
    
    [self setPlayState:BHAudioPlayStatePause];
}

- (void)playTypeClicked {
    switch (self.playType) {
        case BHAudioPlayTypeCircle:
            self.playType = BHAudioPlayTypeRandom;
            break;
        case BHAudioPlayTypeRandom:
            self.playType = BHAudioPlayTypeOneMusic;
            break;
        case BHAudioPlayTypeOneMusic:
            self.playType = BHAudioPlayTypeNoNext;
            break;
        case BHAudioPlayTypeNoNext:
            self.playType = BHAudioPlayTypeCircle;
            break;
        default:
            break;
    }
}

- (void)preClicked {
    if (_nowMusicLocal == 0 && self.musicArray.count) {
        _nowMusicLocal = self.musicArray.count - 1;
        [self playClicked];
    }
    
}

- (void)nextClicked {
    [self playNextMusic];
}

/**
 *  下一首
 */
- (void)playNextMusic
{
    switch (self.playType) {
        case BHAudioPlayTypeCircle:
        {
            //循环播放
            _nowMusicLocal++;
            if (_nowMusicLocal >= self.musicArray.count) {
                _nowMusicLocal = 0;
            }
            [self playClicked];
            
        }
            break;
        case BHAudioPlayTypeRandom:
        {
            //随机播放
            [self randomWithTimes:5];
            
            if (_nowMusicLocal >= self.musicArray.count) {
                _nowMusicLocal = 0;
            }
            [self playClicked];
            
        }
            break;
        case BHAudioPlayTypeOneMusic:
        {
            //单曲循环
            //[self playMusicWithInfo];
            [self playClicked];
        }
            break;
        case BHAudioPlayTypeNoNext:
        {
            //播完就不播了
            
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - 随机播放随机数
/**
 *  随机递归
 *
 *  @param num 递归次数
 */
-(void)randomWithTimes:(NSInteger)num
{
    NSInteger randomMusic = arc4random() % self.musicArray.count;
    
    NSLog(@"随机值为：%ld",(long)randomMusic);
    
    if (_nowMusicLocal == randomMusic && self.musicArray.count != 1) {
        //防止递归死循环
        if (num != 0) {
            num--;
            [self randomWithTimes:num];
            return;
        }else
        {
            randomMusic++;
            //递归多次还一样，就强行设一个了（低概率事件）
            _nowMusicLocal = randomMusic;
        }
    }
    else
    {
        //正常情况
        _nowMusicLocal = randomMusic;
    }
}

- (void)closeClicked {
    if([self.audioTool isPlaying]) {
        [self.audioTool stop];
    }
    [self setPlayState:BHAudioPlayStatePause];
    [self hidePlayerViewToView:nil Completion:^{
        if (self.CloseBlock) {
            self.CloseBlock();
        }
        //[self removeFromSuperview];
    }];
}

- (void)hideClicked {
    [self hidePlayerViewToView:nil];
}

- (void)hidePlayerViewToView:(UIView *)desView Completion:(void (^)())block{
    CGPoint center;
    if (desView) {
        center = desView.center;
    }else {
        center = CGPointMake(CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds), 0);
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.center = center;
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
    }];
}

- (void)showPlayerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.center = [UIApplication sharedApplication].keyWindow.center;
        self.layer.affineTransform = CGAffineTransformMakeScale(1, 1);
    }];
}

@end
