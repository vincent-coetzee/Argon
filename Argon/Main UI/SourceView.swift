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
    func sourceEditor(_ editor: NSTextView,changedSource: String,tokens: Tokens)
    }
    
class SourceView: NSTextView
    {
    public var matchBrackets: Bool = true
        
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
        
    public let theme = StyleTheme.shared
    
    private var _tokens = Tokens()
    public private(set) var rulerView: LineNumberRulerView!
    public var textFocusDelegate: TextFocusDelegate?
    public var sourceEditorDelegate: SourceEditorDelegate?
    private var _compilerIssues = CompilerIssues()
    private var activeAnnotations = Dictionary<Int,CALayer>()
    private var bracketMatcher: BracketMatcher!
    
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
        self.backgroundColor = StyleTheme.shared.color(for: .colorEditorBackground)
        self.font = StyleTheme.shared.font(for: .fontEditor)
        self.textColor = StyleTheme.shared.color(for: .colorEditorText)
        self.isAutomaticTextCompletionEnabled = false
        self.isAutomaticLinkDetectionEnabled = false
        self.isGrammarCheckingEnabled = false
        self.isContinuousSpellCheckingEnabled = false
        self.isAutomaticQuoteSubstitutionEnabled = false
        self.isAutomaticSpellingCorrectionEnabled = false
        self.isAutomaticDashSubstitutionEnabled = false
        self.isAutomaticDataDetectionEnabled = false
        self.isAutomaticTextReplacementEnabled = false
        self.font = StyleTheme.shared.font(for: .fontEditor)
        self.backgroundColor = StyleTheme.shared.color(for: .colorEditorBackground)
        self.isEditable = true
        self.wantsLayer = true
        self.isVerticallyResizable = true
        self.isHorizontallyResizable = false
        self.maxSize = NSSize(width: CGFloat.infinity,height: CGFloat.infinity)
        self.textContainerInset = NSSize(width: 0,height: 10)
        self.textContainer?.lineFragmentPadding = 0
        self.textContainer?.containerSize = NSSize(width: 1000,height: CGFloat.infinity)
        self.textContainer?.widthTracksTextView = true
        self.autoresizingMask = [.width]
        self.rulerView = LineNumberRulerView(withTextView: self, foregroundColorStyleElement: .colorLineNumber, backgroundColorStyleElement: .colorEditorBackground)
        self.rulerView.clientView = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidEndEditing), name: NSText.didEndEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidBeginEditing), name: NSText.didBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChange), name: NSText.didChangeNotification, object: self)
        }
        
    public func resetCompilerIssues(newIssues: CompilerIssues)
        {
        for annotation in self.activeAnnotations.values
            {
            annotation.removeFromSuperlayer()
            }
        self._compilerIssues = newIssues
        self.refreshIssueDisplay()
        }
        
    private func toggleIssueDisplay(`for` issue: CompilerIssue)
        {
        if self.activeAnnotations[issue.location.line].isNotNil
            {
            self.hideAnnotation(for: issue)
            }
        else
            {
            self.showAnnotation(for: issue)
            }
        }
        
    public func hideAnnotation(`for` issue: CompilerIssue)
        {
        let line = issue.location.line
        if let layer = self.activeAnnotations[line]
            {
            layer.removeFromSuperlayer()
            self.activeAnnotations[line] = nil
            return
            }
        }
        
    public func showAnnotation(`for` issue: CompilerIssue)
        {
        let line = issue.location.line
        if self.activeAnnotations[line].isNotNil
            {
            return
            }
        let newLayer = CATextLayer()
        newLayer.string = issue.message
        newLayer.backgroundColor = StyleTheme.shared.color(for: .colorIssue).cgColor
        newLayer.foregroundColor = StyleTheme.shared.color(for: .colorIssueText).cgColor
        newLayer.frame = self.endOfLineRect(forLine: line)
        var layerFrame = newLayer.frame
        if layerFrame.origin.x + 10 < self.bounds.maxX
            {
            layerFrame.origin.x += 10
            layerFrame.size.width -= 10
            }
        let font = StyleTheme.shared.font(for: .fontEditor)
        let attributes: [NSAttributedString.Key:Any] = [.backgroundColor:StyleTheme.shared.color(for: .colorIssue),.foregroundColor: StyleTheme.shared.color(for: .colorIssueText),.font: font]
        let size = NSAttributedString(string: issue.message,attributes: attributes).size()
        newLayer.font = font
        newLayer.fontSize = font.pointSize
        if layerFrame.size.width + 8 > size.width
            {
            layerFrame.size.width = size.width + 8
            }
        newLayer.frame = layerFrame
        self.layer?.addSublayer(newLayer)
        self.activeAnnotations[line] = newLayer
        }
        
    public func showAllCompilerIssues()
        {
        for issue in self.compilerIssues
            {
            self.showAnnotation(for: issue)
            }
        }
        
    public func hideAllCompilerIssues()
        {
        for issue in self.compilerIssues
            {
            self.hideAnnotation(for: issue)
            }
        }
        
    private func refreshIssueDisplay()
        {
        self.rulerView.removeAllIssues()
        self.rulerView.addIssues(self._compilerIssues)
        }
        
    @objc func textDidChange(_ sender: Any?)
        {
        let theString = self.string
        let scanner = ArgonScanner(source: theString)
        let someTokens = scanner.allTokens()
        self.bracketMatcher = scanner.bracketMatcher
        self._tokens = someTokens
        self.sourceEditorDelegate?.sourceEditor(self, changedSource: theString,tokens: someTokens)
        self.refresh()
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
        let sourceTheme = StyleTheme.shared
        let font = sourceTheme.font(for: .fontEditor)
        for token in self._tokens
            {
            var attributes = Dictionary<NSAttributedString.Key,Any>()
            attributes[.foregroundColor] = sourceTheme.color(for: token.styleElement)
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
        self.rulerView.needsDisplay = true
        super.insertNewline(sender)
        }
        
    public func endOfLineRect(forLine: Int) -> CGRect
        {
        var line = 0
        let text = self.string
        var index = text.startIndex
        while index < text.endIndex && line < forLine
            {
            if text[index] == "\n"
                {
                line += 1
                }
            index = text.index(index, offsetBy: 1)
            }
        let characterIndex = text.distance(from: text.startIndex,to: index) - 1
        let glyphIndex = self.layoutManager!.glyphIndexForCharacter(at: characterIndex)
        let range = NSRange(location: glyphIndex,length: 1)
        var rect = self.layoutManager!.boundingRect(forGlyphRange: range, in: self.textContainer!)
        rect.size.width = max(rect.size.width,self.bounds.size.width - 4)
        rect.size.height = self.font!.lineHeight
        rect.origin.y += self.textContainerInset.height
        return(rect)
        }
        
    public override func keyDown(with event: NSEvent)
        {
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
        if self.matchBrackets
            {
            if let bracketKind = event.characters?.bracketKind,let locations = self.bracketMatcher.locateMatch(for: bracketKind, at: location)
                {
                self.highlightCharacters(atLocations: locations,forMilliseconds: 1000,inColor: StyleTheme.shared.color(for: .colorBracketHighlight))
                }
            }
        self.sourceEditorDelegate?.sourceEditor(self,changedLine: line + 1,offset: location - offset)
        }
        
    private func highlightCharacters(atLocations locations: (Location,Location),forMilliseconds: Int,inColor: NSColor)
        {
        self.textStorage?.beginEditing()
        let styleTheme = StyleTheme.shared
        let font = styleTheme.font(for: .fontEditor)
        let boldFont = NSFontManager.shared.convert(font,toHaveTrait: .boldFontMask)
        var attributes = Dictionary<NSAttributedString.Key,Any>()
        attributes[.backgroundColor] = inColor
        attributes[.font] = boldFont
        self.textStorage?.setAttributes(attributes, range: locations.0.range)
        self.textStorage?.setAttributes(attributes, range: locations.1.range)
        self.textStorage?.endEditing()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(forMilliseconds))
            {
            [weak self] in
            self?.textStorage?.beginEditing()
            var attributes = Dictionary<NSAttributedString.Key,Any>()
            attributes[.backgroundColor] = self?.backgroundColor
            attributes[.font] = font
            self?.textStorage?.setAttributes(attributes, range: locations.0.range)
            self?.textStorage?.setAttributes(attributes, range: locations.1.range)
            self?.textStorage?.endEditing()
            }
        }
        
    public override func rulerView(_ rulerView: NSRulerView,handleMouseDownWith event: NSEvent)
        {
        var location = self.convert(event.locationInWindow,from: nil)
        let lineNumberRuler = rulerView as! LineNumberRulerView
        location = rulerView.convert(location,from: self)
        if let issue = lineNumberRuler.issueContainingPoint(location)
            {
            self.toggleIssueDisplay(for: issue)
            }
        }
    }
