//: [Previous](@previous)

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//: # CAShapeLayer
//: 在 `iOS` 开发中 `CAShapeLayer` 使用相对与其它图层类来说频率较高的一个类了，使用它可以实现各种丰富的UI效果，同时 `CAShapeLayer` 的相关属性是可动画的，这为开发过程中一些视图的过渡效果提供了极大的方便，接下来我们开始介绍它。

//: ## 什么是形状图层
//: 形状图层是可以将形状定义为矢量的层。因为是基于矢量，所以它们与分辨率无关。在渲染时，`Core Animation` 将创建一个适当大小的位图以匹配设备的屏幕比例，这使形状图层在绘制时看起来总是十分的清晰。
//:
//: 形状图层可以被描边和填充，所描绘的线的属性也可以做很好的调整。在核心动画中，`CAShapeLayer` 的许多属性是可动画的，因此你可以使用它轻松实现引人注目的动画。最重要的是 `CAShapeLayer` 使用 `GPU` 进行渲染，因此非常的快。

//: ## 创建形状图层
//: 形状图层本身很容易创建，它们没有初始化参数。
example {
    let _ = CAShapeLayer()
}
//: 因为 `CAShapeLayer` 是一个矢量图层，所以我们不需要担心它的 `contentScale` 属性。无论这个值是多少，形状图层总会参照设备的主屏幕的缩放比例进行绘制。

//: ### Path
//: `CAShapeLayer` 中的 `path` 属性是它的核心所在。这个属性采用的是 `CGPath`，因此它使用与 `Core Graphics` 相同的路径逻辑.或者，你可以使用 `UIBezierPath` 创建并返回一个 `CGPath`。
//:
//: 但是什么是路径? 您可以将路径视为一束线段或三次贝塞尔曲线，它可以相互连接在一起或者不连接。Apple 的文档对[使用贝塞尔曲线绘制形状](https://developer.apple.com/library/archive/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/BezierPaths/BezierPaths.html#//apple_ref/doc/uid/TP40010156-CH11-SW1)有很好的指导。总而言之我们可以使用它绘制简单或复杂的形状。
//:
//: 这里展示几种图形的绘制:
//:
//: **绘制矩形**
example(CGRect.zero) { rootView in
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.lineWidth = 2.0
    shapeLayer.strokeColor = UIColor.systemPink.cgColor
    shapeLayer.fillColor = nil
    shapeLayer.path = UIBezierPath(rect: shapeLayer.bounds).cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    PlaygroundPage.current.liveView = rootView
}
//: **绘制圆形**
example(CGRect.zero) { rootView in
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.lineWidth = 2.0
    shapeLayer.strokeColor = UIColor.systemPink.cgColor
    shapeLayer.fillColor = nil
    
    let arcCenter = shapeLayer.position
    let radius = shapeLayer.bounds.size.width / 2.0
    let startAnigle = CGFloat(0)
    let endAngle = CGFloat.pi * 2
    let closewise = true
    
    shapeLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAnigle, endAngle: endAngle, clockwise: closewise).cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    PlaygroundPage.current.liveView = rootView
}
//: **绘制五角星**
example(CGRect.zero) { rootView in
    let shapeLayer = CAShapeLayer()
    shapeLayer.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.lineWidth = 2.0
    shapeLayer.strokeColor = UIColor.systemPink.cgColor
    shapeLayer.fillColor = nil
    
    
    shapeLayer.path = createStarPath(shapeLayer.position).cgPath
    
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    PlaygroundPage.current.liveView = rootView
}
//: ### Fill
//: 形状图层可以使用一个颜色来填充它的路径。这里有两个影响填充的属性，`fillColor` 和 [`fillRule`](https://developer.apple.com/documentation/quartzcore/cashapelayer/1522146-fillrule)
//: #### fillColor
//: `fillColor` 就是给路径填充一个颜色，像这样：
example(CGRect.zero) { rootView in
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.lineWidth = 2.0
    shapeLayer.strokeColor = UIColor.systemPink.cgColor
    shapeLayer.fillColor = UIColor.systemBlue.cgColor
    shapeLayer.path = UIBezierPath(rect: shapeLayer.bounds).cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    PlaygroundPage.current.liveView = rootView
}
//: 可能只有很少的人知道 `UIColor` 可以从一张图案图像中创建颜色，这是一种使形状具有一点纹理的好方法。
example(CGRect.zero) { rootView in
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.lineWidth = 2.0
    shapeLayer.strokeColor = UIColor.systemPink.cgColor
    let patternImage = UIImage(named: "pattern.jpg")!
    
    shapeLayer.fillColor = UIColor(patternImage: patternImage).cgColor
    
    let arcCenter = shapeLayer.position
    let radius = shapeLayer.bounds.size.width / 2.0
    let startAnigle = CGFloat(0)
    let endAngle = CGFloat.pi * 2
    let closewise = true
    
    shapeLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAnigle, endAngle: endAngle, clockwise: closewise).cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    PlaygroundPage.current.liveView = rootView
}
//: 对于路径，你可以选择是否封闭路径，之前的例子中我们都是设置其为k封闭的，现在我们将其设置为开放路径，对于没有开放的路径你可以使用填充颜色查看对形状图层的影响。
example(CGRect.zero) { rootView in
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.lineWidth = 2.0
    shapeLayer.strokeColor = UIColor.systemPink.cgColor
    shapeLayer.fillColor = UIColor.systemYellow.cgColor
    
    let arcCenter = shapeLayer.position
    let radius = shapeLayer.bounds.size.width / 2.0
    let startAnigle = CGFloat(0)
    let endAngle = CGFloat.pi   // 开放的路径
    let closewise = false
    
    shapeLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAnigle, endAngle: endAngle, clockwise: closewise).cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    PlaygroundPage.current.liveView = rootView
}

