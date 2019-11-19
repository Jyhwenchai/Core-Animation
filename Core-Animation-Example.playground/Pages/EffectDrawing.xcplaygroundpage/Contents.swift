import UIKit
import PlaygroundSupport

// MARK: Example13_1 - 用Core Graphics实现一个简单的绘图应用
class Example13_1: UIView {
    
    lazy var path: UIBezierPath = {
        let path = UIBezierPath()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.lineWidth = 5
        return path
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get the starting point
        let point = touches.first!.location(in: self)
        
        // move the path drawing cursor to the starting point
        path.move(to: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //get the current point
        let point = touches.first!.location(in: self)
        
        //add a new line segment to our path
        path.addLine(to: point)
        
        // redraw the view
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        // 绘制路径
        UIColor.clear.setFill()
        UIColor.red.setStroke()
        path.stroke()
    }
}

// MARK: Example13_2 - CAShapeLayer重新实现绘图应用
class Example13_2: UIView {
    
    lazy var path: UIBezierPath = {
        let path = UIBezierPath()
        return path
    }()
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        // configure the layer
        let shapeLayer = self.layer as! CAShapeLayer
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineJoin = .round
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = 5.0
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get the starting point
        let point = touches.first!.location(in: self)
        
        // move the path drawing cursor to the starting point
        path.move(to: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //get the current point
        let point = touches.first!.location(in: self)
        
        //add a new line segment to our path
        path.addLine(to: point)
        
        // 应用绘制的 path 到 shaperLayer
        let shaperLayer = self.layer as! CAShapeLayer
        shaperLayer.path = path.cgPath
    }
}


// MARK: Example13_3 - 简单的类似黑板的应用
class Example13_3: UIView {
    
    let brushSize: CGFloat = 32.0
    
    var strokes: [CGPoint] = []
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.gray
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get the starting point
        let point = touches.first!.location(in: self)
        
        // add brush stroke
        addBrush(at: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //get the current point
        let point = touches.first!.location(in: self)
        
        // add brush stroke
        addBrush(at: point)
    }
    
    override func draw(_ rect: CGRect) {
        // 绘制路径
        for point in strokes {
            
            let brushRect = CGRect(x: point.x - brushSize / 2.0, y: point.y - brushSize / 2.0, width: brushSize, height: brushSize)
            
            // 绘制笔刷
            UIImage(named: "chalk.png")?.draw(in: brushRect)
            
        }
    }
    
    // 添加笔刷并刷新绘制
    func addBrush(at point: CGPoint) {
        
        strokes.append(point)
        
        setNeedsDisplay()
    }
}

// MARK: Example13_4 - 用-setNeedsDisplayInRect:来减少不必要的绘制
class Example13_4: UIView {
    
    let brushSize: CGFloat = 32.0
    
    var strokes: [CGPoint] = []
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 400, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.gray
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get the starting point
        let point = touches.first!.location(in: self)
        
        // add brush stroke
        addBrush(at: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //get the current point
        let point = touches.first!.location(in: self)
        
        // add brush stroke
        addBrush(at: point)
    }
    
    override func draw(_ rect: CGRect) {
        // 绘制路径
        for point in strokes {
            
            let brushRect = self.brushRect(for: point)
            
            // 绘制笔刷,只绘制与脏矩形相交区域
            if rect.intersects(brushRect) {
                UIImage(named: "chalk.png")?.draw(in: brushRect)
            }
            
        }
    }
    
    func brushRect(for point: CGPoint) -> CGRect {
        return CGRect(x: point.x - brushSize / 2.0, y: point.y - brushSize / 2.0, width: brushSize, height: brushSize)
    }
    
    // 添加笔刷并刷新绘制
    func addBrush(at point: CGPoint) {
        
        strokes.append(point)
        
        setNeedsDisplay()
    }
}

//PlaygroundPage.current.liveView = Example13_1()
//PlaygroundPage.current.liveView = Example13_2()
PlaygroundPage.current.liveView = Example13_3()
//PlaygroundPage.current.liveView = Example13_4()
