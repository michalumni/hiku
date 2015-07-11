//
//  LocksMenuViewController.h
//  Skylock
//
//  Created by Daniel Ondruj on 19.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockListItemView.h"

@interface LocksMenuViewController : UIViewController <LockListItemViewDelegate>
{
    NSMutableArray *locksArray;
    NSMutableArray *locksItemArray;
    
    BOOL hideStatusBar;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//debug


@end
