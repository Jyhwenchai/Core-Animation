import UIKit
import PlaygroundSupport


//: # CAShapeLayer
//: 在[CAShapeLayer深入第一部分](CAShapeLayer%20in%20Depth%20Part%20I)，我们探讨了如何创建和配置 `CAShapeLayer`，查看并了解了它的属性。在这篇文章中我们将使用它的可动画属性来做一些引人注目的动画。
//: * Animatable Properties
//:     * Path
//:     * Fill Color
//:     * Line Dash Phase
//:     * Line Width
//:     * Miter Limit
//:     * Stroke Color
//:     * Stroke Start and End

//: ## 可动画属性
//: `CAShapeLayer` 中有一半以上的属性是可动画的：`path`，`fillColor`，`lineDashPhase`，`lineWidth`，`miterLimit`，`strokeColor`，`strokeStart` 和 `strokeEnd`。

//: ### Path
//: 路径动画是 `CAShapeLayer` 最强大，最复杂的方面。路径动画可以使图层从一个形状渐变到另一个形状。使用得当，你可以创建出非常好的 UI 效果。`CAShapeLayer` 对于 `path` 属性上的动画有以下说法：
//: - note: Paths will interpolate as a linear blend of the “on-line” points; “off-line” points may be interpolated non-linearly (e.g. to preserve continuity of the curve’s derivative).
//:
//: 这就是说，“on-line” 的点（在路径描述中明确指定的点）是通过将直线从其起始位置移动到终点而进行插值的。可能使用更复杂的手段对 “off-line” 的点（即在 “on-line” 的点之间计算或推断为插值点的点）进行插值，但我们无法提供其详细信息。
example(CGRect.zero) { rootView in
    func startPath() -> UIBezierPath {
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 81.5, y: 7.0))
        starPath.addLine(to: CGPoint(x: 101.07, y: 63.86))
        starPath.addLine(to: CGPoint(x: 163.0, y: 64.29))
        starPath.addLine(to: CGPoint(x: 113.16, y: 99.87))
        starPath.addLine(to: CGPoint(x: 131.87, y: 157.0))
        starPath.addLine(to: CGPoint(x: 81.5, y: 122.13))
        starPath.addLine(to: CGPoint(x: 31.13, y: 157.0))
        starPath.addLine(to: CGPoint(x: 49.84, y: 99.87))
        starPath.addLine(to: CGPoint(x: 0.0, y: 64.29))
        starPath.addLine(to: CGPoint(x: 61.93, y: 63.86))
        starPath.addLine(to: CGPoint(x: 81.5, y: 7.0))
        return starPath
    }
    
    func endPath() -> UIBezierPath {
        let rectanglePath = UIBezierPath()
        rectanglePath.move(to: CGPoint(x: 81.5, y: 7.0))
        rectanglePath.addLine(to: CGPoint(x: 163.0, y: 7.0))
        rectanglePath.addLine(to: CGPoint(x: 163.0, y: 82.0))
        rectanglePath.addLine(to: CGPoint(x: 163.0, y: 157.0))
        rectanglePath.addLine(to: CGPoint(x: 163.0, y: 157.0))
        rectanglePath.addLine(to: CGPoint(x: 82.0, y: 157.0))
        rectanglePath.addLine(to: CGPoint(x: 0.0, y: 157.0))
        rectanglePath.addLine(to: CGPoint(x: 0.0, y: 157.0))
        rectanglePath.addLine(to: CGPoint(x: 0.0, y: 82.0))
        rectanglePath.addLine(to: CGPoint(x: 0.0, y: 7.0))
        rectanglePath.addLine(to: CGPoint(x: 81.5, y: 7.0))
        return rectanglePath
    }
    
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.lineWidth = 2.0
    shapeLayer.strokeColor = UIColor.systemPink.cgColor
    shapeLayer.fillColor = nil
    shapeLayer.path = startPath().cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    
    func executeAniamte() {
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = endPath().cgPath
        pathAnimation.duration = 0.75
        pathAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pathAnimation.autoreverses = true
        pathAnimation.repeatCount = .infinity
        
        shapeLayer.add(pathAnimation, forKey: nil)
    }

    executeAniamte()
    PlaygroundPage.current.liveView = rootView
}

