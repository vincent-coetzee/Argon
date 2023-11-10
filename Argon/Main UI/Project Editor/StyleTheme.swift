//
//  SourceTheme.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/02/2023.
//

import Foundation
import AppKit

public enum StyleElement
    {
    case colorArray
    case colorAtom
    
    case colorBitSet
    case colorBarBackground
    case colorBackground
    case colorBoolean
    case colorBreakpoint
    case colorBreakpointLine
    case colorByte
    case colorBracketHighlight
    
    case colorCalendrical
    case colorClass
    case colorComment
    case colorConstant
    case colorCharacter
    
    case colorDefault
    case colorDictionary
    
    case colorEditorBackground
    case colorEditorText
    case colorEnumeration

    case colorFloat
    case colorForeground
    case colorFunction
    
    case colorIdentifier
    case colorInteger
    case colorIssue
    case colorIssueLine
    case colorIssueText
    case colorInvocation
    
    case colorKeyword
    
    case colorLine
    case colorLineNumber
    case colorList
    case colorLowlight
    case colorMethod
    case colorMultimethod
    
    case colorName
    case colorNumber
    
    case colorOperator
    case colorOutlinerBackground
    case colorOutlinerText
    
    case colorPath
    case colorProjectControls
    
    case colorSeparator
    case colorSet
    case colorSlot
    case colorString
    case colorSystemEnumeration
    case colorSystemAliasedType
    case colorSystemClass

    case colorText
    case colorTint
    case colorToolbarImage
    case colorToolbarBackground
    case colorToolbarText
    case colorType
    case colorTuple
    
    case fontDefault
    case fontText
    case fontLineNumber
    case fontEditor
    case fontToolbarText
    case fontOutliner
    
    case metric
    case metricLineNumberRulerWidth
    case metricLineNumberIndent
    case metricControlCornerRadius
    case metricOutlinerImageHeight
    }
    
