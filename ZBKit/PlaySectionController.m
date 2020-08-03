//
//  PlaySectionController.m
//  ZBKit
//
//  Created by Suzhibin on 2020/6/18.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "PlaySectionController.h"
#import "ZBKit.h"
#import "PlayCoverViewCell.h"

@interface PlaySectionController ()

@property(nonatomic, strong, readwrite) ListModel *listModel;

@end
@implementation PlaySectionController
- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(ZB_SCREEN_WIDTH, 200);
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {

    PlayCoverViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:[PlayCoverViewCell class] forSectionController:self atIndex:index];
    cell.listModel=self.listModel;

    return cell;
}

#pragma mark -

- (void)didUpdateToObject:(id)object {
    if (object && [object isKindOfClass:[ListModel class]]) {
        self.listModel = object;
    }
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    [self.delegate playSectiondidSelectItemAtIndex:index model:self.listModel];
}
@end
