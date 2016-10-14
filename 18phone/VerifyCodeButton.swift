//
//  VerifyCodeButton.swift
//  18phone
//
//  Created by 戴全艺 on 16/10/8.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class VerifyCodeButton: UIButton {
    
    var timer: Timer?
    var count = 0
    
    func timeFailBeginFrom(_ timeCount: Int) {
        isEnabled = false
        count = timeCount
        titleLabel?.text = "剩余\(count)秒"
        setTitle("剩余\(count)秒", for: .disabled)
        // 加1个计时器
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    func timerFired() {
        if count != 1 {
            count -= 1
            titleLabel?.text = "剩余\(count)秒"
            setTitle("剩余\(count)秒", for: .disabled)
        } else {
            titleLabel?.text = "获取验证码"
            setTitle("获取验证码", for: UIControlState())
            timer?.invalidate()
            isEnabled = true
        }
    }
}
