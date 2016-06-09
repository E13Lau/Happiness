//
//  FaceView.swift
//  Happiness
//
//  Created by command.Zi on 16/6/7.
//  Copyright © 2016年 command.Zi. All rights reserved.
//

import UIKit

class FaceView: UIView {
    //didSet property Observer
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10  //脸半径到眼睛半径比例
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3  //脸半径到眼睛偏移比例
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5  //脸半径到眼睛分离比例
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1  //脸半径到嘴宽度比例
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3  //脸半径到嘴高度比例
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3  //脸半径到嘴偏移比例
    }
    
    private enum Eye {
        case Left, Right
    }
    
    private func bezierPathForEye(whichEye:Eye) -> UIBezierPath {
        //眼睛半径
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        //眼睛垂直偏移
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        //眼睛水平间隔
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .Left:
            eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right:
            eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        bezierPathForSmile(-0.5).stroke()
    }
}
