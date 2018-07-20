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

# Requirements

- Swift 4.1
- macOS or Linux

# Usage

```
import Ranges

let leftOpenRange: LeftOpenRange<Int> = 10<..20
print(leftOpenRange.contains(10)) // -> false
print(leftOpenRange.contains(15)) // -> true
print(leftOpenRange.contains(20)) // -> true

let openRange: OpenRange<Int> = 10<.<20
print(openRange.contains(10)) // -> false
print(openRange.contains(15)) // -> true
print(openRange.contains(20)) // -> false

let greaterThan: PartialRangeGreaterThan<Int> = 10<..
print(greaterThan.contains(10)) // -> false
print(greaterThan.contains(Int.max)) // -> true

print(greaterThan.overlaps(...11)) // -> true
print(greaterThan.overlaps(..<11)) // -> false
                                   // Because there is no integer in "10<.<11"

var multi = MultipleRanges<Int>()
multi.insert(10...20) 
multi.insert(30...40)
print(multi.contains(15)) // -> true
print(multi.contains(25)) // -> false
print(multi.contains(35)) // -> true

multi.subtract(15...35)
print(multi.contains(15)) // -> false
print(multi.contains(20)) // -> false
print(multi.contains(25)) // -> false
print(multi.contains(30)) // -> false
print(multi.contains(35)) // -> false

```

Other methods like `Set` are also implemented in `MultipleRanges`:
* `intersection(_:)`
* `union(_:)`
* `symmetricDifference(_:)`


# License

MIT License.  
See "LICENSE.txt" for more information.

