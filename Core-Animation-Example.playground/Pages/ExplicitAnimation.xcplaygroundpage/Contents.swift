//: [Previous](@previous)

import UIKit
import PlaygroundSupport

// MARK: Example8_3 添加属性动画
class Example8_3: UIView, CAAnimationDelegate {
    
    lazy var colorLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        layer.backgroundColor = UIColor.red.cgColor
        layer.position = CGPoint(x: bounds.midX, y: bounds.midY - 20)
        return layer
    }()
    
    lazy var changeBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.purple.cgColor
        button.setTitle("Change Color", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.center = CGPoint(x: bounds.midX, y: colorLayer.frame.maxY + 25)
        button.addTarget(self, action: #selector(changeBtnAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        
        backgroundColor = UIColor.white
        
        layer.addSublayer(colorLayer)
        addSubview(changeBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeBtnAction() {
        changeColor()
    }
    
    func changeColor() {
        
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1).cgColor
        
        let animation = CABasicAnimation()
        animation.keyPath = "backgroundColor"
        animation.toValue = color
        animation.delegate = self
        
        colorLayer.add(animation, forKey: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        colorLayer.backgroundColor = ((anim as! CABasicAnimation).toValue as! CGColor)
        CATransaction.commit()
    }
}

// MARK: Example8_4
// 存在 bug （由于动画回调方法在动画完成前就已经被调用），指针会迅速回到原始值，将在后面的章节中处理
class Example8_4: UIView, CAAnimationDelegate {
    
    lazy var hourHand: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "clock_hour_15x54_"))
        imageView.center = self.center
        return imageView
    }()
    
    lazy var minuteHand: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "clock_min_16x77_"))
        imageView.center = self.center
        return imageView
    }()
    
    lazy var secondHand: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "clock_sec_15x90_"))
        imageView.center = self.center
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 150
        
        addSubview(hourHand)
        addSubview(minuteHand)
        addSubview(secondHand)
        
        hourHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        minuteHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        secondHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        
        // start timer
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.tick()
        }
        
        updateHands(animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tick() {
        updateHands(animated: true)
    }
    
    func updateHands(animated: Bool) {
        
        // convert time to hours, minutes and seconds
        let calendar = Calendar(identifier: .gregorian)
        let components: Set<Calendar.Component> = [Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]
        
        let dateComponents = calendar.dateComponents(components, from: Date())
        let hourAngle = CGFloat(dateComponents.hour!) / 12.0 * CGFloat.pi * 2.0
        let minuteAngle = CGFloat(dateComponents.minute!) / 60.0 * CGFloat.pi * 2.0
        let secondAngle = CGFloat(dateComponents.second!) / 60.0 * CGFloat.pi * 2.0
        
        // rotate hands
        setAngle(hourAngle, handView: hourHand, animated: animated)
        setAngle(minuteAngle, handView: minuteHand, animated: animated)
        setAngle(secondAngle, handView: secondHand, animated: animated)
        
    }
    
    func setAngle(_ angle: CGFloat, handView: UIView, animated: Bool) {
        
        // generate transform
        let transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        if animated {
            
            updateHands(animated: false)
            
            // create transform animation
            let animation = CABasicAnimation()
            animation.keyPath = "transform"
            animation.toValue = transform
            animation.duration = 0.5
            animation.delegate = self
            animation.setValue(handView, forKey: "handView")
            handView.layer.add(animation, forKey: nil)
        } else {
            // set transform directly
            handView.layer.transform = transform
        }
        
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // set final position for hand view
        guard let handView = anim.value(forKey: "handView") as? UIImageView  else { return }
        
        let value = (anim as! CABasicAnimation).toValue as! NSValue
        handView.layer.transform = value.caTransform3DValue
    }
}


// MARK: Example8_5 关键帧动画
class Example8_5: UIView {
    
    lazy var colorLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        layer.backgroundColor = UIColor.red.cgColor
        layer.position = CGPoint(x: bounds.midX, y: bounds.midY - 20)
        return layer
    }()
    
    lazy var changeBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.purple.cgColor
        button.setTitle("Change Color", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.center = CGPoint(x: bounds.midX, y: colorLayer.frame.maxY + 25)
        button.addTarget(self, action: #selector(changeBtnAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        
        backgroundColor = UIColor.white
        
        layer.addSublayer(colorLayer)
        addSubview(changeBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeBtnAction() {
        changeColor()
    }
    
    func changeColor() {
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "backgroundColor"
        animation.duration = 2.0
        animation.values = [randomColor().cgColor, randomColor().cgColor, randomColor().cgColor, randomColor().cgColor]
        
        colorLayer.add(animation, forKey: nil)
    }

    func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return color
    }
}


// MARK: Example8_6 贝塞尔曲线动画
class Example8_6: UIView {
    
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
    
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 200)
        super.init(frame: aFrame)
        
        backgroundColor = UIColor.white
        
        createAnimatePathAndLayer()
        layer.addSublayer(airplaneLayer)
        addSubview(changeBtn)
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
        animation.duration = 3.0
        animation.path = animatePath.cgPath
        // Example 8.7
        // 使用飞机运动方向与运动轨迹一致
        animation.rotationMode = .rotateAuto
        airplaneLayer.add(animation, forKey: nil)
    }
}

