//
//  main.swift
//  CropBigPicture
//
//  Created by 蔡志文 on 2019/9/9.
//  Copyright © 2019 蔡志文. All rights reserved.
//

import Foundation
import AppKit


let arguments = CommandLine.arguments


func cropPicture(_ arguments: [String]) {
    
    if arguments.count < 2 {
        print("TileCutter arguments: inputfile")
        return
    }
    
    // input file
    let data = arguments[1].data(using: .utf8)
    
    guard let intputData = data else { return }
    
    let inputFile = String(data: intputData, encoding: .utf8)!

    // title size
    let titleSize = 256
    
    // output path
    let outputPath = URL(string: inputFile)?.deletingPathExtension()

    // load image
    let image = NSImage(contentsOfFile: inputFile)
    
    guard let inputImage = image else { return }
    
    var size = inputImage.size
    let representations = image?.representations
    guard let reps = representations, reps.count > 0 else {
        return
    }

    let representation = reps.first!
    size.width = CGFloat(representation.pixelsWide)
    size.height = CGFloat(representation.pixelsHigh)
    
    var rect = CGRect(origin: CGPoint.zero, size: size)
    let imageRef = image?.cgImage(forProposedRect: &rect, context: nil, hints: nil)
    
    
    // calculate rows and columns
    let rows = Int(ceil(size.height / CGFloat(titleSize)))
    let cols = Int(ceil(size.width / CGFloat(titleSize)))
    
    // generate tiles
    for y in 0..<rows {
        for x in 0..<cols {
            
            // extrat tile image
            let tileRect = CGRect(x: x * titleSize, y: y * titleSize, width: titleSize, height: titleSize)
            let tileImage = imageRef?.cropping(to: tileRect)
            
            // convert to jpeg data
            let imageRep = NSBitmapImageRep(cgImage: tileImage!)
            let data = imageRep.representation(using: .jpeg, properties: [:])
            
            // save file
            let pathString = outputPath?.absoluteString.appendingFormat("_%02i_%02i.jpg", x, y)
            
            guard let _ = pathString else { return }
            
            let path = URL(fileURLWithPath: pathString!)
            do {
                try data?.write(to: path)
            } catch {
                print("write error!")
            }
        }
    }
}


cropPicture(arguments)

