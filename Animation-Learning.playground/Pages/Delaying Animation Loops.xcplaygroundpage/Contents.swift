import UIKit
import PlaygroundSupport

//: # 延迟动画循环
//: 在核心动画中你可以很容易的控制动画的重复次数。但是有时候你可能想要在重复动画的开始有一小段时间的延迟。核心动画没有提供直接可用的 API 来达到这一特性，但是实际上这样的设置很容易实现。这篇文章将介绍一种简单的方式来实现重复动画的延迟。
//:
//: ---
//:
//: 下面的例子演示了没有对循环的动画进行延迟处理情况下的效果：
example(CGRect.zero) { rootView in
    let animateView = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
    animateView.backgroundColor = UIColor.orange
    rootView.addSubview(animateView)
    
    let animation = CABasicAnimation(keyPath: "position.x")
    animation.toValue = 250
    animation.duration = 1
    animation.repeatCount = .infinity
    animation.autoreverses = true
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    
    animateView.layer.add(animation, forKey: nil)
    
    PlaygroundPage.current.liveView = rootView
}

//: 在动画之间加入延迟最简单的办法是使用 `CAAnimationGroup`。顾名思义，一个动画组是一个容器对象，它可以将多个动画组合在一起同时运行。重要的是，它继承于 `CAAnimation` ，因此它本身也是可以做动画的。任何添加到 `CAAnimationGroup` 中的动画都相对于 `CAAnimationGroup` 的时间空间。因此，要在重复时延迟动画，只需将动画组的持续时间增加一点，使其超出其包含的动画的持续时间即可：
example(CGRect.zero) { rootView in
    let animateView = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
    animateView.backgroundColor = UIColor.orange
    rootView.addSubview(animateView)
    
    let animation = CABasicAnimation(keyPath: "position.x")
    animation.toValue = 250
    animation.duration = 1
    animation.fillMode = .forwards
    animation.autoreverses = true
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    
    let animationGroup = CAAnimationGroup()
    animationGroup.animations = [animation]
    animationGroup.duration = 3.0
    animationGroup.repeatCount = .infinity
    
    
    animateView.layer.add(animationGroup, forKey: nil)
    
    PlaygroundPage.current.liveView = rootView
}

//: 在使用这种方法时，有三件重要的事情要记住:
//: 1. 需要将动画的 `fillMode` 设置为 `.forwards`。这样可以确保该层在动画完成后再次循环之前保持动画的最后一帧，否则会重置到最开始的位置。
//: 2. 重复次数的属性原来是设置在动画本身，现在你需要移动到动画组上。
//: 3. 如果你的动画支持反转，那么动画组的持续时间必须至少是自动反转动画的两倍

//: ## 原文链接
//: [Delaying Animation Loops](https://www.calayer.com/core-animation/2018/01/16/quick-bits-delaying-animation-loops.html)

