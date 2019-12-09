import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//: # UIBezierPath
//: 在 `CAShapeLayer` 中 `strokeStart` 、 `strokeEnd` 与 `path` 是可动画属性。通过 `UIBezierPath` 我们绘制出我们所需要的 `path`，最终通过可动画属性实现我们所需要的动画。下面的示例中实现了环形动画的默认样式：
example(CGRect.zero) { rootView in
     let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        layer.lineWidth = 5.0
        layer.strokeColor = UIColor.systemRed.cgColor;
        layer.fillColor = nil
        return layer
    }()
    rootView.layer.addSublayer(shapeLayer)
    
    let arcCenter = rootView.layer.position
    let radius: CGFloat = 100.0
    let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
    shapeLayer.path = path.cgPath
    
    func executeAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.5
        animation.fillMode = .forwards
        animation.repeatCount = .infinity
        animation.autoreverses = true
        shapeLayer.add(animation, forKey: nil)
    }
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        executeAnimation()
    }
    PlaygroundPage.current.liveView = rootView

}

//: ## init(arcCenter:radius:startAngle:endAngle:clockwise:)
//: 通过 `UIBezierPath` 的 `init(arcCenter:radius:startAngle:endAngle:clockwise:)` 方法很轻易的绘制出一个圆，其中 `arcCenter` 参数表示圆环中心点的坐标，`radius` 为圆环的半径，`clockwise` 表示路径绘制的方向（false 为逆时针，true 为顺时针），`startAngle` 、`endAngle` 表示圆的弧度起点位置与终点位置，你可以在下面看到官方给出的示例图：
//:
//: ![](bezierPath.jpg)
//:
//: 默认的（0，2π）对应的是起点与终点位置，他们是重合的点。这也解释了之前的示例动画中，动画开始于0的位置。

//: ## 控制路径的起点与终点
//: 虽然 `UIBezierPath` 中的起点与终点都是在3点钟的位置，但这不是不可改变的，我们可以根据需要对起点与终点的位置进行调整。
//:
//: 对于如何控制起点与终点你应该理解下面几点
//:
//: 1. `endAngle` 的值应该参照顺时针或者逆时针的方向进行增加或减少。具体来说，如果是顺时针且你希望沿着顺时针方向增加弧长那么 `endAngle` 值应该在当前值的基础上做加法呈递增趋势，反之如果你希望减小弧长那么应该在当前 `endAngle` 的值基础上做减法呈递减趋势。同理如果是逆时针，那么如果你希望增加弧长那么 `endAngle` 沿着逆时针的方向上做加法呈递增趋势否则做反方向的减法呈递减趋势。
//: 2. `startAngle` 与 `endAngle` 在两种情况下会重合，第一种情况是 `endAngle` 减去 `startAngle` 的值 等于0，此时圆环只是一个点，你不会看到什么东西。第二种情况是 `endAngle` 的值减去 `startAngle` 的绝对值等于2π，此时你可以看到完整的一个圆环。
//: 3. 基于以上两点整体弧长计算方式为 `endAngle` 的值减去 `startAngle` 的值，这个值等于0那就是一个点，这个值等于2π那就是一个圆。

//: 现在我们设定所要绘制的圆弧起点位于π的位置，并沿顺时针方向绘制半弧（也就是对应0的位置。那么需要设置 `clockWise` 值为 true, `startAngle` 值为π，`endAngle` 值为2π。
//: - note: 注意动画是呈逐渐消失效果还是逐渐显示效果取决于是对 `CAShapeLayer` 的 `strokeStart` 属性做动画还是 `strokeEnd` 属性做动画。如果是 `strokeStart` 那么动画呈逐渐消失效果，如果是 `strokeEnd` 则动画呈逐渐显示效果
example(CGRect.zero) { rootView in
     let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        layer.lineWidth = 5.0
        layer.strokeColor = UIColor.systemRed.cgColor;
        layer.fillColor = nil
        return layer
    }()
    rootView.layer.addSublayer(shapeLayer)
    
    let arcCenter = rootView.layer.position
    let radius: CGFloat = 100.0
    let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: true)    // 顺时针
    shapeLayer.path = path.cgPath
    
    func executeAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")  // 可以缓冲 strokeStart 查看效果
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.5
        animation.fillMode = .forwards
        animation.repeatCount = .infinity
        shapeLayer.add(animation, forKey: nil)
    }
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        executeAnimation()
    }
    PlaygroundPage.current.liveView = rootView

}

