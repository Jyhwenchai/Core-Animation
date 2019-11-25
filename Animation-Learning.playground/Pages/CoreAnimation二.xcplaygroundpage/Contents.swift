//: [Previous](@previous)

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/*:
 
                             ┌──────────────────────────────────┐
                             │    CAAction   |  CAMediaTiming   │
                             └───────────────┬──────────────────┘
                                             │
                                   ┌─────────┴─────────┐
                                   │    CAAnimation    │
                                   └─────────┬─────────┘
                                             │
                      ┌──────────────────────┴───────────────────────┐
                      │    CAPropertyAnimation | CAAnimationGroup    │
                      └────────────┬─────────────────────────────────┘
                                   │
          ┌────────────────────────┴────────────────────────┐
          │    CABasicAnimation    |  CAKeyframeAnimation   │
          └────────────┬────────────────────────────────────┘
                       │
          ┌────────────┴───────────┐
          │    CASpringAnimation   │
          └────────────────────────┘

*/
//: 在第一部分中我们通过 `CABasicAnimation` 了解了动画相关属性的使用，现在我们将继续学习剩余的动画类的使用。

//: ---

//: ## `CAAnimationGroup`
//: 我们见到的动画效果多是复杂的，很少说使用 `CABasicAnimation` 就可以满足我们的需求。通过 `CAAnimationGroup` 可以将多个简单动画组合在一起实现一个复杂的动画效果。此时对于大多数动画属性你应该通过 `CABasicAnimation` 对象 来设置，而不是作用在单独的动画对象上。
example(CGRect.zero) { rootView in
    let animateView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    animateView.backgroundColor = UIColor.systemPink
    rootView.addSubview(animateView)
    
    let positionAnimate: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = 25
        animation.toValue = 250
        return animation
    }()
    
    let bgColorAnimate: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = animateView.backgroundColor!.cgColor
        animation.toValue = UIColor.systemTeal.cgColor

        return animation
    }()

    let animationGroup = CAAnimationGroup()
    animationGroup.animations = [positionAnimate, bgColorAnimate]
    animationGroup.duration = 2
    animationGroup.fillMode = .forwards
    animationGroup.isRemovedOnCompletion = false
    animateView.layer.add(animationGroup, forKey: nil)
    
    PlaygroundPage.current.liveView = rootView
}
//: 当然通过在组动画与简单动画对象上设置不同的动画属性有时候可以起到更丰富的效果，这需要你更多的尝试。例如你可以使用 `beginTime` 使用动画组中的其中一个简单动画延迟开始, 或者使用 `timeOffset` 使动画产生不同的效果，你也可以使用 `speed` 来控制位移动画的速度，这是 `fillMode` 与 `isRemovedOnCompletion` 是必须的，如果你不希望位移动画回到开始位置的话。
example(CGRect.zero) { rootView in
    let animateView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    animateView.backgroundColor = UIColor.systemPink
    rootView.addSubview(animateView)
    
    let positionAnimate: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = 25
        animation.toValue = 250
//        animation.beginTime = 1.0
        animation.timeOffset = 1.0
//        animation.speed = 2.0
//        animation.fillMode = .forwards
//        animation.isRemovedOnCompletion = false
        return animation
    }()
    
    let bgColorAnimate: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = animateView.backgroundColor!.cgColor
        animation.toValue = UIColor.systemTeal.cgColor

        return animation
    }()

    let animationGroup = CAAnimationGroup()
    animationGroup.animations = [positionAnimate, bgColorAnimate]
    animationGroup.duration = 2
    animationGroup.fillMode = .forwards
    animationGroup.isRemovedOnCompletion = false
    animateView.layer.add(animationGroup, forKey: nil)
    
    PlaygroundPage.current.liveView = rootView
}

//: ## CAKeyframeAnimation
//: 我们可以使用 `CAKeyframeAnimation` 关键帧动画将一个动画分割成多个片段 `values`，使用 `keyTimes` 定义不同片段在各自的动画时长占总时长的百分比、动画曲线函数 `timingFunctions` 等。
//:
//: 这里 `keyTimes` 受 `calculationMode` 影响
//: * 如果 `calculationMode` 值为 `linear` 或 `cubic` 时，动画将应用插值，数组中的第一个值必须为0.0，最后一个值必须为1.0。所有中间值代表一个片段动画的开始时间和结束时间之间的时间点
//: * 如果 `calculationMode` 值为 `discreate`，动画将依据给的的 `values` 逐帧显示， 数组中的第一个值必须为0.0，最后一个值必须为1.0。该数组应比在values数组中显示的条目多一个。例如，如果有两个值，则应该有三个关键时间。
//: * 如果将 `calculationMode` 设置为 `paced` 或 `cubicPaced`，则将忽略此属性中的值而采用匀速方式运动
example(CGRect.zero) { rootView in
    let ballView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ball.png"))
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.center = CGPoint(x: rootView.center.x, y: 50)
        return view
    }()
    
    rootView.addSubview(ballView)
    
    func animate() {
        let center = rootView.center
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.duration = 1.0
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
    
    animate()
    PlaygroundPage.current.liveView = rootView
}

