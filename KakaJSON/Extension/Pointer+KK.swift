//
//  Pointer+KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/8/1.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

extension UnsafePointer {
    var kk_raw: UnsafeRawPointer {
        return UnsafeRawPointer(self)
    }
    var kk_mutable: UnsafeMutablePointer<Pointee> {
        return UnsafeMutablePointer(mutating: self)
    }
}

extension UnsafeMutablePointer {
    var kk_raw: UnsafeMutableRawPointer {
        return UnsafeMutableRawPointer(self)
    }
    
    var kk_immutable: UnsafePointer<Pointee> {
        return UnsafePointer(self)
    }
}

extension UnsafeRawPointer {
    var kk_mutable: UnsafeMutableRawPointer {
        return UnsafeMutableRawPointer(mutating: self)
    }
    
    static func ~><T>(ptr: UnsafeRawPointer, type: T.Type) -> UnsafePointer<T> {
        return ptr.assumingMemoryBound(to: type)
    }
}

extension UnsafeMutableRawPointer {
    var kk_immutable: UnsafeRawPointer {
        return UnsafeRawPointer(self)
    }
    
    func kk_set(_ value: Any, _ type: Any.Type) {
        return typeProxy(type)._set(value, self)
    }
    
    func kk_get(_ type: Any.Type) -> Any {
        return typeProxy(type)._get(self)
    }
    
    static func ~><T>(ptr: UnsafeMutableRawPointer, type: T.Type) -> UnsafeMutablePointer<T> {
        return ptr.assumingMemoryBound(to: type)
    }
}

private extension TypeProxy {
    static func _set(_ value: Any, _ ptr: UnsafeMutableRawPointer) {
        guard let v = value as? Self else { return }
        (ptr ~> self).pointee = v
    }
    
    static func _get(_ ptr: UnsafeMutableRawPointer) -> Any {
        return (ptr ~> self).pointee
    }
}

infix operator ~>> : MultiplicationPrecedence
func ~>> <T1, T2>(type1: T1, type2: T2.Type) -> T2 {
    return unsafeBitCast(type1, to: type2)
}

infix operator ~> : MultiplicationPrecedence
