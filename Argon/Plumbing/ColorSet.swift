//
//  LivingColorSet.swift
//  Argon
//
//  Created by Vincent Coetzee on 15/08/2023.
//

import Cocoa

public enum ColorName: String
    {
    case livingCoral
    case fusionCoral
    case burntCoral
    case dustyCoral
    case sugarCoral
    case calypsoCoral
    case coralHaze
    case fieryCoral
    case coralReef
    case sunkistCoral
    case peachNectar
    case tropicalPeach
    case petrolBlue
    case blueCoral
    case cambridgeBlue
    case playfulBlue
    case greenTurquoise
    case tribalTurquoise
    case venerableBlue
    case powderBlue
    case cadetBlue
    case veriPeri
    case ultraViolet
    case royalPurple
    case richPurple
    case pulsatingPurple
    case tribalPlum
    case capstonePurple
    case venerablePlum
    case solidPlum
    case radiantOrchid
    case transAirGreen
    case liteBeigeGreen
    case tealGreen
    case turtleGreen
    case greenSea
    case mattGreen
    case playfulGreen
    case racingGreen
    case darkOliveGreen
    case lovelyLime
    case darkSeaGreen
    case activeSeaGreen
    case tribalSeaGreen
    case activeGreen
    case greenery
    }
    
public class ColorSet
    {
    public struct ColorItem
        {
        public let name: ColorName
        public let color: NSColor
        
        public init(name: ColorName,color: NSColor)
            {
            self.name = name
            self.color = color
            }
        }
        
    public static func initialize()
        {
        self.addColor(.argonLivingCoral,named: .livingCoral)
        self.addColor(.argonFusionCoral,named: .fusionCoral)
        self.addColor(.argonBurntCoral,named: .burntCoral)
        self.addColor(.argonDustyCoral,named: .dustyCoral)
        self.addColor(.argonSugarCoral,named: .sugarCoral)
        self.addColor(.argonCalypsoCoral,named: .calypsoCoral)
        self.addColor(.argonCoralHaze,named: .coralHaze)
        self.addColor(.argonFieryCoral,named: .fieryCoral)
        self.addColor(.argonCoralReef,named: .coralReef)
        self.addColor(.argonSunkistCoral,named: .sunkistCoral)
        
        self.addColor(.argonPeachNectar,named: .peachNectar)
        self.addColor(.argonTropicalPeach,named: .tropicalPeach)
        
        self.addColor(.argonPetrolBlue,named: .petrolBlue)
        self.addColor(.argonBlueCoral,named: .blueCoral)
        self.addColor(.argonCambridgeBlue,named: .cambridgeBlue)
        self.addColor(.argonPlayfulBlue,named: .playfulBlue)
        self.addColor(.argonGreenTurquoise,named: .greenTurquoise)
        self.addColor(.argonTribalTurquoise,named: .tribalTurquoise)
        self.addColor(.argonVenerableBlue,named: .venerableBlue)
        self.addColor(.argonPowderBlue,named: .powderBlue)
        self.addColor(.argonCadetBlue,named: .cadetBlue)
        self.addColor(.argonVeriPeri,named: .veriPeri)
        
        self.addColor(.argonUltraViolet,named: .ultraViolet)
        self.addColor(.argonRoyalPurple,named: .royalPurple)
        self.addColor(.argonPulsatingPurple,named: .pulsatingPurple)
        self.addColor(.argonRichPurple,named: .richPurple)
        self.addColor(.argonTribalPlum,named: .tribalPlum)
        self.addColor(.argonCapstonePurple,named: .capstonePurple)
        self.addColor(.argonSolidPlum,named: .solidPlum)
        self.addColor(.argonVenerablePlum,named: .venerablePlum)
        self.addColor(.argonRadiantOrchid,named: .radiantOrchid)
        
        self.addColor(.argonTransAirGreen,named: .transAirGreen)
        self.addColor(.argonLiteBeigeGreen,named: .liteBeigeGreen)
        self.addColor(.argonTealGreen,named: .tealGreen)
        self.addColor(.argonTurtleGreen,named: .turtleGreen)
        self.addColor(.argonGreenSea,named: .greenSea)
        self.addColor(.argonMattGreen,named: .mattGreen)
        self.addColor(.argonPlayfulGreen,named: .playfulGreen)
        self.addColor(.argonRacingGreen,named: .racingGreen)
        self.addColor(.argonDarkOliveGreen,named: .darkOliveGreen)
        self.addColor(.argonLovelyLime,named: .lovelyLime)
        self.addColor(.argonDarkSeaGreen,named: .darkSeaGreen)
        self.addColor(.argonActiveSeaGreen,named: .activeSeaGreen)
        self.addColor(.argonTribalSeaGreen,named: .tribalSeaGreen)
        self.addColor(.argonActiveGreen,named: .activeGreen)
        self.addColor(.argonGreenery,named: .greenery)
        }
        
    private static var colorSet = Dictionary<ColorName,ColorItem>()
    
    public static func addColor(_ color: NSColor,named: ColorName)
        {
        self.colorSet[named] = ColorItem(name: named,color: color)
        }
    }
