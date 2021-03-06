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
  var workExpenses: Double = 0.0
  var mortgageValueString: String = String()
  var mortgageExpenses: String = String()
  var rentValue: Double = 0.0
  var periodicExpenses: String = String()
  var taxes: String = String()
  var mortgageNote: String = String()
  // BuyExpenses
  var buyExpensesPercentage: Double = 0.0
  var selectedExpensesComputation: Int = 0
  var notaryExpenses: Double = 0.0
  var registryExpenses: Double = 0.0
  var managementExpenses: Double = 0.0
  var itpPercentage: Double = 0.0
  var realStateCommission: Double = 0.0
  // MortgageExpenses
  var mortgageValue: Double = 0.0
  var mortgagePercentage: Double = 0.0
  var mortgageYears: Double = 0.0
  var mortgagePercentageToggle: Bool = false
  var mortgageOpenComission: Double = 0.0
  var mortgageRating: Double = 0.0
  var mortgageBrokerComission: Double = 0.0
  var mortgageAJD: Double = 0.0
  // PeriodicExpenses
  var defaultInsurance: Double = 0.0
  var homeInsurance: Double = 0.0
  var lifeInsurance: Double = 0.0
  var communityValue: Double = 0.0
  var ibiValue: Double = 0.0
  var maintenanceValue: Double = 0.0
  var emptySesonsValue: Double = 0.0
  // Taxes
  var irpfRange: Int = 0
  var mainResidence: Int = 0
  var landBuildingValue: Double = 0.0
  var landGroundValue: Double = 0.0
  var mortgageInterestString: String = String()
  var annualDepreciation: String = String()
  
  private let irpfRangeValues: [Double] = [0.19, 0.24, 0.30, 0.37, 0.45]
  
  mutating func reset() {
    buyValue = 0.0
    buyExpenses = String()
    workExpenses = 0.0
    mortgageValueString = String()
    mortgageExpenses = String()
    rentValue = 0.0
    periodicExpenses = String()
    taxes = String()
    mortgageNote = String()
    // BuyExpenses
    buyExpensesPercentage = 0.0
    selectedExpensesComputation  = 0
    notaryExpenses = 0.0
    registryExpenses = 0.0
    managementExpenses = 0.0
    itpPercentage = 0.0
    realStateCommission = 0.0
    // MortgageExpenses
    mortgageValue = 0.0
    mortgagePercentage = 0.0
    mortgageYears = 0.0
    mortgagePercentageToggle = false
    mortgageOpenComission = 0.0
    mortgageRating = 0.0
    mortgageBrokerComission = 0.0
    mortgageAJD = 0.0
    // PeriodicExpenses
    defaultInsurance = 0.0
    homeInsurance = 0.0
    lifeInsurance = 0.0
    communityValue = 0.0
    ibiValue = 0.0
    maintenanceValue = 0.0
    emptySesonsValue = 0.0
    // Taxes
    irpfRange = 0
    mainResidence = 0
    landBuildingValue = 0.0
    landGroundValue = 0.0
    mortgageInterestString = String()
    annualDepreciation = String()
  }
  
  func computeBuyExpenses() -> Double {
    let itpComputation = buyValue * itpPercentage / 100.0
    return notaryExpenses + registryExpenses + managementExpenses +
      itpComputation + realStateCommission
  }
  
  func computeMortgageExpenses() -> Double {
    return mortgageOpenComission + mortgageRating + mortgageBrokerComission + mortgageAJD
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
  
  func computeAnnualDepreciation() -> String {
    if landGroundValue > 0.0 && landBuildingValue > 0.0 {
      let buyExpenses = Double(self.buyExpenses) ?? 0.0
      let buildingPercentage = landBuildingValue / (landBuildingValue + landGroundValue)
      let computation = 0.03 * (buildingPercentage * buyValue + buyExpenses + workExpenses)
      if computation > 0.0 {
        return CoreUtils.textFieldFormattedValue(for: computation, truncateDecimals: true)
      } else {
        return String()
      }
    } else {
      return String()
    }
  }
  
  func computeTaxes() -> String {
    let periodicExpenses = Double(self.periodicExpenses) ?? 0.0
    let depreciation = Double(annualDepreciation) ?? 0.0
    let mortgageInterest = Double(mortgageInterestString) ?? 0.0
    
    let profit = (rentValue * 12.0) - (periodicExpenses * 12.0)
    let computation = profit - depreciation - mortgageInterest
    let taxes = mainResidence == 0 ? computation * 0.4 * irpfRangeValues[irpfRange] : computation * irpfRangeValues[irpfRange]
    if taxes > 0.0 {
      return CoreUtils.textFieldFormattedValue(for: taxes, truncateDecimals: true)
    } else {
      return String()
    }
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

Tramos de IRPF

Salario bruto anual - Retención de IRPF

De 0 a 12.450€       - 19%

De 12.450€ a 20.200€ - 24%

De 20.200€ a 35.200€ - 30%

De 35.200€ a 60.000€ - 37%

Más de 60.000€       - 45%
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
  
  static let mortgageInterestMessage = AlertMessage(title: "Intereses de la hipoteca", message: """
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
  
  static let grossReturnMessage = AlertMessage(title: "Rentabilidad bruta", message: """
La rentabilidad bruta es la diferencia entre los ingresos que se obtienen por el alquiler del inmueble y los gastos que conlleva la compra.
""")
  
  static let netReturnMessage = AlertMessage(title: "Rentabilidad neta", message: """
La rentabilidad neta es aquella que se refiere a los beneficios obtenidos con el alquiler, una vez descontados los gastos periódicos y los impuestos.
""")
  
  static let cashflowMessage = AlertMessage(title: "Cashflow", message: """
El flujo de caja en este caso es el beneficio neto después de haber pagado la deuda hipotecaria del periodo (si la hubiera).
""")
  
  static let roiMessage = AlertMessage(title: "ROI", message: """
El ROI o retorno sobre la inversión es un índice que permite calcular el rendimiento de una inversión. Mide el porcentaje de retorno que una inversión en un inmueble genera en un año.
""")
  
  static let perMessage = AlertMessage(title: "PER", message: """
El PER equivale al número de veces que el precio de alquiler está contenido en el precio de venta o al número de años que tardaríamos en pagar el precio de un inmueble mediante el alquiler en las codiciones actuales.
""")
}
