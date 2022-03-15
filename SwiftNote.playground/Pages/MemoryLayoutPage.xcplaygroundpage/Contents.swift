//: [Previous](@previous)

import Foundation
import Darwin

/*
 ref:
 1. Swift 中的内存布局: https://juejin.cn/post/6986520506002472973
 2. Size, Stride, Alignment: https://swiftunboxed.com/internals/size-stride-alignment/
 */

//: Bool

print("======== \(String(describing: Bool.self)) ========")
print("size:\t\t \(MemoryLayout<Bool>.size)") // size: 1
print("stride:\t\t \(MemoryLayout<Bool>.stride)") // stride: 1
print("alignment:\t \(MemoryLayout<Bool>.alignment)") // alignment: 1

//: Int

print("======== \(String(describing: Int.self)) ========")
print("size:\t\t \(MemoryLayout<Int>.size)") // size: 8
print("stride:\t\t \(MemoryLayout<Int>.stride)") // stride: 8
print("alignment:\t \(MemoryLayout<Int>.alignment)") // alignment: 8

print("======== \(String(describing: Int16.self)) ========")
print("size:\t\t \(MemoryLayout<Int16>.size)") // size: 2
print("stride:\t\t \(MemoryLayout<Int16>.stride)") // stride: 2
print("alignment:\t \(MemoryLayout<Int16>.alignment)") // alignment: 2

//: Float

print("======== \(String(describing: Float.self)) ========")
print("size:\t\t \(MemoryLayout<Float>.size)") // size: 4
print("stride:\t\t \(MemoryLayout<Float>.stride)") // stride: 4
print("alignment:\t \(MemoryLayout<Float>.alignment)") // alignment: 4

//: Double

print("======== \(String(describing: Double.self)) ========")
print("size:\t\t \(MemoryLayout<Double>.size)") // size: 8
print("stride:\t\t \(MemoryLayout<Double>.stride)") // stride: 8
print("alignment:\t \(MemoryLayout<Double>.alignment)") // alignment: 8

//: Struct

struct EmptyStruct {}

print("======== \(String(describing: EmptyStruct.self)) ========")
print("size:\t\t \(MemoryLayout<EmptyStruct>.size)") // size: 0
print("stride:\t\t \(MemoryLayout<EmptyStruct>.stride)") // stride: 1
print("alignment:\t \(MemoryLayout<EmptyStruct>.alignment)") // alignment: 1

struct Puppy {
    let age: Int
    let isTrained: Bool
}

print("======== \(String(describing: Puppy.self)) ========")
print("size:\t\t \(MemoryLayout<Puppy>.size)") // size: 9
print("stride:\t\t \(MemoryLayout<Puppy>.stride)") // stride: 16
print("alignment:\t \(MemoryLayout<Puppy>.alignment)") // alignment: 8

struct AnotherPuppy {
    let isTrained: Bool
    let age: Int
}

print("======== \(String(describing: AnotherPuppy.self)) ========")
print("size:\t\t \(MemoryLayout<AnotherPuppy>.size)") // size: 16
print("stride:\t\t \(MemoryLayout<AnotherPuppy>.stride)") // stride: 16
print("alignment:\t \(MemoryLayout<AnotherPuppy>.alignment)") // alignment: 8

struct CertifiedPuppy {
    let age: Int
    let isTrained: Bool
    let isCertified: Bool
}

print("======== \(String(describing: CertifiedPuppy.self)) ========")
print("size:\t\t \(MemoryLayout<CertifiedPuppy>.size)") // size: 10
print("stride:\t\t \(MemoryLayout<CertifiedPuppy>.stride)") // stride: 16
print("alignment:\t \(MemoryLayout<CertifiedPuppy>.alignment)") // alignment: 8

struct AnotherCertifiedPuppy {
    let isTrained: Bool
    let age: Int
    let isCertified: Bool
}

print("======== \(String(describing: AnotherCertifiedPuppy.self)) ========")
print("size:\t\t \(MemoryLayout<AnotherCertifiedPuppy>.size)") // size: 17
print("stride:\t\t \(MemoryLayout<AnotherCertifiedPuppy>.stride)") // stride: 24
print("alignment:\t \(MemoryLayout<AnotherCertifiedPuppy>.alignment)") // alignment: 8

//: Class

func dumpMemory(of ptr: UnsafeRawPointer, size: Int) {
    for i in 0..<size {
        let value = (ptr + i).load(as: UInt8.self)
        if i % 8 == 0 {
            print(String(format:" %02X", value), terminator: "")
        } else {
            print(String(format:"%02X", value), terminator: "")
        }
    }
    print("")
}

class EmptyClass {
    
}

