//
//  MenuTableViewCell.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/28.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "MenuModel.h"
@interface MenuTableViewCell()
@property (strong, nonatomic) UIView *selectedIndicator;

@end
@implementation MenuTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectedIndicator=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, self.contentView.frame.size.height)];
        self.selectedIndicator.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:self.selectedIndicator];
    }
    return self;
}

- (void)setMenuModel:(MenuModel *)menuModel{
    _menuModel = menuModel;
    self.textLabel.text = menuModel.name;
    self.textLabel.font=[UIFont systemFontOfSize:12];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   self.selectedIndicator.hidden = !selected;
    // Configure the view for the selected state
}

@end
