//
//  KSFrameView.m
//  MosiacCamera
//
//  Created by wangchen on 4/2/15.
//  Copyright (c) 2015 kimsungwhee.com. All rights reserved.
//

#import "KSFrameView.h"

//#define LINE_LENGTH 20
@interface KSFrameView()
{
    int LINE_LENGTH;
    BOOL bShowLine;
}
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation KSFrameView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        LINE_LENGTH = frame.size.width / 10;
         self.timer = [NSTimer scheduledTimerWithTimeInterval:.15 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
        [self.timer fire];
        bShowLine = NO;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont boldSystemFontOfSize:18];
//        label.text = @"请将扫描线对准银行卡号并对齐左右边缘。";
        [self addSubview:label];
        CGAffineTransform transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        label.transform = transform;
        
        float x = frame.size.width * 22 / 54;
        x = x + (frame.size.width - x) / 2;
        label.center = CGPointMake(x, frame.size.height/2);
    }
    return self;
}
-(void)dealloc{
    [self.timer invalidate];
}

-(void)timerFire:(id)notice
{
    bShowLine = !bShowLine;
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 8.0);
    CGContextSetRGBStrokeColor(context, .3, 0.8, .3, .8);
    
    CGContextBeginPath(context);
    
    CGPoint pt = rect.origin;
    CGContextMoveToPoint(context, pt.x, pt.y+LINE_LENGTH);
    CGContextAddLineToPoint(context, pt.x, pt.y);
//    CGContextMoveToPoint(context, pt.x+LINE_LENGTH, pt.y);
    
    pt = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
//    CGContextMoveToPoint(context, pt.x-LINE_LENGTH, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y+LINE_LENGTH);
    
    pt = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
    CGContextMoveToPoint(context, pt.x, pt.y-LINE_LENGTH);
//    CGContextMoveToPoint(context, pt.x-LINE_LENGTH, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    
    pt = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
//    CGContextMoveToPoint(context, pt.x+LINE_LENGTH, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y-LINE_LENGTH);
    CGContextStrokePath(context);
    
    if(bShowLine)
    {
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 1);
        CGPoint p1, p2;
        float x = rect.origin.x + rect.size.width * 22 / 54;
        p1 = CGPointMake(x, rect.origin.y);
        p2 = CGPointMake(x, rect.origin.y + rect.size.height);
        CGContextMoveToPoint(context,p1.x, p1.y);
        CGContextAddLineToPoint(context, p2.x, p2.y);
        CGContextStrokePath(context);
    }
    
    
//    [UIColor colorWithRed:50 green:200 blue:50 alpha:.8];
//    CGContextFillRect(ctx, rect);//直接开始绘图
//    CGContextSetBlendMode(ctx, kCGBlendModeClear);
//    CGRect rect2 = CGRectInset(rect, 2, 2);
//    CGContextFillRect(ctx, rect2);//直接开始绘图
}

@end
