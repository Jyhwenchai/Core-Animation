//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

// MARK:Example5_6 - 应用sublayerTransform
class Example5_6 : UIView {
    
    var leftView = UIView(frame: CGRect(x: 0, y: 50, width: 150, height: 150))
    var rightView = UIView(frame: CGRect(x: 170, y: 50, width: 150, height: 150))
    
    override init(frame: CGRect) {
        
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 400)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        leftView.backgroundColor = UIColor.orange
        rightView.backgroundColor = UIColor.orange
        addSubview(leftView)
        addSubview(rightView)
        
        let transform1 = CATransform3DMakeRotation(CGFloat(Float.pi / 4), 0, 1, 0)
        leftView.layer.transform = transform1
        
        let transform2 = CATransform3DMakeRotation(-CGFloat(Float.pi / 4), 0, 1, 0)
        rightView.layer.transform = transform2
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1 / 500
        layer.sublayerTransform = perspective
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:Example5_8 - 绕Y轴相反的旋转变换
class Example5_8: UIView {
    
    override init(frame: CGRect) {
        
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 400)
        
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        let containerView = UIView(frame: aFrame.insetBy(dx: 50, dy: 50))
        containerView.backgroundColor = UIColor.lightGray
        addSubview(containerView)
        
        
        let innerView = UIView(frame: containerView.bounds.insetBy(dx: 70, dy: 70))
        innerView.backgroundColor = UIColor.red
        containerView.addSubview(innerView)
        
        
        var outer = CATransform3DIdentity
        outer.m34 = -1 / 500
        outer = CATransform3DRotate(outer, CGFloat.pi / 4, 0, 1, 0)
        containerView.layer.transform = outer
        
        var inner = CATransform3DIdentity
        inner.m34 = -1 / 500
        inner = CATransform3DRotate(inner, -CGFloat.pi / 4, 0, 1, 0)
        innerView.layer.transform = inner
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:Example6_5 -  用CATransformLayer装配一个3D图层体系
class Example6_5: UIView {
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 600, height: 400)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        applyCube()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyCube() {
        
        var pt = CATransform3DIdentity
        pt.m34 = -1.0 / 500
        layer.sublayerTransform = pt
        
        var c1t = CATransform3DIdentity
        c1t = CATransform3DTranslate(c1t, -100, 0, 0)
        let cube1 = cube(with: c1t)
        layer.addSublayer(cube1)
        
        
        var c2t = CATransform3DIdentity
        c2t = CATransform3DTranslate(c2t, 100, 0, 0)
        c2t = CATransform3DRotate(c2t, -CGFloat.pi / 4.0, 1, 0, 0)
        c2t = CATransform3DRotate(c2t, -CGFloat.pi / 4.0, 0, 1, 0)
        let cube2 = cube(with: c2t)
        layer.addSublayer(cube2)
        
    }
    
    func face(with transform: CATransform3D) -> CALayer {
        
        let face = CALayer()
        face.frame = CGRect(x: -50, y: -50, width: 100, height: 100)
        
        
        let red = CGFloat.random(in: 0..<1)
        let green = CGFloat.random(in: 0..<1)
        let blue = CGFloat.random(in: 0..<1)
        face.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1).cgColor
        
        
        face.transform = transform
        return face
    }
    
