/***************************************************************************************************
 HashableRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
public protocol HashableRange: GeneralizedRange, Hashable where Bound: Hashable {}
