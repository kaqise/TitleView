//
//  YSTitlesView.m
//  Demo_03
//
//  Created by Milton on 16/12/30.
//  Copyright © 2016年 YueShi. All rights reserved.
//

#import "YSTitlesView.h"

#import "UIView+HKExtension.h"

@interface YSTitlesView()

@property (nonatomic, strong)NSArray *titles;

@property (nonatomic, strong)UIView *line;

@property (nonatomic, weak)UIScrollView *targetScrollView;

@property (nonatomic, copy)NSMutableArray <UIButton*> *buttonArr;

@property (nonatomic, strong)UIColor *normalColor;

@property (nonatomic, strong)UIColor *selectedColor;

@end

@implementation YSTitlesView

{
    UIButton *_positionButton;
    
    CGFloat _oldOffset;
    
    CGFloat _oraginalPosition_x;
}

#pragma mark - LazyLoad 懒加载

-(NSMutableArray<UIButton *> *)buttonArr{
    if (!_buttonArr) {
        
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles observerTarget:(UIScrollView *)target normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _titles = titles;
        
        _targetScrollView = target;
        
        _normalColor = normalColor;
        
        _selectedColor = selectedColor;
        
        [self setUpDefault];//配置默认属性
        
        [target addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        [self initUI];
    }
    
    return self;
}

- (void)setUpDefault{
    
    _lineOffset = 2;
    
    _lineColor = [UIColor whiteColor];
    
    _titleSize = 14;
    
    _lineMultiple = 0.5;
    
    _titleAnimationScale = 0.2;
    
    _hasColorAnimation = YES;
    
    _hasScaleAnimation = YES;
}

- (void)initUI{
    
    CGFloat button_W = self.bounds.size.width / _titles.count;
    
    CGFloat button_H = self.bounds.size.height;
    
    for (NSInteger i = 0; i < _titles.count ;i++ ) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * button_W, 0, button_W, button_H)];
        
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        
        [button setTitleColor:_normalColor forState:UIControlStateNormal];
        [button setTitleColor:_selectedColor forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:_titleSize];
        
        if (i == 0) {
            
            button.selected = YES;
            
            button.transform = CGAffineTransformMakeScale(1 * _titleAnimationScale + 1, 1 * _titleAnimationScale + 1);
            
            _positionButton = button;
        }
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        [self.buttonArr addObject:button];
    }
    
    _line = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height + _lineOffset, self.bounds.size.width / _titles.count * _lineMultiple , 1)];
    
    _line.centerX = self.buttonArr.firstObject.centerX;
    
    _oraginalPosition_x = _line.x;
    
    _line.backgroundColor = _lineColor;
    
    [self addSubview:_line];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        if (_targetScrollView.contentOffset.x < 0 || _targetScrollView.contentOffset.x > (_targetScrollView.contentSize.width - kScreen_Width)) return;//当左右出边界时什么都不做
        
        CGRect lineRect = _line.frame;
        
        CGFloat _line_x =  _targetScrollView.contentOffset.x / _targetScrollView.contentSize.width * self.bounds.size.width + _oraginalPosition_x;
        
        _line.frame = CGRectMake(_line_x, lineRect.origin.y, lineRect.size.width, lineRect.size.height);
        
        if ((int)_targetScrollView.contentOffset.x % (int)kScreen_Width == 0) {
            
            NSInteger index = _targetScrollView.contentOffset.x / kScreen_Width;
            
            if ([_buttonArr[index] isEqual:_positionButton]) {
                return;
            }else{
                
                _positionButton.selected = NO;
                
                _buttonArr[index].selected = YES;
                
                _positionButton = _buttonArr[index];
            }
        }
        
        CGFloat curPage = _targetScrollView.contentOffset.x / _targetScrollView.bounds.size.width;
        
        NSInteger leftIndex = curPage;
        
        NSInteger rightIndex = curPage + 1;
        
        UIButton *leftButton = _buttonArr[leftIndex];
        
        UIButton *rightButton ;
        
        if (rightIndex <= _buttonArr.count - 1) {
            
            rightButton = _buttonArr[rightIndex];
        }
        
        CGFloat rightScale = curPage - leftIndex;
        
        CGFloat leftScale = 1 - rightScale;
        
        if (_hasScaleAnimation) {//有大小动画
            
            leftButton.transform = CGAffineTransformMakeScale(leftScale * _titleAnimationScale + 1, leftScale * _titleAnimationScale + 1);
            
            rightButton.transform = CGAffineTransformMakeScale(rightScale * _titleAnimationScale + 1, rightScale * _titleAnimationScale + 1);
        }
        
        if (_hasColorAnimation) {//有颜色动画
            
            [leftButton setTitleColor:[self getColorWithScale:leftScale] forState:UIControlStateNormal];
            
            [rightButton setTitleColor:[self getColorWithScale:rightScale] forState:UIControlStateNormal];
        }else{//无颜色动画
            NSInteger idx = _targetScrollView.contentOffset.x / _targetScrollView.bounds.size.width;
            
            _positionButton.selected = NO;
            _buttonArr[idx].selected = YES;
            _positionButton = _buttonArr[idx];
             
        }
        
        _oldOffset = _targetScrollView.contentOffset.x;
    }
}

