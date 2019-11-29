//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//: ## CATransaction
//: `CATransaction` 在核心动画中起到很重要的作用，根据文档描述 `CATransaction` 用于将多个图层树的操作批量更新到渲染树中，也就说它可以将多个动画组合在一起同时进行。这里我们将对它的一些内容进行说明。

//: ### 隐式事务和显示事务
//: [文档](https://developer.apple.com/documentation/quartzcore/catransaction)中说明核心动画支持两种事务，包括隐式事务和显示事务。如何你没有创建显示事务那么当你修改图层树的时候那么将自动创建隐式事务，并在线程的 `runloop` 下次迭代时自动提交，在你修改图层树之前向 `CATransaction` 发送 `begin()` 方法然后发送 `commit()` 消息时就会发生显示事务。
example(CGRect.zero) { rootView in
    let animateLayer = CALayer()
    animateLayer.frame  = CGRect(x: 50, y: 50, width: 50, height: 50)
    animateLayer.backgroundColor = UIColor.orange.cgColor
    rootView.layer.addSublayer(animateLayer)
    
    /// 隐式事务
    func implicitTransaction() {
        animateLayer.position = CGPoint(x: 200, y: 200)
        animateLayer.backgroundColor = UIColor.systemIndigo.cgColor
    }
    
    /// 显示事务
    func explicitTransaction() {
        CATransaction.begin()
        animateLayer.position = CGPoint(x: 200, y: 200)
        animateLayer.backgroundColor = UIColor.systemIndigo.cgColor
        CATransaction.commit()
    }
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        implicitTransaction()
//        explicitTransaction()
    }
    
    PlaygroundPage.current.liveView = rootView
}



//: ### 禁止动画
//: 在上面的代码中演示了隐式事务和显示事务的操作，但实际上你会发现两者并没有区别，虽然你使用了显示事务但是它依然以动画的方式呈现出来。如果你真的要禁止动画，那么你向发生 `setDisableActions()` 消息或者通过 `KVC` 的方式将其 `kCATransactionDisableActions` 属性设置为 `true`，你可以在[这里](https://developer.apple.com/documentation/quartzcore/catransaction/transaction_properties)看到可操作的相关属性。
//: - note: 从技术上来讲禁用动画的实现应该是阻止因修改图层属性而创建 `CAAction` 对象
example(CGRect.zero) { rootView in
    let animateLayer = CALayer()
    animateLayer.frame  = CGRect(x: 50, y: 50, width: 50, height: 50)
    animateLayer.backgroundColor = UIColor.orange.cgColor
    rootView.layer.addSublayer(animateLayer)
    
    /// 显示事务
    func explicitTransaction() {
        CATransaction.begin()
//        CATransaction.setDisableActions(true)
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        animateLayer.position = CGPoint(x: 200, y: 200)
        animateLayer.backgroundColor = UIColor.systemIndigo.cgColor
        CATransaction.commit()
    }
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        explicitTransaction()
    }
    
    PlaygroundPage.current.liveView = rootView
}

//: ### CATransaction 动画相关
//: `CATransaction` 提供了一些动画相关的方法，你可以使用这几个方法对动画的表现进行调整
//: * `setAnimationDuration(_:)` 设置动画时长
//: * `setAnimationTimingFunction(_:)` 设置动画的缓冲函数
//: * `setCompletionBlock(_:)` 可以监听动画完成的回调
//: - note: 注意事务完成回调应该设置在任何要修改的动画属性之前
example(CGRect.zero) { rootView in
    let animateLayer = CALayer()
    animateLayer.frame  = CGRect(x: 50, y: 50, width: 50, height: 50)
    animateLayer.backgroundColor = UIColor.orange.cgColor
    rootView.layer.addSublayer(animateLayer)
    
    func executeAnimate() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeIn))
        CATransaction.setCompletionBlock {
            print("animate complete.")
        }
        animateLayer.backgroundColor = UIColor.systemTeal.cgColor
        animateLayer.position = CGPoint(x: 200, y: 200)
        animateLayer.cornerRadius = 25.0
        CATransaction.commit()
    }
    
     DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
           executeAnimate()
     }
    
   PlaygroundPage.current.liveView = rootView
}

//: ### 并发处理
//: 核心动画本质上是线程安全的，所以图层动画及图层树的修改可以在多线程环境中进行，为了在多线程环境中可以正确的修改图层动画进行修改，你需要使用 `lock()` 与 `unlock()` 对数据的修改进行锁住和解锁操作以防止数据损坏。
//:
//: 下面的示例中尝试注释掉锁的操作会发现运行的结果是未知的
example(CGRect.zero) { rootView in
    let animateLayer = CALayer()
     animateLayer.frame  = CGRect(x: 50, y: 50, width: 50, height: 50)
     animateLayer.backgroundColor = UIColor.orange.cgColor
     rootView.layer.addSublayer(animateLayer)
     
     func executeAnimateOne() {
        CATransaction.lock()
         CATransaction.begin()
         CATransaction.setAnimationDuration(2.0)
         CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeIn))
         CATransaction.setCompletionBlock {
             print("animate one complete.")
         }
  
         animateLayer.backgroundColor = UIColor.systemTeal.cgColor
         animateLayer.position = CGPoint(x: 200, y: 200)
         animateLayer.cornerRadius = 25.0
         CATransaction.commit()
        CATransaction.unlock()
     }

    func executeAnimateTwo() {
        CATransaction.lock()
          CATransaction.begin()
          CATransaction.setAnimationDuration(2.0)
          CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeIn))
          CATransaction.setCompletionBlock {
              print("animate two complete.")
          }
          animateLayer.backgroundColor = UIColor.systemPurple.cgColor
          animateLayer.position = CGPoint(x: 50, y: 200)
          animateLayer.cornerRadius = 10.0
          CATransaction.commit()
        CATransaction.unlock()
      }
     
    let queue = DispatchQueue(label: "queue1", attributes: .concurrent)
    queue.asyncAfter(deadline: DispatchTime.now() + 1) {
        executeAnimateOne()
    }
    queue.asyncAfter(deadline: DispatchTime.now() + 1) {
        executeAnimateTwo()
    }
    
    PlaygroundPage.current.liveView = rootView
}

//: ### 嵌套事务
//: 在文档中提到事务是可以嵌套使用的，在嵌套的事务中，外层的事务会等到内层事务完成之后才会执行完成回调。
example(CGRect.zero) { rootView in
    let animateLayer = CALayer()
     animateLayer.frame  = CGRect(x: 50, y: 50, width: 50, height: 50)
     animateLayer.backgroundColor = UIColor.orange.cgColor
     rootView.layer.addSublayer(animateLayer)
     
    func executeAnimate() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeIn))
        CATransaction.setCompletionBlock {
            print("outer transaction complete.")
        }
        
        animateLayer.backgroundColor = UIColor.systemTeal.cgColor
        animateLayer.position = CGPoint(x: 200, y: 200)
        animateLayer.cornerRadius = 25.0
        
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(3)
        CATransaction.setCompletionBlock {
            print("inner transaction complete.")
        }
        
        animateLayer.transform = CATransform3DMakeScale(3, 3, 3)
             
        CATransaction.commit()  // 提交内层事务
        
        CATransaction.commit()  // 提交外层事务
     }

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        executeAnimate()
    }

    PlaygroundPage.current.liveView = rootView
}
//: ## 参考
//: [Apple CATransaction Document](https://developer.apple.com/documentation/quartzcore/catransaction)
//:
//: [CATransaction in Depth](https://www.calayer.com/core-animation/2016/05/17/catransaction-in-depth.html#fnref:8)

//: [Next](@next)
