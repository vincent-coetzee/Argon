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
    case colorArray
    
    case colorBitSet
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
    case colorIssueText
    
    case colorKeyword
    
    case colorLine
    case colorLineNumber
    case colorList
    case colorLowlight
    case colorMethod
    
    case colorName
    case colorNumber
    
    case colorOperator
    case colorOutlineBackground
    
    case colorPath
    case colorProjectControls
    
    case colorSeparator
    case colorSet
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
        
        self.styles[.colorArray] = NSColor.argonYellowSpaghettiSquash

        self.styles[.colorBackground] = NSColor.black
        self.styles[.colorBarBackground] = NSColor.argonDarkestGray
        self.styles[.colorBitSet] = NSColor.argonDivaPink
        self.styles[.colorBoolean] = NSColor.argonBayside
        self.styles[.colorByte] = NSColor.argonXSmoke
        
        self.styles[.colorComment] = NSColor.argonSolidPlum
        self.styles[.colorClass] = NSColor.argonLime
        self.styles[.colorCharacter] = NSColor.argonXSmoke
        self.styles[.colorConstant] = NSColor.argonCheese
        
        self.styles[.colorDefault] = NSColor.argonWhite50
        self.styles[.colorDate] = NSColor.argonAtomicBlue
        self.styles[.colorDateTime] = NSColor.argonAtomicBlue
        self.styles[.colorDictionary] = NSColor.argonFreshSalmon
        
        self.styles[.colorEnumeration] = NSColor.argonThemeCyan
        self.styles[.colorEditorBackground] = NSColor.argonBlack20
        self.styles[.colorEditorText] = NSColor.argonStandardPink
        
        self.styles[.colorFunction] = NSColor.argonXSeaBlue
        self.styles[.colorFloat] = NSColor.argonSizzlingRed

//        self.styles[.colorTint] = NSColor.argonLivingCoral

        self.styles[.colorIdentifier] = NSColor.argonThemePink
        self.styles[.colorInteger] = NSColor.argonZomp
        self.styles[.colorIssue] = NSColor.argonBrightYellowCrayola
        self.styles[.colorIssueText] = NSColor.black
        
        self.styles[.colorKeyword] = NSColor(red: 63,green: 149,blue: 116)
        
        self.styles[.colorLowlight] = NSColor.argonWhite50
        self.styles[.colorLine] = NSColor.argonWhite50
        self.styles[.colorLineNumber] = NSColor(hex: 0xA0A0A0)
        self.styles[.colorList] = NSColor.argonBluestone
        
        self.styles[.colorMethod] = NSColor.argonNeonOrange
        
        self.styles[.colorName] = NSColor.argonXIvory
        
        self.styles[.colorOperator] = NSColor.argonSalmonPink
        self.styles[.colorOutlineBackground] = NSColor.windowBackgroundColor
        
        self.styles[.colorProjectControls] = NSColor.argonWhite40
        
        self.styles[.colorSet] = NSColor.argonOrangeClownFish
        self.styles[.colorSystemClass] = NSColor.argonBrightYellowCrayola
        self.styles[.colorSlot] = NSColor.argonCoral
        self.styles[.colorString] = NSColor.argonXBlue
        self.styles[.colorSymbol] = NSColor.argonSalmonPink
        self.styles[.colorSystemEnumeration] = NSColor.argonDeepOrange
        self.styles[.colorSystemAliasedType] = NSColor.argonPomelo
        self.styles[.colorSeparator] = NSColor.argonAnnotationOrange

        self.styles[.colorText] = NSColor.argonLime
        self.styles[.colorTint] = NSColor.controlAccentColor
        self.styles[.colorTime] = NSColor.argonAtomicBlue
        self.styles[.colorToolbarText] = NSColor.argonWhite50
        self.styles[.colorToolbarImage] = NSColor.controlAccentColor
        self.styles[.colorToolbarBackground] = NSColor.argonWhite25
        self.styles[.colorType] = NSColor.argonXIvory

//        self.styles[.colorWarning] = NSColor.argonBrightYellowCrayola
//        self.styles[.colorWarning] = NSColor.argonSunglow
        self.styles[.colorWarning] = NSColor.argonDeepOrange
        
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
        
    public func font(`for` element: StyleElement) -> NSFont
        {
        self.styles[element] as! NSFont
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
