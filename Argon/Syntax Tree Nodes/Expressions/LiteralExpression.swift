//
//  LiteralNode.swift
//  Argon
//
//  Created by Vincent Coetzee on 23/07/2023.
//

import Foundation

public class LiteralExpression: Expression
    {
    private var value: ValueBox = .none
    
    public required init(coder: NSCoder)
        {
        self.value = coder.decodeValueBox(forKey: "value")
        super.init(coder: coder)
        }
        
    public init(value: ValueBox)
        {
        self.value = value
        super.init()
        }
        
    public init(value: String)
        {
        self.value = .string(value)
        super.init()
        }
        
    public init(value: Argon.Integer)
        {
        self.value = .integer(value)
        super.init()
        }
        
    public init(value: Argon.Float)
        {
        self.value = .float(value)
        super.init()
        }
        
    public init(value: Bool)
        {
        self.value = .boolean(value)
        super.init()
        }
        
    public init(value: Class)
        {
        self.value = .class(value)
        super.init()
        }
        
    public init(value: Enumeration)
        {
        self.value = .enumeration(value)
        super.init()
        }
        
    public init(value: Method)
        {
        self.value = .method(value)
        super.init()
        }
        
    public init(value objectInstance: ObjectInstance)
        {
        self.value = .object(objectInstance)
        super.init()
        }
        
    public init(enumeration: Enumeration,enumerationCase: EnumerationCase)
        {
        self.value = .enumerationInstance(enumeration,enumerationCase)
        super.init()
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.value,forKey: "value")
        super.encode(with: coder)
        }
    }
        
