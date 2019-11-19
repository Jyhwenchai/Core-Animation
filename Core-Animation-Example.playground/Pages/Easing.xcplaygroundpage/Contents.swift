//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport


// MARK: Example10_1 - 缓冲函数的简单测试
class Example10_1 : UIView {
    
    lazy var colorLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.backgroundColor = UIColor.red.cgColor
        layer.position = center
        return layer
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        layer.addSublayer(colorLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // configure the transaction
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
        
        colorLayer.position = touches.first!.location(in: self)
        
        CATransaction.commit()
        
    }
    
}


// MARK: Example10_2 - 使用UIKit动画的缓冲测试工程
class Example10_2 : UIView {
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.backgroundColor = UIColor.red
        view.center = center
        return view
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        addSubview(colorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.colorView.center = touches.first!.location(in: self)
        })
    }
    
}


// MARK: Example10_3 - 对CAKeyframeAnimation使用CAMediaTimingFunction
class Example10_3 : UIView {
    
    lazy var colorLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.backgroundColor = UIColor.blue.cgColor
        layer.position = center
        return layer
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        layer.addSublayer(colorLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "backgroundColor"
        animation.duration = 2.0
        animation.values = [UIColor.blue.cgColor, UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
        let fn = CAMediaTimingFunction(name: .easeIn)
        animation.timingFunctions = [fn, fn, fn]
        
        colorLayer.add(animation, forKey: nil)
        
    }
    
}


// MARK: Example10_4 - UIBezierPath 绘制 CAMediaTimingFunction
// 可以通过该工具查看不同缓冲曲线的效果 https://github.com/YouXianMing/Tween-o-Matic-CN
// 更多的曲线效果 https://easings.net/
class Example10_4 : UIView {
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        // 切换查看不同的缓冲曲线
//        let function = CAMediaTimingFunction(name: .easeOut)
//        let function = CAMediaTimingFunction(name: .easeIn)
//        let function = CAMediaTimingFunction(name: .easeInEaseOut)
//        let function = CAMediaTimingFunction(name: .default)
//        let function = CAMediaTimingFunction(name: .linear)
        let function = CAMediaTimingFunction(controlPoints: 1, 0, 0.75, 1)
        var controlPoint1: [Float] = [0.0,0.0]
        var controlPoint2: [Float] = [0.0,0.0]
        
        function.getControlPoint(at: 1, values: &controlPoint1)
        function.getControlPoint(at: 2, values: &controlPoint2)
        
        // create curve
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        let point1 = CGPoint(x: Double(controlPoint1.first!), y: Double(controlPoint1.last!))
        let point2 = CGPoint(x: Double(controlPoint2.first!), y: Double(controlPoint2.last!))
        
        //create curve
        path.addCurve(to: CGPoint(x: 1, y: 1), controlPoint1: point1, controlPoint2: point2)

        // scale the path up to a reasonable size for display
        path.apply(CGAffineTransform(scaleX: 300, y: 300))
        
        //create shape layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4.0
        shapeLayer.path = path.cgPath
        
        layer.addSublayer(shapeLayer)
        
        // 翻转几何体，使0,0在左下角
        layer.isGeometryFlipped = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: Example10_6 - 使用关键帧实现反弹球的动画
class Example10_6 : UIView, CAAnimationDelegate {
    
    lazy var ballView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ball.png"))
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.center = CGPoint(x: center.x, y: 50)
        return view
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        addSubview(ballView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        animate()
    }
    
    func animate() {
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.duration = 1.0
        animation.delegate = self
        animation.values = [
            CGPoint(x: center.x, y: 32),
            CGPoint(x: center.x, y: 268),
            CGPoint(x: center.x, y: 140),
            CGPoint(x: center.x, y: 268),
            CGPoint(x: center.x, y: 220),
            CGPoint(x: center.x, y: 268),
            CGPoint(x: center.x, y: 250),
            CGPoint(x: center.x, y: 268)]
        
        animation.timingFunctions = [
            CAMediaTimingFunction(name: .easeIn),
            CAMediaTimingFunction(name: .easeOut),
            CAMediaTimingFunction(name: .easeIn),
            CAMediaTimingFunction(name: .easeOut),
            CAMediaTimingFunction(name: .easeIn),
            CAMediaTimingFunction(name: .easeOut),
            CAMediaTimingFunction(name: .easeIn),]
        
        animation.keyTimes = [0.0, 0.3, 0.5, 0.7, 0.8, 0.9, 0.95, 1.0];
        
        ballView.layer.position = CGPoint(x: center.x, y: 268)
        ballView.layer.add(animation, forKey: nil)
    }
}

// MARK: Example10_7 - 使用插入的值创建一个关键帧动画
class Example10_7 : UIView, CAAnimationDelegate {
    
