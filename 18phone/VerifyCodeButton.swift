//
//  VerifyCodeButton.swift
//  18phone
//
//  Created by 戴全艺 on 16/10/8.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class VerifyCodeButton: UIButton {
    
    var timer: NSTimer?
    var count = 0
    
    func timeFailBeginFrom(timeCount: Int) {
        enabled = false
        count = timeCount
        titleLabel?.text = "剩余\(count)秒"
        setTitle("剩余\(count)秒", forState: .Disabled)
        // 加1个计时器
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    func timerFired() {
        if count != 1 {
            count -= 1
            titleLabel?.text = "剩余\(count)秒"
            setTitle("剩余\(count)秒", forState: .Disabled)
        } else {
            titleLabel?.text = "获取验证码"
            setTitle("获取验证码", forState: .Normal)
            timer?.invalidate()
            enabled = true
        }
    }
}
