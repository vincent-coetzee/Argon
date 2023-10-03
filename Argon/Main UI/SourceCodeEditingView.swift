//
//  SourceCodeEditingView.swift
//  Argon
//
//  Created by Vincent Coetzee on 23/04/2023.
//

import AppKit
    
public class SourceCodeEditingView: NSView,NSTextViewDelegate,Model
    {
    public var sourceString: String
        {
        get
            {
            fatalError()
            }
        set
            {
            self.textView.string = newValue
            self.textView.textStorage?.setAttributes([.foregroundColor: StyleTheme.shared.color(for: .colorEditorText)],range: NSRange(location: 0,length: newValue.count))
            }
        }
        
//    public var compilerIssues: CompilerIssues
//        {
//        get
//            {
//            self.textView.compilerIssues
//            }
//        set
//            {
//            self.textView.compilerIssues = newValue
//            }
//        }
        
//    public var sourceEditorDelegate: SourceEditorDelegate?
//        {
//        get
//            {
//            self.textView.sourceEditorDelegate
//            }
//        set
//            {
//            self.textView.sourceEditorDelegate = newValue
//            }
//        }
        
//    public var textViewDelegate: NSTextViewDelegate?
//        {
//        get
//            {
//            self._textViewDelegate
//            }
//        set
//            {
//            self.textView.delegate = self
//            self._textViewDelegate = newValue
//            }
//        }
        
//    public var textFocusDelegate: TextFocusDelegate?
//        {
//        get
//            {
//            self.textView.textFocusDelegate
//            }
//        set
//            {
//            self.textView.textFocusDelegate = newValue
//            }
//        }
    
    private var textView: NSTextView!
    private var scrollView: NSScrollView!
    private var _textViewDelegate: NSTextViewDelegate?
    public var dependentKey = DependentSet.nextDependentKey
    public var dependents = DependentSet()
    private var _compilerIssues = CompilerIssues()
    
    public override init(frame: NSRect)
        {
        super.init(frame: frame)
        self.configureScrollView()
        self.configureTextView()
        }
        
    public required init?(coder: NSCoder)
        {
        super.init(coder: coder)
        self.configureScrollView()
        self.configureTextView()
        }
        
    private func configureScrollView()
        {
        self.wantsLayer = true
        self.layer?.backgroundColor = StyleTheme.shared.color(for: .colorEditorBackground).cgColor
        self.scrollView = NSTextView.scrollableTextView()
        self.textView = self.scrollView.documentView as? NSTextView
        self.scrollView.drawsBackground = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.borderType = .noBorder
        self.scrollView.hasVerticalRuler = true
        self.scrollView.hasVerticalScroller = true
        self.scrollView.hasHorizontalScroller = false
        self.scrollView.autohidesScrollers = true
        self.addSubview(scrollView)
        self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
    private func configureTextView()
        {
        self.textView.drawsBackground = false
        self.scrollView.documentView = self.textView
        self.textView.font = StyleTheme.shared.font(for: .fontEditor)
        self.textView.textColor = StyleTheme.shared.color(for: .colorEditorText)
        self.textView.isAutomaticTextCompletionEnabled = false
        self.textView.isAutomaticLinkDetectionEnabled = false
        self.textView.isGrammarCheckingEnabled = false
        self.textView.isContinuousSpellCheckingEnabled = false
        self.textView.isAutomaticQuoteSubstitutionEnabled = false
        self.textView.isAutomaticSpellingCorrectionEnabled = false
        self.textView.isAutomaticDashSubstitutionEnabled = false
        self.textView.isAutomaticDataDetectionEnabled = false
        self.textView.isAutomaticTextReplacementEnabled = false
        self.textView.isEditable = true
        self.textView.wantsLayer = true
        self.textView.isVerticallyResizable = true
        self.textView.isHorizontallyResizable = false
        self.textView.maxSize = NSSize(width: CGFloat.infinity,height: CGFloat.infinity)
        self.textView.textContainerInset = NSSize(width: 0,height: 10)
        self.textView.textContainer?.lineFragmentPadding = 0
        self.textView.textContainer?.containerSize = NSSize(width: 2000,height: CGFloat.infinity)
        self.textView.textContainer?.heightTracksTextView = false
        self.textView.textContainer?.widthTracksTextView = true
        self.scrollView.verticalRulerView = LineNumberRulerView(withTextView: self.textView, foregroundColorStyleElement: .colorLineNumber, backgroundColorStyleElement: .colorEditorBackground)
        self.scrollView.rulersVisible = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidEndEditing), name: NSText.didEndEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidBeginEditing), name: NSText.didBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChange), name: NSText.didChangeNotification, object: self)
        }
        
    @objc public func textDidEndEditing(_ notification: Notification)
        {
        }
        
    @objc public func textDidBeginEditing(_ notification: Notification)
        {
        }
        
    @objc public func textDidChange(_ notification: Notification)
        {
        }
        
    public func resetCompilerIssues(newIssues: CompilerIssues)
        {
//        self.textView.resetCompilerIssues(newIssues: newIssues)
        }
        
    public func showAllCompilerIssues()
        {
//        self.textView.showAllCompilerIssues()
        }
        
    public func hideAllCompilerIssues()
        {
//        self.textView.hideAllCompilerIssues()
        }
        
    public func shake(aspect: String)
        {
        }
    }