//: 我们可以在 `CAKeyframeAnimation` 应用 `path`，`path` 属性让动画可以沿着一段路径进行运动，与之关联的属性 `rotationMode` 影响了动画再 `path` 上的运动方向,
//: * 在 `rotationMode` 为 `rotateAuto` 下视图对象会旋转以沿着 `path` 的切线运动
//: * 在 `rotationMode` 为 `rotateAutoReverse` 下视图会旋转以沿着 `path` 相切的180度运动，也就是说在这个状态下的方向与 `rotationMode` 下相反
example(CGRect.zero) { rootView in
    let animateView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    animateView.layer.contents = UIImage(named: "airplane")?.cgImage
    rootView.addSubview(animateView)
    
    let positionAnimate: CAAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath(ovalIn: rootView.bounds.inset(by: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)))
        animation.path = path.cgPath
        animation.duration = 10.0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.rotationMode = .rotateAuto     // 尝试修改这里以测试动画效果
        return animation
    }()
    
    animateView.layer.add(positionAnimate, forKey: nil)
    
    PlaygroundPage.current.liveView = rootView
}

//: 在 `calucateMode` 为 `cubic` 和 `cubicPice` 下动画的曲线受三个属性影响
//: * `tensionValues` 影响曲线的紧密层度，当 `tensionValues` 中的值为整数时表示曲线更加紧密，负数这曲线更圆分的更开, 你可以通过示例来进一步理解
//: * `continuityValues` 影响曲线的拐角的样式，正值会导致向运动方向凸出的拐角，负值将导致向运动方向凹陷的拐角，你可以通过示例进一步理解
//: * `biasValues` 影响控制点的偏移，正值则向前偏移，负值向后偏移，你可以通过示例进一步理解
example(CGRect.zero) { rootView in
    let animateView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    animateView.layer.contents = UIImage(named: "airplane")?.cgImage
    rootView.addSubview(animateView)
    let lineView = UIView(frame: CGRect(x: 150, y: 0, width: 1.0, height: 300))
    lineView.backgroundColor = UIColor.orange
    rootView.addSubview(lineView)
    
    let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
    animation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
    animation.values = [CGPoint(x: 25, y: 250),
                        CGPoint(x: 145, y: 100),
                        CGPoint(x: 265, y: 250)]
    animation.duration = 10.0
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    animation.rotationMode = .rotateAuto     // 尝试修改这里以测试动画效果
    animation.calculationMode = .cubicPaced
//    animation.tensionValues = [0, -2, 0]      // 尝试调整中间值观察运动轨迹
//    animation.continuityValues = [0, -2, 0]   // 尝试调整中间值观察运动轨迹
    animation.biasValues = [0, -2, 0]   // 尝试调整中间值观察运动轨迹
    animateView.layer.add(animation, forKey: nil)
    
    PlaygroundPage.current.liveView = rootView
}

//: ## CASpringAnimation
//: 相比于 `UIView` 的弹性动画函数，`CASpringAnimation` 提供了更细腻的控制方式, `CASpringAnimation` 提供了 `damping（阻尼）`,`initialVelocity（初始速度）`,`mass（重力）`,`stiffness（刚度）`，相比于 `UIView` 动画多了`重力`及`刚度`的控制，真正的 动画时间 `settlingDuration` 由前面四个参数计算得出。
//: * `damping` [阻尼](https://zh.wikipedia.org/wiki/%E9%98%BB%E5%B0%BC) 越大，物体的震动幅度越小，停止越快，默认为10
//: * `initialVelocity` 初始速度，正值表示物体与弹簧固定点越近，越小物体与弹簧固定点越远，所以初始速度越大震动幅度越大，默认为0
//: * `mass` 物体的质量越大，弹簧做行变越大，运动惯性越大，震动的幅度也就越大，默认为1
//: * `stiffness` 弹簧的刚度越大意味着它受形变影响越小，受压缩产生的力越大，所以物体往返摆动的次数也就越多（如果你需要调整物体来回摆动的次数可以调整该值），默认为100
public class SpringAnimation: UIView {
    let ballView: UIImageView = {
    
        let view = UIImageView(image: UIImage(named: "ball.png"))
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.center = CGPoint(x: 200, y: 50)
        return view
    }()
    
