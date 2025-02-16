//
//  SJViewController8.m
//  SJVideoPlayer_Example
//
//  Created by 畅三江 on 2019/7/13.
//  Copyright © 2019 changsanjiang. All rights reserved.
//

#import "SJViewController8.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import <Masonry/Masonry.h>
#import <SJUIKit/SJUIKit.h>
#import "SJSourceURLs.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJViewController8 ()
@property (weak, nonatomic) IBOutlet UIView *playerContainerView;
@property (nonatomic, strong) SJVideoPlayer *player;

@end

@implementation SJViewController8

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)show:(id)sender {
    static NSArray<NSString *> *arr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[@"悲哀化身-内蒙专区", @"车迟国@最终幻想-剑侠风骨", @"老虎222-天竺国", @"今朝醉-云中殿", @"杀手阿七-五明宫", @"浅墨淋雨桥-剑胆琴心"];
    });
    
    NSAttributedString *text = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        make.append(arr[arc4random() % arr.count]);
        make.textColor(UIColor.whiteColor);
    }];
    
    NSTimeInterval duration = arc4random() % 10 + 2;
    
    // show
    [_player showAttributedString:text duration:duration];
}

- (IBAction)hidden:(id)sender {
    [_player hiddenTitle];
}


- (void)_setupViews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _player = [SJVideoPlayer player];
    [_playerContainerView addSubview:self.player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    _player.controlLayerAppearStateDidChangeExeBlock = ^(SJVideoPlayer * _Nonnull player, BOOL isAppeared) {
        if ( isAppeared ) {
            player.popPromptController.bottomMargin = player.defaultEdgeControlLayer.bottomContainerView.bounds.size.height + 8;
        }
        else {
            player.popPromptController.bottomMargin = 16;
        }
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player vc_viewDidDisappear];
}

- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

@end
NS_ASSUME_NONNULL_END

#import <SJRouter/SJRouter.h>
@interface SJViewController8 (RouteHandler)<SJRouteHandler>

@end

@implementation SJViewController8 (RouteHandler)

+ (NSString *)routePath {
    return @"demo/prompt2";
}

+ (void)handleRequest:(SJRouteRequest *)request topViewController:(UIViewController *)topViewController completionHandler:(SJCompletionHandler)completionHandler {
    [topViewController.navigationController pushViewController:[[SJViewController8 alloc] initWithNibName:@"SJViewController8" bundle:nil] animated:YES];
}

@end
