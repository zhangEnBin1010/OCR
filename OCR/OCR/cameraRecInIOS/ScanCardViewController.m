//
//  ScanCardViewController.m
//  OCR_SavingCard
//
//  Created by linyingwei on 16/5/5.
//  Copyright © 2016年 linyingwei. All rights reserved.
//

#import "ScanCardViewController.h"
#import "KSHCameraController.h"
#import "KSHPreviewView.h"
#import "KSHContextManager.h"
#import "KSHOverlayView.h"
#import "KSFrameView.h"
#import "BinCodeSearch.h"

@interface ScanCardViewController ()<KSHRecDelegate>
{
    CGRect frameBounders;
}
@property (nonatomic, strong) KSHCameraController *cameraController;
@property (strong, nonatomic) KSHPreviewView *previewView;
@property (strong, nonatomic) KSFrameView *frameView;
@property (weak, nonatomic) IBOutlet KSHOverlayView *overlayView;
@property (copy,nonatomic) passValue block;
@end

@implementation ScanCardViewController
CGRect getPreViewFrame( int previewWidth, int previewHeight)
{
    float cardh, cardw;
    float lft, top;
    
    cardw = previewWidth*70/100;
    if(previewWidth < cardw)
        cardw = previewWidth;
    
    cardh = (float)(cardw / 0.63084f);
    
    lft = (previewWidth-cardw)/2;
    top = (previewHeight-cardh)/2;
    CGRect r = CGRectMake(lft, top, cardw, cardh);
    return r;
}

-(void)viewWillDisappear:(BOOL)animated
{
    //    self.navigationController.navigationBarHidden = NO;
    if([self.cameraController.captureSession isRunning])
    {
        [self.cameraController.captureSession stopRunning];
    }
    [super viewWillDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated
//-(void)viewDidAppear:(BOOL)animated
{
    if([self.cameraController.captureSession isRunning] == NO)
    {
        [self.cameraController.captureSession startRunning];
        [self.cameraController resetRecParams];
    }
    //    [self.cameraController resetRecParams];
    //    [super viewDidAppear:animated];
    
    [super viewWillAppear:animated];
}

- (KSHCameraController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[KSHCameraController alloc] init];
    }
    return _cameraController;
}

-(KSHPreviewView *)previewView
{
    if (!_previewView) {
        _previewView = [[KSHPreviewView alloc] initWithFrame:frameBounders context:[KSHContextManager sharedInstance].eaglContext];
    }
    return _previewView;
}

-(KSFrameView*)frameView
{
    if(!_frameView)
    {
        CGRect rect = getPreViewFrame(frameBounders.size.width, frameBounders.size.height);
        _frameView = [[KSFrameView alloc] initWithFrame:rect];
    }
    return _frameView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}


//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeRight;
//}
//
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeRight;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    frameBounders = [UIScreen mainScreen].bounds;
    
    [self.view insertSubview:self.frameView atIndex:0];
    // Do any additional setup after loading the view from its nib.
    //    self.overlayView.tapToFocusEnabled = self.cameraController.cameraSupportsTapToFocus;
    //    self.overlayView.tapToExposeEnabled = self.cameraController.cameraSupportsTapToExpose;
    //    self.overlayView.tapedHandelDelegate = self;
    
    //    self.previewView.coreImageContext = [KSHContextManager sharedInstance].ciContext;
    //
    //    self.cameraController.imageTarget = self.previewView;
    self.cameraController.recDelegate = self;
    
    //    [self.view insertSubview:self.previewView atIndex:0];
    
    self.cameraController.sessionPreset = AVCaptureSessionPreset1280x720;
    
    self.overlayView.session = self.cameraController.captureSession;
    
    NSError *error;
    if ([self.cameraController setupSession:&error]) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        
        [self.view insertSubview:view atIndex:0];
        AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.cameraController.captureSession];
        preLayer.frame = frameBounders;// CGRectMake(0, 0, 320, 240);
        preLayer.frame = frameBounders;// CGRectMake(0, 0, 320, 240);
        
        preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [view.layer addSublayer:preLayer];
        //        CGAffineTransform transform = CGAffineTransformMakeRotation((-90.0f * M_PI) / 180.0f);
        //        view.transform = transform;
        //        [view setFrame:CGRectMake(0, -250, 320, 568)];
        [self.cameraController startSession];
    }
    else {
        
    }
    
    
    //    CGAffineTransform transform = CGAffineTransformMakeRotation((-90.0f * M_PI) / 180.0f);
    //
    //    self.frameView.transform = transform;
    //    [self.frameView setFrame:CGRectMake(108, 46, self.frameView.frame.size.width, self.frameView.frame.size.height)];
    //    [self.view addSubview:scanImageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(CGRect)getEffectImageRect:(CGSize)size
{
    //    CGSize size = image.extent.size;
    CGSize size2 = frameBounders.size;
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
    return CGRectMake(pt.x, pt.y, size.width, size.height);
}

-(void)showRecError:(NSString*)str
{
    //    errorLabel.text = str;
}



-(void)didEndRecNumber:(NSString*)str image:(UIImage*)img bank:(NSString *)bank
{
    //    [_delegate didEndRecWithResult:str image:img from:self];
    //    NSDictionary* returnedData=[[NSDictionary alloc]initWithObjectsAndKeys:@"success",@"backValue", nil];
       //    self.cardNumberTextField.text = str;
    [self.cameraController stopSession];

    self.block(str,bank);
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark- KSHPreviewViewDelegate
- (void)tappedToFocusAtPoint:(CGPoint)point {
    [self.cameraController focusAtPoint:point];
}

- (void)tappedToResetFocusAndExposure {
    [self.cameraController resetFocusAndExposureModes];
}

- (void)tappedToExposeAtPoint:(CGPoint)point {
}


- (void)passValue:(passValue)block{
    self.block = block;
}

#pragma mark - Navigation




@end