// 如果调整 `clockWise` 为 false 逆时针方向，那么动画将以逆时针的趋势进行从 `startAngle` 位置绘制到 `endAngle` 的位置
example(CGRect.zero) { rootView in
     let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        layer.lineWidth = 5.0
        layer.strokeColor = UIColor.systemRed.cgColor;
        layer.fillColor = nil
        return layer
    }()
    rootView.layer.addSublayer(shapeLayer)
    
    let arcCenter = rootView.layer.position
    let radius: CGFloat = 100.0
    let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: false)    // 逆时针
    shapeLayer.path = path.cgPath
    
    func executeAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")  // 可以缓冲 strokeStart 查看效果
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.5
        animation.fillMode = .forwards
        animation.repeatCount = .infinity
        shapeLayer.add(animation, forKey: nil)
    }
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        executeAnimation()
    }
    PlaygroundPage.current.liveView = rootView

}

//: 你可以自己控制相关参数并运行查看效果
class BezierPathView: UIView {
    lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 20, width: 200, height: 200)
        layer.lineWidth = 5.0
        layer.strokeColor = UIColor.systemRed.cgColor;
        layer.fillColor = nil
        return layer
    }()
    
    lazy var startAngleSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = -Float.pi * 2.0
        slider.maximumValue = Float.pi * 2.0
        slider.value = 0
        slider.addTarget(self, action: #selector(angleChanged), for: .valueChanged)
        return slider
    }()
    
    lazy var endAngleSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = -Float.pi * 2.0
        slider.maximumValue = Float.pi * 2.0
        slider.value = Float.pi * 2
        slider.addTarget(self, action: #selector(angleChanged), for: .valueChanged)
        return slider
    }()
    
    lazy var shapePath: UIBezierPath = {
        return createPath(startAngle: 0, endAngle: CGFloat.pi * 2)
    }()
    
    lazy var animateButton: UIButton = {
        let button = UIButton()
        button.setTitle("start", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(executeAnimation), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        backgroundColor = UIColor.white
        shapeLayer.path = shapePath.cgPath
        layer.addSublayer(shapeLayer)
        startAngleSlider.frame = CGRect(x: 20, y: shapeLayer.frame.maxY + 30, width: bounds.width - 40, height: 20)
        endAngleSlider.frame = CGRect(x: 20, y: startAngleSlider.frame.maxY + 30, width: bounds.width - 40, height: 20)
        animateButton.frame = CGRect(x: 50, y: endAngleSlider.frame.maxY + 20, width: 50, height: 35)
        addSubview(startAngleSlider)
        addSubview(endAngleSlider)
        addSubview(animateButton)
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func executeAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.5
        animation.fillMode = .forwards
        shapeLayer.add(animation, forKey: nil)
    }
    
    @objc func angleChanged() {
        let path = createPath(startAngle: CGFloat(startAngleSlider.value), endAngle: CGFloat(endAngleSlider.value))
        shapeLayer.path = path.cgPath
    }

    
    func createPath(startAngle: CGFloat, endAngle: CGFloat) -> UIBezierPath {
        var arcCenter = layer.position
       arcCenter.y -= 100
       let radius: CGFloat = 100.0
       let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
       return path
    }
    
}

PlaygroundPage.current.liveView = BezierPathView()
