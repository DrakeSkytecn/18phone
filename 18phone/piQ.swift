//
//  piQ.swift
//  piQ
//
//  Created by Marvin Böddeker on 06.12.15.
//  Copyright © 2015 Marvin Böddeker. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

open class piQ{
    public init (){
        print("Class has been initialised")
    }
    
    
/*========================================TOGGLEVISIBILITYANIMATION============================================*/
    
    open var imageHeightVisible : CGFloat!
    
    open func toggleImageViewVisibility(_ Controller: UIViewController, ImageConstraint : NSLayoutConstraint){
        
        //let animated : Bool = true
       
        
        if ImageConstraint.constant != 0 {
            imageHeightVisible = ImageConstraint.constant
            ImageConstraint.constant = 0
        } else {
            ImageConstraint.constant = imageHeightVisible
        }
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                Controller.view.layoutIfNeeded()
                }, completion: nil)
    }
/*=============================================================================================================*/

}

extension UIImageView {
    
    /*=========================================================
    
                            *GEOMETRICS*
    
    
    Usage:  Import piQ and define your ImageView. After that 
            take your geometric mask. Example:
    
            myImageView.piQ_RoundImage()
    
            Thats it!
    
    =========================================================*/
    
    public func piQ_RoundImage(){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    public func piQ_triangle_UP(){

        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        
        
        // Create Path
        let bezierPath = UIBezierPath()
        
        // Draw Points
        bezierPath.move(to: CGPoint(x: layerWidth/2, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: layerHeight))
        bezierPath.addLine(to: CGPoint(x: 0, y: layerHeight))
        // bezierPath.addLineToPoint(CGPoint(x: 0, y: 0))
        bezierPath.close()
        
        
        
        // Mask to Path
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = bezierPath.cgPath
        
        self.layer.mask = mask
        
    }
    
    public func piQ_triangle_DOWN(){
        
        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        
        
        // Create Path
        let bezierPath = UIBezierPath()
        
        // Draw Points
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth/2, y: layerHeight))
        // bezierPath.addLineToPoint(CGPoint(x: 0, y: 0))
        bezierPath.close()
        
        
        
        // Mask to Path
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = bezierPath.cgPath
        
