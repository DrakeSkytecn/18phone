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

    fileprivate var captureSession: AVCaptureSession?
    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var animationLineView: UIImageView?
    fileprivate var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildInputAVCaptureDevice()
        buildFrameImageView()
        buildTitleLabel()
        buildAnimationLineView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    fileprivate func buildTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = "将二维码对准方块扫描"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.frame = CGRect(x: 0, y: 340, width: Screen.width, height: 30)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }
    
    fileprivate func buildInputAVCaptureDevice() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let input = try? AVCaptureDeviceInput(device: captureDevice)
        if input == nil {
            return
        }
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession = AVCaptureSession()
        captureSession?.addInput(input!)
        captureSession?.addOutput(captureMetadataOutput)
        let dispatchQueue = DispatchQueue(label: "myQueue", attributes: [])
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.frame
        view.layer.addSublayer(videoPreviewLayer!)
        captureMetadataOutput.rectOfInterest = CGRect(x: 100 / view.bounds.height, y: 0.2, width: (100 + Screen.width * 0.6) / view.bounds.height, height: 0.8)
        captureSession?.startRunning()
    }
    
    fileprivate func buildFrameImageView() {
        let lineT = [CGRect(x: 0, y: 0, width: Screen.width, height: 100),
            CGRect(x: 0, y: 100, width: Screen.width * 0.2, height: Screen.width * 0.6),
            CGRect(x: 0, y: 100 + Screen.width * 0.6, width: Screen.width, height: view.bounds.height - 100 - Screen.width * 0.6),
            CGRect(x: Screen.width * 0.8, y: 100, width: Screen.width * 0.2, height: Screen.width * 0.6)]
        for lineTFrame in lineT {
            buildTransparentView(lineTFrame)
        }
        
        let yellowHeight: CGFloat = 4
        let yellowWidth: CGFloat = 30
        let yellowX: CGFloat = Screen.width * 0.2
        let bottomY: CGFloat = 100 + Screen.width * 0.6
        let lineY = [CGRect(x: yellowX, y: 100, width: yellowWidth, height: yellowHeight),
            CGRect(x: yellowX, y: 100, width: yellowHeight, height: yellowWidth),
            CGRect(x: Screen.width * 0.8 - yellowHeight, y: 100, width: yellowHeight, height: yellowWidth),
            CGRect(x: Screen.width * 0.8 - yellowWidth, y: 100, width: yellowWidth, height: yellowHeight),
            CGRect(x: yellowX, y: bottomY - yellowHeight + 2, width: yellowWidth, height: yellowHeight),
            CGRect(x: Screen.width * 0.8 - yellowWidth, y: bottomY - yellowHeight + 2, width: yellowWidth, height: yellowHeight),
            CGRect(x: yellowX, y: bottomY - yellowWidth, width: yellowHeight, height: yellowWidth),
            CGRect(x: Screen.width * 0.8 - yellowHeight, y: bottomY - yellowWidth, width: yellowHeight, height: yellowWidth)]
        
        for yellowRect in lineY {
            buildYellowLineView(yellowRect)
        }
    }
    
    fileprivate func buildYellowLineView(_ frame: CGRect) {
        let yellowView = UIView(frame: frame)
        yellowView.backgroundColor = UIColor.green
        view.addSubview(yellowView)
    }
    
    fileprivate func buildTransparentView(_ frame: CGRect) {
        let tView = UIView(frame: frame)
        tView.backgroundColor = UIColor.black
        tView.alpha = 0.5
        view.addSubview(tView)
    }
    
    fileprivate func buildAnimationLineView() {
        animationLineView = UIImageView()
        animationLineView!.image = UIImage(named: "yellowlight")
        view.addSubview(animationLineView!)
        
        timer = Timer(timeInterval: 2.5, target: self, selector: #selector(QRCodeViewController.startYellowViewAnimation), userInfo: nil, repeats: true)
        let runloop = RunLoop.current
        runloop.add(timer!, forMode: RunLoopMode.commonModes)
        timer!.fire()
    }
    
    func startYellowViewAnimation() {
        weak var weakSelf = self
        animationLineView!.frame = CGRect(x: Screen.width * 0.2 + Screen.width * 0.1 * 0.5, y: 100, width: Screen.width * 0.5, height: 20)
        UIView.animate(withDuration: 2.5, animations: {
            weakSelf!.animationLineView!.frame.origin.y += Screen.width * 0.55
        }) 
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        var stringValue:String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
        }
        Thread.sleep(forTimeInterval: 0.5)
        captureSession!.stopRunning()
        let alertController = UIAlertController(title: "二维码", message: "扫到的二维码结果为:\(stringValue!) 是否打开？", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { action in
            App.application.openURL(Foundation.URL(string: stringValue!)!)
            self.captureSession?.startRunning()
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { action in
            self.captureSession?.startRunning()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

