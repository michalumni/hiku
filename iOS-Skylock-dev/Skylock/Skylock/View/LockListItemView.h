//
//  LockListItemView.h
//  Skylock
//
//  Created by Daniel Ondruj on 20.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lock.h"

@class LockListItemView;

@protocol LockListItemViewDelegate <NSObject>

-(void)lockItemClicked:(LockListItemView *)item withLock:(CDLock *)lock;

@end

@interface LockListItemView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bkgImage;
@property (weak, nonatomic) IBOutlet UIImageView *defaultSignImage;
@property (weak, nonatomic) IBOutlet UIImageView *lockImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) CDLock *lock;
@property (nonatomic, strong) UIImage *selectedBkgImage;
@property (nonatomic, strong) UIImage *unselectedBkgImage;
@property (nonatomic) BOOL selected;

@property (nonatomic, weak) id<LockListItemViewDelegate> delegate;

-(void)setUp;
-(void)setSelected:(BOOL)state;
-(void)setDefault:(BOOL)isDefault;

@end