    let lineView = UIView(frame: CGRect(x: 0, y: 300, width: 400, height: 1))
    let animateButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 15, y: 315, width: 0, height: 0))
        button.setTitle("Start Animate", for: .normal)
        button.setTitleColor(UIColor.systemIndigo, for: .normal)
        button.addTarget(self, action: #selector(executeAnimate), for: .touchUpInside)
        button.layer.borderColor = UIColor.systemIndigo.cgColor
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 5.0
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.sizeToFit()
        return button
    }()
    
    func createLabel(with frame: CGRect, title: String) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = title
        label.textColor = UIColor.systemTeal
        return label
    }

    lazy var dampingSlider: UISlider = {
        let label = createLabel(with: CGRect(x: 15, y: self.animateButton.frame.maxY + 20, width: 80, height: 20), title: "damping")
        addSubview(label)
        let slider = UISlider(frame: CGRect(x: 100, y: 0, width: bounds.width - 140, height: 30))
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 10
        slider.center = CGPoint(x: slider.center.x, y: label.center.y)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    lazy var initialVelocitySlider: UISlider = {
        let label = createLabel(with: CGRect(x: 15, y: self.dampingSlider.frame.maxY + 20, width: 80, height: 20), title: "velocity")
               addSubview(label)
        let slider = UISlider(frame: CGRect(x: 100, y: 0, width: bounds.width - 140, height: 30))
        slider.minimumValue = -20
        slider.maximumValue = 40
        slider.value = 0
        slider.center = CGPoint(x: slider.center.x, y: label.center.y)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
   }()
    
    lazy var massSlider: UISlider = {
        let label = createLabel(with: CGRect(x: 15, y: self.initialVelocitySlider.frame.maxY + 20, width: 80, height: 20), title: "mass")
               addSubview(label)
        let slider = UISlider(frame: CGRect(x: 100, y:0 , width: bounds.width - 140, height: 30))
        slider.minimumValue = 1
        slider.maximumValue = 50
        slider.value = 1
        slider.center = CGPoint(x: slider.center.x, y: label.center.y)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
       return slider
    }()
    
    lazy var stiffnessSlider: UISlider = {
        let label = createLabel(with: CGRect(x: 15, y: self.massSlider.frame.maxY + 20, width: 80, height: 20), title: "stiffness")
               addSubview(label)
        let slider = UISlider(frame: CGRect(x: 100, y: 0, width: bounds.width - 140, height: 30))
        slider.minimumValue = 100
        slider.maximumValue = 1000
        slider.value = 100
        slider.center = CGPoint(x: slider.center.x, y: label.center.y)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    
    lazy var dampingLabel: UILabel = {
        let x = self.dampingSlider.frame.maxX
        let label = createLabel(with: CGRect(x: x, y: 0, width: bounds.width - x, height: 20), title: "0")
        label.center = CGPoint(x: label.center.x, y: self.dampingSlider.center.y)
        label.textAlignment = .center
        return label
    }()
    
    lazy var initialVelocityLabel: UILabel = {
       let x = self.initialVelocitySlider.frame.maxX
       let label = createLabel(with: CGRect(x: x, y: 0, width: bounds.width - x, height: 20), title: "0")
       label.center = CGPoint(x: label.center.x, y: self.initialVelocitySlider.center.y)
       label.textAlignment = .center
       return label
   }()
    
    lazy var massLabel: UILabel = {
       let x = self.massSlider.frame.maxX
       let label = createLabel(with: CGRect(x: x, y: 0, width: bounds.width - x, height: 20), title: "0")
       label.center = CGPoint(x: label.center.x, y: self.massSlider.center.y)
       label.textAlignment = .center
       return label
   }()
    
    lazy var stiffLabel: UILabel = {
       let x = self.stiffnessSlider.frame.maxX
       let label = createLabel(with: CGRect(x: x, y: 0, width: bounds.width - x, height: 20), title: "0")
       label.center = CGPoint(x: label.center.x, y: self.stiffnessSlider.center.y)
       label.textAlignment = .center
       return label
   }()
    
    @objc func sliderValueChanged() {
        dampingLabel.text = String(format: "%.1f", dampingSlider.value)
        initialVelocityLabel.text = String(format: "%.1f", initialVelocitySlider.value)
        massLabel.text = String(format: "%.1f", massSlider.value)
        stiffLabel.text = String(format: "%.f", stiffnessSlider.value)
    }
    
    override init(frame: CGRect) {
        let aframe = CGRect(x: 0, y: 0, width: 400, height: 600)
        super.init(frame: aframe)
        backgroundColor = UIColor.white
        lineView.backgroundColor = UIColor.orange
        addSubview(ballView)
        addSubview(lineView)
        addSubview(animateButton)
        addSubview(dampingSlider)
        addSubview(initialVelocitySlider)
        addSubview(massSlider)
        addSubview(stiffnessSlider)
        addSubview(dampingLabel)
        addSubview(initialVelocityLabel)
        addSubview(massLabel)
        addSubview(stiffLabel)
        sliderValueChanged()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc public func executeAnimate()  {
        let animation = CASpringAnimation(keyPath: "position.y")
        animation.fromValue = 50
        animation.toValue = 275
        animation.damping = CGFloat(Float(dampingLabel.text!)!)
        animation.initialVelocity = CGFloat(Float(initialVelocityLabel.text!)!)
        animation.mass = CGFloat(Float(massLabel.text!)!)
        animation.stiffness = CGFloat(Float(stiffLabel.text!)!)
        animation.duration = 3.0
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        ballView.layer.add(animation, forKey: nil)
    }
    
    @objc func tapAction() {
        executeAnimate()
    }
}
PlaygroundPage.current.liveView = SpringAnimation()
//: [Next](@next)