//: #### Fill Rule
//: 填充规则确定了路径如何使用样色填充其区域。填充规则有些技术性，但基本上，在复杂路径中，如果路径的某个区域被另一个区域包围，则这些规则将确定哪些区域被颜色所填充。该[站点](https://www.sitepoint.com/understanding-svg-fill-rule-property/)对这两个规则都有不错的视觉解释，请随时查看。
example(CGRect.zero) { rootView in
    let shapeLayer = CAShapeLayer()

    shapeLayer.frame = CGRect(x: 0.0, y: 0.0, width: 150.0, height: 150.0)
    shapeLayer.lineWidth = 2.0
    shapeLayer.strokeColor = UIColor.systemPink.cgColor
    shapeLayer.fillColor = UIColor.systemTeal.cgColor
    // 使用 nonZero 填充规则
//    shapeLayer.fillRule = .nonZero
    // 使用 evenOdd 填充规则
    shapeLayer.fillRule = .evenOdd
    
    let outerPath = UIBezierPath(rect: shapeLayer.bounds.insetBy(dx: 20, dy: 20))
    let innerPath = UIBezierPath(rect: shapeLayer.bounds.insetBy(dx: 50, dy: 50))

    let shapeLayerPath = UIBezierPath()
    shapeLayerPath.append(outerPath)
    shapeLayerPath.append(innerPath)

    shapeLayer.path = shapeLayerPath.cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    PlaygroundPage.current.liveView = rootView
}

//: ### Line
//: `CAShapeLayer` 有一些与其绘制线条相关的属性：`lineWidth`，`lineJoin`,`meterLimit`,`lineCap`,`lineDashPattern` 和 `lineDashPhase`。
//: #### lineWidth
//: 这很明显就是用来确定描边路径的宽度，需要注意的是线条的宽度会绘制在两侧，你可以想象在路径的中间画一条线。
//: - note: 这与 `CALayer` 的边界绘制原理不同，`CALayer` 对于边界的绘制总是向内侧移动
example(CGRect.zero) { rootView in
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.lineWidth = 12.0  // 修改以查看不同的结果
    shapeLayer.strokeColor = UIColor.systemPink.cgColor
    shapeLayer.fillColor = nil
    shapeLayer.path = UIBezierPath(rect: shapeLayer.bounds).cgPath
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    PlaygroundPage.current.liveView = rootView
}
//: #### lineJoin
//: 形状图层的线连接很容易理解：它确定路径的连接线段具有的形状。`CAShapeLayer` 支持三种不懂连接风格：`miter`，`round` 和 `bevel`
example(CGRect.zero) { rootView in
    let shapeLayer = CAShapeLayer()
    shapeLayer.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
    shapeLayer.lineWidth = 8.0
    shapeLayer.strokeColor = UIColor.systemPink.cgColor
    shapeLayer.fillColor = nil
    shapeLayer.lineJoin = .bevel    // 你可以修改该值运行进行比较

    shapeLayer.path = createStarPath(shapeLayer.position).cgPath
    
    rootView.layer.addSublayer(shapeLayer)
    shapeLayer.position = rootView.layer.position
    PlaygroundPage.current.liveView = rootView
}
//: 在 `lineJoin` 为 `miter` 风格下 `miterLimit` 值不同的显示结果
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
    
    
    let shapeLayer1 = shapeLayerWithdifferentMiter(miter: 2.0, position: CGPoint(x: 60, y: 60))
    shapeLayer1.lineWidth = 10.0
    let shapeLayer2 = shapeLayerWithdifferentMiter(miter: 3.0, position: CGPoint(x: 140, y: 140))
    shapeLayer2.lineWidth = 5.0
    let shapeLayer3 = shapeLayerWithdifferentMiter(miter: 10.0, position: CGPoint(x: 240, y: 240))
    shapeLayer3.lineWidth = 10.0
    
    rootView.layer.addSublayer(shapeLayer1)
    rootView.layer.addSublayer(shapeLayer2)
    rootView.layer.addSublayer(shapeLayer3)
    

    PlaygroundPage.current.liveView = rootView
}

