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
    case colorBarBackground
    case colorBackground
    case colorBoolean
    case colorByte
    
    case colorClass
    case colorComment
    case colorConstant
    case colorCharacter
    
    case colorDate
    case colorDateTime
    case colorDefault
    
    case colorEditorBackground
    case colorEditorText
    case colorEnumeration

    case colorFloat
    case colorForeground
    case colorFunction
    
    case colorIdentifier
    case colorInteger
    case colorIssue

    case colorLine
    
    case colorKeyword

    case colorLineNumber
    case colorLowlight
    case colorMethod
    
    case colorName
    case colorNumber
    
    case colorOperator
    case colorOutlineBackground
    
    case colorPath
    case colorProjectControls
    
    case colorSeparator
    case colorSlot
    case colorString
    case colorSymbol
    case colorSystemEnumeration
    case colorSystemAliasedType
    case colorSystemClass

    case colorText
    case colorTime
    case colorTint
    case colorToolbarImage
    case colorToolbarBackground
    case colorToolbarText
    case colorType
    
    case colorWarning
    
    case fontDefault
    case fontText
    case fontLineNumber
    case fontEditor
    case fontToolbarText
    
    case metric
    case metricLineNumberRulerWidth
    case metricLineNumberIndent
    case metricControlCornerRadius
    }
    
public class SourceTheme
    {
    public static let shared = SourceTheme()
    
    public private(set) var styles: Dictionary<StyleElement,Any>
    
    public init()
        {
        self.styles = [:]
        self.styles[.fontDefault] = NSFont(name: "SunSans-Demi",size: 11)!
        self.styles[.fontToolbarText] = NSFont(name: "SunSans-Regular",size: 10)!
        self.styles[.fontText] = NSFont(name: "SunSans-Regular",size: 10)!
        self.styles[.fontEditor] = NSFont(name: "Menlo-Regular",size: 11)
        self.styles[.fontLineNumber] = self.styles[.fontEditor]
        
        self.styles[.colorProjectControls] = NSColor.argonWhite40
        self.styles[.colorLowlight] = NSColor.argonWhite50
        self.styles[.colorLine] = NSColor.argonWhite50
        self.styles[.colorToolbarText] = NSColor.argonWhite50
        self.styles[.colorToolbarImage] = NSColor.controlAccentColor
        self.styles[.colorToolbarBackground] = NSColor.argonWhite25
        self.styles[.colorDefault] = NSColor.argonWhite50
//        self.styles[.colorTint] = NSColor.controlAccentColor
        self.styles[.colorTint] = NSColor.argonLivingCoral
        self.styles[.colorOutlineBackground] = NSColor.windowBackgroundColor
        self.styles[.colorEditorBackground] = NSColor.argonBlack20
        self.styles[.colorEditorText] = NSColor.argonStandardPink
        self.styles[.colorEnumeration] = NSColor.argonThemeCyan
        self.styles[.colorKeyword] = NSColor(red: 63,green: 149,blue: 116)
        self.styles[.colorText] = NSColor.argonLime
        self.styles[.colorName] = NSColor.argonXIvory
        self.styles[.colorString] = NSColor.argonXBlue
        self.styles[.colorComment] = NSColor.argonSolidPlum
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
//        self.styles[.colorWarning] = NSColor.argonBrightYellowCrayola
//        self.styles[.colorWarning] = NSColor.argonSunglow
        self.styles[.colorWarning] = NSColor.argonDeepOrange
        self.styles[.colorIssue] = NSColor.argonSizzlingRed
        self.styles[.colorSystemEnumeration] = NSColor.argonDeepOrange
        self.styles[.colorSystemAliasedType] = NSColor.argonPomelo
        self.styles[.colorSeparator] = NSColor.argonAnnotationOrange
        self.styles[.colorBarBackground] = NSColor.argonDarkestGray
        
        self.styles[.metricLineNumberRulerWidth] = CGFloat(40 + 10)
        self.styles[.metricLineNumberIndent] = CGFloat(10)
        self.styles[.metricControlCornerRadius] = CGFloat(4)
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
