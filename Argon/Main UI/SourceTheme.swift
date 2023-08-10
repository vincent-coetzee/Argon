//
//  SourceTheme.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/02/2023.
//

import Foundation
import Cocoa

public enum StyleElement
    {
    case fontDefault
    case fontLineNumber
    case fontEditor
    case colorEditorBackground
    case colorEditorText
    case colorDefault
    case metric
    case colorForeground
    case colorBackground
    case colorOutlineBackground
    case colorKeyword
    case colorString
    case colorNumber
    case colorIdentifier
    case colorComment
    case colorEnumeration
    case colorPath
    case colorSymbol
    case colorClass
    case colorInteger
    case colorMethod
    case colorSlot
    case colorSystemClass
    case colorOperator
    case colorFunction
    case colorType
    case colorConstant
    case colorCharacter
    case colorLineNumber
    case colorBoolean
    case colorByte
    case colorName
    case colorFloat
    case colorText
    case colorWarning
    case colorError
    case colorSystemEnumeration
    case colorSystemAliasedType
    case colorSeparator
    case colorDate
    case colorTime
    case colorDateTime
    case colorBarBackground
    case colorTint
    case metricLineNumberRulerWidth
    case metricLineNumberIndent
    }
    
public class SourceTheme
    {
    public static let `default` = SourceTheme()
    
    public private(set) var styles: Dictionary<StyleElement,Any>
    
    public init()
        {
        self.styles = [:]
        self.styles[.fontDefault] = NSFont(name: "SunSans-Demi",size: 11)!
        self.styles[.colorDefault] = NSColor.controlAccentColor
        self.styles[.colorTint] = NSColor.controlAccentColor
        self.styles[.colorOutlineBackground] = NSColor.black
        self.styles[.fontEditor] = NSFont(name: "Menlo-Regular",size: 11)
        self.styles[.fontLineNumber] = self.styles[.fontEditor]
        self.styles[.colorEditorBackground] = NSColor.argonBlack20
        self.styles[.colorEditorText] = NSColor.argonStandardPink
        self.styles[.colorEnumeration] = NSColor.argonThemeCyan
        self.styles[.colorKeyword] = NSColor(red: 63,green: 149,blue: 116)
        self.styles[.colorText] = NSColor.argonLime
        self.styles[.colorName] = NSColor.argonXIvory
        self.styles[.colorString] = NSColor.argonXBlue
        self.styles[.colorComment] = NSColor(red: 145,green: 92,blue: 176)
        self.styles[.colorClass] = NSColor.argonLime
        self.styles[.colorIdentifier] = NSColor.argonThemePink
        self.styles[.colorInteger] = NSColor.argonZomp
        self.styles[.colorFloat] = NSColor.argonSizzlingRed
        self.styles[.colorSymbol] = NSColor.argonSalmonPink
        self.styles[.colorOperator] = NSColor.argonSalmonPink
        self.styles[.colorSystemClass] = NSColor.argonBrightYellowCrayola
        self.styles[.colorByte] = NSColor.argonXSmoke
        self.styles[.colorCharacter] = NSColor.argonXSmoke
        self.styles[.colorLineNumber] = NSColor(hex: 0xA0A0A0)
        self.styles[.colorType] = NSColor.argonXIvory
        self.styles[.colorMethod] = NSColor.argonNeonOrange
        self.styles[.colorFunction] = NSColor.argonXSeaBlue
        self.styles[.colorBoolean] = NSColor.argonBayside
        self.styles[.colorSlot] = NSColor.argonCoral
        self.styles[.colorConstant] = NSColor.argonCheese
        self.styles[.colorBackground] = NSColor.black
        self.styles[.colorWarning] = NSColor.argonBrightYellowCrayola
        self.styles[.metricLineNumberRulerWidth] = CGFloat(40 + 10)
        self.styles[.metricLineNumberIndent] = CGFloat(10)
        self.styles[.colorWarning] = NSColor.argonSunglow
        self.styles[.colorError] = NSColor.argonSizzlingRed
        self.styles[.colorSystemEnumeration] = NSColor.argonDeepOrange
        self.styles[.colorSystemAliasedType] = NSColor.argonPomelo
        self.styles[.colorSeparator] = NSColor.argonAnnotationOrange
        self.styles[.colorBarBackground] = NSColor.argonDarkestGray
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
        
    public func font(for: StyleElement) -> NSFont
        {
        self.styles[`for`] as! NSFont
        }
        
    public func color(for: StyleElement) -> NSColor
        {
        self.styles[`for`] as! NSColor
        }
        
    public func metric(for: StyleElement) -> CGFloat
        {
        self.styles[`for`] as! CGFloat
        }
    }
