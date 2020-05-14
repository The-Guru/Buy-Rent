//
//  AppModel.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 09/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import Foundation

// MARK: AppModel

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

// MARK: AlertMessage

struct AlertMessage: Identifiable {
  let id = UUID()
  let title: String
  let message: String
}

class TaxMessages {
  static let irpfMessage = AlertMessage(title: "IRPF", message: """
Los ingresos por el alquiler del inmueble se sumarán a la base general del IRPF donde también está tu salario.

El porcentaje concreto a pagar por el alquiler será el que corresponda según los tipos generales de IRPF.

Estos tipos se aplican de forma progresiva y a la hora de calcular el IRPF también se restarán los gastos deducibles para pagar menos impuestos.
""")
  
  static let mainResidenceMessage = AlertMessage(title: "Uso de la vivienda", message: """
En los supuestos de arrendamientos de bienes inmuebles destinados a vivienda, el rendimiento neto se reducirá en un 60%.

Otras tipologías de alquileres como el turístico, vacacional o por temporadas no tienen este tipo de decucción.
""")
  
  static let landRegistryMessage = AlertMessage(title: "Valor catastral", message: """
El valor catastral es un valor administrativo determinado objetivamente para cada bien inmueble a partir de los datos que existen en el catastro inmobiliario.

Se puede consultar en el catastro o en el recibo del IBI y es básico para el cálculo de la deducción del 3%, ya que, determinan el valor de construcción del coste de adquisición
""")
  
  static let annualDepreciationMessage = AlertMessage(title: "Amortización anual", message: """
Para la determinación del rendimiento neto, se deducirá de los rendimientos íntegros el siguiente gasto:

Las cantidades destinadas a la amortización del inmueble y de los demás bienes cedidos con el mismo, siempre que respondan a su depreciación efectiva, en las condiciones que reglamentariamente se determinen.

Tratándose de inmuebles, se entiende que la amortización cumple el requisito de efectividad si no excede del resultado de aplicar el 3% sobre el mayor de los siguientes valores:

El coste de adquisición (sin incluir el valor del suelo).

El valor catastral (sin incluir el valor del suelo).
""")
  
  static let mortageInterestMessage = AlertMessage(title: "Intereses de la hipoteca", message: """
Para la determinación del rendimiento neto, se deducirá de los rendimientos íntegros el siguiente gasto:

Todos los gastos necesarios para la obtención de los rendimientos. Se considerarán gastos necesarios para la obtención de los rendimientos, entre otros, los siguientes:

Los intereses de los capitales ajenos invertidos en la adquisición o mejora del bien, derecho o facultad de uso y disfrute del que preocedan los rendimientos, y demás gastos de financiación, así como los gastos de reparación y conservación del inmueble.
""")
  
  static let taxesMessage = AlertMessage(title: "Impuestos", message: """
Los rendimientos procedentes del arrendamiento de una vivienda constituyen para el arrendador un rendimiento de capital inmobiliario.

La cuantificación del rendimiento se realiza restando de los ingresos los gastos deducibles y aplicando sobre esta cantidad, en los casos que proceda, determinadas reducciones.

En el supuesto de subarrendamientos, las cantidades percibidas por el subarrendador no se considerarán rendimientos del capital inmobiliario, sino del capital mobiliario. Sin embargo, la participación del propietario en el precio del subarriendo sí tiene la consideración de rendimientos del capital inmobiliario, sin que proceda aplicar sobre el rendimiento neto reducción alguna.

Únicamente si el arrendamiento se realiza como actividad económica las cantidades obtenidas no tienen la consideración de rendimientos del capital inmobiliario, sino de actividades económicas, dentro de cuyo apartado específico deberán ser declaradas.

Se entiende que el arrendamiento se realiza como actividad económica cuando en el desarrollo de la actividad exista, al menos, una persona empleada con contrato laboral y a jornada completa, para el desempeño de dicha gestión.
""")
}


