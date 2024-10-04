# What is `SwiftRanges`?

`SwiftRanges` provides some kinds of range that are not implemented in Swift Standard Library.  
It was originally written as a part of [SwiftCGIResponder](https://github.com/YOCKOW/SwiftCGIResponder).

## Ranges

| Name                    | Lower Bound | Upper Bound | Implemented in         |
|-------------------------|-------------|-------------|------------------------|
| ClosedRange             | Included    | Included    | Swift Standard Library |
| LeftOpenRange           | Excluded    | Included    | This Library           |
| OpenRange               | Excluded    | Excluded    | This Library           |
| Range                   | Included    | Excluded    | Swift Standard Library |
| PartialRangeFrom        | Included    | (Pos. Inf.) | Swift Standard Library |
| PartialRangeGreaterThan | Excluded    | (Pos. Inf.) | This Library           |
| PartialRangeThrough     | (Neg. Inf.) | Included    | Swift Standard Library |
| PartialRangeUpTo        | (Neg. Inf.) | Excluded    | Swift Standard Library |
| UnboundedRange          | (Neg. Inf.) | (Pos. Inf.) | Swift Standard Library |

### Other `struct`s implemented in this library

* `AnyRange`: A type-erased range.
* `RangeDictionary`: A collection like `Dictionary` whose key is a range.
* `MultipleRanges`: A set that can contain multiple types of ranges.

# Requirements

- Swift 4.2, 5, 6
- macOS or Linux

# Usage

## Left-Open Ranges

```Swift
import Ranges

let leftOpenRange: LeftOpenRange<Int> = 10<..20
print(leftOpenRange.contains(10)) // -> false
print(leftOpenRange.contains(15)) // -> true
print(leftOpenRange.contains(20)) // -> true

let openRange: OpenRange<Int> = 10<..<20
print(openRange.contains(10)) // -> false
print(openRange.contains(15)) // -> true
print(openRange.contains(20)) // -> false

let greaterThan: PartialRangeGreaterThan<Int> = 10<..
print(greaterThan.contains(10)) // -> false
print(greaterThan.contains(Int.max)) // -> true

print(greaterThan.overlaps(...11)) // -> true
print(greaterThan.overlaps(..<11)) // -> false
                                   // Because there is no integer in "10<..<11"
```

## Type-erased Range: `AnyRange`

```Swift
import Ranges
// Original operators are implemented for `AnyRange`.
// Some of them are below:

let leftOpenRange: LeftOpenRange<Int> = 10<..20
let typeErasedLeftOpenRange: AnyRange<Int> = 10<...20
print(leftOpenRange == typeErasedLeftOpenRange) // -> true

let openRange: OpenRange<Int> = 10<..<20
let typeErasedOpenRange: AnyRange<Int> = 19<...<30
print(openRange.overlaps(typeErasedOpenRange)) // -> false

let greaterThan: PartialRangeGreaterThan<Int> = 10<..
let typeErasedGreaterThan: AnyRange<Int> = 20<...
print(greaterThan.contains(15)) // -> true
print(typeErasedGreaterThan.contains(15)) // -> false
```

## `RangeDictionary` 

```Swift
var dic: RangeDictionary<Int, String> = [
  1....2: "Index",
  3....10: "Chapter 01",
  11....40: "Chapter 02"
]

print(dic[1]) // Prints "Index"
print(dic[5]) // Prints "Chapter 01"
print(dic[15]) // Prints "Chapter 02"
print(dic[100]) // Prints "nil"

dic.insert("Prologue", forRange: 2....5)
print(dic[5]) // Prints "Prologue"
```


## `MultipleRanges`

```Swift
import Ranges

var multi = MultipleRanges<Int>()
multi.insert(10...20) 
multi.insert(30...40)
print(multi.contains(15)) // -> true
print(multi.contains(25)) // -> false
print(multi.contains(35)) // -> true

multi.subtract(15...35)
print(multi.ranges) // -> [10..<15, 35<..40]

```

Other methods like `Set` are also implemented in `MultipleRanges`:
* `intersection(_:)`
* `union(_:)`
* `symmetricDifference(_:)`


# License

MIT License.  
See "LICENSE.txt" for more information.

