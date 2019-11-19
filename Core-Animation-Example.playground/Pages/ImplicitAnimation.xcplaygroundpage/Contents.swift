//: [Previous](@previous)

import UIKit
import PlaygroundSupport

// MARK: Example7_2 - 使用CATransaction控制动画时间
class Example7_2: UIView {
    
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
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        print("red:\(red) green:\(green) blue:\(blue)")
        colorLayer.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1).cgColor
        
        CATransaction.commit()
    }
    
}

// MARK: Example7_3 - 使用CATransaction添加动画完成回调
class Example7_3: UIView {
    
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
        changeColorAndRotate()
    }

    func changeColorAndRotate() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)

        // rotate animate
        CATransaction.setCompletionBlock {
            let transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4.0)
            self.colorLayer.setAffineTransform(transform)
        };
        
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        
        // change color
        colorLayer.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1).cgColor
        
        CATransaction.commit()
    }
}

// MARK: Example7_4 - 直接设置图层的属性
class Example7_4: UIView {
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        view.backgroundColor = UIColor.red
        view.center = CGPoint(x: bounds.midX, y: bounds.midY - 20)
        return view
    }()
    
    lazy var changeBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.purple.cgColor
        button.setTitle("Change Color", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.center = CGPoint(x: bounds.midX, y: colorView.frame.maxY + 25)
        button.addTarget(self, action: #selector(changeBtnAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        
        backgroundColor = UIColor.white
        
        addSubview(colorView)
        addSubview(changeBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeBtnAction() {
        changeColor()
    }
    
    func changeColor() {
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        print("red:\(red) green:\(green) blue:\(blue)")
        colorView.layer.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1).cgColor
        
        CATransaction.commit()
    }

}

// MARK: Example7_6 - 实现自定义行为
class Example7_6: UIView {
    
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
        
        let transition = CATransition()
        transition.type = .push
        transition.subtype = .fromLeft
        colorLayer.actions = ["backgroundColor": transition]
        
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        print("red:\(red) green:\(green) blue:\(blue)")
        colorLayer.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1).cgColor

    }

}

// MARK: Example7_7 - 使用presentationLayer图层来判断当前图层位置
class Example7_7: UIView {
    
    lazy var layerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.frame = self.bounds
        return view
    }()
    
    lazy var colorLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        layer.backgroundColor = UIColor.red.cgColor
        layer.position = CGPoint(x: bounds.midX, y: bounds.midY - 20)
        return layer
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        
        backgroundColor = UIColor.white
        
        addSubview(layerView)
        layerView.layer.addSublayer(colorLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func changeColor() {
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        print("red:\(red) green:\(green) blue:\(blue)")
        colorLayer.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1).cgColor
        
        CATransaction.commit()
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if let layer = colorLayer.presentation(), let _ = layer.hitTest(point) {
            changeColor()
        } else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(2.0)
            colorLayer.position = point
            CATransaction.commit()
        }
        
        return super.hitTest(point, with: event)
    }
}


//PlaygroundPage.current.liveView = Example7_2()
//PlaygroundPage.current.liveView = Example7_3()
//PlaygroundPage.current.liveView = Example7_4()
//PlaygroundPage.current.liveView = Example7_6()
PlaygroundPage.current.liveView = Example7_7()

