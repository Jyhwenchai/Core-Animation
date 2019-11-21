import UIKit

public class AnimateView: UIView {
    override init(frame: CGRect) {
        var aframe = CGRect.zero
        if frame.equalTo(aframe) {
            aframe = CGRect(x: 0, y: 0, width: 300, height: 300)
        }
        
        super.init(frame: aframe)
        backgroundColor = UIColor.white
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func executeAnimate(_ action: ()->())  {
        action()
    }
    
}

public func example(_ frame: CGRect, action: (_ view: UIView) -> ()) -> UIView {
    let animateView = AnimateView()
    animateView.executeAnimate {
        action(animateView)
    }
    return animateView
}
