//
//  CoreUtils.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 09/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import Foundation

class CoreUtils {
  
  static let numberFormatter = NumberFormatter()
   
  static func textFieldFormattedValue(for value: Double, truncateDecimals: Bool) -> String {
     let isInteger = floor(value) == value
    return isInteger ? String(format: "%.0f", value) :
      truncateDecimals ?  String(format: "%.2f", value) : String(value)
   }
}
