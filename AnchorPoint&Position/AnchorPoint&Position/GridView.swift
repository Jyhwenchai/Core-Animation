//
//  GridView.swift
//  AnchorPoint&Position
//
//  Created by 蔡志文 on 2019/11/13.
//  Copyright © 2019 蔡志文. All rights reserved.
//

import UIKit

@IBDesignable
class GridView: UIView {

    @IBInspectable public var spacing: CGFloat = 10
    
    @IBInspectable public var lineColor: UIColor = UIColor.lightGray
    
    private var hLines: [CALayer] = []
    private var vLines: [CALayer] = []

    private var reDraw = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if reDraw {
            createLines()
            reDraw = false
        }
    }
    
    public func reDrawGrid() {
        reDraw = true
        clearLines()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func clearLines() {
        hLines.forEach { $0.removeFromSuperlayer() }
        hLines.removeAll()
        
        vLines.forEach { $0.removeFromSuperlayer() }
        vLines.removeAll()
    }
    
    private func createLines() {
        var hLineCount = Int(ceil(bounds.size.height / spacing))
        var vLineCount = Int(ceil(bounds.size.width / spacing))
       
        while hLineCount >= 0 {
            let size = CGSize(width: bounds.size.width, height: 1 / UIScreen.main.scale)
            let point = CGPoint(x: 0, y: CGFloat(hLineCount) * spacing)
            let layer = createLine(with: CGRect(origin: point, size: size))
            hLines.append(layer)
            hLineCount -= 1
        }
        
        while vLineCount >= 0 {
            let size = CGSize(width: 1 / UIScreen.main.scale, height: bounds.size.height)
            let point = CGPoint(x: CGFloat(vLineCount) * spacing, y: 0)
            let layer = createLine(with: CGRect(origin: point, size: size))
            vLines.append(layer)
            vLineCount -= 1
        }
    }

    func createLine(with frame: CGRect) -> CALayer {
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = lineColor.cgColor
        self.layer.addSublayer(layer)
        return layer
    }
}
