//
//  ZBLabel.m
//  ZBKit
//
//  Created by NQ UEC on 2017/5/31.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBLabel.h"

@implementation ZBLabel
@synthesize alignment = alignment_;
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.alignment = ZBTextAlignmentCenter;

    }
    return self;
}

- (void)setAlignment:(ZBtextAlignment)alignment{
    alignment_ = alignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.alignment) {
        case ZBTextAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case ZBTextAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case ZBTextAlignmentCenter:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}
-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
