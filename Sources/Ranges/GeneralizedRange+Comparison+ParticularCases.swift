/***************************************************************************************************
 GeneralizedRange+Comparison+ParticularCases.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
/* ***** GeneralizedRange <=> Empty Range *********************************************************/
extension GeneralizedRange {
  public static func ==(lhs:Self, _:()) -> Bool {
    return lhs.bounds == nil
  }
  public static func !=(lhs:Self, _:()) -> Bool {
    return lhs.bounds != nil
  }
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

public func ==<R>(_:(), rhs:R) -> Bool where R:GeneralizedRange {
  return rhs == ()
}
public func !=<R>(_:(), rhs:R) -> Bool where R:GeneralizedRange {
  return rhs != ()
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
extension GeneralizedRange {
  public static func ==(lhs:Self, _:UnboundedRange) -> Bool {
    guard let lBounds = lhs.bounds, lBounds.lower == nil, lBounds.upper == nil else {
      return false
    }
    return true
  }
  public static func !=(lhs:Self, _:UnboundedRange) -> Bool {
    return !(lhs == (...))
  }
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

public func ==<R>(_:UnboundedRange, rhs:R) -> Bool where R:GeneralizedRange {
  return rhs == (...)
}
public func !=<R>(_:UnboundedRange, rhs:R) -> Bool where R:GeneralizedRange {
  return rhs != (...)
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
public func ==(_:UnboundedRange, _:UnboundedRange) -> Bool {
  return true
}
public func !=(_:UnboundedRange, _:UnboundedRange) -> Bool {
  return false
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
public func ==(_:(), _:UnboundedRange) -> Bool {
  return false
}
public func ==(_:UnboundedRange, _:()) -> Bool {
  return false
}
public func !=(_:(), _:UnboundedRange) -> Bool {
  return true
}
public func !=(_:UnboundedRange, _:()) -> Bool {
  return true
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