//: 很明显，动画本身是微不足道的：它需要的是另一个 `CGPath` 进行动画处理。困难的部分是构建正确的路径，以使动画看起来吸引人。现在考虑简化矩形路径时会发生什么。毕竟，矩形可以很容易地由只有四个唯一点的路径表示:
example(CGRect.zero) { rootView in
    func startPath() -> UIBezierPath {
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 81.5, y: 7.0))
        starPath.addLine(to: CGPoint(x: 101.07, y: 63.86))
        starPath.addLine(to: CGPoint(x: 163.0, y: 64.29))
        starPath.addLine(to: CGPoint(x: 113.16, y: 99.87))
        starPath.addLine(to: CGPoint(x: 131.87, y: 157.0))
        starPath.addLine(to: CGPoint(x: 81.5, y: 122.13))
        starPath.addLine(to: CGPoint(x: 31.13, y: 157.0))
        starPath.addLine(to: CGPoint(x: 49.84, y: 99.87))
        starPath.addLine(to: CGPoint(x: 0.0, y: 64.29))
        starPath.addLine(to: CGPoint(x: 61.93, y: 63.86))
        starPath.addLine(to: CGPoint(x: 81.5, y: 7.0))
        return starPath
    }
    
    func endPath() -> UIBezierPath {
        let squarePath = UIBezierPath()
        squarePath.move(to: CGPoint(x: 0.0, y: 7.0))
        squarePath.addLine(to: CGPoint(x: 163.0, y: 7.0))
        squarePath.addLine(to: CGPoint(x: 163.0, y: 157.0))
        squarePath.addLine(to: CGPoint(x: 0.0, y: 157.0))
        squarePath.addLine(to: CGPoint(x: 0.0, y: 7.0))
        return squarePath
    }
    
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.lineWidth = 2.0
    shapeLayer.strokeColor = UIColor.systemPink.cgColor
    shapeLayer.fillColor = nil
    shapeLayer.path = startPath().cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    
    func executeAniamte() {
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = endPath().cgPath
        pathAnimation.duration = 0.75
        pathAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pathAnimation.autoreverses = true
        pathAnimation.repeatCount = .infinity
        
        shapeLayer.add(pathAnimation, forKey: nil)
    }

    executeAniamte()
    PlaygroundPage.current.liveView = rootView
}
//: 这样的动画大多不是我们所期待的，根据 `CAShapeLayer` 的 `path` 属性的文档，如果要动画化的路径具有不同数量的控制点或线段，则路径动画的结果不确定。在这种情况下，动画路径的线段较少，因此 `Core Animation` 实际上不知道如何处理原始路径中的其余线段。所以根据一般经验，你应该设置动画路径与原始路径始终包含相同数量的点。

//: ### Fill Color
//: 对 `CAShapeLayer` 填充颜色进行动画非常的简单，你只需要改变动画颜色即可。
example(CGRect.zero) { rootView in
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.strokeColor = nil
    shapeLayer.fillColor = UIColor.red.cgColor
    
    let arcCenter = shapeLayer.position
    let radius = shapeLayer.bounds.size.width / 2.0
    let startAnigle = CGFloat(0)
    let endAngle = CGFloat.pi * 2
    let closewise = true
    
    shapeLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAnigle, endAngle: endAngle, clockwise: closewise).cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    
    func executeAnimate() {
        let animation = CABasicAnimation(keyPath: "fillColor")
        animation.toValue = UIColor.cyan.cgColor
        animation.duration = 1.75
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        shapeLayer.add(animation, forKey: nil)
    }
    
    executeAnimate()
    
    PlaygroundPage.current.liveView = rootView
}