extension NSCoder
    {
    public func encode(_ value: ValueBox,forKey key: String)
        {
        switch(value)
            {
            case(.none):
                self.encode(0,forKey: "\(key)_index")
            case(.integer(let integer)):
                self.encode(1,forKey: "\(key)_index")
                self.encode(integer,forKey: "\(key)_integer")
            case(.enumerationInstance(let enumeration,let aCase)):
                self.encode(2,forKey: "\(key)_index")
                self.encode(enumeration,forKey: "\(key)_enumerationInstance_enumeration")
                self.encode(aCase,forKey: "\(key)_enumerationInstance_enumerationCase")
            case(.object(let object)):
                self.encode(3,forKey: "\(key)_index")
                self.encode(object,forKey: "\(key)_object")
            case(.float(let float)):
                self.encode(4,forKey: "\(key)_index")
                self.encode(float,forKey: "\(key)_float")
            case(.symbol(let string)):
                self.encode(5,forKey: "\(key)_index")
                self.encode(string,forKey: "\(key)_symbol")
            case(.string(let string)):
                self.encode(6,forKey: "\(key)_index")
                self.encode(string,forKey: "\(key)_string")
            case(.uInteger(let integer)):
                self.encode(7,forKey: "\(key)_index")
                self.encode(integer,forKey: "\(key)_uinteger")
            case(.boolean(let boolean)):
                self.encode(8,forKey: "\(key)_index")
                self.encode(boolean,forKey: "\(key)_boolean")
            case(.void):
                self.encode(9,forKey: "\(key)_index")
            case(.character(let character)):
                self.encode(10,forKey: "\(key)_index")
                self.encode(character,forKey: "\(key)_character")
            case(.byte(let byte)):
                self.encode(11,forKey: "\(key)_index")
                self.encode(byte,forKey: "\(key)_byte")
            case(.class(let type)):
                self.encode(12,forKey: "\(key)_index")
                self.encode(type,forKey: "\(key)_class")
            case(.method(let method)):
                self.encode(13,forKey: "\(key)_index")
                self.encode(method,forKey: "\(key)_method")
            case(.enumeration(let enumeration)):
                self.encode(14,forKey: "\(key)_index")
                self.encode(enumeration,forKey: "\(key)_enumeration")
            case(.identifier(let identifier)):
                self.encode(15,forKey: "\(key)_index")
                self.encode(identifier,forKey: "\(key)_identifier")
            case(.variable(let variable)):
                self.encode(16,forKey: "\(key)_index")
                self.encode(variable,forKey: "\(key)_variable")
            case(.constant(let constant)):
                self.encode(17,forKey: "\(key)_index")
                self.encode(constant,forKey: "\(key)_constant")
            case(.date(let date)):
                self.encode(18,forKey: "\(key)_index")
                self.encode(date.day,forKey: "\(key)_date_day")
                self.encode(date.month,forKey: "\(key)_date_month")
                self.encode(date.year,forKey: "\(key)_date_year")
            case(.time(let time)):
                self.encode(19,forKey: "\(key)_index")
                self.encode(time.hour,forKey: "\(key)_time_hour")
                self.encode(time.minute,forKey: "\(key)_time_minute")
                self.encode(time.second,forKey: "\(key)_time_second")
                self.encode(time.millisecond,forKey: "\(key)_time_millisecond")
            case(.dateTime(let dateTime)):
                self.encode(20,forKey: "\(key)_index")
                self.encode(dateTime.date.day,forKey: "\(key)_dateTime_day")
                self.encode(dateTime.date.month,forKey: "\(key)_dateTime_month")
                self.encode(dateTime.date.year,forKey: "\(key)_dateTime_year")
                self.encode(dateTime.time.hour,forKey: "\(key)_dateTime_hour")
                self.encode(dateTime.time.minute,forKey: "\(key)_dateTime_minute")
                self.encode(dateTime.time.second,forKey: "\(key)_dateTime_second")
                self.encode(dateTime.time.millisecond,forKey: "\(key)_dateTime_millisecond")
            }
        }

    public func decodeValueBox(forKey key: String) -> ValueBox
        {
        let index = self.decodeInteger(forKey: "\(key)_index")
        switch(index)
            {
            case(0):
                return(.none)
            case(1):
                return(.integer(self.decodeInt64(forKey: "\(key)_integer")))
            case(2):
                return(.enumerationInstance(self.decodeObject(forKey: "\(key)_enumerationInstance_enumeration") as! Enumeration,self.decodeObject(forKey: "\(key)_enumerationInstance_enumerationCase") as! EnumerationCase))
            case(3):
                return(.object(self.decodeObject(forKey: "\(key)_object") as! ObjectInstance))
            case(4):
                return(.float(self.decodeDouble(forKey: "\(key)_float")))
            case(5):
                return(.symbol(self.decodeObject(forKey: "\(key)_symbol") as! String))
            case(6):
                return(.string(self.decodeObject(forKey: "\(key)_string") as! String))
            case(7):
                let value = UInt64(bitPattern: self.decodeInt64(forKey: "\(key)_uinteger"))
                return(.uInteger(value))
            case(8):
                return(.boolean(self.decodeBool(forKey: "\(key)_boolean")))
            case(9):
                return(.void)
            case(10):
                return(.character(UInt16(self.decodeInteger(forKey: "\(key)_character"))))
            case(11):
                return(.byte(UInt8(self.decodeInteger(forKey: "\(key)_byte"))))
            case(12):
                return(.class(self.decodeObject(forKey: "\(key)_class") as! Class))
            case(13):
                return(.method(self.decodeObject(forKey: "\(key)_method") as! Method))
            case(14):
                return(.enumeration(self.decodeObject(forKey: "\(key)_enumeration") as! Enumeration))
            case(15):
                return(.identifier(self.decodeObject(forKey: "\(key)_identifier") as! Identifier))
            case(16):
                return(.variable(self.decodeObject(forKey: "\(key)_variable") as! Variable))
            case(17):
                return(.constant(self.decodeObject(forKey: "\(key)_constant") as! Constant))
            case(18):
                let day = self.decodeInteger(forKey: "\(key)_date_day")
                let month = self.decodeInteger(forKey: "\(key)_date_month")
                let year = self.decodeInteger(forKey: "\(key)_date_year")
                return(.date(Argon.Date(day: day,month: month,year: year)))
            case(19):
                let hour = self.decodeInteger(forKey: "\(key)_time_hour")
                let minute = self.decodeInteger(forKey: "\(key)_time_minute")
                let second = self.decodeInteger(forKey: "\(key)_time_second")
                let millisecond = self.decodeInteger(forKey: "\(key)_time_millisecond")
                return(.time(Argon.Time(hour: hour,minute: minute,second: second,millisecond: millisecond)))
            case(20):
                let day = self.decodeInteger(forKey: "\(key)_dateTime_day")
                let month = self.decodeInteger(forKey: "\(key)_dateTime_month")
                let year = self.decodeInteger(forKey: "\(key)_dateTime_year")
                let hour = self.decodeInteger(forKey: "\(key)_dateTime_hour")
                let minute = self.decodeInteger(forKey: "\(key)_dateTime_minute")
                let second = self.decodeInteger(forKey: "\(key)_dateTime_second")
                let millisecond = self.decodeInteger(forKey: "\(key)_dateTime_millisecond")
                return(.dateTime(Argon.DateTime(date: Argon.Date(day: day,month: month,year: year),time: Argon.Time(hour: hour,minute: minute,second: second,millisecond: millisecond))))
            default:
                fatalError()
            }
        }
    }
