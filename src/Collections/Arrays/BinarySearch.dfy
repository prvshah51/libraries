// RUN: %dafny /compile:0 "%s"

/*******************************************************************************
*  Copyright by the contributors to the Dafny Project
*  SPDX-License-Identifier: MIT 
*******************************************************************************/

include "../../Wrappers.dfy"
include "../../Relations/Relations.dfy"
include "../../Relations/Comparison.dfy"

module Search {
    import opened Relations
    import opened Wrappers
    import opened Comparison = Relations.Comparison

  method BinarySearch<T>(a: array<T>, key: T, compare: (T, T) -> Comparison.CompResult) returns (r:Option<nat>)
    requires forall i,j :: 0 <= i < j < a.Length ==> compare(a[i], a[j]).LessThan? || a[i] == a[j]
    requires Total?(compare)
    ensures r.Some? ==> r.value < a.Length && a[r.value] == key
    ensures r.None? ==> key !in a[..]
  {
    var lo, hi : nat := 0, a.Length;
    while lo < hi
      invariant 0 <= lo <= hi <= a.Length
      invariant key !in a[..lo] && key !in a[hi..]
    {
    var mid := (lo + hi) / 2;

    var comp := compare(key , a[mid]);
    match comp
      case LessThan => 
        hi := mid;
      case GreaterThan => 
        lo:= mid + 1;
      case _ => 
        return Some(mid);

    return None;
    }
  } 
} 