    func cube(with transform: CATransform3D) -> CALayer {
        
        let cube = CATransformLayer()
        
        // add cube face 1
        var ct = CATransform3DMakeTranslation(0, 0, 50)
        cube.addSublayer(face(with: ct))
        
        // add cube face 2
        ct = CATransform3DMakeTranslation(50, 0, 0)
        ct = CATransform3DRotate(ct, CGFloat.pi / 2, 0, 1, 0)
        cube.addSublayer(face(with: ct))
        
        // add cube face 3
        ct = CATransform3DMakeTranslation(0, -50, 0)
        ct = CATransform3DRotate(ct, CGFloat.pi / 2, 1, 0, 0)
        cube.addSublayer(face(with: ct))
        
        // add cube face 4
        ct = CATransform3DMakeTranslation(0, 50, 0)
        ct = CATransform3DRotate(ct, -CGFloat.pi / 2, 1, 0, 0)
        cube.addSublayer(face(with: ct))
        
        
        // add cube face 5
        ct = CATransform3DMakeTranslation(-50, 0, 0)
        ct = CATransform3DRotate(ct, -CGFloat.pi / 2, 0, 1, 0)
        cube.addSublayer(face(with: ct))
        
        // add cube face 6
        ct = CATransform3DMakeTranslation(0, 0, -50)
        ct = CATransform3DRotate(ct, CGFloat.pi, 0, 1, 0)
        cube.addSublayer(face(with: ct))
        
        // center the cube layer within the container
        let size = bounds.size
        cube.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        
        // apply the transform and return
        cube.transform = transform
        return cube
 
    }

}

// MARK:Example6_6 -  简单的两种颜色的对角线渐变
class Example6_6: UIView {
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
//        singleGradientColor()
        mutableGradientColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func singleGradientColor() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        layer.addSublayer(gradientLayer)
        
        // set gradient colors
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        
        // set gradient start and end points
        gradientLayer.startPoint = CGPoint.zero         // left - top
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)    // right - bottom
    }
    
    func mutableGradientColor() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        layer.addSublayer(gradientLayer)
        
        // set gradient colors
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.blue.cgColor]
        
        // set locations
        // 完全红色 - 完全黄色： 0 - 0.25， 完全黄色 - 完全蓝色：0.25 - 0.5， 0.5 之后显示蓝色没有渐变效果
        gradientLayer.locations = [0, 0.25, 0.5]
        
        // set gradient start and end points
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    }
}

// MARK:Example6_8 - 用CAReplicatorLayer重复图层
class Example6_8: UIView {
    
    override init(frame: CGRect) {
        
        let aFrame = CGRect(x: 0, y: 0, width: 600, height: 600)
        super.init(frame: aFrame)
        backgroundColor = UIColor.lightGray
        
        let center = CGPoint(x: aFrame.midX, y: aFrame.midY)
        let rotateCenter = UIView(frame: CGRect(x: center.x - 2, y: center.y - 2, width: 4, height: 4))
        rotateCenter.backgroundColor = UIColor.blue
        rotateCenter.layer.cornerRadius = 2.0
        addSubview(rotateCenter)
        
        rotationRectangle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotationRectangle() {
        
        let replicator = CAReplicatorLayer()
        replicator.frame = bounds
        layer.addSublayer(replicator)
        
        // configure the replicator
        replicator.instanceCount = 10
        
        // apply a transform for each instance
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, CGFloat.pi / 5, 0, 0, 1)
        replicator.instanceTransform = transform
        
        // apply a color shift for each instance
        // 为每个实例应用颜色偏移
        replicator.instanceBlueOffset = -0.1
        replicator.instanceGreenOffset = -0.1
        
        // 创建并添加一个需要被复制的图层到 replicator 中
        let layer = CALayer()
        layer.frame = CGRect(x: bounds.width / 2.0 - 50, y: 0, width: 100, height: 100)
        layer.backgroundColor = UIColor.white.cgColor
        replicator.addSublayer(layer)
        
    }
}

// MARK:Example6_9 -  用CAReplicatorLayer自动绘制反射
class Example6_9: UIView {
    
