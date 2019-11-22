//: [Previous](@previous)

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//: ## CALayer
//: 在开始说明 `Core Animation` 中的相关动画前我们需要对 `CALayer` 有些了解。可以说使用核心动画作用的对象是 `CALayer` 的相关属性，如果你有查看 `CALayer` 的相关属性列表，你可以看到绝大多数的属性都带有 `Animatable` 的备注，这说明这些属性都是可动画的，你可以这个[列表](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatableProperties/AnimatableProperties.html#//apple_ref/doc/uid/TP40004514-CH11-SW1)中查看所有可动画属性。

//: ### Frame & Bounds & AnchorPoint & Position
//: 在开始实现动画一些动画前我们来对 `CALayer` 的 `frame`、`bounds` 、`anchorPoint`、 `position` 这几个属性进行说明。
//: * `bounds` 属性相对于图层本身的坐标系统，它确定图层本身的坐标以及自身的大小。
//: * `position` 属性是相对于其父图层坐标系统上的位置，修改值会改变图层在父图层中的位置
//: * `frame` 属性很多开发者会简单的将其看成是相对于父坐标系统上的位置，这就和 `position` 类似了，实际上 `frame` 是由根据 `bounds` 与 `position` 两者衍生出来的属性，它会受旋转、缩放等操作的影响，所以当你对图层进行了一些旋转、缩放等行为之后你不能依据 `frame` 来确定图层的大小，而是应该使用 `bounds` 与 `position` 获取大小和位置信息。
//: * `anchorPoint` 属性你可以将其看成是一个支点，所有的旋转、缩放等行为都是围绕这个点进行的操作。
//:
//: 有一点需要知道的是 `position` 始终指向 `anchorPoint` 的位置，当你调整 `anchorPoint` 的值时，此时图层的位置将发生变化，`position` 与 `anchorPoint` 将不再同一个位置，这时候为了保持 `position` 指向 `anchorPoint` 的位置你需要调整 `position` 的值。可以观察下面示图中图层相关信息（你可以只关注左半部分的内容）：
//:
//:
//: ![](layer_coords_anchorpoint_position_2x.png)
//:
//:
//: 示图中 `anchorPoint` 初始默认值为（0.5，0.5）位于图层的中心，此时对应的 `position` 的值为（100，100）, 在下一张中调整 `anchorPoint` 值为（0，0）, 此时如果你不调整 `position` 的值那么图层将往右下角移动，因为这样 `anchorPoint` 才会与 `position` 在一个位置。所以当在示图中为了保持图层相对于父视图的位置不变，当 `anchorPoint` 的值为（0，0）时，你需要修改 `position` 的值为（40，60）, 保持两者指向相同的位置。
//:
//:
//: **你可以下面的公式来计算调整 `anchorPoint` 后图层相对父视图的位置以及如何调整以保持相对父视图的位置保持不变**
//:
//: #### 调整 `anchorPoint` 后图层相对父视图的位置
//: `new.origin.x = origin.x - (new.anchorPoint.x - 0.5) * width`, 其中 `origin.x` 表示图层相对于父图层的初始位置，`new.origin.x` 为调整 `anchorPoint x` 后的新位置
//: #### 如果你需要保持调整前后相对于父视图位置不变
//: `new.position.x = position.x + (new.anchorPoint.x - 0.5) * width` 或者是 `new.position.x = position.x + origin.x - new.origin.x`
//:
//: - note: 你也可以通过这个[示例代码](https://github.com/Jyhwenchai/Core-Animation-Example/AnchorPoint&Position)来观察它们之间的关系

//: ### Animation
//: 首先我们来看下动画相关类的继承关系图，在最顶层分别是 `CAAction` 与 `CAMediaTiming` 两个协议, `CAAction` 在后续的文章中会有进一步的说明，这里先不做讨论。`CAMediaTiming` 协议包含了动画运动相关的参数，包括动画的开始时间、重复次数、动画的执行时长、动画的速度等等。`CAAnimation` 作为所有动画类的抽象基类，它遵循` CAAction` 与 `CAMediaTiming` 协议并为具体的动画类 提供了一些通用的操作方法，例如动画的代理（`CAAnimationDelegate`）与 动画运动节奏相关属性（`CAMediaTimingFunction`）等。这两个协议 `CAAnimation` 类包含了所有实际做动画类提供了所需要的绝大多数数的信息。
//:
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