- (void)buttonClick:(UIButton*)sender{
    
    if ([sender isEqual:_positionButton]) {return;
    }else{
        
        _positionButton.selected = NO;
        
        sender.selected = YES;
        
        _positionButton = sender;
        
        NSUInteger index = [_buttonArr indexOfObject:sender];
        
        [_targetScrollView setContentOffset:CGPointMake(kScreen_Width * index, 0) animated:YES];
    }
}

- (UIColor *)getColorWithScale:(CGFloat)scale{
    
    CGFloat startComponents[3];
    
    [self getRGBComponents:startComponents forColor:_normalColor];
    
    CGFloat endComponents[3];
    
    [self getRGBComponents:endComponents forColor:_selectedColor];
    
    CGFloat color[3];
    
    for (int i = 0; i < 3; i++) {
        
        color[i] = startComponents[i] + (endComponents[i] - startComponents[i]) * scale;
        
    }
    return [UIColor colorWithRed:color[0] green:color[1] blue:color[2] alpha:1];
    
}

- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char resultingPixel[4];
    
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

- (void)dealloc{
    
    [self removeObserver:self forKeyPath:@"contentOffset"];
    
}

- (void)setLineColor:(UIColor *)lineColor{
    
    _lineColor = lineColor;
    
    _line.backgroundColor = lineColor;
}

- (void)setTitleSize:(CGFloat)titleSize{
    
    _titleSize = titleSize;
    
    [self.buttonArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
       
        btn.titleLabel.font = [UIFont systemFontOfSize:titleSize];
        
    }];
}
- (void)setLineOffset:(CGFloat)lineOffset{
    
    _lineOffset = lineOffset;
    
    CGRect rect = _line.frame;
    
    _line.frame = CGRectMake(rect.origin.x, rect.origin.y + lineOffset, rect.size.width, rect.size.height);
}

- (void)setLineMultiple:(CGFloat)lineMultiple{
    
    _lineMultiple = lineMultiple;
    
    CGRect rect = _line.frame;
    
    CGFloat button_W = self.bounds.size.width / _titles.count;
    
    _line.frame = CGRectMake(rect.origin.x, rect.origin.y, button_W * lineMultiple, rect.size.height);
    
    _line.centerX = self.buttonArr.firstObject.centerX;
    
    _oraginalPosition_x = _line.x;
}

- (void)setTitleAnimationScale:(CGFloat)titleAnimationScale{
    
    _titleAnimationScale = titleAnimationScale;
    
    _positionButton.transform = CGAffineTransformMakeScale(1 * _titleAnimationScale + 1, 1 * _titleAnimationScale + 1);
    
}

- (void)setHasScaleAnimation:(BOOL)hasScaleAnimation{
    
    _hasScaleAnimation = hasScaleAnimation;
    
    self.titleAnimationScale = 0;
}

- (void)setHasColorAnimation:(BOOL)hasColorAnimation{
    
    _hasColorAnimation = hasColorAnimation;
}


@end
