//
//  AppModel.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 09/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import Foundation

struct AppModel {
  // Content View
  var buyValue: Double = 0.0
  var buyExpenses: String = String()
  var mortageValueString: String = String()
  var mortageExpenses: String = String()
  var rentValue: Double = 0.0
  var periodicExpenses: String = String()
  
  // BuyExpenses
  var buyExpensesPercentage: Double = 0.0
  var selectedExpensesComputation: Int = 0
  var notaryExpenses: Double = 0.0
  var registryExpenses: Double = 0.0
  var managementExpenses: Double = 0.0
  var itpPercentage: Double = 0.0
  var realStateCommission: Double = 0.0
  // MortageExpenses
  var mortageValue: Double = 0.0
  var mortagePercentage: Double = 0.0
  var mortageYears: Double = 0.0
  var mortagePercentageToggle: Bool = false
  var mortageOpenComission: Double = 0.0
  var mortageRating: Double = 0.0
  var mortageBrokerComission: Double = 0.0
  // PeriodicExpenses
  var defaultInsurance: Double = 0.0
  var homeInsurance: Double = 0.0
  var lifeInsurance: Double = 0.0
  var communityValue: Double = 0.0
  var ibiValue: Double = 0.0
  var maintenanceValue: Double = 0.0
  var emptySesonsValue: Double = 0.0
  
  func computeBuyExpenses() -> Double {
    let itpComputation = buyValue * itpPercentage / 100.0
    return notaryExpenses + registryExpenses + managementExpenses +
      itpComputation + realStateCommission
  }
  
  func computeMortageExpenses() -> Double {
    return mortageOpenComission + mortageRating + mortageBrokerComission
  }
  
  func computePeriodicExpenses() -> Double {
    let totalYearlyExpensesByMonth = (defaultInsurance +
      homeInsurance + lifeInsurance + ibiValue) / 12.0
    let maintenancePerMonth = ((rentValue * maintenanceValue) / 100.0)
    let emptySesonsPerMonth = ((rentValue * emptySesonsValue) / 100.0)
    let totalPeriodicExpenses = totalYearlyExpensesByMonth + communityValue +
      maintenancePerMonth + emptySesonsPerMonth
    return totalPeriodicExpenses
  }
}
