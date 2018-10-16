//
//  PictureCutToolVC.m
//  btc
//
//  Created by lingda on 2017/9/20.
//  Copyright © 2017年 btc. All rights reserved.
//

#import "LDPictureCutController.h"

@implementation UIImage(PictureCutPrivate)
+ (UIImage *)clipRect:(UIImage *)image frame:(CGRect)frame
{
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
}

+ (UIImage *)clipCircle:(UIImage *)image frame:(CGRect)frame
{
    //先裁剪成指定大小
    image = [UIImage clipRect:image frame:frame];
    //获取图片尺寸
    CGSize size = image.size;
    //开启位图上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //创建圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, frame.size.width, frame.size.width)];
    //设置为裁剪区域
    [path addClip];
    //绘制图片
    [image drawAtPoint:CGPointZero];
    //获取裁剪后的图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    //获取裁剪后的图片
    return image;
}

+(UIImage *)imageCapWithView:(UIView *)view
{    
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    return  theImage;
}

@end

@interface LDPictureCutController ()
@property (weak, nonatomic) IBOutlet UIView *closeView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (assign ,nonatomic)CGRect clipAreaFrame;
@end

@implementation LDPictureCutController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isCircleShape = NO;
        self.marginLR = 20;
        self.ratio = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.picImageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    self.picImageView.image = self.image;
    self.closeView.transform = CGAffineTransformMakeRotation(M_PI_4);
    [self addShape];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.picImageView addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.picImageView addGestureRecognizer:pinch];
    
    UIRotationGestureRecognizer * rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    [self.picImageView addGestureRecognizer:rotation];
    
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    CGFloat scale = recognizer.scale;
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, scale, scale); //在已缩放大小基础下进行累加变化；区别于：使用 CGAffineTransformMakeScale 方法就是在原大小基础下进行变化
    recognizer.scale = 1.0;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateEnded && recognizer.state != UIGestureRecognizerStateFailed){
        CGPoint translation = [recognizer translationInView:self.view];
        CGPoint center = self.picImageView.center;
        self.picImageView.center = CGPointMake(center.x + translation.x, center.y + translation.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

- (void)handleRotation:(UIRotationGestureRecognizer *)recognizer {
    CGFloat rotation = recognizer.rotation;
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, rotation);
    recognizer.rotation = 0;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    UIImage * image = change[@"new"];
    CGSize origeImageSize = image.size;
    CGFloat imageViewWidth = [UIScreen mainScreen].bounds.size.width - 40;
    CGFloat imageViewHeight = imageViewWidth * origeImageSize.height/origeImageSize.width;
    self.picImageView.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height/2 - imageViewHeight/2, imageViewWidth, imageViewHeight);
}

- (void)addShape
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    path.usesEvenOddFillRule = YES;
    if (self.isCircleShape) {
        self.clipAreaFrame = CGRectMake(self.marginLR, screenH/2 - screenW/2 + self.marginLR, screenW - 2 * self.marginLR, screenW - 2 * self.marginLR);
        [path addArcWithCenter:CGPointMake(screenW/2, screenH/2) radius:screenW/2 - self.marginLR startAngle:0 endAngle:M_PI *2 clockwise:YES];
    } else {
        CGFloat reactangleW = screenW - self.marginLR * 2;
        CGFloat reactangleH = reactangleW / self.ratio;
        CGFloat centerY = screenH/2;
        [path addLineToPoint:CGPointMake(self.marginLR, centerY - reactangleH/2)];
        [path addLineToPoint:CGPointMake(screenW - self.marginLR, centerY - reactangleH/2)];
        [path addLineToPoint:CGPointMake(screenW - self.marginLR, centerY + reactangleH/2)];
        [path addLineToPoint:CGPointMake(self.marginLR, centerY + reactangleH/2)];
        [path addLineToPoint:CGPointMake(self.marginLR, centerY - reactangleH/2)];
        self.clipAreaFrame = CGRectMake(self.marginLR, centerY - reactangleH/2, reactangleW, reactangleH);
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor= [UIColor blackColor].CGColor;  //其他颜色都可以，只要不是透明的
    shapeLayer.fillRule=kCAFillRuleEvenOdd;
    self.bgView.layer.mask = shapeLayer;
    
}

- (IBAction)clickCloseTap:(UITapGestureRecognizer *)sender
{
    [self dismissSelf];
}
- (IBAction)clickCancelBtn:(UIButton *)sender {
    [self dismissSelf];
}
- (IBAction)clickComfirmBtn:(UIButton *)sender {
    UIImage * image = [UIImage imageCapWithView:self.view];
    if (self.isCircleShape) {
        image = [UIImage clipCircle:image frame:self.clipAreaFrame];
    } else {
        image = [UIImage clipRect:image frame:self.clipAreaFrame];
    }
    if (self.clipPicResult) {
        self.clipPicResult(image);
        [self dismissSelf];
    }
}

- (void)dismissSelf
{
    [self.picImageView removeObserver:self forKeyPath:@"image"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
