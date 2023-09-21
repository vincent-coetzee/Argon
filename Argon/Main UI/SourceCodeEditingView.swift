//
//  SourceCodeEditingView.swift
//  Argon
//
//  Created by Vincent Coetzee on 23/04/2023.
//

import Cocoa

public class SourceCodeEditingView: NSView,NSTextViewDelegate,Model
    {
    private var textView: SourceView!
    private var scrollView: NSScrollView!
    
    public var string: String
        {
        get
            {
            self.textView.string
            }
        set
            {
            self.textView.string = newValue
            }
        }
        
    public var tokens: Tokens
        {
        get
            {
            self.textView.tokens
            }
        set
            {
            self.textView.tokens = newValue
            }
        }
        
    public var compilerIssues: CompilerIssues
        {
        get
            {
            self.textView.compilerIssues
            }
        set
            {
            self.textView.compilerIssues = newValue
            }
        }
        
    public var sourceEditorDelegate: SourceEditorDelegate?
        {
        get
            {
            self.textView.sourceEditorDelegate
            }
        set
            {
            self.textView.sourceEditorDelegate = newValue
            }
        }
        
    public var textViewDelegate: NSTextViewDelegate?
        {
        get
            {
            self._textViewDelegate
            }
        set
            {
            self.textView.delegate = self
            self._textViewDelegate = newValue
            }
        }
        
    public var textFocusDelegate: TextFocusDelegate?
        {
        get
            {
            self.textView.textFocusDelegate
            }
        set
            {
            self.textView.textFocusDelegate = newValue
            }
        }
    
    private var _textViewDelegate: NSTextViewDelegate?
    public var dependentKey = DependentSet.nextDependentKey
    public var dependents = DependentSet()
    private var _compilerIssues = CompilerIssues()
    
    public override init(frame: NSRect)
        {
        super.init(frame: frame)
        self.initView()
        }
        
    public required init?(coder: NSCoder)
        {
        super.init(coder: coder)
        self.initView()
        }
        
    private func initView()
        {
        let aView = SourceView(frame: .zero)
        self.textView = aView
        self.scrollView = NSScrollView(frame: .zero)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.borderType = .noBorder
        self.scrollView.hasVerticalRuler = true
        self.scrollView.hasVerticalScroller = true
        self.scrollView.hasHorizontalScroller = false
        self.scrollView.autohidesScrollers = true
        self.scrollView.verticalRulerView = self.textView.rulerView
        self.scrollView.rulersVisible = true
        self.addSubview(scrollView)
        self.scrollView.documentView = self.textView
        self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
    public func resetCompilerIssues(newIssues: CompilerIssues)
        {
        self.textView.resetCompilerIssues(newIssues: newIssues)
        }
        
    public func showAllCompilerIssues()
        {
        self.textView.showAllCompilerIssues()
        }
        
    public func hideAllCompilerIssues()
        {
        self.textView.hideAllCompilerIssues()
        }
        
    public func shake(aspect: String)
        {
        }
    }

