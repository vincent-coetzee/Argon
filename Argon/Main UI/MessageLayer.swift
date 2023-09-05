//
//  MessageLayer.swift
//  Argon
//
//  Created by Vincent Coetzee on 02/09/2023.
//

import Cocoa

public class MessageLayer: CAShapeLayer
    {
    private let message: String
    private let textLayer: CATextLayer
    
    public var textColor: CGColor = NSColor.black.cgColor
        {
        didSet
            {
            self.textLayer.foregroundColor = self.textColor
            }
        }
        
    public override var backgroundColor: CGColor?
        {
        didSet
            {
            self.textLayer.backgroundColor = self.backgroundColor
            }
        }
        
    public var foregroundColor: CGColor?
        {
        didSet
            {
            self.fillColor = self.foregroundColor
            }
        }
        
    public var font: NSFont = NSFont(name: "Helvetica", size: 12)!
        {
        didSet
            {
            self.textLayer.font = self.font
            }
        }
        
    public var fontSize: CGFloat = 14
        {
        didSet
            {
            self.textLayer.fontSize = self.fontSize
            }
        }
    
    public init(message: String)
        {
        self.message = message
        self.textLayer = CATextLayer()
        self.textLayer.string = message
        super.init()
        self.addSublayer(self.textLayer)
        }
        
    public required init(coder: NSCoder)
        {
        self.message = coder.decodeObject(forKey: "message") as! String
        self.textLayer = coder.decodeObject(forKey: "textLayer") as! CATextLayer
        self.textColor = (coder.decodeObject(forKey: "textColor") as! NSColor).cgColor
        super.init()
        self.addSublayer(self.textLayer)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.message,forKey: "message")
        coder.encode(self.textLayer,forKey: "textLayer")
        coder.encode(NSColor(cgColor: self.textColor),forKey: "textColor")
        }
        
    private func setPath()
        {
        let aPath = NSBezierPath()
        let someBounds = self.bounds
        let height = someBounds.size.height
        let halfHeight = height / 2.0
        aPath.move(to: NSPoint(x: halfHeight,y: 0))
        aPath.line(to: NSPoint(x: someBounds.size.width - halfHeight,y: 0))
        let center = NSPoint(x: someBounds.size.width - halfHeight,y: halfHeight)
        aPath.appendArc(withCenter: center,radius: halfHeight, startAngle: 180, endAngle: 360, clockwise: false)
        aPath.line(to: NSPoint(x: halfHeight,y: height))
        aPath.line(to: NSPoint(x: 0,y: halfHeight))
        aPath.line(to: NSPoint(x: halfHeight,y: 0))
        self.path = aPath.cgPath
        self.lineWidth = 1.5
        }
    }
