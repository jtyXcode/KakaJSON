//
//  JTM_05_CustomValue.swift
//  KakaJSONTests
//
//  Created by MJ Lee on 2019/8/10.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

private let date1Fmt: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd"
    return fmt
}()

private let date2Fmt: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return fmt
}()

class JTM_05_CustomValue: XCTestCase {
    // MARK: - Date
    func testDate() {
        struct Student: Convertible {
            var date1: Date?
            var date2: NSDate?
            
            func kk_modelValue(from jsonValue: Any?,
                               property: Property) -> Any? {
                switch property.name {
                case "date1": return (jsonValue as? String).flatMap(date1Fmt.date)
                // Date to NSDate is a bridging conversion
                case "date2": return (jsonValue as? String).flatMap(date2Fmt.date)
                default: return jsonValue
                }
            }
        }
        
        let date1 = "2008-09-09"
        let date2 = "2011-11-12 14:20:30"
        
        let json: [String: Any] = [
            "date1": date1,
            "date2": date2
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.date1.flatMap(date1Fmt.string) == date1)
        XCTAssert(student?.date2.flatMap(date2Fmt.string) == date2)
    }
    
    // MARK: - Any
    func testAny() {
        class Dog: Convertible {
            var name: String = ""
            var weight: Double = 0.0
            required init() {}
        }
        
        struct Person: Convertible {
            var name: String = ""
            // AnyObject、Convertible
            var pet: Any?
            func kk_modelValue(from jsonValue: Any?,
                               property: Property) -> Any? {
                if property.name != "pet" { return jsonValue }
                return (jsonValue as? [String: Any])?.kk.model(Dog.self)
            }
        }
        
        let name = "Jack"
        let dog = (name: "Wang", weight: 109.5)
        
        let json: [String: Any] = [
            "name": name,
            "pet": ["name": dog.name, "weight": dog.weight]
        ]
        
        let person = json.kk.model(Person.self)
        XCTAssert(person?.name == name)
        
        let pet = person?.pet as? Dog
        XCTAssert(pet?.name == dog.name)
        XCTAssert(pet?.weight == dog.weight)
    }
    
    // MARK: - Array<Any>
    func testAnyArray() {
        class Book: Convertible {
            var name: String = ""
            var price: Double = 0.0
            required init() {}
        }
        
        struct Person: Convertible {
            var name: String = ""
            // [AnyObject]、[Convertible]、NSArray、NSMutableArray
            var books: [Any]?
            
            func kk_modelValue(from jsonValue: Any?,
                               property: Property) -> Any? {
                if property.name != "books" { return jsonValue }
                // if books is `NSMutableArray`, neet convert `Array` to `NSMutableArray`
                // because `Array` to `NSMutableArray` is not a bridging conversion
                return (jsonValue as? [Any])?.kk.modelArray(Book.self)
            }
        }
        
        let name = "Jack"
        let books = [
            (name: "Fast C++", price: 666),
            (name: "Data Structure And Algorithm", price: 1666)
        ]
        
        let json: [String: Any] = [
            "name": name,
            "books": [
                ["name": books[0].name, "price": books[0].price],
                ["name": books[1].name, "price": books[1].price]
            ]
        ]
        
        let person = json.kk.model(Person.self)
        XCTAssert(person?.name == name)
        
        XCTAssert(person?.books?.count == books.count)
        
        let book0 = person?.books?[0] as? Book
        XCTAssert(book0?.name == books[0].name)
        XCTAssert(book0?.price == Double(books[0].price))
        
        let book1 = person?.books?[1] as? Book
        XCTAssert(book1?.name == books[1].name)
        XCTAssert(book1?.price == Double(books[1].price))
    }
    
    // MARK: - Other
    func testOther1() {
        struct Student: Convertible {
            var age: Int = 0
            var name: String = ""
            
            func kk_modelValue(from jsonValue: Any?,
                               property: Property) -> Any? {
                switch property.name {
                case "age": return (jsonValue as? Int).flatMap { $0 + 5 }
                case "name": return (jsonValue as? String).flatMap { "kk_" + $0 }
                default: return jsonValue
                }
            }
        }
        
        let json: [String: Any] = [
            "age": 10,
            "name": "Jack"
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.age == 15)
        XCTAssert(student?.name == "kk_Jack")
    }
    
    func testOther2() {
        struct Student: Convertible {
            var age: Int = 0
            var name: String = ""
            
            mutating func kk_didConvertToModel(from json: JSONObject) {
                age += 5
                name = "kk_" + name
            }
        }
        
        let json: [String: Any] = [
            "age": 10,
            "name": "Jack"
        ]
        
        let student = json.kk.model(Student.self)
        XCTAssert(student?.age == 15)
        XCTAssert(student?.name == "kk_Jack")
    }
}