//: ### Line Dash Phase
//: 你可以利用 `lineDashPattern` 与 `dashPhase` 配合实现”行军蚁“的效果
example(CGRect.zero) { rootView in
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.strokeColor = UIColor.red.cgColor
    shapeLayer.lineWidth = 5.0
    shapeLayer.lineDashPattern = [5]
    shapeLayer.fillColor = nil
    
    let arcCenter = shapeLayer.position
    let radius = shapeLayer.bounds.size.width / 2.0
    let startAnigle = CGFloat(0)
    let endAngle = CGFloat.pi * 2
    let closewise = true
    
    shapeLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAnigle, endAngle: endAngle, clockwise: closewise).cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    
    func executeAnimate() {
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.byValue = 10.0
        animation.duration = 0.75
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.repeatCount = .infinity
        shapeLayer.add(animation, forKey: nil)
    }
    
    executeAnimate()
    
    PlaygroundPage.current.liveView = rootView
}
//: 为了确保虚线动画循环正常，如果 `dashPattern` 中只有一个元素，则动画值应该是 `dashPattern` 中的值的两倍，否则为元素之和。
example(CGRect.zero) { rootView in
    
    let dashPattern: [NSNumber] = [NSNumber(5), NSNumber(4), NSNumber(3), NSNumber(2)]
    let dashPhase = dashPattern.map{$0.floatValue}.reduce(0, +)
    
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.strokeColor = UIColor.red.cgColor
    shapeLayer.lineWidth = 5.0
    shapeLayer.lineDashPattern = dashPattern
    shapeLayer.fillColor = nil
    
    let arcCenter = shapeLayer.position
    let radius = shapeLayer.bounds.size.width / 2.0
    let startAnigle = CGFloat(0)
    let endAngle = CGFloat.pi * 2
    let closewise = true
    
    shapeLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAnigle, endAngle: endAngle, clockwise: closewise).cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    
    func executeAnimate() {
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.byValue = dashPhase
        animation.duration = 0.75
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.repeatCount = .infinity
        shapeLayer.add(animation, forKey: nil)
    }
    
    executeAnimate()
    
    PlaygroundPage.current.liveView = rootView
}
//: ### Line Width
//: `lineWidth` 是另外一个简单的动画属性：
example(CGRect.zero) { rootView in
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.strokeColor = UIColor.red.cgColor
    shapeLayer.lineWidth = 0.0
    shapeLayer.fillColor = nil
    
    let arcCenter = shapeLayer.position
    let radius = shapeLayer.bounds.size.width / 2.0
    let startAnigle = CGFloat(0)
    let endAngle = CGFloat.pi * 2
    let closewise = true
    
    shapeLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAnigle, endAngle: endAngle, clockwise: closewise).cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    
    func executeAnimate() {
        let animation = CABasicAnimation(keyPath: "lineWidth")
        animation.byValue = 10.0
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.repeatCount = .infinity
        animation.autoreverses = true
        shapeLayer.add(animation, forKey: nil)
    }
    
    executeAnimate()
    
    PlaygroundPage.current.liveView = rootView
}
//: ### Miter Limit
//: 在所有可动画属性中 `miterLimit` 是最令人困惑的。虽然文档中把它标志为可动画的属性，当似乎当我们以动画的方式改变他的值时并不会呈现良好的动画效果，而是立刻的发生变化。
example(CGRect(x: 0, y: 0, width: 400, height: 400)) { rootView in
    
    func shapeLayerWithdifferentMiter(miter: CGFloat, position: CGPoint) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        shapeLayer.lineWidth = 8.0
        shapeLayer.strokeColor = UIColor.systemPink.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineJoin = .miter
        shapeLayer.miterLimit = miter
        shapeLayer.path = createStarPath(shapeLayer.position).cgPath
        shapeLayer.position = position
        return shapeLayer
    }
    
    
    let shapeLayer = shapeLayerWithdifferentMiter(miter: 10.0, position: CGPoint(x: 60, y: 60))
    shapeLayer.position = rootView.layer.position
    rootView.layer.addSublayer(shapeLayer)
    
    func executeAnimate() {
        let animation = CABasicAnimation(keyPath: "miterLimit")
        animation.toValue = 0
        animation.duration = 1.75
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.repeatCount = .infinity
        animation.autoreverses = true
        shapeLayer.add(animation, forKey: nil)
    }
    
    executeAnimate()

    PlaygroundPage.current.liveView = rootView
}
//: ### Stroke Color
//: 类似于 `fillColor`，`strokeColor` 的动画实现很简单：
example(CGRect.zero) { rootView in
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.strokeColor = UIColor.red.cgColor
    shapeLayer.lineWidth = 5.0
    shapeLayer.fillColor = nil
    
    let arcCenter = shapeLayer.position
    let radius = shapeLayer.bounds.size.width / 2.0
    let startAnigle = CGFloat(0)
    let endAngle = CGFloat.pi * 2
    let closewise = true
    
    shapeLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAnigle, endAngle: endAngle, clockwise: closewise).cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    
    func executeAnimate() {
        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.toValue = UIColor.blue.cgColor
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.repeatCount = .infinity
        animation.autoreverses = true
        shapeLayer.add(animation, forKey: nil)
    }
    
    executeAnimate()
    
    PlaygroundPage.current.liveView = rootView
}

