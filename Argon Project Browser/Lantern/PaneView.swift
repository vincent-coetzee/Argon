//
//  PaneView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

class PaneView: NSView
    {
    private let paneLayer = PaneLayer()
    private var isDragging = false
    private var mouseIsDown = false
    private var hand = DragHand()
    private var handOffset:NSPoint = .zero
    private var trackingArea:NSTrackingArea?
    
    override init(frame:NSRect)
        {
        super.init(frame:frame)
        self.wantsLayer = true
        self.layer?.addSublayer(self.paneLayer)
        self.paneLayer.frame = self.layer!.bounds
        self.hand = self.paneLayer.hand
        self.paneLayer.drawsAsynchronously = true
        self.paneLayer.removeAllAnimations()
        self.trackingArea = NSTrackingArea(rect: self.frame, options: [.mouseEnteredAndExited,.activeAlways,.inVisibleRect,.mouseMoved],owner: self, userInfo: nil)
        self.addTrackingArea(self.trackingArea!)
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isFlipped:Bool
        {
        return(true)
        }
        
    public func initDemoPanes()
        {
        self.initDemoTextPanes()
        self.initDemoCompositePanes()
        }
        
    private func initDemoTextPanes()
        {
        var pane = TextPane(text:"Hello World")
        pane.frame = NSRect(origin:NSPoint(x:300,y:300),size: pane.measure())
        pane.font = StylePalette.kDefaultFont
        pane.textColor = StylePalette.kPrimaryTextColor
        var point = NSPoint.random(in: self.bounds)
        print("RANDOM POINT IN BOUNDS \(self.bounds) IS \(point)")
        var borderPane = pane.withBorder()
        borderPane.position = point
        self.addPane(borderPane)
        pane = TextPane(text:"This is a rather long piece of text\nthat will serve as a demonstration of how panes handle\nallsorts of text.\nThe quick brown fox jumped over the lazy dog\nwhich was fast asleep on the couch.")
        pane.frame = NSRect(origin:NSPoint(x:40,y:700),size: pane.measure())
        pane.font = StylePalette.kHeadlineFont
        pane.textColor = StylePalette.kHeadlineTextColor
        point = NSPoint.random(in: self.bounds)
        print("RANDOM POINT IN BOUNDS \(self.bounds) IS \(point)")
        borderPane = pane.withBorder()
        borderPane.position = point
        self.addPane(borderPane)
        }
        
    private func initDemoCompositePanes()
        {
        let titlePane = TitledPane(title:"Classified Items")
        let count = Int.random(in: 5..<15)
        for _ in 0..<count
            {
            let word = EnglishWord.randomWord()
            let element = TextPane(text:word.stringValue)
            titlePane.addKid(element)
            }
        titlePane.layoutToFit()
        titlePane.position = NSPoint.random(in: self.bounds)
        self.addPane(titlePane)
        }
        
    public func addPane(_ pane:Pane)
        {
        pane.layoutToFit()
        self.paneLayer.addPane(pane)
        }
        
    public override func layout()
        {
        super.layout()
        self.paneLayer.frame = self.bounds
        self.paneLayer.layout()
        self.paneLayer.setNeedsLayout()
        self.paneLayer.setNeedsDisplay()
        }
        
    public override func mouseDown(with event:NSEvent)
        {
        self.mouseIsDown = true
        let localPoint = self.convert(event.locationInWindow,from:nil)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.paneLayer.dragTo(localPoint)
        if let pane = self.paneLayer.paneUnder(point:localPoint)
            {
            self.hand.collectDragPane(pane,atPoint:localPoint,inLayer:self.layer!)
            }
        self.paneLayer.displayIfNeeded()
        CATransaction.commit()
        }
        

        
    public override func mouseDragged(with event:NSEvent)
        {
        let localPoint = self.convert(event.locationInWindow,from:nil)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.paneLayer.dragTo(localPoint)
        self.paneLayer.displayIfNeeded()
        CATransaction.commit()
        }
        
    public override func mouseUp(with event:NSEvent)
        {
        self.mouseIsDown = false
        let localPoint = self.convert(event.locationInWindow,from:nil)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.paneLayer.dragTo(localPoint)
        self.hand.dropDragPane(atPoint:localPoint,inLayer:self.layer!)
        self.paneLayer.displayIfNeeded()
        CATransaction.commit()
        }
        
    public override func mouseMoved(with event:NSEvent)
        {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let localPoint = self.convert(event.locationInWindow,from:nil)
        self.paneLayer.dragTo(localPoint)
        self.paneLayer.displayIfNeeded()
        CATransaction.commit()
        }
        
    public override func mouseEntered(with event:NSEvent)
        {
        let localPoint = self.convert(event.locationInWindow,from:nil)
//        self.hand.movePositionTo(localPoint)
        self.paneLayer.moveTo(localPoint)
        }
    }
