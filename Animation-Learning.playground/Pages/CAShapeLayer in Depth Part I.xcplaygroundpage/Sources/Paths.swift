import UIKit

/// create star path
public func createStarPath(_ position: CGPoint) -> UIBezierPath {
    let starPath = UIBezierPath()
       
    let center = position
   
    let numberOfPoints: CGFloat = 5.0
    let numberOfLiineSegments = Int(numberOfPoints * 2)
    let theta = CGFloat.pi / numberOfPoints
   
    let circumscribedRadius = center.x
    let outerRadius = circumscribedRadius * 1.039
    let excessRadius = outerRadius - circumscribedRadius
    let innerRadius = CGFloat(outerRadius * 0.382)
   
    let leftEdgePointX = (center.x + cos(4.0 * theta) * outerRadius) + excessRadius
    let horizoontalOffset = leftEdgePointX / 2.0
   
    let offsetCenter = CGPoint(x: center.x - horizoontalOffset, y: center.y)
   
    for i in 0..<numberOfLiineSegments {
        let radius = i % 2 == 0 ? outerRadius : innerRadius
       
        let pointX = offsetCenter.x + cos(CGFloat(i) * theta) * radius
        let pointY = offsetCenter.y + sin(CGFloat(i) * theta) * radius
        let point = CGPoint(x: pointX, y: pointY)
       
        if i == 0 {
            starPath.move(to: point)
        } else {
            starPath.addLine(to: point)
        }
       
   }
   
   starPath.close()
   
   var pathTransform = CGAffineTransform.identity
   pathTransform = pathTransform.translatedBy(x: center.x, y: center.y)
   pathTransform = pathTransform.rotated(by: -CGFloat.pi / 2)
   pathTransform = pathTransform.translatedBy(x: -center.x, y: -center.y)
    
    starPath.apply(pathTransform)
    return starPath
}