//: Stroke Start and End
//: 一对非常有用的可动画属性：`strokeStart` 和 `strokeEnd`。两者都表示沿总路径长度的相对点，定义为0.0到1.0之间的分数，其中0.0表示路径的起点，而1.0表示路径的终点。路径的可见部分始终是 `strokeEnd` 和 `strokeStart` 之间的差值。
//:
//: 从0.0到1.0对 `strokeEnd` 进行动画处理通常用于“绘制”路径：
example(CGRect.zero) { rootView in
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.strokeColor = UIColor.red.cgColor
    shapeLayer.strokeEnd = 0.0
    shapeLayer.lineWidth = 2.0
    shapeLayer.fillColor = nil
    
    let arcCenter = shapeLayer.position
    let radius = shapeLayer.bounds.size.width / 2.0
    let startAnigle = CGFloat(0)
    let endAngle = CGFloat.pi * 2
    let closewise = true
    
    shapeLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAnigle, endAngle: endAngle, clockwise: closewise).cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    
    func executeAnimate() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1.0
        animation.duration = 0.75
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.repeatCount = .infinity
        animation.autoreverses = true
        shapeLayer.add(animation, forKey: nil)
    }
    
    executeAnimate()
    
    PlaygroundPage.current.liveView = rootView
}
//: 相反，从0.0到1.0的动画 `strokeStart` 通常用于“擦除”路径：
example(CGRect.zero) { rootView in
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.strokeColor = UIColor.red.cgColor
    shapeLayer.strokeStart = 0.0
    shapeLayer.strokeEnd = 1.0
    shapeLayer.lineWidth = 2.0
    shapeLayer.fillColor = nil
    
    let arcCenter = shapeLayer.position
    let radius = shapeLayer.bounds.size.width / 2.0
    let startAnigle = CGFloat(0)
    let endAngle = CGFloat.pi * 2
    let closewise = true
    
    let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAnigle, endAngle: endAngle, clockwise: closewise)
    shapeLayer.path = path.cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    
    func executeAnimate() {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.toValue = 1.0
        animation.duration = 0.75
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.repeatCount = .infinity
        animation.autoreverses = true
        shapeLayer.add(animation, forKey: nil)
    }
    
    executeAnimate()
    
    PlaygroundPage.current.liveView = rootView
}

//: ## 原文链接
//: [CAShapeLayer in Depth, Part II](https://www.calayer.com/core-animation/2017/12/25/cashapelayer-in-depth-part-ii.html)