// MARK: Example8_9 transform.rotation动画
class Example8_9: UIView {
    
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
    
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 200)
        super.init(frame: aFrame)
        
        backgroundColor = UIColor.white
        
        layer.addSublayer(airplaneLayer)
        addSubview(changeBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeBtnAction() {
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = 3.0
        animation.byValue = CGFloat.pi * 2
        airplaneLayer.add(animation, forKey: nil)
    }
}

// MARK: Example8_10 动画组
class Example8_10: UIView {
    
    lazy var rectangleLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        layer.backgroundColor = UIColor.green.cgColor
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
    
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 200)
        super.init(frame: aFrame)
        
        backgroundColor = UIColor.white
        
        createAnimatePathAndLayer()
        layer.addSublayer(rectangleLayer)
        addSubview(changeBtn)
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
        
        // create position animation
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.path = animatePath.cgPath
        animation.rotationMode = .rotateAuto
        
        // create color animation
        let animation2 = CABasicAnimation()
        animation2.keyPath = "backgroundColor"
        animation2.toValue = UIColor.red.cgColor
        
        // create group animation
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation, animation2]
        groupAnimation.duration = 4.0
        
        rectangleLayer.add(groupAnimation, forKey: nil)
    }
}


// MARK: Example8_11 过度 - 淡入淡出
class Example8_11: UIView {
   
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 210))
        imageView.image = UIImage(named: "cat.jpg")
        imageView.contentMode = .scaleAspectFill
        var center = self.center
        center.y -= 40.0
        imageView.center = center
        return imageView
    }()
    
    lazy var changeBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.purple.cgColor
        button.setTitle("swith image", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.center = CGPoint(x: bounds.midX, y: bounds.maxY - 45)
        button.addTarget(self, action: #selector(changeBtnAction), for: .touchUpInside)
        return button
    }()
    
    let images = ["cat.jpg", "lion.jpg", "fox.jpg", "tiger.jpg"]
    
    var switchIndex = 0
    
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 400)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
    
        addSubview(imageView)
        addSubview(changeBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc func changeBtnAction() {
        
        switchIndex += 1
        if switchIndex == images.count {
            switchIndex = 0
        }
        
        
        let transition = CATransition()
        transition.type = .fade
        imageView.layer.add(transition, forKey: nil)
        imageView.image = UIImage(named: images[switchIndex])
    }
    
}

// MARK: Playground 无法演示该示例，需要一个 iOS 工程才可实现效果
class Example8_12: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.red
        vc1.title = "ViewController1"
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.orange
        vc2.title = "ViewController2"
        self.viewControllers = [vc1, vc2]
        delegate = self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let transition = CATransition()
        transition.type = .fade
//        view.layer.add(transition, forKey: nil)
    }
    
}

// MARK: Example8_14 自定义过度效果
class Example8_14: UIView {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 210))
        imageView.image = UIImage(named: "cat.jpg")
        imageView.contentMode = .scaleAspectFill
        var center = self.center
        center.y -= 40.0
        imageView.center = center
        return imageView
    }()
    
    lazy var changeBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.purple.cgColor
        button.setTitle("swith image", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.center = CGPoint(x: bounds.midX, y: bounds.maxY - 45)
        button.addTarget(self, action: #selector(changeBtnAction), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 400)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        addSubview(imageView)
        addSubview(changeBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func changeBtnAction() {
       
        // 保留当前视图快照
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let coverImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 插入快照视图
        let coverView = UIImageView(image: coverImage)
        coverView.frame = bounds
        addSubview(coverView)
        
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        backgroundColor = color
        
        UIView .animate(withDuration: 1.0, animations: {
            // scale, rotate and fade the view
            let transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            let rotate = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
            
            coverView.transform = transform.concatenating(rotate)
            coverView.alpha = 0.0
        }) { (_) in
            coverView.removeFromSuperview()
        }
    }
    
}

// MARK: Example8_15 中断动画
class Example8_15: UIView, CAAnimationDelegate {
    
    lazy var airplaneLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        layer.contents = UIImage(named: "airplane")?.cgImage
        layer.position = CGPoint(x: 150, y: 70)
        return layer
    }()
    
    lazy var starBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.purple.cgColor
        button.setTitle("start", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.center = CGPoint(x: bounds.midX - 70, y: bounds.maxY - 45)
        button.addTarget(self, action: #selector(startBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy var stopBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.purple.cgColor
        button.setTitle("stop", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.center = CGPoint(x: bounds.midX + 70, y: bounds.maxY - 45)
        button.addTarget(self, action: #selector(stopBtnAction), for: .touchUpInside)
        return button
    }()
    
    var animatePath: UIBezierPath!
    
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 200)
        super.init(frame: aFrame)
        
        backgroundColor = UIColor.white
        
        layer.addSublayer(airplaneLayer)
        addSubview(starBtn)
        addSubview(stopBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func startBtnAction() {
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = 3.0
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
}

//PlaygroundPage.current.liveView = Example8_3()
//PlaygroundPage.current.liveView = Example8_4()
//PlaygroundPage.current.liveView = Example8_5()
//PlaygroundPage.current.liveView = Example8_6()
//PlaygroundPage.current.liveView = Example8_9()
//PlaygroundPage.current.liveView = Example8_10()
//PlaygroundPage.current.liveView = Example8_12()
//PlaygroundPage.current.liveView = Example8_14()
PlaygroundPage.current.liveView = Example8_15()
//