//: #### CAPropertyAnimation
//: `CAPropertyAnimation` 类本身也是一个抽象类，它本身也无法实现一个具体动画。它为其子类提供了几个属性：
//: * cumulative - 下一次动画执行是否从前一个动画结束位置开始，默认为false
//: * additive - 多个动画的效果是否可以叠加，默认值为false
//: * valueFunction - 它只对 `CATransform3D` 的变换有效（如：rotateX、rotateY、rotateZ、scale、scaleX、scaleY、scaleZ、translate、translateX、translateY、translateZ）

//: #### CABasicAnimation
//: 从 `CABasicAnimation` 开始我们可以使用它产生真正动画对象，并作用于一个图层（`CALayer`）上。再一次你可以[这里](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatableProperties/AnimatableProperties.html#//apple_ref/doc/uid/TP40004514-CH11-SW1)查看所有可动画属性。接下来将演示一些简单的动画效果

example(CGRect.zero) { rootView in
    let animateView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    animateView.backgroundColor = UIColor.systemPink
    rootView.addSubview(animateView)
    
    let animation = CABasicAnimation(keyPath: "position.x")
    animation.fromValue = animateView.layer.position.x
    animation.toValue = 250
    animation.duration = 1.5
    animateView.layer.add(animation, forKey: nil)
    
    PlaygroundPage.current.liveView = rootView
}

//: 运行动画前要说明用到的几个动画属性
//:
//: * `fromValue` 表示动画开始前的初始位置，也就是从哪个位置开始进行动画
//: * `toValue` 指定动画结束的位置
//: * `byValue` 指定动画在 `fromValue` 基础上偏移的值，也就是说 `byValue = toValue - fromValue`
//: * `duration` 指定动画执行时长
//:
//: 最终运行后你可以看到 `animateView` 向有移动了一段距离，但是在动画结束之后又回到了开始的位置，这是因为虽然你为 `CALayer` 提供了动画，但是动画的结果并不就代表你最终所要展示的结果，所以你如果确定动画完成后的位置就是你最终的位置，那么你应该在动画完成后更新到指定位置。
public class AnimateExample01: UIView, CAAnimationDelegate {
    
    let animateView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override init(frame: CGRect) {
        let aframe = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aframe)
        backgroundColor = UIColor.white
        animateView.backgroundColor = UIColor.systemPink
        animateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        addSubview(animateView)
        executeAnimate()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func executeAnimate()  {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = animateView.layer.position.x
        animation.toValue = 250
        animation.duration = 1.5
        animation.delegate = self
//        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animateView.layer.add(animation, forKey: nil)
    }
 
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        animateView.layer.position = CGPoint(x: 250, y: 25)
      }
    
    @objc func tapAction() {
        print(animateView)
    }
}

PlaygroundPage.current.liveView = AnimateExample01()
//: 之前的示例中通过设置 `animation.delegate = self` 使在动画结束的代理方法 `animationDidStop(::)` 中更新视图到正确的位置，同时也可以看到使用了两个新的属性 `isRemovedOnCompletion` 与 `fillMode`, 如果你不在代理方法中更新最终的位置而设置`isRemovedOnCompletion` 与 `fillMode`属性为示例中的值，那么你也可以看到在动画完成后不会再回到最开始的位置，但是需要知道的是这并不表明视图真正的位置就在那里了，你可以通过点击视图来验证这一点。
//: * `isRemovedOnCompletion` - 动画完成后是否移除该动画, 默认为true
//: * `fillMode` - 动画的填充模式决定了动画再非激活状态下的表现
//:     - `removed` 在动画在完成之后将被移除, 默认
//:     - `forwards` 在动画完成后将保留动画最后的状态
//:     - `backwords` 在动画开始前，动画图层将处于设定的初始位置，也就是 `fromValue` 对应的值
//:     - `both` 是 `forwards` 与 `backwords` 的结合，在动画开始前的表现与 `backwords` 相同，动画完成后的表现与 `forwords` 相同，你可以修改下面示例代码中 `fillMode` 为 `both` 并且 `isRemovedOnCompletion` 为 `false` 来观察动画的表现
example(CGRect.zero) { rootView in
    let animateView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    animateView.backgroundColor = UIColor.systemPink
    rootView.addSubview(animateView)
    
    let animation = CABasicAnimation(keyPath: "position.x")
    animation.beginTime = CACurrentMediaTime() + 3 // 后面有说明
    animation.fromValue = 100
    animation.toValue = 250
    animation.duration = 1.5
    animation.fillMode = .backwards
//    animation.fillMode = .both
    animation.isRemovedOnCompletion = false
    animateView.layer.add(animation, forKey: nil)
    
    PlaygroundPage.current.liveView = rootView
}

