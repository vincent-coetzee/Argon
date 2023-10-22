//
//  LineNumberRuler.swift
//  ArgonWorks
//
//  Created by Vincent Coetzee on 10/4/22.
//

import AppKit

/// Adds line numbers to a NSTextField.
public class LineNumberRulerView: NSRulerView
    {
    public var issues: CompilerIssues = []
        {
        willSet
            {
            self.removeAllIssues()
            self.needsDisplay = true
            }
        didSet
            {
            for issue in self.issues
                {
                self.addIssue(issue)
                }
            self.needsDisplay = true
            }
        }
        
    public var font: NSFont = StyleTheme.shared.font(for: .fontLineNumber)
        {
        didSet
            {
            self.needsDisplay = true
            }
        }
        
    private var lineNumberOffsets = Array<CGFloat>()
    /// Contains a true value for every line that is annotated or nil otherwise
    private var annotatedLines = Dictionary<Int,NSRulerMarker>()
    /// Holds the height of a line
    internal var lineHeight: CGFloat = 0
    /// Holds the number of lines
    internal var totalLineCount = 0
    /// Holds the background color.
    internal var backgroundColorStyleElement: StyleElement
        {
        didSet
            {
            self.needsDisplay = true
            }
        }

    /// Holds the text color.
    internal var foregroundColorStyleElement: StyleElement
        {
        didSet
            {
            self.needsDisplay = true
            }
        }

    ///  Initializes a LineNumberGutter with the given attributes.
    ///
    ///  - parameter textView:        NSTextView to attach the LineNumberGutter to.
    ///  - parameter foregroundColor: Defines the foreground color.
    ///  - parameter backgroundColor: Defines the background color.
    ///
    ///  - returns: An initialized LineNumberGutter object.
    init(withTextView textView: NSTextView,foregroundColorStyleElement: StyleElement, backgroundColorStyleElement: StyleElement)
        {
        // Set the color preferences.
        self.backgroundColorStyleElement = backgroundColorStyleElement
        self.foregroundColorStyleElement = foregroundColorStyleElement
        // Make sure everything's set up properly before initializing properties.
        super.init(scrollView: textView.enclosingScrollView, orientation: .verticalRuler)
        // Set the rulers clientView to the supplied textview.
        self.clientView = textView
        // Define the ruler's width.
        self.ruleThickness = StyleTheme.shared.metric(for: .metricLineNumberRulerWidth)
//        self.reservedThicknessForMarkers = 18
        }

    required init(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    ///  Draws the line numbers.
    ///
    ///  - parameter rect: NSRect to draw the gutter view in.
    public override func drawHashMarksAndLabels(in rect: NSRect)
        {
        // Default the lineHeight to the font's lineHeight until lineHeight id calculated
        self.lineHeight = self.font.lineHeight
        self.lineNumberOffsets = []
        // Set the current background color...
        StyleTheme.shared.color(for: self.backgroundColorStyleElement).set()
        // ...and fill the given rect.
        var rulerRect = rect
        rulerRect.size.width = StyleTheme.shared.metric(for: .metricLineNumberRulerWidth)
        rulerRect.fill()
        // Unwrap the clientView, the layoutManager and the textContainer, since we'll need
        // them sooner or later.
        guard let textView = self.clientView as? NSTextView,let layoutManager = textView.layoutManager,let textContainer = textView.textContainer else
            {
            return
            }
        let content = textView.string
        // Get the range of the currently visible glyphs.
        let visibleGlyphsRange = layoutManager.glyphRange(forBoundingRect: textView.visibleRect, in: textContainer)
        // Check how many lines are out of the current bounding rect.
        var lineNumber: Int = 1
        do
            {
            // Define a regular expression to find line breaks.
            let newlineRegex = try NSRegularExpression(pattern: "\n", options: [])
            // Check how many lines are out of view; From the glyph at index 0
            // to the first glyph in the visible rect.
            lineNumber += newlineRegex.numberOfMatches(in: content, options: [], range: NSMakeRange(0, visibleGlyphsRange.location))
            }
        catch
            {
            return
            }
        // Get the index of the first glyph in the visible rect, as starting point...
        var firstGlyphOfLineIndex = visibleGlyphsRange.location
        // ...then loop through all visible glyphs, line by line.

        while firstGlyphOfLineIndex < NSMaxRange(visibleGlyphsRange)
            {
            // Get the character range of the line we're currently in.
            let charRangeOfLine  = (content as NSString).lineRange(for: NSRange(location: layoutManager.characterIndexForGlyph(at: firstGlyphOfLineIndex), length: 0))
            // Get the glyph range of the line we're currently in.
            let glyphRangeOfLine = layoutManager.glyphRange(forCharacterRange: charRangeOfLine, actualCharacterRange: nil)
            var firstGlyphOfRowIndex = firstGlyphOfLineIndex
            var lineWrapCount = 0
            // Loop through all rows (soft wraps) of the current line.
            while firstGlyphOfRowIndex < NSMaxRange(glyphRangeOfLine)
                {
                // The effective range of glyphs within the current line.
                var effectiveRange = NSRange(location: 0, length: 0)
                // Get the rect for the current line fragment.
                let lineRect = layoutManager.lineFragmentRect(forGlyphAt: firstGlyphOfRowIndex, effectiveRange: &effectiveRange, withoutAdditionalLayout: true)
                self.lineHeight = lineRect.height
//                self.reservedThicknessForMarkers = self.lineHeight + 2 + 2
                // Draw the current line number;
                // When lineWrapCount > 0 the current line spans multiple rows.
                if lineWrapCount == 0
                    {
                    self.drawLineNumber(number: lineNumber, atYPosition: lineRect.minY)
                    self.lineNumberOffsets.append(lineRect.minY + lineRect.height / 2)
//                    self.lineNumberRects[lineNumber] = NSRect(x:0,y: lineRect.minY,width: 100,height: lineHeight)
                    }
                else
                    {
                    break
                    }
                // Move to the next row.
                firstGlyphOfRowIndex = NSMaxRange(effectiveRange)
                lineWrapCount += 1
                }
            // Move to the next line.
            firstGlyphOfLineIndex = NSMaxRange(glyphRangeOfLine)
            lineNumber += 1
            }
          // Draw another line number for the extra line fragment.
        if let _ = layoutManager.extraLineFragmentTextContainer
            {
            self.drawLineNumber(number: lineNumber, atYPosition: layoutManager.extraLineFragmentRect.minY)
            self.lineNumberOffsets.append(layoutManager.extraLineFragmentRect.minY + layoutManager.extraLineFragmentRect.height / 2)
            self.totalLineCount = lineNumber
            lineNumber += 1
            }
        // Fill in the line numbers from the end of the lines to the end of the ruler
        var lineOffset = layoutManager.extraLineFragmentRect.minY + self.lineHeight
        while lineOffset < self.bounds.size.height
            {
            self.drawLineNumber(number: lineNumber, atYPosition: lineOffset)
            self.lineNumberOffsets.append(lineOffset)
            lineNumber += 1
            lineOffset += self.lineHeight
            }

        }
    ///
    ///  - parameter rect: NSRect to draw the gutter view in.
    internal func find(lineNumber line:inout Int,andRectangle rectangle:inout NSRect,forPoint point: NSPoint)
        {
        guard let textView      = self.clientView as? NSTextView,
              let layoutManager = textView.layoutManager,
              let textContainer = textView.textContainer
        else
            {
            return
            }
        let content = textView.string
        // Get the range of the currently visible glyphs.
        let visibleGlyphsRange = layoutManager.glyphRange(forBoundingRect: textView.visibleRect, in: textContainer)

        // Check how many lines are out of the current bounding rect.
        var lineNumber: Int = 1
        do
            {
            // Define a regular expression to find line breaks.
            let newlineRegex = try NSRegularExpression(pattern: "\n", options: [])
            // Check how many lines are out of view; From the glyph at index 0
            // to the first glyph in the visible rect.
            lineNumber += newlineRegex.numberOfMatches(in: content, options: [], range: NSMakeRange(0, visibleGlyphsRange.location))
            }
        catch
            {
            lineNumber += 1
            return
            }

        // Get the index of the first glyph in the visible rect, as starting point...
        var firstGlyphOfLineIndex = visibleGlyphsRange.location

        // ...then loop through all visible glyphs, line by line.
        while firstGlyphOfLineIndex < NSMaxRange(visibleGlyphsRange)
            {
            // Get the character range of the line we're currently in.
            let charRangeOfLine  = (content as NSString).lineRange(for: NSRange(location: layoutManager.characterIndexForGlyph(at: firstGlyphOfLineIndex), length: 0))
            // Get the glyph range of the line we're currently in.
            let glyphRangeOfLine = layoutManager.glyphRange(forCharacterRange: charRangeOfLine, actualCharacterRange: nil)

            var firstGlyphOfRowIndex = firstGlyphOfLineIndex
            var lineWrapCount        = 0

            // Loop through all rows (soft wraps) of the current line.
            while firstGlyphOfRowIndex < NSMaxRange(glyphRangeOfLine)
                {
                // The effective range of glyphs within the current line.
                var effectiveRange = NSRange(location: 0, length: 0)
                // Get the rect for the current line fragment.
                let lineRect = layoutManager.lineFragmentRect(forGlyphAt: firstGlyphOfRowIndex, effectiveRange: &effectiveRange, withoutAdditionalLayout: true)
                // Draw the current line number;
                // When lineWrapCount > 0 the current line spans multiple rows.
                if lineWrapCount != 0
                    {
                    break
                    }
                if lineRect.minY >= point.y
                    {
                    rectangle = lineRect
                    line = lineNumber
                    return
                    }
                // Move to the next row.
                firstGlyphOfRowIndex = NSMaxRange(effectiveRange)
                lineWrapCount += 1
                }
            // Move to the next line.
            firstGlyphOfLineIndex = NSMaxRange(glyphRangeOfLine)
            lineNumber += 1
            }
        }
    
    func drawLineNumber(number: Int, atYPosition yPos: CGFloat)
        {
        // Unwrap the text view.
        guard let textView = self.clientView as? NSTextView else
            {
            return
            }
        let font = StyleTheme.shared.font(for: .fontLineNumber)
        // Define attributes for the attributed string.
        let marker = self.annotatedLines[number]
        let color = marker.isNotNil ? marker!.color : StyleTheme.shared.color(for: self.foregroundColorStyleElement)
        let attrs = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        // Define the attributed string.
        let attributedString = NSAttributedString(string: "\(number)", attributes: attrs)
        // Get the NSZeroPoint from the text view.
        let relativePoint    = self.convert(NSZeroPoint, from: textView)
        // Calculate the x position, within the gutter.
        let xPosition = StyleTheme.shared.metric(for: .metricLineNumberRulerWidth) - (attributedString.size().width)
        // Draw the attributed string to the calculated point.
        attributedString.draw(at: NSPoint(x: xPosition - StyleTheme.shared.metric(for: .metricLineNumberIndent), y: relativePoint.y + yPos + textView.textContainerInset.height))
        }
        
    public func offset(forLine line: Int) -> CGFloat?
        {
        if line - 1 >= self.lineNumberOffsets.count
            {
            return(nil)
            }
        guard let textView = self.clientView as? NSTextView else
            {
            return(nil)
            }
        return(self.lineNumberOffsets[line - 1] + textView.textContainerInset.height)
        }

    public func addIssue(_ issue: CompilerIssue)
        {
        if let marker = self.rulerMarker(from: issue)
            {
            self.addMarker(marker)
            self.annotatedLines[issue.location.line] = marker
            self.needsDisplay = true
            }
        }
        
    public func issueContainingPoint(_ point: NSPoint) -> CompilerIssue?
        {
        for marker in (self.markers ?? [])
            {
            if marker.imageRectInRuler.contains(point)
                {
                return(marker.representedObject as? CompilerIssue)
                }
            }
        return(nil)
        }
        
    public func rulerMarker(from issue: CompilerIssue) -> NSRulerMarker?
        {
        var image = NSImage(named: "IconMarker")!
        image.isTemplate = true
        image = image.image(withTintColor: StyleTheme.shared.color(for: .colorIssue))
        image.size = NSSize(width: self.lineHeight,height: self.lineHeight)
        guard let offset = self.offset(forLine: issue.location.line) else
            {
            return(nil)
            }
        let marker = NSRulerMarker(rulerView: self, markerLocation: offset, image: image, imageOrigin: NSPoint(x: 0,y: self.lineHeight / 2))
        self.annotatedLines[issue.location.line] = marker
        marker.representedObject = issue as NSCopying
        return(marker)
        }
        
    public func addIssues(_ issues: CompilerIssues)
        {
        for issue in issues
            {
            self.addIssue(issue)
            }
        }
        
    public func removeAllIssues()
        {
        self.annotatedLines = Dictionary<Int,NSRulerMarker>()
        let some = self.markers ?? []
        for marker in some
            {
            self.removeMarker(marker)
            }
        }
    }
