

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>
#import "KSHImageTarget.h"


@interface KSHPreviewView : GLKView<KSHImageTarget>


@property (strong, nonatomic) CIContext *coreImageContext;

@end