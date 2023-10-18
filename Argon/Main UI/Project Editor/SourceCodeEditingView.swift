//
//  SourceCodeEditingView.swift
//  Argon
//
//  Created by Vincent Coetzee on 23/04/2023.
//

import AppKit
    
public class SourceCodeEditingView: NSView,NSTextViewDelegate,Model,IDEEditorView
    {
    public var editorDelegate: IDEEditorViewDelegate?
        {
        get
            {
            self.sourceView.editorDelegate
            }
        set
            {
            self.sourceView.editorDelegate = newValue
            }
        }
    
    public func beginEditing(node: IDENode?)
        {
        self.sourceView.beginEditing(node: node)
        }

    
    public func endEditing(node: IDENode?)
        {
        self.sourceView.endEditing(node: node)
        }
    
    public var sourceString: String
        {
        get
            {
            fatalError()
            }
        set
            {
            self.sourceView.string = newValue
            self.sourceView.textStorage?.setAttributes([.foregroundColor: StyleTheme.shared.color(for: .colorEditorText)],range: NSRange(location: 0,length: newValue.count))
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
    
    private var sourceView: SourceView!
    private var scrollView: NSScrollView!
    private var _textViewDelegate: NSTextViewDelegate?
    public var dependentKey = DependentSet.nextDependentKey
    public var dependents = DependentSet()
    private var _compilerIssues = CompilerIssues()
    
    public override init(frame: NSRect)
        {
        super.init(frame: frame)
        self.scrollView = SourceView.scrollableTextView()
        self.sourceView = self.scrollView.documentView as? SourceView
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        self.sourceView.configureScrollView()
        self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        self.configureScrollView()
//        self.configureTextView()
        }
        
    public required init?(coder: NSCoder)
        {
        super.init(coder: coder)
//        self.configureScrollView()
//        self.configureTextView()
        }
        
    private func configureScrollView()
        {
        self.wantsLayer = true
        self.layer?.backgroundColor = StyleTheme.shared.color(for: .colorEditorBackground).cgColor
        self.scrollView = SourceView.scrollableTextView()
        self.sourceView = self.scrollView.documentView as? SourceView
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
    private func configureTextView()
        {
//        self.sourceView.drawsBackground = false
////        self.scrollView.documentView = self.sourceView
//        self.sourceView.font = StyleTheme.shared.font(for: .fontEditor)
//        self.sourceView.textColor = StyleTheme.shared.color(for: .colorEditorText)
//        self.sourceView.isAutomaticTextCompletionEnabled = false
//        self.sourceView.isAutomaticLinkDetectionEnabled = false
//        self.sourceView.isGrammarCheckingEnabled = false
//        self.sourceView.isContinuousSpellCheckingEnabled = false
//        self.sourceView.isAutomaticQuoteSubstitutionEnabled = false
//        self.sourceView.isAutomaticSpellingCorrectionEnabled = false
//        self.sourceView.isAutomaticDashSubstitutionEnabled = false
//        self.sourceView.isAutomaticDataDetectionEnabled = false
//        self.sourceView.isAutomaticTextReplacementEnabled = false
//        self.sourceView.isEditable = true
//        self.sourceView.wantsLayer = true
//        self.sourceView.isVerticallyResizable = true
//        self.sourceView.isHorizontallyResizable = false
//        self.sourceView.maxSize = NSSize(width: CGFloat.infinity,height: CGFloat.infinity)
//        self.sourceView.textContainerInset = NSSize(width: 0,height: 10)
//        self.sourceView.textContainer?.lineFragmentPadding = 0
//        self.sourceView.textContainer?.containerSize = NSSize(width: 2000,height: CGFloat.infinity)
//        self.sourceView.textContainer?.heightTracksTextView = false
//        self.sourceView.textContainer?.widthTracksTextView = true
//        self.scrollView.verticalRulerView = LineNumberRulerView(withTextView: self.sourceView, foregroundColorStyleElement: .colorLineNumber, backgroundColorStyleElement: .colorEditorBackground)
//        self.scrollView.rulersVisible = true
//        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidEndEditing), name: NSText.didEndEditingNotification, object: self)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidBeginEditing), name: NSText.didBeginEditingNotification, object: self)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChange), name: NSText.didChangeNotification, object: self)
        }
        
//    @objc public func textDidEndEditing(_ notification: Notification)
//        {
//        }
//        
//    @objc public func textDidBeginEditing(_ notification: Notification)
//        {
//        }
//        
//    @objc public func textDidChange(_ notification: Notification)
//        {
//        }
        
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
        
    public func canEdit(node: IDENode?) -> Bool
        {
        if node.isNil
            {
            return(false)
            }
        return(node!.nodeType == .fileNode)
        }
        
    @objc public func handleMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        switch(menuItem.identifier!.rawValue)
            {
            case("showIssues"):
                self.sourceView.showAllCompilerIssues()
                menuItem.title = "Hide Issues"
                menuItem.action = #selector(self.handleMenuItem)
                menuItem.target = self
                return(true)
            case("hideIssues"):
                self.sourceView.hideAllCompilerIssues()
                menuItem.title = "Show Issues"
                menuItem.action = #selector(self.handleMenuItem)
                menuItem.target = self
                return(true)
            case("showInferredTypes"):
                return(true)
            case("hideInferredTypes"):
                return(true)
            case("commentSelection"):
                self.sourceView.toggleCommentsOfCurrentSelection()
                return(true)
            default:
                return(false)
            }
        }
        
    public func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        switch(menuItem.identifier!.rawValue)
            {
            case("showIssues"):
                return(true)
            case("hideIssues"):
                return(true)
            case("showInferredTypes"):
                return(true)
            case("hideInferredTypes"):
                return(true)
            case("commentSelection"):
                return(!self.sourceView.selectionIsEmpty())
            default:
                return(false)
            }
        }
    }

