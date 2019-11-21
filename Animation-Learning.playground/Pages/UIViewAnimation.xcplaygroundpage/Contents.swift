//: [Previous](@previous)

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
//: # UIView 动画
//: 在 `iOS` 开发过程中, 针对一些简单的动画表现（frame、alpha、backgroundColor 等属性的修改），你会尽量考虑使用简单的方式来实现它.`UIView` 中提供了一系列执行动画的类方法为此提供了便利(虽然说苹果已经不推荐使用这些方法)，这里将对其中的一些方法进行简单的示例说明。

//: ---

//: ## animate(withDuration:animations:)
//: `animateWithDuration:animations:` 提供一个简单的方式来执行动画，你只需要给的动画进行的时长即可
example(CGRect.zero) { rootView in
    let view = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
    view.backgroundColor = UIColor.orange
    rootView.addSubview(view)
    
    let duration = 1.0
    UIView.animate(withDuration: duration) {
        view.backgroundColor = UIColor.systemTeal
        view.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
    }
    PlaygroundPage.current.liveView = rootView
}


//: ## animate(withDuration:animations:completion:)
//: 很多时候你可能需要在动画完成时进行额外的操作，该方法为你提供了这样的可能
example(CGRect.zero) { rootView in
    let view = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
    view.backgroundColor = UIColor.orange
    rootView.addSubview(view)
       
    let duration = 1.0
    UIView.animate(withDuration: duration, animations: {
        view.backgroundColor = UIColor.systemTeal
        view.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
    }) { _ in
        print("animation complete!")
    }
    PlaygroundPage.current.liveView = rootView
}

//: ## animate(withDuration:delay:options:animations:completion:)
//: 该方法相比于之前多了两个参数 `delay` 和 `options` ，`delay` 允许你延迟几秒再开始执行动画，`options` 表示你要如何执行动画（缓入、缓出等），你可以在此 [UIViewAnimationOptions](https://developer.apple.com/documentation/uikit/uiviewanimationoptions?language=occ) 查看其所有的枚举值
example(CGRect.zero) { rootView in
    let view = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
    view.backgroundColor = UIColor.orange
    rootView.addSubview(view)
       
    let duration = 1.0
    let delay = 1.0
    let options: UIView.AnimationOptions = [.curveEaseIn]
    UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
        view.backgroundColor = UIColor.systemTeal
        view.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
    }) { _ in
        print("animation complete!")
    }
    PlaygroundPage.current.liveView = rootView
}

//: ## transition(with:duration:options:animations:completion:)
//: 这个方法允许你对指定的视图里的子视图进行动画行为，例如 `移除`、`添加`、`显示`、`隐藏` 等。下面的例子显示了对移除和添加的过程执行过渡动画的行为。 要注意的是在这里你必须指定正确的过渡方式，即 `options` 参数（仅限于以 `.transition` 开头的相关枚举对其有效）
//: - note: 由于使用 playground，下面的示例效果有些偏差. 另外该方法与 `transition(from:to:duration:options:completion:)` 的过渡表现都将在下一次的 run loop 循环中执行，所以如果你不做延迟或者手动的触发动画，那么你无法看到正确的过渡表现
example(CGRect.zero) { rootView in
    
    let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    rootView.addSubview(containerView)
    
    let fromView = UIView(frame: CGRect(x: 50, y: 50, width: 150, height: 150))
    fromView.backgroundColor = UIColor.orange
    containerView.addSubview(fromView)
    
    let toView = UIView(frame: CGRect(x: 50, y: 50, width: 150, height: 150))
    toView.backgroundColor = UIColor.systemTeal
       
    let duration = 2.0
    let options: UIView.AnimationOptions = [.transitionFlipFromLeft]
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        UIView.transition(with: containerView, duration: duration, options: options, animations: {
            fromView.removeFromSuperview()
            containerView.addSubview(toView)
        }, completion: nil)
    }
    PlaygroundPage.current.liveView = rootView
}

//: ## transition(from:to:duration:options:completion:)
//: 该方法与 `transition(with:duration:options:animations:completion:)` 类似，不同的是它可以直接提供两个视图，在过渡动画开始前 `from` 视图将从父视图中移除，在过渡动画结束时 `to` 视图将会添加到父视图中，这个过程你不需要手动的添加 `to` 视图到父视图中。
example(CGRect.zero) { rootView in
    
    let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    rootView.addSubview(containerView)
    
    let fromView = UIView(frame: CGRect(x: 50, y: 50, width: 150, height: 150))
    fromView.backgroundColor = UIColor.orange
    containerView.addSubview(fromView)
    
    let toView = UIView(frame: CGRect(x: 50, y: 50, width: 150, height: 150))
    toView.backgroundColor = UIColor.systemTeal
       
    let duration = 2.0
    let options: UIView.AnimationOptions = [.transitionCrossDissolve, .transitionFlipFromTop]
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        UIView.transition(from: fromView, to: toView, duration: duration, options: options, completion: nil)
    }
    PlaygroundPage.current.liveView = rootView
}


