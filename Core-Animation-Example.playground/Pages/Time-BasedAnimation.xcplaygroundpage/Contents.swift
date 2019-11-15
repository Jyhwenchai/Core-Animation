import UIKit
import PlaygroundSupport

// MARK: Example11_1 - 使用NSTimer实现弹性球动画
class Example11_1 : UIView, CAAnimationDelegate {
    
    lazy var ballView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ball.png"))
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.center = CGPoint(x: center.x, y: 50)
        return view
    }()
    
    var fromValue = CGPoint.zero
    var toValue = CGPoint.zero

    var duration = 0.0
    var timeOffset = 0.0
    

    var timer: Timer?
    
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        addSubview(ballView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        animate()
    }
    
    func animate() {
        
        // reset ball to top of screen
        ballView.center = CGPoint(x: center.x, y: 32)
        
        // configure the animation
        duration = 1.0
        timeOffset = 0.0
        
        fromValue = CGPoint(x: center.x, y: 32)
        toValue = CGPoint(x: center.x, y: 268)
        
        // stop the timer if it's already running
        if let timer = timer {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1 / 60.0, target: self, selector: #selector(step(_:)), userInfo: nil, repeats: true)
    }
    
    
    @objc func step(_ timer: Timer) {
        // 更新 timeOffset
        timeOffset = min(timeOffset + 1 / 60.0, duration)
        
        // 获取标准化的时间偏移量, 即转换为（0 ~ 1）之间
        var time = timeOffset / duration
        
        // 应用曲线
        time = bounceEaseOut(t: time)
        
        // 插值位置
        let position = interpolate(from: fromValue, to: toValue, time: time)
        
        // 移动视图到新的位置
        ballView.center = position
        
        // 如果球体运动结束则移除计时器
        if timeOffset >= duration {
            self.timer!.invalidate()
            self.timer = nil
        }
        
    }
    
    func interpolate(from value1: CGPoint, to value2: CGPoint, time: CFTimeInterval) -> CGPoint {
        let result = CGPoint(x: interpolate(from: value1.x, to: value2.x, time: time), y: interpolate(from: value1.y, to: value2.y, time: time))
        return result
    }
    
    func interpolate(from: CGFloat, to: CGFloat, time: CFTimeInterval) -> CGFloat {
        return (to - from) * CGFloat(time) + from
    }
    
    func bounceEaseOut(t: Double) -> Double {
        if (t < 4/11.0) {
            return (121 * t * t)/16.0;
        } else if (t < 8/11.0) {
            return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
        } else if (t < 9/10.0) {
            return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
        }
        return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
    }
}

// MARK: Example11_2 - 通过测量没帧持续的时间来使得动画更加平滑
class Example11_2 : UIView, CAAnimationDelegate {
    
    lazy var ballView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ball.png"))
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.center = CGPoint(x: center.x, y: 50)
        return view
    }()
    
    var fromValue = CGPoint.zero
    var toValue = CGPoint.zero
    
    var duration = 0.0
    var timeOffset = 0.0
    var lastStep = 0.0
    
    
    
    var timer: CADisplayLink?
    
    
    override init(frame: CGRect) {
        let aFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        super.init(frame: aFrame)
        backgroundColor = UIColor.white
        
        addSubview(ballView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        animate()
    }
    
    func animate() {
        
        // reset ball to top of screen
        ballView.center = CGPoint(x: center.x, y: 32)
        
        // configure the animation
        duration = 1.0
        timeOffset = 0.0
        
        fromValue = CGPoint(x: center.x, y: 32)
        toValue = CGPoint(x: center.x, y: 268)
        
        // stop the timer if it's already running
        if let timer = timer {
            timer.invalidate()
        }
        
        lastStep = CACurrentMediaTime()
        timer = CADisplayLink(target: self, selector: #selector(step(_:)))
        
        timer?.add(to: RunLoop.main, forMode: .default)
        
    }
    
    
    @objc func step(_ timer: Timer) {
        
        // 计算时间增量
        let thisStep = CACurrentMediaTime()
        let stepDuration = thisStep - lastStep
        lastStep = thisStep
        print(stepDuration)
        
        // 更新 timeOffset
        timeOffset = min(timeOffset + stepDuration, duration)
        
        // 获取标准化的时间偏移量, 即转换为（0 ~ 1）之间
        var time = timeOffset / duration
        
        // 应用曲线
        time = bounceEaseOut(t: time)
        
        // 插值位置
        let position = interpolate(from: fromValue, to: toValue, time: time)
        
        // 移动视图到新的位置
        ballView.center = position
        
        // 如果球体运动结束则移除计时器
        if timeOffset >= duration {
            self.timer!.invalidate()
            self.timer = nil
        }
        
    }
    
    func interpolate(from value1: CGPoint, to value2: CGPoint, time: CFTimeInterval) -> CGPoint {
        let result = CGPoint(x: interpolate(from: value1.x, to: value2.x, time: time), y: interpolate(from: value1.y, to: value2.y, time: time))
        return result
    }
    
    func interpolate(from: CGFloat, to: CGFloat, time: CFTimeInterval) -> CGFloat {
        return (to - from) * CGFloat(time) + from
    }
    
    func bounceEaseOut(t: Double) -> Double {
        if (t < 4/11.0) {
            return (121 * t * t)/16.0;
        } else if (t < 8/11.0) {
            return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
        } else if (t < 9/10.0) {
            return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
        }
        return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
    }
}

//PlaygroundPage.current.liveView = Example11_1()
PlaygroundPage.current.liveView = Example11_2()
