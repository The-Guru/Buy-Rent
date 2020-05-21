//
//  PeriodicExpenses.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 07/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import SwiftUI

struct PeriodicExpenses: View {
  
  @Binding var appModel: AppModel
  
  init(appModel: Binding<AppModel>) {
    // Drop space between form sections
    UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
    self._appModel = appModel
  }
  
  var body: some View {
    Form {
      HStack {
        Text("Seguro de impago")
          .fixedSize()
        TextField("0", text: defaultInsuranceProxy, onEditingChanged: {
          if $0 {
            self.defaultInsuranceProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Text("€/año")
      }
      HStack {
        Text("Seguro de hogar")
          .fixedSize()
        TextField("0", text: homeInsuranceProxy, onEditingChanged: {
          if $0 {
            self.homeInsuranceProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 12)
        Text("€/año")
      }
      HStack {
        Text("Seguro de vida")
          .fixedSize()
        TextField("0", text: lifeInsuranceProxy, onEditingChanged: {
          if $0 {
            self.lifeInsuranceProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 24)
        Text("€/año")
      }
      HStack {
        Text("Comunidad")
          .fixedSize()
        TextField("0", text: communityValueProxy, onEditingChanged: {
          if $0 {
            self.communityValueProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 50)
        Text("€/mes")
          .padding(.leading, -4)
      }
      HStack {
        Text("IBI")
          .fixedSize()
        TextField("0", text: ibiValueProxy, onEditingChanged: {
          if $0 {
            self.ibiValueProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 118)
        Text("€/año")
      }
      HStack {
        Text("Mantenimiento")
          .fixedSize()
        TextField("5", text: maintenanceValueProxy, onEditingChanged: {
          if $0 {
            self.maintenanceValueProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 23)
        Text("%")
          .padding(.trailing, 30)
      }
      HStack {
        Text("Períodos vacíos")
          .fixedSize()
        TextField("5", text: emptySesonsValueProxy, onEditingChanged: {
          if $0 {
            self.emptySesonsValueProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 16)
        Text("%")
          .padding(.trailing, 30)
      }
    }
    .navigationBarTitle(Text("Gastos del alquiler"), displayMode: .inline)
    .keyboardObserving()
  }
}

struct PeriodicExpenses_Previews: PreviewProvider {
  static var previews: some View {
    PeriodicExpenses(appModel: .constant(AppModel()))
  }
}

extension PeriodicExpenses {
  
  func updatePeriodicExpenses() {
    let totalPeriodicExpenses = self.appModel.computePeriodicExpenses()
    
    if totalPeriodicExpenses > 0.0 {
      self.appModel.periodicExpenses = CoreUtils.textFieldFormattedValue(for: totalPeriodicExpenses, truncateDecimals: true)
    } else {
      self.appModel.periodicExpenses = String()
    }
  }
  
  var defaultInsuranceProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.defaultInsurance.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.defaultInsurance, truncateDecimals: false)
        }
    },
      set: {
        if let value = Double($0) {
          self.appModel.defaultInsurance = value < 0.0 ? 0.0 : value
          self.updatePeriodicExpenses()
        }
    })
  }
  
  var homeInsuranceProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.homeInsurance.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.homeInsurance, truncateDecimals: false)
        }
    },
      set: {
        if let value = Double($0) {
          self.appModel.homeInsurance = value < 0.0 ? 0.0 : value
          self.updatePeriodicExpenses()
        }
    })
  }
  
  var lifeInsuranceProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.lifeInsurance.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.lifeInsurance, truncateDecimals: false)
        }
    },
      set: {
        if let value = Double($0) {
          self.appModel.lifeInsurance = value < 0.0 ? 0.0 : value
          self.updatePeriodicExpenses()
        }
    })
  }
  
  var communityValueProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.communityValue.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.communityValue, truncateDecimals: false)
        }
    },
      set: {
        if let value = Double($0) {
          self.appModel.communityValue = value < 0.0 ? 0.0 : value
          self.updatePeriodicExpenses()
        }
    })
  }
  
  var ibiValueProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.ibiValue.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.ibiValue, truncateDecimals: false)
        }
    },
      set: {
        if let value = Double($0) {
          self.appModel.ibiValue = value < 0.0 ? 0.0 : value
          self.updatePeriodicExpenses()
        }
    })
  }
  
  var maintenanceValueProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.maintenanceValue.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.maintenanceValue, truncateDecimals: false)
        }
    },
      set: {
        if let value = Double($0) {
          self.appModel.maintenanceValue = value < 0.0 ? 0.0 : value
          self.updatePeriodicExpenses()
        }
    })
  }
  
  var emptySesonsValueProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.emptySesonsValue.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.emptySesonsValue, truncateDecimals: false)
        }
    },
      set: {
        if let value = Double($0) {
          self.appModel.emptySesonsValue = value < 0.0 ? 0.0 : value
          self.updatePeriodicExpenses()
        }
    })
  }
}
