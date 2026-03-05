/***************************************************************************************************
 GeneralizedRange+Comparison+ParticularCases.swift
   © 2018-2019,2025-2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
/* ***** GeneralizedRange <=> Empty Range *********************************************************/
@available(*, deprecated)
extension Optional where Wrapped: GeneralizedRange {
  public static func ==(lhs: Optional, rhs: ()?) -> Bool {
    guard let range = lhs, let _ = rhs else {
      return lhs == Optional<Wrapped>.none && rhs == nil
    }
    return range.bounds == nil
  }
  public static func !=(lhs: Optional, rhs: ()?) -> Bool {
    return !(lhs == rhs)
  }
}

@available(*, deprecated)
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

@available(*, deprecated)
extension Optional where Wrapped == Void {
  public static func ==<R>(lhs: Optional, rhs: R?) -> Bool where R: GeneralizedRange {
    return rhs == lhs
  }
  public static func !=<R>(lhs: Optional, rhs: R?) -> Bool where R: GeneralizedRange {
    return rhs != lhs
  }
}

@available(*, deprecated)
public func < <R>(_:(), rhs:R) -> Bool where R:GeneralizedRange {
  return rhs > ()
}

@available(*, deprecated)
public func >= <R>(_:(), rhs:R) -> Bool where R:GeneralizedRange {
  return rhs <= ()
}

@available(*, deprecated)
public func > <R>(_:(), rhs:R) -> Bool where R:GeneralizedRange {
  return rhs < ()
}

@available(*, deprecated)
public func <= <R>(_:(), rhs:R) -> Bool where R:GeneralizedRange {
  return rhs >= ()
}


/* ***** GeneralizedRange <=> UnboundedRange ******************************************************/
@available(*, deprecated)
extension Optional where Wrapped: GeneralizedRange {
  public static func ==(lhs: Optional, rhs: UnboundedRange?) -> Bool {
    guard let range = lhs, let _ = rhs else {
      return lhs == Optional<Wrapped>.none && rhs == nil
    }
    return range.bounds?.lower == .unbounded  && range.bounds?.upper == .unbounded
  }
  public static func !=(lhs: Optional, rhs: UnboundedRange?) -> Bool {
    return !(lhs == rhs)
  }
}

@available(*, deprecated)
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

@available(*, deprecated)
extension Optional where Wrapped == UnboundedRange {
  public static func ==<R>(lhs: Optional, rhs: R?) -> Bool where R: GeneralizedRange {
    return rhs == lhs
  }
  public static func !=<R>(lhs: Optional, rhs: R?) -> Bool where R: GeneralizedRange {
    return rhs != lhs
  }
}

@available(*, deprecated)
public func < <R>(_:UnboundedRange, rhs:R) -> Bool where R:GeneralizedRange {
  return rhs > (...)
}

@available(*, deprecated)
public func >= <R>(_:UnboundedRange, rhs:R) -> Bool where R:GeneralizedRange {
  return rhs <= (...)
}

@available(*, deprecated)
public func > <R>(_:UnboundedRange, rhs:R) -> Bool where R:GeneralizedRange {
  return rhs < (...)
}

@available(*, deprecated)
public func <= <R>(_:UnboundedRange, rhs:R) -> Bool where R:GeneralizedRange {
  return rhs >= (...)
}

/* ***** UnboundedRange <=> UnboundedRange ********************************************************/
@available(*, deprecated)
extension Optional where Wrapped == UnboundedRange {
  public static func ==(lhs: Optional, rhs: Optional) -> Bool {
    return (lhs == nil && rhs == nil) || (lhs != nil && rhs != nil)
  }
  public static func !=(lhs: Optional, rhs: Optional) -> Bool {
    return !(lhs == rhs)
  }
}

@available(*, deprecated)
public func <(_:UnboundedRange, _:UnboundedRange) -> Bool {
  return false
}

@available(*, deprecated)
public func >=(_:UnboundedRange, _:UnboundedRange) -> Bool {
  return true
}

@available(*, deprecated)
public func >(_:UnboundedRange, _:UnboundedRange) -> Bool {
  return false
}

@available(*, deprecated)
public func <=(_:UnboundedRange, _:UnboundedRange) -> Bool {
  return true
}

/* ***** Empty Range <=> UnboundedRange ***********************************************************/
@available(*, deprecated)
extension Optional where Wrapped == Void {
  public static func ==(lhs: Optional, rhs: UnboundedRange?) -> Bool {
    switch (lhs, rhs) {
    case (nil, nil): return true
    default: return false
    }
  }
  public static func !=(lhs: Optional, rhs: UnboundedRange?) -> Bool {
    return !(lhs == rhs)
  }
}

@available(*, deprecated)
extension Optional where Wrapped == UnboundedRange {
  public static func ==(lhs: Optional, rhs: ()?) -> Bool {
    return rhs == lhs
  }
  public static func !=(lhs: Optional, rhs: ()?) -> Bool {
    return rhs != lhs
  }
}

@available(*, deprecated)
public func <(_:(), _:UnboundedRange) -> Bool {
  return false
}

@available(*, deprecated)
public func <(_:UnboundedRange, _:()) -> Bool {
  return true
}

@available(*, deprecated)
public func >=(_:(), _:UnboundedRange) -> Bool {
  return true
}

@available(*, deprecated)
public func >=(_:UnboundedRange, _:()) -> Bool {
  return false
}

@available(*, deprecated)
public func >(_:(), _:UnboundedRange) -> Bool {
  return true
}

@available(*, deprecated)
public func >(_:UnboundedRange, _:()) -> Bool {
  return false
}

@available(*, deprecated)
public func <=(_:(), _:UnboundedRange) -> Bool {
  return false
}

@available(*, deprecated)
public func <=(_:UnboundedRange, _:()) -> Bool {
  return true
}
