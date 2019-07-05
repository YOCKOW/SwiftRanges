/***************************************************************************************************
 GeneralizedRange+Comparison+ParticularCases.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
/* ***** GeneralizedRange <=> Empty Range *********************************************************/
extension Optional where Wrapped: GeneralizedRange {
  public static func ==(lhs: Optional, rhs: ()?) -> Bool {
    guard let range = lhs, let _ = rhs else { return lhs == nil && rhs == nil }
    return range.bounds == nil
  }
  public static func !=(lhs: Optional, rhs: ()?) -> Bool {
    return !(lhs == rhs)
  }
}
extension GeneralizedRange {
  public static func <(lhs:Self, _:()) -> Bool {
    if lhs == () { return false }
    return true
  }
  public static func >=(lhs:Self, _:()) -> Bool {
    return !(lhs < ())
  }
  public static func >(lhs:Self, _:()) -> Bool {
    return false
  }
  public static func <=(lhs:Self, _:()) -> Bool {
    return true
  }
}

extension Optional where Wrapped == Void {
  public static func ==<R>(lhs: Optional, rhs: R?) -> Bool where R: GeneralizedRange {
    return rhs == lhs
  }
  public static func !=<R>(lhs: Optional, rhs: R?) -> Bool where R: GeneralizedRange {
    return rhs != lhs
  }
}
public func < <R>(_:(), rhs:R) -> Bool where R:GeneralizedRange {
  return rhs > ()
}
public func >= <R>(_:(), rhs:R) -> Bool where R:GeneralizedRange {
  return rhs <= ()
}
public func > <R>(_:(), rhs:R) -> Bool where R:GeneralizedRange {
  return rhs < ()
}
public func <= <R>(_:(), rhs:R) -> Bool where R:GeneralizedRange {
  return rhs >= ()
}


/* ***** GeneralizedRange <=> UnboundedRange ******************************************************/
extension Optional where Wrapped: GeneralizedRange {
  public static func ==(lhs: Optional, rhs: UnboundedRange?) -> Bool {
    guard let range = lhs, let _ = rhs else { return lhs == nil && rhs == nil }
    return range.bounds?.lower == .unbounded  && range.bounds?.upper == .unbounded
  }
  public static func !=(lhs: Optional, rhs: UnboundedRange?) -> Bool {
    return !(lhs == rhs)
  }
}
extension GeneralizedRange {
  public static func <(lhs:Self, _:UnboundedRange) -> Bool {
    return false
  }
  public static func >=(lhs:Self, _:UnboundedRange) -> Bool {
    return true
  }
  public static func >(lhs:Self, _:UnboundedRange) -> Bool {
    if lhs == (...) { return false }
    return true
  }
  public static func <=(lhs:Self, _:UnboundedRange) -> Bool {
    return !(lhs > (...))
  }
}

extension Optional where Wrapped == UnboundedRange {
  public static func ==<R>(lhs: Optional, rhs: R?) -> Bool where R: GeneralizedRange {
    return rhs == lhs
  }
  public static func !=<R>(lhs: Optional, rhs: R?) -> Bool where R: GeneralizedRange {
    return rhs != lhs
  }
}
public func < <R>(_:UnboundedRange, rhs:R) -> Bool where R:GeneralizedRange {
  return rhs > (...)
}
public func >= <R>(_:UnboundedRange, rhs:R) -> Bool where R:GeneralizedRange {
  return rhs <= (...)
}
public func > <R>(_:UnboundedRange, rhs:R) -> Bool where R:GeneralizedRange {
  return rhs < (...)
}
public func <= <R>(_:UnboundedRange, rhs:R) -> Bool where R:GeneralizedRange {
  return rhs >= (...)
}

/* ***** UnboundedRange <=> UnboundedRange ********************************************************/
extension Optional where Wrapped == UnboundedRange {
  public static func ==(lhs: Optional, rhs: Optional) -> Bool {
    return (lhs == nil && rhs == nil) || (lhs != nil && rhs != nil)
  }
  public static func !=(lhs: Optional, rhs: Optional) -> Bool {
    return !(lhs == rhs)
  }
}
public func <(_:UnboundedRange, _:UnboundedRange) -> Bool {
  return false
}
public func >=(_:UnboundedRange, _:UnboundedRange) -> Bool {
  return true
}
public func >(_:UnboundedRange, _:UnboundedRange) -> Bool {
  return false
}
public func <=(_:UnboundedRange, _:UnboundedRange) -> Bool {
  return true
}

/* ***** Empty Range <=> UnboundedRange ***********************************************************/
extension Optional where Wrapped == Void {
  public static func ==(lhs: Optional, rhs: UnboundedRange?) -> Bool {
    return lhs == nil && rhs == nil
  }
  public static func !=(lhs: Optional, rhs: UnboundedRange?) -> Bool {
    return !(lhs == rhs)
  }
}
extension Optional where Wrapped == UnboundedRange {
  public static func ==(lhs: Optional, rhs: ()?) -> Bool {
    return rhs == lhs
  }
  public static func !=(lhs: Optional, rhs: ()?) -> Bool {
    return rhs != lhs
  }
}
public func <(_:(), _:UnboundedRange) -> Bool {
  return false
}
public func <(_:UnboundedRange, _:()) -> Bool {
  return true
}
public func >=(_:(), _:UnboundedRange) -> Bool {
  return true
}
public func >=(_:UnboundedRange, _:()) -> Bool {
  return false
}
public func >(_:(), _:UnboundedRange) -> Bool {
  return true
}
public func >(_:UnboundedRange, _:()) -> Bool {
  return false
}
public func <=(_:(), _:UnboundedRange) -> Bool {
  return false
}
public func <=(_:UnboundedRange, _:()) -> Bool {
  return true
}