//: ## animateKeyframes(withDuration:delay:options:animations:completion:) 与 addKeyframe(withRelativeStartTime:relativeDuration:animations:)
//: 相较与之前简单的动画表现，这两个方法提供了关键帧动画使你的动画表现可以更加丰富，`UIView.animateKeyframes(:::)` 方法中 `withDuration` 定义了整个关键帧动画的总时长，`options` 指定了你要如何执行动画，具体的可以查看 [KeyframeAnimationOptions](https://developer.apple.com/documentation/uikit/uiview/keyframeanimationoptions) 。`UIView.addKeyframe(::)` 需要在 `UIView.animateKeyframes(:::)` 的 `animations` 闭包中使用，该方法将执行一帧动画，你可以执行多个该方法，也就是执行了对应帧数的动画。在改方法中 `withRelativeStartTime` 是关键帧动画的开始时间，你应该相对于 `UIView.animateKeyframes(:::)` 设置的总时长进行调整，`relativeDuration` 参数为一帧动画执行的时间。
//: - note: 该方法执行的动画将在下一次的 run loop 循环周期的开始执行
example(CGRect.zero) { rootView in
    
    let animateView = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
    animateView.backgroundColor = UIColor.orange
    rootView.addSubview(animateView)
       
    let duration = 4.0
    let options: UIView.KeyframeAnimationOptions = [.calculationModePaced]
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: options, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                animateView.frame = CGRect(x: 200, y: 50, width: 50, height: 50)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1 / duration, relativeDuration: 1) {
                 animateView.frame = CGRect(x: 200, y: 200, width: 50, height: 50)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 2 / duration, relativeDuration: 1) {
                animateView.frame = CGRect(x: 50, y: 200, width: 50, height: 50)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 3 / duration, relativeDuration: 1) {
                animateView.frame = CGRect(x: 50, y: 50, width: 50, height: 50)
           }
            
        }, completion: nil)
    }
    PlaygroundPage.current.liveView = rootView
}

//: ## animate(withDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)
//: `UIView` 中还提供了一个实现简单弹性动画的方法，虽然该方法的表现效果并不是那么出色。在该方法中有两个之前没见过的参数 `usingSpringWithDamping` 和 `initialSpringVelocity`, `usingSpringWithDamping` 表示弹簧的阻尼强度，强度越大物体的弹性表现效果越不明显，强度越小物体的弹性表现效果越明显，其取值范围为 0-1 之间。`initialSpringVelocity` 为初始速度，如果执行弹性动画的视图本身已经在移动，那么设置初始速度与视图当前的速度保持一致可以使视图的表现更加平滑。默认的，如果视图本身没有在移动那么表示视图当前的速度为 `0pt/s`, 那么其实你可以指定 `initialSpringVelocity` 的值为 0。`initialSpringVelocity` 越大弹性表现效果也越明显，越小表现效果也越差。
//: - note: 你可以通过[文档](https://developer.apple.com/documentation/uikit/uiview/1622594-animate)进一步理解该方法的相关属性， 该方法执行的动画将在下一次的 run loop 循环周期的开始执行
example(CGRect.zero) { rootView in
    
    let animateView = UIView(frame: CGRect(x: 50, y: 0, width: 50, height: 50))
    animateView.layer.cornerRadius = 25.0
    animateView.backgroundColor = UIColor.orange
    rootView.addSubview(animateView)
       
    let duration = 3.0
    let damping: CGFloat = 0.35
    let velocity: CGFloat = 0
    
    
    let options: UIView.AnimationOptions = [.curveEaseIn]
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
            animateView.frame = CGRect(x: 50, y: 200, width: 50, height: 50)
        }, completion: nil)
        
    }
    PlaygroundPage.current.liveView = rootView
}

//: ## performSystemAnimation:onViews:options:animations:completion:
//: 这是要说明的最后一个方法，该方法的第一个参数为动画的目的，目前该枚举只定义了一个枚举值 `delete`, 它的效果是将给定的视图从父视图中移除
//: - note: 该方法执行的动画将在下一次的 run loop 循环周期的开始执行
example(CGRect.zero) { rootView in
    
    let view1 = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
    view1.backgroundColor = UIColor.orange
    rootView.addSubview(view1)
    
    let view2 = UIView(frame: CGRect(x: 200, y: 50, width: 50, height: 50))
    view2.backgroundColor = UIColor.systemTeal
    rootView.addSubview(view2)
    
    let animation: UIView.SystemAnimation = .delete
    let options: UIView.AnimationOptions = [.curveEaseIn]
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        UIView.perform(animation, on: [view1, view2], options: options, animations: {
            view1.frame = CGRect(x: 50, y: 250, width: 50, height: 50)
            view2.frame = CGRect(x: 200, y: 250, width: 50, height: 50)
        }, completion: nil)
    }
    PlaygroundPage.current.liveView = rootView
}

//: performWithoutAnimation(_:)
//: 最后这个方法将屏蔽视图的相关过渡动画, 你可以用此禁用 `UITableView` 插入删除等动画行为，另外该方法并不能使 `CALayer` 的动画失效
example(CGRect.zero) { rootView in
    
    let view1 = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
    view1.backgroundColor = UIColor.orange
    rootView.addSubview(view1)
    
    let view2 = UIView(frame: CGRect(x: 200, y: 50, width: 50, height: 50))
    view2.backgroundColor = UIColor.systemTeal
    rootView.addSubview(view2)
    
    let animation: UIView.SystemAnimation = .delete
    let options: UIView.AnimationOptions = [.curveEaseIn]
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        UIView.performWithoutAnimation {
            UIView.perform(animation, on: [view1, view2], options: options, animations: {
                view1.frame = CGRect(x: 50, y: 250, width: 50, height: 50)
                view2.frame = CGRect(x: 200, y: 250, width: 50, height: 50)
            }, completion: nil)
        }
    }
    PlaygroundPage.current.liveView = rootView
}


//: ## 扩展阅读
//: [View-Layer 协作](https://objccn.io/issue-12-4/)


//: [Next](@next)

