//
//  ViewController.m
//  LYC_UseTag
//
//  Created by Lyuci on 2016/10/28.
//  Copyright © 2016年 Lyuci. All rights reserved.
//

#import "ViewController.h"
#import "UIView+lyc_Frame.h"
#import "LYCTagImageView.h"
#import "LYCTagInfo.h"


@interface ViewController ()<LYCTagImageViewDelegate>
@property (nonatomic, strong) LYCTagImageView *lycimageView;
@property (nonatomic, strong) NSArray *tagInfoArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _tagInfoArray = [NSArray array];
    UIImage *image = [UIImage imageNamed:@"detail_4.jpeg"];
    _lycimageView = [[LYCTagImageView alloc] initWithImage:image];
    _lycimageView.delegate = self;
    _lycimageView.lyc_width = lyc_KScreenW - 40;
    _lycimageView.lyc_height = _lycimageView.lyc_width *image.size.height/image.size.width;
    _lycimageView.lyc_y = 100;
    _lycimageView.lyc_centerX = lyc_KScreenW / 2.0;
    [self.view addSubview:_lycimageView];
//    self.imageView = lycimageView;
    
//    添加标签
    LYCTagInfo *info1 = [LYCTagInfo tagInfo];
    info1.point = CGPointMake(20, 40);
    info1.title = @"我是一个标签";
    
    LYCTagInfo *info2 = [LYCTagInfo tagInfo];

    info2.proportion = LYCPositionProportionMake(0.5, 0.8);
    info2.title = @"点击图片， 添加标签";
    
    LYCTagInfo *info3 = [LYCTagInfo tagInfo];
    info3.proportion = LYCPositionProportionMake(0.9, 0.9);
    info3.title = @"长按图片， 修改标签";
    
    [_lycimageView addTagsWithTagInfoArray:@[info1, info2, info3]];
//    清楚标签  恢复标签
    UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cleanBtn setTitle:@"隐藏标签" forState:UIControlStateNormal];
    [cleanBtn setTitle:@"恢复标签" forState:UIControlStateSelected];
    [cleanBtn addTarget:self action:@selector(clickClearBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cleanBtn sizeToFit];
    cleanBtn.lyc_x = _lycimageView.lyc_x;
    cleanBtn.lyc_y = _lycimageView.lyc_bottom + 10;
    [self.view addSubview:cleanBtn];
    
//    浏览模式  编辑模式
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [editBtn setTitle:@"浏览模式" forState:UIControlStateNormal];
    [editBtn setTitle:@"编辑模式" forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn sizeToFit];
    editBtn.lyc_x = _lycimageView.lyc_x;
    editBtn.lyc_y = cleanBtn.lyc_bottom + 10;
    [self.view addSubview:editBtn];
}

#pragma mark event response
- (void)clickClearBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        self.tagInfoArray = [self.lycimageView getAllTagInfos];
        
               [self.lycimageView hiddenAllTags];
//        清除全部标签请使用 removeAllTags 方法
        
    }
    else
    {
        //        [self.lycimageView addTagsWithTagInfoArray:self.tagInfoArray];
        [self.lycimageView showAllTags];
    }
}
- (void)clickEditBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self.lycimageView setAllTagsEditEnable:!btn.selected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark LYCTagImageViewDelegate
- (void)tagImageView:(LYCTagImageView *)tagImageView activeTapGesture:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:tagImageView];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"添加标签" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:nil];
    UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = ((UITextField *)(alertVC.textFields[0])).text;
        if (text.length) {
//            添加标签
            [tagImageView addTagWithTitle:text point:tapPoint object:nil];
        }
    }];
    [alertVC addAction:ac];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)tagImageView:(LYCTagImageView *)tagImageView tagViewActiveTapGesture:(LYCTagView *)tagView
{
//    可自定义点击手势的反馈
    if (tagView.isEditEnabled) {
        NSLog(@"编辑模式 -- 轻触");
        [tagView switchDeleteState];
    }else
    {
        NSLog(@"预览模式 -- 轻触");
    }
}

- (void)tagImageView:(LYCTagImageView *)tagImageView tagViewActiveLongPressGesture:(LYCTagView *)tagView
{
//    可自定义长按手势
    if (tagView.isEditEnabled) {
        NSLog(@"编辑模式 -- 长按");
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"修改标签" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = tagView.tagInfo.title;
        }];
        
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (((UITextField *)(alertVC.textFields[0])).text.length) {
                
                [tagView updateTitle:((UITextField *)(alertVC.textFields[0])).text];
            }
        }];
        [alertVC addAction:ac];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }else
    {
        NSLog(@"预览模式 -- 长按");
    }
}



@end
