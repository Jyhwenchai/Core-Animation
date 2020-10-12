import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

example(CGRect.zero) { rootView in
     let replicatorLayer: CAReplicatorLayer = {
        let layer = CAReplicatorLayer()
        layer.frame = rootView.bounds
        layer.backgroundColor = UIColor.clear.cgColor
        
        layer.instanceCount = 5
        layer.instanceTransform = CATransform3DMakeTranslation(50, 0, 0)
        layer.instanceBlueOffset = -1 / Float(layer.instanceCount)
        layer.instanceGreenOffset = -1 / Float(layer.instanceCount)
        return layer
    }()
    
    let redSquare: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        return layer
    }()
    
    replicatorLayer.addSublayer(redSquare)
    rootView.layer.addSublayer(replicatorLayer)
    
    PlaygroundPage.current.liveView = rootView

}

/// 两个 CAReplicatorLayer 叠加效果
example(CGRect.zero) { rootView in
     let replicatorLayer: CAReplicatorLayer = {
        let layer = CAReplicatorLayer()
        layer.frame = rootView.bounds
        layer.backgroundColor = UIColor.clear.cgColor
        
        layer.instanceCount = 5
        layer.instanceTransform = CATransform3DMakeTranslation(50, 0, 0)
        layer.instanceBlueOffset = -1 / Float(layer.instanceCount)
        layer.instanceGreenOffset = -1 / Float(layer.instanceCount)
        return layer
    }()
    
    let replicatorLayer2: CAReplicatorLayer = {
       let layer = CAReplicatorLayer()
       layer.frame = rootView.bounds
       layer.backgroundColor = UIColor.clear.cgColor
       
       layer.instanceCount = 5
       layer.instanceTransform = CATransform3DMakeTranslation(0, 50, 0)
       layer.instanceRedOffset = -1 / Float(layer.instanceCount)
    
       return layer
   }()
    
    
    let redSquare: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        return layer
    }()
    
    replicatorLayer.addSublayer(redSquare)
    replicatorLayer2.addSublayer(replicatorLayer)
    rootView.layer.addSublayer(replicatorLayer2)
    
    PlaygroundPage.current.liveView = rootView

}

example(CGRect.zero) { rootView in
     let replicatorLayer: CAReplicatorLayer = {
        let layer = CAReplicatorLayer()
        layer.frame = rootView.bounds.insetBy(dx: 50, dy: 50)
        layer.backgroundColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        layer.cornerRadius = 10
        
        layer.instanceCount = 15
        let angle = CGFloat(2 * Double.pi) / 15
        layer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        layer.instanceDelay = 1.5 / Double(15)
        return layer
    }()
    
    let dotLayer: CALayer = {
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = layer.bounds.width / 2.0
        layer.transform = CATransform3DMakeScale(0.01,0.01,0.01)
        return layer
    }()
    
    dotLayer.position = CGPoint(x: replicatorLayer.bounds.width / 2.0, y: 20)
    replicatorLayer.addSublayer(dotLayer)
    func executeAnimation() {
        let duration: CFTimeInterval = 1.5
        let animation = CABasicAnimation(keyPath:"transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 0.1
        animation.duration = duration
        animation.repeatCount = Float.infinity
        
        dotLayer.add(animation, forKey:nil)
    }
    
    rootView.layer.addSublayer(replicatorLayer)
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        executeAnimation()
    }
    
    PlaygroundPage.current.liveView = rootView

}


example(CGRect.zero) { rootView in
     let replicatorLayer: CAReplicatorLayer = {
        let layer = CAReplicatorLayer()
        layer.frame = CGRect(x: 100, y: 50, width: 60, height: 60)
        layer.backgroundColor = UIColor.clear.cgColor
        
        layer.instanceCount = 4
        layer.instanceTransform = CATransform3DMakeTranslation(10, 0, 0)
        layer.instanceDelay = 0.33
        layer.masksToBounds = true
        return layer
    }()
    
    let barLayer: CALayer = {
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 8, height: 40)
        layer.backgroundColor = UIColor.red.cgColor
        layer.cornerRadius = 2
        layer.position = CGPoint(x: 10, y: 75)
        return layer
    }()
    
   
    replicatorLayer.addSublayer(barLayer)
    func executeAnimation() {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.toValue = barLayer.position.y - 30.0
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        barLayer.add(animation, forKey:nil)

    }
    
    rootView.layer.addSublayer(replicatorLayer)
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        executeAnimation()
    }
    
    PlaygroundPage.current.liveView = rootView

}
