//
//  SJMediaTableViewCell.m
//  SJVideoPlayer
//
//  Created by 畅三江 on 2019/6/8.
//  Copyright © 2019 畅三江. All rights reserved.
//

#import "SJMediaTableViewCell.h"
#import <SJUIKit/SJCornerMask.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>

@interface SJMediaTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *mediaTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@end

@implementation SJMediaTableViewCell
+ (NSString *)reuseIdentifier {
    return [self description];
}

+ (void)registerWithTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:@"SJMediaTableViewCell" bundle:nil] forCellReuseIdentifier:[self reuseIdentifier]];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    SJMediaTableViewCell *cell = nil;
    NSString *reuseIdentifier = [self reuseIdentifier];
    @try {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    } @catch (NSException *exception) {
        [self registerWithTableView:tableView];
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    _coverImageView.backgroundColor = UIColor.clearColor;
    _coverImageView.sd_imageTransition = [SDWebImageTransition fadeTransition];
    _coverImageView.userInteractionEnabled = YES;
    
    SJCornerMaskSetRound(_avatarImageView, 2, UIColor.brownColor);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [_coverImageView addGestureRecognizer:tap];
}

- (void)handleTapGesture:(id)sender {
    if ( [(id)_delegate respondsToSelector:@selector(tappedOnTheCoverAtTableViewCell:)] ) {
        [_delegate tappedOnTheCoverAtTableViewCell:self];
    }
}

- (void)setDataSource:(nullable id<SJMediaTableViewCellDataSource>)dataSource {
    if ( dataSource != _dataSource ) {
        _dataSource = dataSource;
        
        _coverImageView.tag = _dataSource.coverTag;
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource.cover] placeholderImage:[UIImage imageNamed:@"p1"]];
        _mediaTitleLabel.attributedText = _dataSource.mediaTitle;
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_dataSource.avatar] placeholderImage:[UIImage imageNamed:@"p2"]];
        _usernameLabel.attributedText = _dataSource.username;
    }
}
@end
