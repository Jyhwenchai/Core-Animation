//: [Previous](@previous)
import Foundation
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//: ## CAAction
//: 在核心动画的开始我们介绍过动画类的继承结构，在最顶端的就是 `CAAction` 协议，`CAAction` 中只有一个方法 `run(forKey:object:arguments:)`。`CAAnimation` 类实现了该协议，在 `CALayer` 中的可动画属性提供了默认的 `action` 对象， 所以你在修改 `CALayer` 的 `frame` 等属性后会触发 `CALayer` 的隐式动画也就是触发了对应 `action` 的 `run(forKey:object:arguments:)` 方法。你可以通过以下几种方式触发 `CAAction` 对象。
//: * 当 `layer` 中的一个属性被修改时，包括你自定义的属性。`action` 对象关联的 `key` 被标识为对应的属性名称
//: * 当 `layer` 可见或已添加到图层层次结构中时，`action` 对象关联的 `key` 被标识为 `kCAOnOrderIn`
//: * 当 `layer` 从图层层次结构中移除时，`action` 对象关联的 `key` 被标识为 `kCAOnOrderOut`
//: * 当 `layer` 执行过渡动画时，`action` 对象关联的 `key` 被标识为 `kCATransition`

//: ### `CAAction` 对象必须放置在 `CALayer` 上才能生效
//: 在 `action` 对象执行之前，`layer` 需要找到对应的 `action` 对象来执行。查找 `action` 对象的 `key` 就是 `layer` 中将要被修改的属性或者你自己标识的特定字符串。当 `layer` 发生事件时，`layer` 会调用 `action(forKey:)`，这个方法会查找并返回与提供的 `key` 匹配的 `action` 对象。你可以在下面的几种途径中应用自己的 `action` 对象。
//: * 如果layer实现 `action(forKey:)` 那么会调用该方法执行下面行为
//:     1. 返回给定 `key` 的 `action` 对象
//:     2. 如果没有需要处理的 `action` 操作的话返回 `nil`，搜索将会继续在其他地方进行
//:     3. 返回 `NSNull` 对象，这种情况下会立刻结束搜索
//: * `layer` 会在 `actions` 字典中搜索指定 `key` 的 `action` 对象
//: * `layer` 会在 `style` 字典中查找含有 `key` 的 `actions` 字典
//: * `layer` 调用 `defaultAction(forKey:)` 类方法
//: * `Layer` 执行通过核心动画定义的隐式 `action` 对象（如果有的话）
//:
//: 如果你指定 `key` 的 `action` 对象在合适的地方被找到，那么会执行 `action` 对象的 `run(forKey:object:arguments:)` 方法。下面的示例中我们对图层的 `contents` 属性自定义了一个 `action` 对象。
class CustomActionView: UIView {
    
    var flag = false
    
    
    lazy var actionButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 50, width: 0, height: 0))
        button.setTitle("animate", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(executeAnimate), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        layer.contents = UIImage(named: "image1")?.cgImage
        addSubview(actionButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        guard event == "contents" else {
            return nil
        }
        let animation = CATransition()
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.type = .push
        animation.subtype = .fromRight
        return animation    // 返回一个 action 对象之后会执行 action 对象的 `run(forKey:object:arguments:)` 方法，默认的系统已经帮你实现了该方法中的具体动画行为
    }
    
    @objc func executeAnimate() {
        let imageName = flag ? "image1" : "image2"
        layer.contents = UIImage(named: imageName)?.cgImage
        flag.toggle()
    }
}

PlaygroundPage.current.liveView = CustomActionView()

//: ## 参考
//: [Layer’s Default Behavior](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/ReactingtoLayerChanges/ReactingtoLayerChanges.html)


//: [Next](@next)
