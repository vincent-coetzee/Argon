//
//  SourceView.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/02/2023.
//

import Cocoa

public protocol TextFocusDelegate
    {
    func textDidGainFocus(_ textView: NSTextView)
    func textDidLoseFocus(_ textView: NSTextView)
    }
    
public protocol SourceEditorDelegate
    {
    func sourceEditorKeyPressed(_ editor: NSTextView)
    func sourceEditor(_ editor: NSTextView,changedLine: Int,offset: Int)
    func sourceEditor(_ editor: NSTextView,changedSource: String)
    }
    
class SourceView: NSTextView
    {
    public var compilerIssues: CompilerIssues
        {
        get
            {
            self._compilerIssues
            }
        set
            {
            self._compilerIssues = newValue
            self.refreshIssueDisplay()
            }
        }
        
    public var tokens: Tokens
        {
        get
            {
            self._tokens
            }
        set
            {
            self._tokens = newValue
            self.refresh()
            }
        }
        
    public private(set) var theme = SourceTheme.shared
    
    private var _tokens = Tokens()
    public private(set) var rulerView: LineNumberRulerView!
    public var textFocusDelegate: TextFocusDelegate?
    public var sourceEditorDelegate: SourceEditorDelegate?
    private var _compilerIssues = CompilerIssues()
    
    public override init(frame: NSRect)
        {
        super.init(frame: frame)
        self.initSourceView()
        }
        
    public required init?(coder: NSCoder)
        {
        super.init(coder: coder)
        self.initSourceView()
        }
        
    public override init(frame: NSRect,textContainer: NSTextContainer?)
        {
        super.init(frame: frame,textContainer: textContainer)
        self.initSourceView()
        }
        
    private func initSourceView()
        {
        self.backgroundColor = SourceTheme.shared.color(for: .colorEditorBackground)
        self.font = SourceTheme.shared.font(for: .fontEditor)
        self.textColor = SourceTheme.shared.color(for: .colorEditorText)
        self.isAutomaticTextCompletionEnabled = false
        self.isAutomaticLinkDetectionEnabled = false
        self.isGrammarCheckingEnabled = false
        self.isContinuousSpellCheckingEnabled = false
        self.isAutomaticQuoteSubstitutionEnabled = false
        self.isAutomaticSpellingCorrectionEnabled = false
        self.isAutomaticDashSubstitutionEnabled = false
        self.isAutomaticDataDetectionEnabled = false
        self.isAutomaticTextReplacementEnabled = false
        self.font = SourceTheme.shared.font(for: .fontEditor)
        self.backgroundColor = SourceTheme.shared.color(for: .colorEditorBackground)
        self.isEditable = true
        self.wantsLayer = true
        self.isVerticallyResizable = true
        self.isHorizontallyResizable = false
        self.maxSize = NSSize(width: CGFloat.infinity,height: CGFloat.infinity)
        self.textContainer?.containerSize = NSSize(width: 1000,height: CGFloat.infinity)
        self.textContainer?.widthTracksTextView = true
        self.autoresizingMask = [.width]
        self.rulerView = LineNumberRulerView(withTextView: self, foregroundColorStyleElement: .colorLineNumber, backgroundColorStyleElement: .colorEditorBackground)
        self.rulerView.clientView = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidEndEditing), name: NSText.didEndEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidBeginEditing), name: NSText.didBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChange), name: NSText.didChangeNotification, object: self)
        }
        
    private func refreshIssueDisplay()
        {
        self.rulerView.removeAllIssues()
        self.rulerView.addIssues(self._compilerIssues)
        }
        
    @objc func textDidChange(_ sender: Any?)
        {
        self.sourceEditorDelegate?.sourceEditor(self, changedSource: self.string)
        }
        
    @objc func textDidEndEditing(_ sender: Any?)
        {
        }
        
    @objc func textDidBeginEditing(_ sender: Any?)
        {
        }
        
    private func refresh()
        {
        self.textStorage?.beginEditing()
        let sourceTheme = SourceTheme.shared
        let font = sourceTheme.font(for: .fontEditor)
        for token in self._tokens
            {
            var attributes = Dictionary<NSAttributedString.Key,Any>()
            attributes[.foregroundColor] = sourceTheme.color(for: token.styleElement)
            print("Color is \(sourceTheme.color(for: token.styleElement))")
            attributes[.font] = font
            self.textStorage?.setAttributes(attributes, range: token.location.range)
            }
        self.textStorage?.endEditing()
        self.rulerView.needsDisplay = true
        }
        
    public override func becomeFirstResponder() -> Bool
        {
        self.textFocusDelegate?.textDidGainFocus(self)
        return(true)
        }
        
    public override func resignFirstResponder() -> Bool
        {
        self.textFocusDelegate?.textDidLoseFocus(self)
        super.resignFirstResponder()
        return(true)
        }
        
    public override func insertNewline(_ sender:Any?)
        {
        let location = self.selectedRanges[0].rangeValue.location
        let string = self.string
        let startIndex = string.startIndex
        var currentIndex = string.index(startIndex,offsetBy: location)
        var tabString = ""
        if currentIndex < string.endIndex
            {
            currentIndex = string.index(currentIndex,offsetBy: 1)
            while currentIndex < string.endIndex && string[currentIndex].isWhitespace && string[currentIndex] != "\n"
                {
                if string[currentIndex] == "\t"
                    {
                    tabString += "\t"
                    }
                currentIndex = string.index(after: currentIndex)
                }
            }
//        let range = NSRange(location: location,length: 0)
        self.rulerView.needsDisplay = true
//        self.textStorage?.replaceCharacters(in: range, with: "\n\(tabString)")
        super.insertNewline(sender)
        }
        
    public override func keyDown(with event: NSEvent)
        {
        if event.characters == "="
            {
            let newCharacters = "⇦"
            let newEvent = NSEvent.keyEvent(with: event.type, location: event.locationInWindow, modifierFlags: event.modifierFlags, timestamp: event.timestamp, windowNumber: event.windowNumber, context: nil, characters: newCharacters, charactersIgnoringModifiers: event.charactersIgnoringModifiers!, isARepeat: event.isARepeat, keyCode: event.keyCode)
            self.interpretKeyEvents([newEvent!])
            }
        else
        if event.isARepeat,let someCharacters = event.characters
            {
            let newCharacters = someCharacters + someCharacters + someCharacters + someCharacters
            let newEvent = NSEvent.keyEvent(with: event.type, location: event.locationInWindow, modifierFlags: event.modifierFlags, timestamp: event.timestamp, windowNumber: event.windowNumber, context: nil, characters: newCharacters, charactersIgnoringModifiers: event.charactersIgnoringModifiers!, isARepeat: event.isARepeat, keyCode: event.keyCode)
            self.interpretKeyEvents([newEvent!])
            }
        else
            {
            self.interpretKeyEvents([event])
            }
        var location = self.selectedRanges.first!.rangeValue.location
        var line = 0
        var offset = 0
        let lines = self.string.components(separatedBy: "\n")
        while offset + lines[line].count < location
            {
            offset += lines[line].count + 1
            line += 1
            }
        location = self.selectedRanges.first!.rangeValue.location
        self.sourceEditorDelegate?.sourceEditor(self,changedLine: line + 1,offset: location - offset)
        }
    }
