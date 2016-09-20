//
//  ViewController.swift
//  QRCodeTool
//
//  Created by 戴全艺 on 16/3/3.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var animationLineView: UIImageView?
    private var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildInputAVCaptureDevice()
        buildFrameImageView()
        buildTitleLabel()
        buildAnimationLineView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    private func buildTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = "将二维码对准方块扫描"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.frame = CGRectMake(0, 340, Screen.width, 30)
        titleLabel.textAlignment = .Center
        
        let tintLabel = UILabel()
        tintLabel.text = "(不支持微信账号二维码)"
        tintLabel.textColor = UIColor.whiteColor()
        tintLabel.font = UIFont.systemFontOfSize(12)
        tintLabel.frame = CGRectMake(0, 380, Screen.width, 30)
        tintLabel.textAlignment = .Center
        
        view.addSubview(titleLabel)
//        view.addSubview(tintLabel)
    }
    
    private func buildInputAVCaptureDevice() {
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        let input = try? AVCaptureDeviceInput(device: captureDevice)
        if input == nil {
            return
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession = AVCaptureSession()
        captureSession?.addInput(input!)
        captureSession?.addOutput(captureMetadataOutput)
        let dispatchQueue = dispatch_queue_create("myQueue", nil)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.frame
        view.layer.addSublayer(videoPreviewLayer!)
        captureMetadataOutput.rectOfInterest = CGRectMake(100 / view.bounds.height, 0.2, (100 + Screen.width * 0.6) / view.bounds.height, 0.8)
        captureSession?.startRunning()
    }
    
    private func buildFrameImageView() {
        let lineT = [CGRectMake(0, 0, Screen.width, 100),
            CGRectMake(0, 100, Screen.width * 0.2, Screen.width * 0.6),
            CGRectMake(0, 100 + Screen.width * 0.6, Screen.width, view.bounds.height - 100 - Screen.width * 0.6),
            CGRectMake(Screen.width * 0.8, 100, Screen.width * 0.2, Screen.width * 0.6)]
        for lineTFrame in lineT {
            buildTransparentView(lineTFrame)
        }
        
        let yellowHeight: CGFloat = 4
        let yellowWidth: CGFloat = 30
        let yellowX: CGFloat = Screen.width * 0.2
        let bottomY: CGFloat = 100 + Screen.width * 0.6
        let lineY = [CGRectMake(yellowX, 100, yellowWidth, yellowHeight),
            CGRectMake(yellowX, 100, yellowHeight, yellowWidth),
            CGRectMake(Screen.width * 0.8 - yellowHeight, 100, yellowHeight, yellowWidth),
            CGRectMake(Screen.width * 0.8 - yellowWidth, 100, yellowWidth, yellowHeight),
            CGRectMake(yellowX, bottomY - yellowHeight + 2, yellowWidth, yellowHeight),
            CGRectMake(Screen.width * 0.8 - yellowWidth, bottomY - yellowHeight + 2, yellowWidth, yellowHeight),
            CGRectMake(yellowX, bottomY - yellowWidth, yellowHeight, yellowWidth),
            CGRectMake(Screen.width * 0.8 - yellowHeight, bottomY - yellowWidth, yellowHeight, yellowWidth)]
        
        for yellowRect in lineY {
            buildYellowLineView(yellowRect)
        }
    }
    
    private func buildYellowLineView(frame: CGRect) {
        let yellowView = UIView(frame: frame)
        yellowView.backgroundColor = UIColor.greenColor()
        view.addSubview(yellowView)
    }
    
    private func buildTransparentView(frame: CGRect) {
        let tView = UIView(frame: frame)
        tView.backgroundColor = UIColor.blackColor()
        tView.alpha = 0.5
        view.addSubview(tView)
    }
    
    private func buildAnimationLineView() {
        animationLineView = UIImageView()
        animationLineView!.image = UIImage(named: "yellowlight")
        view.addSubview(animationLineView!)
        
        timer = NSTimer(timeInterval: 2.5, target: self, selector: "startYellowViewAnimation", userInfo: nil, repeats: true)
        let runloop = NSRunLoop.currentRunLoop()
        runloop.addTimer(timer!, forMode: NSRunLoopCommonModes)
        timer!.fire()
    }
    
    func startYellowViewAnimation() {
        weak var weakSelf = self
        animationLineView!.frame = CGRectMake(Screen.width * 0.2 + Screen.width * 0.1 * 0.5, 100, Screen.width * 0.5, 20)
        UIView.animateWithDuration(2.5) {
            weakSelf!.animationLineView!.frame.origin.y += Screen.width * 0.55
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        var stringValue:String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
        }
        NSThread.sleepForTimeInterval(0.5)
        captureSession!.stopRunning()
        let alertController = UIAlertController(title: "二维码", message: "扫到的二维码结果为:\(stringValue!) 是否打开？", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "确认", style: .Default, handler: { action in
            App.application.openURL(NSURL(string: stringValue!)!)
            self.captureSession?.startRunning()
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { action in
            self.captureSession?.startRunning()
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

