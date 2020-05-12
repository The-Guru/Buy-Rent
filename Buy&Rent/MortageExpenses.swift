//
//  MortageExpenses.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 07/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import SwiftUI

struct MortageExpenses: View {
  
  @Binding var appModel: AppModel
  @State private var mortageNote: String = String()
  @State private var mortagePlusInterests: String = String()
  
  init(appModel: Binding<AppModel>) {
    // Drop space between form sections
    UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
    self._appModel = appModel
  }
  
  var body: some View {
    Form {
      HStack {
        Toggle(isOn: mortagePercentageToggleProxy) {
          Text("Cálculo por porcentaje")
        }
      }
      HStack {
        Text("Importe del préstamo")
          .fixedSize()
        TextField("0", text: mortageValueProxy, onEditingChanged: {
          if $0 {
            self.mortageValueProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 10)
        Text(appModel.mortagePercentageToggle ? "%" : "€")
          .animation(.default)
      }
      HStack {
        Text("Intereses del préstamo")
          .fixedSize()
        TextField("0", text: mortagePercentageProxy, onEditingChanged: {
          if $0 {
            self.mortagePercentageProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Text("%")
      }
      HStack {
        Text("Años del préstamo")
          .fixedSize()
        TextField("0", text: mortageYearsProxy, onEditingChanged: {
          if $0 {
            self.mortageYearsProxy.wrappedValue = "0"
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
          TextField("0", text: mortageOpenComissionProxy, onEditingChanged: {
            if $0 {
              self.mortageOpenComissionProxy.wrappedValue = "0"
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
          TextField("0", text: mortageRatingProxy, onEditingChanged: {
            if $0 {
              self.mortageRatingProxy.wrappedValue = "0"
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
          TextField("0", text: mortageBrokerComissionProxy, onEditingChanged: {
            if $0 {
              self.mortageBrokerComissionProxy.wrappedValue = "0"
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
          Text((!mortageNote.isEmpty ? mortageNote : "0") + " €/mes")
            .fixedSize()
        }
        HStack {
          Text("Gastos hipotecarios")
            .fixedSize()
          Spacer()
          Text((!appModel.mortageExpenses.isEmpty ? appModel.mortageExpenses : "0") + " €")
            .fixedSize()
        }
        HStack {
          Text("Préstamo + intereses")
            .fixedSize()
          Spacer()
          Text((!mortagePlusInterests.isEmpty ? mortagePlusInterests : "0") + " €")
            .fixedSize()
        }
      }
    }
    .navigationBarTitle(Text("Hipoteca"), displayMode: .inline)
    .onAppear {
      self.computeMortage()
    }
  }
  
  struct MortageExpenses_Previews: PreviewProvider {
    static var previews: some View {
      MortageExpenses(appModel: .constant(AppModel()))
    }
  }
}

extension MortageExpenses {
  
  func updateMortageExpenses() {
    let totalExpenses = self.appModel.computeMortageExpenses()
    if totalExpenses > 0.0 {
      self.appModel.mortageExpenses = CoreUtils.textFieldFormattedValue(for: totalExpenses, truncateDecimals: true)
    } else {
      self.appModel.mortageExpenses = String()
    }
  }
  
  func computeMortage()  {
    let mortageMonths = self.appModel.mortageYears * 12.0
    let mortagePercentagePerMonth = self.appModel.mortagePercentage / 12.0
    let mortagePerMonth = mortagePercentagePerMonth / 100.0
    
    if !self.appModel.mortagePercentageToggle {
      if self.appModel.mortageValue > 0.0 &&
        mortageMonths > 0.0 &&
        mortagePercentagePerMonth > 0.0 {
        
        let mortageNote = self.appModel.mortageValue * mortagePerMonth /
          (1.0 - pow(1.0 + mortagePerMonth, -mortageMonths))
        
        self.mortageNote = CoreUtils.textFieldFormattedValue(for: mortageNote, truncateDecimals: true)
        self.mortagePlusInterests = CoreUtils.textFieldFormattedValue(for: mortageNote * mortageMonths, truncateDecimals: true)
        self.appModel.mortageValueString = CoreUtils.textFieldFormattedValue(for: self.appModel.mortageValue, truncateDecimals: true)
      } else {
        self.mortageNote = String()
        self.mortagePlusInterests = String()
        self.appModel.mortageValueString = String()
      }
    } else {
      if self.appModel.buyValue > 0.0 &&
        self.appModel.mortageValue > 0.0 &&  // This time is a percentage
        mortageMonths > 0.0 &&
        mortagePercentagePerMonth > 0.0  {
        
        let mortageValue = ((self.appModel.buyValue * self.appModel.mortageValue) / 100.0)
        let mortageNote = mortageValue * mortagePerMonth / (1.0 - pow(1.0 + mortagePerMonth, -mortageMonths))
        
        self.mortageNote = CoreUtils.textFieldFormattedValue(for: mortageNote, truncateDecimals: true)
        self.mortagePlusInterests = CoreUtils.textFieldFormattedValue(for: mortageNote * mortageMonths, truncateDecimals: true)
        self.appModel.mortageValueString = CoreUtils.textFieldFormattedValue(for: mortageValue, truncateDecimals: true)
      } else {
        self.mortageNote = String()
        self.mortagePlusInterests = String()
        self.appModel.mortageValueString = String()
      }
    }
  }
  
  var mortagePercentageToggleProxy: Binding<Bool> {
    Binding<Bool>(
      get: {
        return self.appModel.mortagePercentageToggle
    },
      set: {
        self.mortageValueProxy.wrappedValue = "0"
        self.appModel.mortagePercentageToggle = $0
    })
  }
  
  var mortageValueProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.mortageValue.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.mortageValue, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.mortageValue = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.computeMortage()
        }
    })
  }
  
  var mortagePercentageProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.mortagePercentage.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.mortagePercentage, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.mortagePercentage = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.computeMortage()
        }
    })
  }
  
  var mortageYearsProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.mortageYears.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.mortageYears, truncateDecimals: true)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.mortageYears = value.doubleValue < 0.0 ? 0.0 : value.doubleValue.rounded()  // Avoiding decimals in years
          self.computeMortage()
        }
    })
  }
  
  var mortageOpenComissionProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.mortageOpenComission.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.mortageOpenComission, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.mortageOpenComission = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.updateMortageExpenses()
        }
    })
  }
  
  var mortageRatingProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.mortageRating.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.mortageRating, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.mortageRating = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.updateMortageExpenses()
        }
    })
  }
  
  var mortageBrokerComissionProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.mortageBrokerComission.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.mortageBrokerComission, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.mortageBrokerComission = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.updateMortageExpenses()
        }
    })
  }
}