// Classes are reference types, so MemoryLayout reports the size of a reference: Eight bytes.

print("======== \(String(describing: EmptyClass.self)) ========")
print("size:\t\t\t \(MemoryLayout<EmptyClass>.size)") // 8
print("stride:\t\t\t \(MemoryLayout<EmptyClass>.stride)") // 8
print("alignment:\t\t \(MemoryLayout<EmptyClass>.alignment)") // 8
print("instance size:\t \(class_getInstanceSize(EmptyClass.self))") // 16

class PuppyClass {
    let isTrained: Bool = false
    let age: Int = 3
}

print("======== \(String(describing: PuppyClass.self)) ========")
print("size:\t\t\t \(MemoryLayout<PuppyClass>.size)") // 8
print("stride:\t\t\t \(MemoryLayout<PuppyClass>.stride)") // 8
print("alignment:\t\t \(MemoryLayout<PuppyClass>.alignment)") // 8
print("instance size:\t \(class_getInstanceSize(PuppyClass.self))") // 32

class AnotherPuppyClass {
    let age: Int = 3
    let isTrained: Bool = false
}

print("======== \(String(describing: AnotherPuppyClass.self)) ========")
print("size:\t\t\t \(MemoryLayout<AnotherPuppyClass>.size)") // 8
print("stride:\t\t\t \(MemoryLayout<AnotherPuppyClass>.stride)") // 8
print("alignment:\t\t \(MemoryLayout<AnotherPuppyClass>.alignment)") // 8
print("instance size:\t \(class_getInstanceSize(AnotherPuppyClass.self))") // 32


class ClassA {
    var x: Int = 0xff // 8
    var y: Bool = true // 1
    var z: Bool = true // 1
}

do {
    print("======== \(String(describing: ClassA.self)) ========")
    var size = class_getInstanceSize(ClassA.self)
    print("instance size: ", size) // 40

    let exmaple = ClassA()
    let ptr = UnsafeRawPointer(bitPattern: unsafeBitCast(exmaple, to: UInt.self))
    size = malloc_size(ptr)
    print("malloc size: ", size) // 48
    
    print("memory content:", terminator: " ")
    dumpMemory(of: ptr!, size: size)
}

class ClassB {
    var x: Bool = true // 1
    var y: Int = 0xff // 8
    var z: Bool = true // 1
}

do {
    print("======== \(String(describing: ClassB.self)) ========")
    var size = class_getInstanceSize(ClassB.self)
    print("instance size: ", size) // 40

    let exmaple = ClassB()
    let ptr = UnsafeRawPointer(bitPattern: unsafeBitCast(exmaple, to: UInt.self))
    size = malloc_size(ptr)
    print("malloc size: ", size) // 48
    
    print("memory content:", terminator: " ")
    dumpMemory(of: ptr!, size: size)
}


class ClassC {
    var x: Bool = true // 1
    var y: Int = 0xff // 8
    var z: Bool = true // 1
    var a: Bool = true // 1
    var b: Bool = true // 1
    var c: Bool = true // 1
    var d: Bool = true // 1
    var e: Bool = true // 1
    var f: Bool = true // 1
}

do {
    print("======== \(String(describing: ClassC.self)) ========")
    var size = class_getInstanceSize(ClassC.self)
    print("instance size: ", size) // 40

    let exmaple = ClassC()
    let ptr = UnsafeRawPointer(bitPattern: unsafeBitCast(exmaple, to: UInt.self))
    size = malloc_size(ptr)
    print("malloc size: ", size) // 48
    
    print("memory content:", terminator: " ")
    dumpMemory(of: ptr!, size: size)
}

autoreleasepool {
    var arr: [ClassC] = []
    var ptrArr: [UnsafeRawPointer] = []
    for _ in 0..<100 {
        let exmaple = ClassC()
        arr.append(exmaple)
        let ptr = UnsafeRawPointer(bitPattern: unsafeBitCast(exmaple, to: UInt.self))
        ptrArr.append(ptr!)
    }
    print(ptrArr.sorted(by: <))
}

class ClassD {
    var x: Int = 0xff // 8
    var y: Bool = true // 1
    
    func foo() -> Void {
        print("foo")
    }
}

do {
    print("======== \(String(describing: ClassD.self)) ========")
    var size = class_getInstanceSize(ClassD.self)
    print("instance size: ", size) // 40

    let exmaple = ClassD()
    let ptr = UnsafeRawPointer(bitPattern: unsafeBitCast(exmaple, to: UInt.self))
    size = malloc_size(ptr)
    print("malloc size: ", size) // 48
    
    print("memory content:", terminator: " ")
    dumpMemory(of: ptr!, size: size)
}



//: [Next](@next)
