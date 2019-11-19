//: [Previous](@previous)

import UIKit
import PlaygroundSupport

// MARK: Example9_1 - 测试duration和repeatCount
class Example9_1: UIViewController, CAAnimationDelegate {
    
    lazy var airplaneLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 72, height: 72)
        layer.contents = UIImage(named: "airplane")?.cgImage
        layer.position = CGPoint(x: 200, y: 70)
        return layer
    }()
    
    lazy var starBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 70, y: 300, width: 120, height: 30))
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.purple.cgColor
        button.setTitle("start", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(startBtnAction), for: .touchUpInside)
        return button
    }()
    

    lazy var durationTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 70, y: 200, width: 120, height: 30))
        textField.backgroundColor = UIColor.white
        textField.text = String(2.0)
        textField.textAlignment = .center
        textField.placeholder = "duration"
        textField.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()
    
    lazy var repeatCountTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 70, y: 250, width: 120, height: 30))
        textField.backgroundColor = UIColor.white
        textField.text = String(3.5)
        textField.textAlignment = .center
        textField.placeholder = "repeat count"
        textField.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()
    
    var animatePath: UIBezierPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray

        let containerView = UIView(frame: CGRect(x: 50, y: 100, width: 200, height: 200))
        view.addSubview(containerView)
        containerView.layer.addSublayer(airplaneLayer)
        
        view.addSubview(durationTextField)
        view.addSubview(repeatCountTextField)
        view.addSubview(starBtn)
    }
    
    @objc func startBtnAction() {
        
        let duration = CFTimeInterval(durationTextField.text!)!
        let repeatCount = Float(repeatCountTextField.text!)!
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.byValue = CGFloat.pi * 2
        animation.delegate = self
        airplaneLayer.add(animation, forKey: "rotateAnimation")
    }
    
    @objc func stopBtnAction() {
        airplaneLayer.removeAnimation(forKey: "rotateAnimation")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let text = flag ? "YES" : "NO"
        print("The animation stopped (finished: \(text)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: Example9_2 - 使用 autoreverses 属性实现门的摇摆
class Example9_2: UIView {
    
    lazy var doorLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 300, height: 500)
        layer.contents = UIImage(named: "door.png")?.cgImage
        layer.position = CGPoint(x: 350, y: bounds.midY - 100)
        layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        return layer
    }()
    
    lazy var changeBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.purple.cgColor
        button.setTitle("start animation", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.center = CGPoint(x: bounds.midX, y: doorLayer.frame.maxY + 85)
        button.addTarget(self, action: #selector(changeBtnAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 800)
        super.init(frame: aFrame)
        
        backgroundColor = UIColor.white
        
        layer.addSublayer(doorLayer)
        addSubview(changeBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeBtnAction() {
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500.0
        layer.sublayerTransform = perspective
        
        // apply swinging animation
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.y"
        animation.toValue = CGFloat.pi / 2.0
        animation.duration = 2.0
        animation.repeatDuration = Double.infinity
        animation.autoreverses = true
        doorLayer.add(animation, forKey: nil)
    }
}

// MARK: Example9_3 - 测试timeOffset和speed属性
class Example9_3: UIView {
    
    class ControlView: UIView {
        
        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor.black
            return label
        }()
        
        
        lazy var descLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor.black
            return label
        }()
        
        lazy var slider: UISlider = {
            let slider = UISlider()
            slider.maximumValue = 1.0
            slider.minimumValue = 0.0
            slider.value = 0
            slider.addTarget(self, action: #selector(valueChanged(sender:)), for: UIControl.Event.valueChanged)
            return slider
        }()
        
        var value: Float {
            return slider.value
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(titleLabel)
            addSubview(slider)
            addSubview(descLabel)
            
            slider.tintColor = UIColor.blue
            slider.thumbTintColor = UIColor.orange
            
            
        }
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
        override func layoutSubviews() {
            super.layoutSubviews()
            
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint(x: titleLabel.center.x, y: bounds.midY)
            
            slider.frame = CGRect(x: 80, y: 0, width: 150, height: 10)
            slider.center = CGPoint(x: slider.center.x, y: bounds.midY)
            
            descLabel.frame = CGRect(x: slider.frame.maxX + 10, y: 0, width: 0, height: 0)
            descLabel.sizeToFit()
            descLabel.center = CGPoint(x: descLabel.center.x, y: bounds.midY)
        }
        
        @objc func valueChanged(sender: UISlider) {
            descLabel.text = String(format: "%.1f", sender.value)
            descLabel.sizeToFit()
        }
        
    }
    
    ////////////////////////////////////
    lazy var airplaneLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        layer.contents = UIImage(named: "airplane")?.cgImage
        layer.position = CGPoint(x: 50, y: 70)
        return layer
    }()
    
    lazy var changeBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.purple.cgColor
        button.setTitle("start move", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.center = CGPoint(x: bounds.midX, y: bounds.maxY - 45)
        button.addTarget(self, action: #selector(changeBtnAction), for: .touchUpInside)
        return button
    }()
    
    var animatePath: UIBezierPath!
    
    lazy var timeOffsetControl: ControlView = {
        let control = ControlView(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        control.center = CGPoint(x: self.bounds.midX, y: bounds.maxY - 140)
        control.titleLabel.text = "timeOffset"
        control.slider.value = 0.5
        control.descLabel.text = "0.5"
        return control
    }()
    
    lazy var speedControl: ControlView = {
        let control = ControlView(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        control.center = CGPoint(x: self.bounds.midX, y: bounds.maxY - 100)
        control.titleLabel.text = "speed"
        control.slider.value = 1.0
        control.descLabel.text = "1.0"
        return control
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 350)
        super.init(frame: aFrame)
        
        backgroundColor = UIColor.white
        
        createAnimatePathAndLayer()
        layer.addSublayer(airplaneLayer)
        addSubview(changeBtn)
        addSubview(timeOffsetControl)
        addSubview(speedControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createAnimatePathAndLayer() {
        // create a path
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 50, y: 70))
        bezierPath.addCurve(to: CGPoint(x: 350, y: 70), controlPoint1: CGPoint(x: 125, y: -80), controlPoint2: CGPoint(x: 275, y: 180))
        animatePath = bezierPath
        
        // draw the path using a CAShapeLayer
        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.cgPath
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.red.cgColor
        pathLayer.lineWidth = 3.0
        layer.insertSublayer(pathLayer, at: 0)
    }
    
    @objc func changeBtnAction() {
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.timeOffset = CFTimeInterval(timeOffsetControl.value)
        animation.speed = speedControl.value
        animation.duration = 1.0
        animation.path = animatePath.cgPath
        // Example 8.7
        // 使用飞机运动方向与运动轨迹一致
        animation.rotationMode = .rotateAuto
        animation.isRemovedOnCompletion = false
        airplaneLayer.add(animation, forKey: nil)
    }
}


// MARK: Example9_4 - 通过触摸手势手动控制动画
class Example9_4: UIView {
    
    lazy var doorLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 300, height: 500)
        layer.contents = UIImage(named: "door.png")?.cgImage
        layer.position = CGPoint(x: bounds.midX - 150, y: bounds.midY - 100)
        layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        return layer
    }()
    
    lazy var changeBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.purple.cgColor
        button.setTitle("start animation", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.center = CGPoint(x: bounds.midX, y: doorLayer.frame.maxY + 85)
//        button.addTarget(self, action: #selector(changeBtnAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 800)
        super.init(frame: aFrame)
        
        backgroundColor = UIColor.white
        
        layer.addSublayer(doorLayer)
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(_:))))
        
        addSwingAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSwingAnimation() {
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500.0
        layer.sublayerTransform = perspective
        
        // pause all layer animations
        doorLayer.speed = 0.0
        
        // apply swinging animation
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.y"
        animation.toValue = -CGFloat.pi / 2.0
        animation.duration = 2.0
        doorLayer.add(animation, forKey: nil)
        
    }
    
    @objc func pan(_ gesutre: UIPanGestureRecognizer) {
        
        // get horizontal component of pan gesture
        var x = gesutre.translation(in: self).x
        
        // convert from points to animation duration //using a reasonable scale factor
        x /= 200.0
        
        // update timeOffset and clamp result
        var timeOffset = doorLayer.timeOffset
        print(timeOffset)
        timeOffset = min(1, max(0, timeOffset - Double(x)))
        doorLayer.timeOffset = timeOffset
        // reset pan gesture
        gesutre.setTranslation(CGPoint.zero, in: self)
    }
}


//let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 768, height: 1024))
//let viewController = Example9_1()
//window.rootViewController = viewController
//window.makeKeyAndVisible()
//
//PlaygroundPage.current.liveView = window

//PlaygroundPage.current.liveView = Example9_2()
//PlaygroundPage.current.liveView = Example9_3()
PlaygroundPage.current.liveView = Example9_4()
