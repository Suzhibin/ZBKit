//
//  ZBLabel.h
//  ZBKit
//
//  Created by NQ UEC on 2017/5/31.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZBtextAlignment) {
    
    ZBTextAlignmentTop =0,  // default
    ZBTextAlignmentCenter,
    ZBTextAlignmentBottom
};

@interface ZBLabel : UILabel{
@private ZBtextAlignment _zbtextAlignment;
}
@property (nonatomic) ZBtextAlignment alignment;


@end
