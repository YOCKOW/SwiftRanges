# What is `SwiftRanges`?

`SwiftRanges` provides some kinds of range that are not implemented in Swift Standard Library.  
It was originally written as a part of [SwiftCGIResponder](https://github.com/YOCKOW/SwiftCGIResponder).

## Ranges

### Uncountable

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

### Countable

| Name                             | Lower Bound | Upper Bound | Implemented in         |
|----------------------------------|-------------|-------------|------------------------|
| CountableClosedRange             | Included    | Included    | Swift Standard Library |
| CountableLeftOpenRange           | Excluded    | Included    | *Unimplemented*        |
| CountableOpenRange               | Excluded    | Excluded    | *Unimplemented*        |
| CountableRange                   | Included    | Excluded    | Swift Standard Library |
| CountablePartialRangeFrom        | Included    | (Pos. Inf.) | Swift Standard Library |
| CountablePartialRangeGreaterThan | Excluded    | (Pos. Inf.) | *Unimplemented*        |
| CountablePartialRangeThrough     | (Neg. Inf.) | Included    | *Unimplemented*        |
| CountablePartialRangeUpTo        | (Neg. Inf.) | Excluded    | *Unimplemented*        |
| CountableUnboundedRange          | (Neg. Inf.) | (Pos. Inf.) | **Not required**       |

# Requirements

- Swift 4.1
- macOS or Linux

# Usage

*in printing*

# License

MIT License.  
See "LICENSE.txt" for more information.

