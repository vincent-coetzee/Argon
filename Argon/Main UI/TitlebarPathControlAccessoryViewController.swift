//
//  TitlebarPathControlAccessoryViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 10/08/2023.
//

import Cocoa

public class TitlebarPathControlAccessoryViewControler: NSTitlebarAccessoryViewController
    {
    public var pathControl: NSPathControl!
    
    public var rightOffset: CGFloat = 0
        {
        didSet
            {
            var frame = self.view.frame
            let width = 200.0
            frame.size.width = width
            self.view.frame = frame
            }
        }
        
    public init()
        {
        super.init(nibName: nil, bundle: nil)
        self.layoutAttribute = .right
        self.pathControl = NSPathControl()
        }
        
    public required init?(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public override func loadView()
        {
        self.view = self.pathControl
        self.automaticallyAdjustsSize = false
        self.view.needsLayout = true
        }
    }
