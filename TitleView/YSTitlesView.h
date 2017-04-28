//
//  YSTitlesView.h
//  Demo_03
//
//  Created by Milton on 16/12/30.
//  Copyright © 2016年 YueShi. All rights reserved.
//

#import <UIKit/UIKit.h>

//Mama of, who is who code comments in English more cow force, let a person look not to understand cow force, to more English, go to look

#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#define kScreen_Height [UIScreen mainScreen].bounds.size.height

@interface YSTitlesView : UIView<UIScrollViewDelegate>
/**
 The color of the title on the bottom line 
 The default is white
*/
@property (nonatomic, strong)UIColor *lineColor;
/**
 The title font size
*/
@property (nonatomic, assign)CGFloat titleSize;
/**
 Title at the bottom of the line distance is the distance of the title, the default is 1, you can set the advice set between 2 to 5
*/
@property (nonatomic, assign)CGFloat lineOffset;
/**
 Below the title line and the entire length of the button a multiple relationship between the default is 0.5, is half of the button, can be set according to the situation
*/
@property (nonatomic, assign)CGFloat lineMultiple;
/**
 Title magnifying multiples when rolling, the default is 0.3, can be set according to the circumstance, suggest setting between [0.1 - 0.3], otherwise the effect is not very good
 */
@property (nonatomic, assign)CGFloat titleAnimationScale;
/**
 Whether to set the zoom animation. The default is yes
 */
@property (nonatomic, assign)BOOL hasScaleAnimation;
/**
 Whether to set the color change Animation. The default is yes
 */
@property (nonatomic, assign)BOOL hasColorAnimation;

/** 
 1.titleArr  : [@"wo",@"ri",@"ni",@"mei"]
 2.observerTarget : UIScrollView
 3.titleNomalColor
 4.titleSelectedColor
 */

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles observerTarget:(UIScrollView *)target normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor;


@end