//: #### lineCap
//: `lineCap` 确定了如何绘制**开放**路径的端点, `CAShapeLayer` 中提供了三种风格的样式：butt`,`round` 和 `square`。
example(CGRect.zero) { rootView in
    
    func shapeLayerWithLineCap(lineCap: CAShapeLayerLineCap, position: CGPoint) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 2)
        shapeLayer.lineWidth = 14.0
        shapeLayer.strokeColor = UIColor.systemPink.cgColor
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.lineCap = lineCap
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: shapeLayer.frame.width, y: 0))
    
        let lineLayer = CALayer()
        lineLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 2)
        lineLayer.backgroundColor = UIColor.systemYellow.cgColor
        shapeLayer.addSublayer(lineLayer)
        
        shapeLayer.path = path.cgPath
        shapeLayer.position = position
        return shapeLayer
    }
    
    
    let shapeLayer1 = shapeLayerWithLineCap(lineCap: .butt, position: CGPoint(x: 150, y: 50))
    let shapeLayer2 = shapeLayerWithLineCap(lineCap: .round, position: CGPoint(x: 150, y: 100))
    let shapeLayer3 = shapeLayerWithLineCap(lineCap: .square, position: CGPoint(x: 150, y: 150))
    
    rootView.layer.addSublayer(shapeLayer1)
    rootView.layer.addSublayer(shapeLayer2)
    rootView.layer.addSublayer(shapeLayer3)
    

    PlaygroundPage.current.liveView = rootView
}

//: #### lineDashPattern
//: 虚线模式允许您使形状图层使用任意虚线模式而不是实线绘制其线条。此属性是一个在用户空间中交替排列的长度的数组，这些长度决定了描边多长时间以及不描边多长时间。重复执行该模式，直到到达路径末尾。
example(CGRect.zero) { rootView in
    
     func shapeLayerWithLineDashPattern(lineDashPattern: [NSNumber], position: CGPoint) {
    
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        shapeLayer.lineWidth = 2.0
        shapeLayer.strokeColor = UIColor.systemPink.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineDashPattern = lineDashPattern
        
        let arcCenter = shapeLayer.position
        let radius = shapeLayer.bounds.size.width / 2.0
        let startAnigle = CGFloat(0)
        let endAngle = CGFloat.pi * 2
        let closewise = true
        
        shapeLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAnigle, endAngle: endAngle, clockwise: closewise).cgPath
        shapeLayer.position = position
        rootView.layer.addSublayer(shapeLayer)
    }
    
    shapeLayerWithLineDashPattern(lineDashPattern: [10, 5, 20, 5], position: CGPoint(x: 120, y: 120))
    shapeLayerWithLineDashPattern(lineDashPattern: [5, 3], position: CGPoint(x: 250, y: 120))
    shapeLayerWithLineDashPattern(lineDashPattern: [1], position: CGPoint(x: 120, y: 250))
    shapeLayerWithLineDashPattern(lineDashPattern: [40], position: CGPoint(x: 250, y: 250))
    
    PlaygroundPage.current.liveView = rootView
}
//: 在示例中第一个值为 `[10, 5, 20, 5]` ，首先它会绘制10个点的长度然后空5个点的长度再绘制20个点的长度再空5个点的长度，以此为循环重复绘制得到。第二个图形亦是如此。第三第四个图形都只提供了一个值，那么它会以相同的长度绘制空白部分，例如 `lineDashPattern` 为 `[1]` 图层中，首先绘制1个点的长度再空1个点以此为循环进行绘制。

//: #### lineDashPhase
//: `lineDashPhase` 是一个偏移数值，它指定 `lineDashPattern` 中第一个值相对于开始位置的偏移出开始绘制。
example(CGRect.zero) { rootView in
    
     func shapeLayerWithLineDashPhase(lineDashPhase: CGFloat, position: CGPoint) {
    
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        shapeLayer.lineWidth = 2.0
        shapeLayer.strokeColor = UIColor.systemPink.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineDashPattern = [40]
        shapeLayer.lineDashPhase = lineDashPhase
        let arcCenter = shapeLayer.position
        let radius = shapeLayer.bounds.size.width / 2.0
        let startAnigle = CGFloat(0)
        let endAngle = CGFloat.pi * 2
        let closewise = true
        
        shapeLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAnigle, endAngle: endAngle, clockwise: closewise).cgPath
        shapeLayer.position = position
        rootView.layer.addSublayer(shapeLayer)
    }
    
    shapeLayerWithLineDashPhase(lineDashPhase: 0, position: CGPoint(x: 120, y: 120))
    shapeLayerWithLineDashPhase(lineDashPhase: 10, position: CGPoint(x: 250, y: 120))
    shapeLayerWithLineDashPhase(lineDashPhase: -20, position: CGPoint(x: 120, y: 250))
    
    PlaygroundPage.current.liveView = rootView
}
