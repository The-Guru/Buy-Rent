//
//  AppModel.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 09/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import Foundation

struct AppModel {
  var buyValue: Double = 0.0
  var buyExpenses: String = String()
  var buyExpensesPercentage: Double = 0.0
  var selectedExpensesComputation: Int = 0
  var notaryExpenses: Double = 0.0
  var registryExpenses: Double = 0.0
  var managementExpenses: Double = 0.0
  var itpPercentage: Double = 0.0
  var realStateCommission: Double = 0.0
  
  func computeAllExpenses() -> Double {
    let itpComputation = buyValue * itpPercentage / 100.0
    return notaryExpenses + registryExpenses + managementExpenses +
      itpComputation + realStateCommission
  }
}