public class StyleTheme
    {
    public static let shared = StyleTheme()
    
    public private(set) var styles: Dictionary<StyleElement,Any>
    
    public init()
        {
        self.styles = [:]
        self.styles[.fontDefault] = NSFont(name: "SunSans-Demi",size: 12)!
        self.styles[.fontOutliner] = NSFont(name: "SunSans-Demi",size: 13)!
        self.styles[.fontToolbarText] = NSFont(name: "SunSans-Regular",size: 10)!
        self.styles[.fontText] = NSFont(name: "SunSans-Regular",size: 11)!
        self.styles[.fontEditor] = NSFont(name: "Menlo-Regular",size: 11)
//        self.styles[.fontEditor] = self.styles[.fontDefault]
        self.styles[.fontLineNumber] = self.styles[.fontEditor]
        
        self.styles[.colorArray] = NSColor.argonYellowSpaghettiSquash
        
        self.styles[.colorBackground] = NSColor.black
        self.styles[.colorBarBackground] = NSColor.argonDarkestGray
        self.styles[.colorBitSet] = NSColor.argonDivaPink
        self.styles[.colorBreakpoint] = NSColor.argonDivaPink
        self.styles[.colorBreakpointLine] = NSColor.argonDivaPink
        self.styles[.colorBoolean] = NSColor.argonBayside
        self.styles[.colorByte] = NSColor.argonXSmoke
        self.styles[.colorBracketHighlight] = NSColor.argonIvory
        
        self.styles[.colorComment] = NSColor.argonCommentPurple
        self.styles[.colorClass] = NSColor.argonLime
        self.styles[.colorCharacter] = NSColor.argonXSmoke
        self.styles[.colorConstant] = NSColor.argonCheese
        
        self.styles[.colorDefault] = NSColor.argonWhite50
        self.styles[.colorCalendrical] = NSColor.argonAtomicBlue
        self.styles[.colorDictionary] = NSColor.argonFreshSalmon
        
        self.styles[.colorEnumeration] = NSColor.argonThemeCyan
        self.styles[.colorEditorBackground] = NSColor.argonBlack20
        self.styles[.colorEditorText] = NSColor.argonStandardPink
        
        self.styles[.colorFunction] = NSColor.argonXSeaBlue
        self.styles[.colorFloat] = NSColor.argonSizzlingRed

//        self.styles[.colorTint] = NSColor.argonLivingCoral

        self.styles[.colorIdentifier] = NSColor.argonNeonGreen
        self.styles[.colorInteger] = NSColor.argonGreenSea
        self.styles[.colorIssue] = NSColor.argonBrightYellowCrayola
        self.styles[.colorIssueLine] = NSColor.argonBrightYellowCrayola
        self.styles[.colorIssueText] = NSColor.black
        self.styles[.colorInvocation] = NSColor.argonWhite90
        
//        self.styles[.colorKeyword] = NSColor(red: 63,green: 149,blue: 116)
        self.styles[.colorKeyword] = NSColor.argonNeonPink
        
        self.styles[.colorLowlight] = NSColor.argonWhite50
        self.styles[.colorLine] = NSColor.argonWhite50
//        self.styles[.colorLineNumber] = NSColor(hex: 0xA0A0A0)
        self.styles[.colorLineNumber] = NSColor(hex: 0x606060)
        self.styles[.colorList] = NSColor.argonBluestone
        
        self.styles[.colorMethod] = NSColor.white
        self.styles[.colorMultimethod] = NSColor.white
        
        self.styles[.colorName] = NSColor.argonXIvory
        
        self.styles[.colorOperator] = NSColor.argonFulvous
        self.styles[.colorOutlinerBackground] = NSColor.windowBackgroundColor
        self.styles[.colorOutlinerText] = NSColor.argonWhite80
        
        self.styles[.colorProjectControls] = NSColor.argonWhite40
        
        self.styles[.colorSet] = NSColor.argonOrangeClownFish
        self.styles[.colorSystemClass] = NSColor.argonBrightYellowCrayola
        self.styles[.colorSlot] = NSColor.argonCoral
        self.styles[.colorString] = NSColor.argonLivingCoral
        self.styles[.colorAtom] = NSColor.argonSalmonPink
        self.styles[.colorSystemEnumeration] = NSColor.argonDeepOrange
        self.styles[.colorSystemAliasedType] = NSColor.argonPomelo
        self.styles[.colorSeparator] = NSColor.argonAnnotationOrange

        self.styles[.colorText] = NSColor.argonThemePink
        self.styles[.colorTint] = NSColor.controlAccentColor
        self.styles[.colorToolbarText] = NSColor.argonWhite50
        self.styles[.colorToolbarImage] = NSColor.controlAccentColor
        self.styles[.colorToolbarBackground] = NSColor.argonWhite25
        self.styles[.colorType] = NSColor.argonXIvory
        self.styles[.colorTuple] = NSColor.argonPomelo

//        self.styles[.colorWarning] = NSColor.argonBrightYellowCrayola
//        self.styles[.colorWarning] = NSColor.argonSunglow
//        self.styles[.colorWarning] = NSColor.argonDeepOrange
        
        self.styles[.metricLineNumberRulerWidth] = CGFloat(30 + 10)
        self.styles[.metricLineNumberIndent] = CGFloat(6)
        self.styles[.metricControlCornerRadius] = CGFloat(4)
        self.styles[.metricOutlinerImageHeight] = CGFloat(16)
        }
        
    public func set(font: NSFont,for: StyleElement)
        {
        self.styles[`for`] = font
        }
        
    public func set(color: NSColor,for: StyleElement)
        {
        self.styles[`for`] = color
        }
        
    public func set(metric: Int,for: StyleElement)
        {
        self.styles[`for`] = metric
        }
        
    public func font(`for` element: StyleElement) -> NSFont
        {
        self.styles[element] as! NSFont
        }
        
    public func font(`for` element: StyleElement,size: CGFloat) -> NSFont
        {
        (self.styles[element] as! NSFont).withSize(size)
        }
        
    public func color(`for` element: StyleElement) -> NSColor
        {
        self.styles[element] as! NSColor
        }
        
    public func metric(`for` element: StyleElement) -> CGFloat
        {
        self.styles[element] as! CGFloat
        }
    }