//: * `beginTime` 指定动画相对于父图层的开始时间，你可以使用此做延迟动画,默认为0动画将立刻开始
//: * `timeOffset` 与 `beginTime` 类似，但是它只是将动画快进到偏移的时间点然后继续动画，例如，1秒的动画你设置 `timeOffset` 为0.5，那么动画将从 0.5 秒的位置开始动画，且动画时间还是1秒
example(CGRect.zero) { rootView in
    let animateView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    animateView.backgroundColor = UIColor.systemPink
    rootView.addSubview(animateView)
    
    let animation = CABasicAnimation(keyPath: "position.x")
    animation.timeOffset = 0.5
    animation.fromValue = animateView.layer.position.x
    animation.toValue = 250
    animation.duration = 1
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    animateView.layer.add(animation, forKey: nil)
    
    PlaygroundPage.current.liveView = rootView
}
//: * `speed` 可以加快时间的速度，如果你设置为2.0 `duration` 为1.0，那么时间动画完成的时间为 `duration/speed`, 也就是说0.5秒就完成了动画，它的默认为1.0
example(CGRect.zero) { rootView in
    let animateView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    animateView.backgroundColor = UIColor.systemPink
    rootView.addSubview(animateView)
    
    let animation = CABasicAnimation(keyPath: "position.x")
    animation.fromValue = animateView.layer.position.x
    animation.toValue = 250
    animation.duration = 1
    animation.speed = 2.0
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
    animateView.layer.add(animation, forKey: nil)
    PlaygroundPage.current.liveView = rootView
}

//: `CAAnimation` 中有一个属性为 `timingFunction`, 它可以使你的动画表现更加平滑自然，我们可以称其为`缓冲效果`，你可以在[这里](https://zsisme.gitbooks.io/ios-/content/chapter10/animation-velocity.html)看到对 `timingFunction` 的详细介绍。
//:
//: 系统提供了5个 `timingFunction` 值来影响动画的缓冲效果，当然你也可以自定义自己的缓冲函数 `CAMediaTimingFunction(controlPoints:)`, 缓冲函数有四个参数，分别对应着两个控制点（controlPoints: x1, y1, x2, y2）,你可以通过调整这四个参数值来实现不同的缓冲效果。你可以在[这里](https://zsisme.gitbooks.io/ios-/content/chapter10/custom-easing-functions.html)进一步的了解缓冲函数相关的知识。
example(CGRect.zero) { rootView in
    let animateView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    animateView.backgroundColor = UIColor.systemPink
    rootView.addSubview(animateView)
    
    let animation = CABasicAnimation(keyPath: "position.x")
    animation.fromValue = animateView.layer.position.x
    animation.toValue = 250
    animation.duration = 2
    animation.speed = 2.0
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    animation.timingFunction = CAMediaTimingFunction(controlPoints: 1, 0, 0.75, 1)
//    animation.timingFunction = CAMediaTimingFunction(name: .default)    // 系统自带的缓冲效果
    animateView.layer.add(animation, forKey: nil)
    PlaygroundPage.current.liveView = rootView
}

//: ### 说明
//: iOS-Core-Animation-Advanced-Techniques 书籍相关的示例代码可以[在此查看](https://github.com/Jyhwenchai/Core-Animation-Example/tree/master/Core-Animation-Example.playground)，你可以找对对应章节查看对应的代码，包括`缓冲函数`的示例等。

//: ### 参考列表
//: [valueFunction](https://www.xuzhengke.cn/archives/708)
//:
//: [fillMode](https://www.jianshu.com/p/91fccd32f6fb)
//:
//: [相对时间](https://zsisme.gitbooks.io/ios-/content/chapter9/the-cAMediaTiming-protocol.html)


