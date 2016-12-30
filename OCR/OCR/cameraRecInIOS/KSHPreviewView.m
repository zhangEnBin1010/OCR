

#import "KSHPreviewView.h"



@interface KSHPreviewView()
{
    BOOL bRect;
    CGRect imgRect;
}
@property (nonatomic) CGRect drawableBounds;
@end

@implementation KSHPreviewView

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context
{
    if (self = [super initWithFrame:frame context:context]) {
        self.enableSetNeedsDisplay = NO;
        self.backgroundColor = [UIColor blackColor];
        self.opaque = YES;
        
        // because the native video image from the back camera is in
        // UIDeviceOrientationLandscapeLeft (i.e. the home button is on the right),
        // we need to apply a clockwise 90 degree transform so that we can draw
        // the video preview as if we were in a landscape-oriented view;
        // if you're using the front camera and you want to have a mirrored
        // preview (so that the user is seeing themselves in the mirror), you
        // need to apply an additional horizontal flip (by concatenating
        // CGAffineTransformMakeScale(-1.0, 1.0) to the rotation transform)
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.frame = frame;
        
        [self bindDrawable];
        _drawableBounds = self.bounds;
        _drawableBounds.size.width = self.drawableWidth;
        _drawableBounds.size.height = self.drawableHeight;
        bRect = NO;
    }
    return self;
}

-(CGRect)getEffectImageRect
{
    if(bRect == YES)
    {
        return imgRect;
    }
    return CGRectZero;
}

- (void)updateContentImage2:(CIImage*)image
{
    [self bindDrawable];
    [self.coreImageContext drawImage:image
                              inRect:self.drawableBounds//
                            fromRect:image.extent];
    [self display];
}

- (void)updateContentImage:(CIImage*)image
{
//    CGRect rect = image.extent;
//    CGRect rect2 = self.drawableBounds;
    {
        
        [self bindDrawable];
    if(bRect == NO)
    {
        CGSize size = image.extent.size;
        CGSize size2 = self.drawableBounds.size;
        CGPoint pt;
        if(size.width/size.height > size2.width/size2.height)
        {
            float oldW = size.width;
            size.width = size2.width / size2.height * size.height;
            pt.x = (oldW - size.width)/2;
            pt.y = 0;
        }
        else
        {
            float oldH = size.height;
            size.height = size2.height / size2.width * size.width;
            pt.x = 0;
            pt.y = (oldH - size.height)/2;;
        }
        bRect = YES;
        imgRect = CGRectMake(pt.x, pt.y, size.width, size.height);
    }
    
    [self.coreImageContext drawImage:image
                              inRect:self.drawableBounds//
                            fromRect:imgRect];
    [self display];
    }
}
@end