    lazy var ballView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ball.png"))
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.center = CGPoint(x: center.x, y: 50)
        return view
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        addSubview(ballView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        animate()
    }
    
    func animate() {
        
        let fromPoint = CGPoint(x: center.x, y: 32)
        let toPoint = CGPoint(x: center.x, y: 268)
        
        let duration = 1.0
        
        // generate keyframes
        let numFrames = duration * 60
        var frames: [CGPoint] = []
        for i in 0..<Int(numFrames) {
            let time = 1.0 / numFrames * Double(i)
            let point = interpolate(from: fromPoint, to: toPoint, time: time)
            frames.append(point)
        }
        
        // create keyframe animation
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.duration = 1.0
        animation.delegate = self
        animation.values = frames
        
        ballView.layer.position = CGPoint(x: center.x, y: 268)
        ballView.layer.add(animation, forKey: nil)
    }
    
    func interpolate(from value1: CGPoint, to value2: CGPoint, time: CFTimeInterval) -> CGPoint {
        let result = CGPoint(x: interpolate(from: value1.x, to: value2.x, time: time), y: interpolate(from: value1.y, to: value2.y, time: time))
        return result
    }
    
    func interpolate(from: CGFloat, to: CGFloat, time: CFTimeInterval) -> CGFloat {
        return (to - from) * CGFloat(time) + from
    }
}


// MARK: Example10_8 - 用关键帧实现自定义的缓冲函数
class Example10_8 : UIView, CAAnimationDelegate {
    
    lazy var ballView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ball.png"))
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.center = CGPoint(x: center.x, y: 50)
        return view
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        addSubview(ballView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        animate()
    }
    
    func animate() {
        
        let fromPoint = CGPoint(x: center.x, y: 32)
        let toPoint = CGPoint(x: center.x, y: 268)
        
        let duration = 1.0
        
        // generate keyframes
        let numFrames = duration * 60
        var frames: [CGPoint] = []
        for i in 0..<Int(numFrames) {
            var time = 1.0 / numFrames * Double(i)
            // apply easing
            time = bounceEaseOut(t: time)
            // add keyframe
            let point = interpolate(from: fromPoint, to: toPoint, time: time)
            frames.append(point)
        }
        
        // create keyframe animation
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.duration = 1.0
        animation.delegate = self
        animation.values = frames
        
        ballView.layer.position = CGPoint(x: center.x, y: 268)
        ballView.layer.add(animation, forKey: nil)
    }
    
    func interpolate(from value1: CGPoint, to value2: CGPoint, time: CFTimeInterval) -> CGPoint {
        let result = CGPoint(x: interpolate(from: value1.x, to: value2.x, time: time), y: interpolate(from: value1.y, to: value2.y, time: time))
        return result
    }
    
    func interpolate(from: CGFloat, to: CGFloat, time: CFTimeInterval) -> CGFloat {
        return (to - from) * CGFloat(time) + from
    }
    
    func bounceEaseOut(t: Double) -> Double {
        if (t < 4/11.0) {
            return (121 * t * t)/16.0;
        } else if (t < 8/11.0) {
            return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
        } else if (t < 9/10.0) {
            return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
        }
            return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
    }
}

// Present the view controller in the Live View window
//PlaygroundPage.current.liveView = Example10_1()
//PlaygroundPage.current.liveView = Example10_2()
//PlaygroundPage.current.liveView = Example10_3()
//PlaygroundPage.current.liveView = Example10_4()
//PlaygroundPage.current.liveView = Example10_6()
//PlaygroundPage.current.liveView = Example10_7()
PlaygroundPage.current.liveView = Example10_8()
