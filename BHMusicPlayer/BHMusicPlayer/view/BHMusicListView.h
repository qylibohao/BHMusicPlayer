//
//  BHMusicListView.h
//  BHMusicPlayer
//
//  Created by libohao on 16/5/26.
//  Copyright © 2016年 libohao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHMusicPlayerView.h"

@interface BHMusicListView : UIView

@property (nonatomic, copy) NSArray* musicArray;

@property (nonatomic, weak) BHMusicPlayerView* playView;

@end
