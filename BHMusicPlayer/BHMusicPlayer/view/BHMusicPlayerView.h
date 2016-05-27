//
//  MusicPlayerView.h
//  BHMusicPlayer
//
//  Created by libohao on 16/5/25.
//  Copyright © 2016年 libohao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicItem.h"
/**
 歌曲播放形式
 */
typedef enum : NSUInteger {
    BHAudioPlayTypeCircle,  //循环播放
    BHAudioPlayTypeRandom,  //随机播放
    BHAudioPlayTypeOneMusic,//单曲循环
    BHAudioPlayTypeNoNext,  //播完就不播了
} BHAudioPlayType;


@interface BHMusicPlayerView : UIView

+ (BHMusicPlayerView *)sharePlayerView;

@property (nonatomic, copy) NSArray* musicArray;

@property (nonatomic, assign) BHAudioPlayType playType;
@property (nonatomic, weak) MusicItem* currentMusicItem;

- (void)playMusic:(MusicItem *)musicItem;
- (void)showPlayerView;
- (void)hidePlayerViewToView:(UIView *)desView;

@property (nonatomic, copy) void (^CloseBlock)();
@end