    override init(frame: CGRect) {
        
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.lightGray
        
        reflectionContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func reflectionContents() {
        
        let view = ReflectionView(frame: CGRect(x: 100, y: 40, width: 100, height: 100))
        let imageView = UIImageView(frame: view.bounds)
        view.addSubview(imageView)
        imageView.image = UIImage(named: "60")

        addSubview(view)
    }
    
    class ReflectionView: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            let replicatorLayer = layer as! CAReplicatorLayer
            replicatorLayer.instanceCount = 2
            
            var transform = CATransform3DIdentity
            let verticalOffset = bounds.size.height + 2
            transform = CATransform3DTranslate(transform, 0, verticalOffset, 0)
            transform = CATransform3DScale(transform, 1, -1, 0)
            
            
            replicatorLayer.instanceTransform = transform
            replicatorLayer.instanceAlphaOffset = -0.6
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override class var layerClass: AnyClass {
            return CAReplicatorLayer.self
        }
    }
}

// MARK:Example6_12 - 一个简单的滚动CATiledLayer实现
class Example6_12: UIViewController, CALayerDelegate {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 50, y: 100, width: 300, height: 300))
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(scrollView)
        
        let tileLayer = CATiledLayer()
        tileLayer.backgroundColor = UIColor.red.cgColor
        tileLayer.contentsScale = UIScreen.main.scale
        tileLayer.frame = CGRect(x: 0, y: 0, width: 2048, height: 2048)
        tileLayer.delegate = self
        scrollView.layer.addSublayer(tileLayer)
        //
        scrollView.contentSize = tileLayer.frame.size
        scrollView.clipsToBounds = true;
        //
        tileLayer.setNeedsDisplay()
    }

    func draw(_ layer: CALayer, in ctx: CGContext) {

        // determine tile coordinate
        let tileLayer = layer as! CATiledLayer

        let bounds = ctx.boundingBoxOfClipPath
        let scale = UIScreen.main.scale
        let x = Int(floor(bounds.origin.x / tileLayer.tileSize.width * scale))
        let y = Int(floor(bounds.origin.y / tileLayer.tileSize.height * scale))
        print("x/y = \(bounds.origin.x / tileLayer.tileSize.width * scale)")
        print("floor(x/y) = \(floor(bounds.origin.x / tileLayer.tileSize.width))")
        // load tile image
        let imageName = String(format: "test_%02i_%02i", x, y);
        let imagePath = Bundle.main.path(forResource: imageName, ofType: "jpg")
        
        guard let _ = imagePath else {
            print("not found image sequence")
            return
        }
        let tileImage = UIImage(contentsOfFile: imagePath!)

        // draw tile
        UIGraphicsPushContext(ctx)
        tileImage?.draw(in: bounds)
        UIGraphicsPopContext()
    }
}

// MARK:Example6_13 - 用CAEmitterLayer创建爆炸效果
class Example6_13: UIView {
    override init(frame: CGRect) {
        
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.black
    
        executeEmitterAnimate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func executeEmitterAnimate() {

        let emitter = CAEmitterLayer()
        emitter.frame = bounds
        layer.addSublayer(emitter)
        
        
        // configure emitter
        emitter.renderMode = .additive
        emitter.emitterPosition = CGPoint(x: bounds.midX , y: bounds.midY)
        
        // create a particle template
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "friend_icon_likes")?.cgImage
        cell.birthRate = 150
        cell.lifetime = 5.0
        cell.color = UIColor(red: 1, green: 0.5, blue: 0.1, alpha: 1.0).cgColor
        cell.alphaSpeed = -0.4
        cell.velocity = 50
        cell.velocityRange = 50
        cell.emissionRange = CGFloat.pi * 2
        
        // add particle template to emitter
        emitter.emitterCells = [cell]
        
    }
}

//PlaygroundPage.current.liveView = Example5_6()
//PlaygroundPage.current.liveView = Example5_8()
//PlaygroundPage.current.liveView = Example6_5()
//PlaygroundPage.current.liveView = Example6_6()
//PlaygroundPage.current.liveView = Example6_8()
PlaygroundPage.current.liveView = Example6_9()
//PlaygroundPage.current.liveView = Example6_12()
//PlaygroundPage.current.liveView = Example6_13()
