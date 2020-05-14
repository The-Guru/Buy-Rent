//
//  MortgageExpenses.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 07/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import SwiftUI

struct MortgageExpenses: View {
  
  @Binding var appModel: AppModel
  @State private var mortgageNote: String = String()
  @State private var mortgagePlusInterests: String = String()
  
  init(appModel: Binding<AppModel>) {
    // Drop space between form sections
    UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
    self._appModel = appModel
  }
  
  var body: some View {
    Form {
      HStack {
        Toggle(isOn: mortgagePercentageToggleProxy) {
          Text("Cálculo por porcentaje")
        }
      }
      HStack {
        Text("Importe del préstamo")
          .fixedSize()
        TextField("0", text: mortgageValueProxy, onEditingChanged: {
          if $0 {
            self.mortgageValueProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 10)
        Text(appModel.mortgagePercentageToggle ? "%" : "€")
          .animation(.default)
      }
      HStack {
        Text("Intereses del préstamo")
          .fixedSize()
        TextField("0", text: mortgagePercentageProxy, onEditingChanged: {
          if $0 {
            self.mortgagePercentageProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Text("%")
      }
      HStack {
        Text("Años del préstamo")
          .fixedSize()
        TextField("0", text: mortgageYearsProxy, onEditingChanged: {
          if $0 {
            self.mortgageYearsProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 31)
        Text("años")
      }
      
      Section(header: Text("Gastos")) {
        HStack {
          Text("Comisión de apertura")
            .fixedSize()
          TextField("0", text: mortgageOpenComissionProxy, onEditingChanged: {
            if $0 {
              self.mortgageOpenComissionProxy.wrappedValue = "0"
            }
          })
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 9)
          Text("€")
        }
        HStack {
          Text("Tasación")
            .fixedSize()
          TextField("0", text: mortgageRatingProxy, onEditingChanged: {
            if $0 {
              self.mortgageRatingProxy.wrappedValue = "0"
            }
          })
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 106)
          Text("€")
        }
        HStack {
          Text("Comisión broker")
            .fixedSize()
          TextField("0", text: mortgageBrokerComissionProxy, onEditingChanged: {
            if $0 {
              self.mortgageBrokerComissionProxy.wrappedValue = "0"
            }
          })
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 49)
          Text("€")
        }
      }
      
      Section(header: Text("Resultados")) {
        HStack {
          Text("Letra hipotecaria")
            .fixedSize()
          Spacer()
          Text((!mortgageNote.isEmpty ? mortgageNote : "0") + " €/mes")
            .fixedSize()
        }
        HStack {
          Text("Gastos hipotecarios")
            .fixedSize()
          Spacer()
          Text((!appModel.mortgageExpenses.isEmpty ? appModel.mortgageExpenses : "0") + " €")
            .fixedSize()
        }
        HStack {
          Text("Préstamo + intereses")
            .fixedSize()
          Spacer()
          Text((!mortgagePlusInterests.isEmpty ? mortgagePlusInterests : "0") + " €")
            .fixedSize()
        }
      }
    }
    .navigationBarTitle(Text("Hipoteca"), displayMode: .inline)
    .onAppear {
      self.computeMortgage()
    }
  }
  
  struct MortgageExpenses_Previews: PreviewProvider {
    static var previews: some View {
      MortgageExpenses(appModel: .constant(AppModel()))
    }
  }
}

extension MortgageExpenses {
  
  func updateMortgageExpenses() {
    let totalExpenses = self.appModel.computeMortgageExpenses()
    if totalExpenses > 0.0 {
      self.appModel.mortgageExpenses = CoreUtils.textFieldFormattedValue(for: totalExpenses, truncateDecimals: true)
    } else {
      self.appModel.mortgageExpenses = String()
    }
  }
  
  func computeMortgage()  {
    let mortgageMonths = self.appModel.mortgageYears * 12.0
    let mortgagePercentagePerMonth = self.appModel.mortgagePercentage / 12.0
    let mortgagePerMonth = mortgagePercentagePerMonth / 100.0
    
    if !self.appModel.mortgagePercentageToggle {
      if self.appModel.mortgageValue > 0.0 &&
        mortgageMonths > 0.0 &&
        mortgagePercentagePerMonth > 0.0 {
        
        let mortgageNote = self.appModel.mortgageValue * mortgagePerMonth /
          (1.0 - pow(1.0 + mortgagePerMonth, -mortgageMonths))
        
        self.mortgageNote = CoreUtils.textFieldFormattedValue(for: mortgageNote, truncateDecimals: true)
        self.mortgagePlusInterests = CoreUtils.textFieldFormattedValue(for: mortgageNote * mortgageMonths, truncateDecimals: true)
        self.appModel.mortgageValueString = CoreUtils.textFieldFormattedValue(for: self.appModel.mortgageValue, truncateDecimals: true)
        let mortgageInterest = ((mortgageNote * mortgageMonths - self.appModel.mortgageValue) / mortgageMonths) * 12.0
        self.appModel.mortgageInterestString = CoreUtils.textFieldFormattedValue(for: mortgageInterest, truncateDecimals: true)
      } else {
        self.mortgageNote = String()
        self.mortgagePlusInterests = String()
        self.appModel.mortgageValueString = String()
        self.appModel.mortgageInterestString = String()
      }
    } else {
      if self.appModel.buyValue > 0.0 &&
        self.appModel.mortgageValue > 0.0 &&  // This time is a percentage
        mortgageMonths > 0.0 &&
        mortgagePercentagePerMonth > 0.0  {
        
        let mortgageValue = ((self.appModel.buyValue * self.appModel.mortgageValue) / 100.0)
        let mortgageNote = mortgageValue * mortgagePerMonth / (1.0 - pow(1.0 + mortgagePerMonth, -mortgageMonths))
        
        self.mortgageNote = CoreUtils.textFieldFormattedValue(for: mortgageNote, truncateDecimals: true)
        self.mortgagePlusInterests = CoreUtils.textFieldFormattedValue(for: mortgageNote * mortgageMonths, truncateDecimals: true)
        self.appModel.mortgageValueString = CoreUtils.textFieldFormattedValue(for: mortgageValue, truncateDecimals: true)
        let mortgageInterest = ((mortgageNote * mortgageMonths - mortgageValue) / mortgageMonths) * 12.0
        self.appModel.mortgageInterestString = CoreUtils.textFieldFormattedValue(for: mortgageInterest, truncateDecimals: true)
      } else {
        self.mortgageNote = String()
        self.mortgagePlusInterests = String()
        self.appModel.mortgageValueString = String()
        self.appModel.mortgageInterestString = String()
      }
    }
  }
  
  var mortgagePercentageToggleProxy: Binding<Bool> {
    Binding<Bool>(
      get: {
        return self.appModel.mortgagePercentageToggle
    },
      set: {
        self.mortgageValueProxy.wrappedValue = "0"
        self.appModel.mortgagePercentageToggle = $0
    })
  }
  
  var mortgageValueProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.mortgageValue.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.mortgageValue, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.mortgageValue = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.computeMortgage()
        }
    })
  }
  
  var mortgagePercentageProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.mortgagePercentage.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.mortgagePercentage, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.mortgagePercentage = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.computeMortgage()
        }
    })
  }
  
  var mortgageYearsProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.mortgageYears.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.mortgageYears, truncateDecimals: true)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.mortgageYears = value.doubleValue < 0.0 ? 0.0 : value.doubleValue.rounded()  // Avoiding decimals in years
          self.computeMortgage()
        }
    })
  }
  
  var mortgageOpenComissionProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.mortgageOpenComission.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.mortgageOpenComission, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.mortgageOpenComission = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.updateMortgageExpenses()
        }
    })
  }
  
  var mortgageRatingProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.mortgageRating.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.mortgageRating, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.mortgageRating = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.updateMortgageExpenses()
        }
    })
  }
  
  var mortgageBrokerComissionProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.mortgageBrokerComission.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.mortgageBrokerComission, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.mortgageBrokerComission = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.updateMortgageExpenses()
        }
    })
  }
}