        self.layer.mask = mask
        
    }
    
    public func piQ_Pentagon(){
        
        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        
        
        // Create Path
        let bezierPath = UIBezierPath()
        
        // Draw Points
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth/2, y: layerHeight))
        // bezierPath.addLineToPoint(CGPoint(x: 0, y: 0))
        bezierPath.close()
        
        
        
        // Mask to Path
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = bezierPath.cgPath
        
        self.layer.mask = mask
        
    }
    
    public func piQ_Hexagon(){
        
        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        
        
        // Create Path
        let bezierPath = UIBezierPath()
        
        // Draw Points
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth/2, y: layerHeight))
        // bezierPath.addLineToPoint(CGPoint(x: 0, y: 0))
        bezierPath.close()
        
        
        
        // Mask to Path
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = bezierPath.cgPath
        
        self.layer.mask = mask
        
    }

    public func piQ_Octagon(){
        
        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        
        
        // Create Path
        let bezierPath = UIBezierPath()
        
        // Draw Points
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth/2, y: layerHeight))
        // bezierPath.addLineToPoint(CGPoint(x: 0, y: 0))
        bezierPath.close()
        
        
        
        // Mask to Path
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = bezierPath.cgPath
        
        self.layer.mask = mask
        
    }

    
    
    
    

    /*=========================================================
    
                        *IMAGEFILTER*
    
    
    Usage:  Import piQ and define your ImageView. After that
            take your filterfamily and your filter. Example:
    
            myImageView.piQ_convertToGrayScale(imageFilter: .Noir)
    
            Thats it!
    
    
            *TODO*:
            I'm working on some new retro and vintage filter.
            Cooming soon.
    
    =========================================================*/
    
    
    public enum filterNames {
        case tonality
        case noir
        case anselAdams
        case dark
        case dots
    }
    
    public func piQ_convertToGrayScale(_ imageFilter:filterNames){
        
        // var filterNames: [String] = ["CIPhotoEffectTonal","CIPhotoEffectNoir","CIMaximumComponent","CIMinimumComponent","CIDotScreen"]
        
        var CIfilterName:String = ""
        
        
        
        
        switch imageFilter {
        case .tonality:
            CIfilterName = "CIPhotoEffectTonal"
            break
        case .noir:
            CIfilterName = "CIPhotoEffectNoir"
            break
        case .anselAdams:
            CIfilterName = "CIMaximumComponent"
            break
        case .dark:
            CIfilterName = "CIMinimumComponent"
            break
        case .dots:
            CIfilterName = "CIDotScreen"
            break
        default:
            CIfilterName = ""
            break
        }
        
        let originalImage = self.image
        
        let ciContext = CIContext(options: nil)
        let startImage = CIImage(image: originalImage!)
        
        let filter = CIFilter(name: CIfilterName)
        
        filter?.setDefaults()
        
        //LETS WORK
        
        filter?.setValue(startImage, forKey: kCIInputImageKey)
        let filteredImageData = filter?.value(forKey: kCIOutputImageKey) as! CIImage
        
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        self.image = UIImage(cgImage: filteredImageRef!)
        
    }
    
    public func piQ_tintImageColor(_ color: UIColor){
        self.image = self.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = color
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*=========================================================
    
                        *IMAGEANIMATIONS*
    
    
    Usage:  Import piQ and define your ImageView. After that
            take your animationstyle. Example:
    
            myImageView.piQ_rotateImageWithAnimation(Duration:3)
    
            With this example function, you can animate your 
            ImageViews. You can decide how long.
    
            Thats it!
    
    
            *TODO*:
            Creating some new Animations ;)
    
    =========================================================*/

    public func piQ_rotateImage(){
        self.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(M_PI)) / 180.0)
    }
    
    public func piQ_rotateImageWithAnimation(_ Duration:Double){
        rotateFirst(self, time: Duration)
        rotateSecond(self, time: Duration)
        
    }
    
    
    

    
    
    
    
    
    /*=========================================================
    
                        *IMAGELOADING*
    
    
    Usage:  Import piQ and define your ImageView. Now you can 
            load your image with an URL. Both functions are 
            working asynchronously, but do you wanna use it,
            with one of the other functions of piQ, than use it
            with a placeholder. It's more safe.
    
            Example:
            myImageView.piQ_imageFromURL(urlString: "http://pic.jpg")
    =========================================================*/
    
    
    
//    public func piQ_imageFromUrl(_ urlString: String) {
//        
//        
//        if let url = Foundation.URL(string: urlString) {
//            let request = URLRequest(url: url)
//            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {
//                (response: URLResponse?, data: Data?, error: NSError?) -> Void in
//                if data != nil {
//                self.image = UIImage(data: data!)
//                } else {
//                    print("Error Loading Image")
//                }
//            } as! (URLResponse?, Data?, Error?) -> Void            }
//    }
//    
//    public func piQ_imageFromUrl(_ urlString: String, placeholderImage: UIImage) {
//        
//        //Use your Placeholder, if you download an image with big loading times.
//        self.image = placeholderImage
//        
//        if let url = Foundation.URL(string: urlString) {
//            let request = URLRequest(url: url)
//            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {
//                (response: URLResponse?, data: Data?, error: NSError?) -> Void in
//                if data != nil {
//                self.image =  UIImage(data: data!)
//                } else {
//                    print("Error Loading Image")
//                }
//            } as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void
//        } else {
//            print("Error Loading Image")
//        }
//    }
    
    
    
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    func rotateFirst(_ image: UIImageView!, time:Double){
        
        
        UIView.animate(withDuration: time / 2, animations: {
            image.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(M_PI)) / 180.0)
            
        })
    }
    
    func rotateSecond(_ image: UIImageView!, time:Double){
        
        
        UIView.animate(withDuration: time / 2, animations: {
            image.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(M_PI)) / 180.0)
            
        })
    }

    
    
    
}
