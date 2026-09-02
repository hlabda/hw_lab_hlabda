import Foundation

/// Model responsible for validation and temperature conversion.
final class TempConverter {
    enum TemperatureUnit {
        case celsius
        case fahrenheit
    }

    private var isConvertingCtoF = true
    private var inputTemp = 0
    private var convertedTemp: Int?

    /// The lab's algorithm uses this function as an "is valid" check: it
    /// returns true only when the input is above the relevant absolute zero.
    func isBelowAbsoluteZero() -> Bool {
        if isConvertingCtoF {
            return inputTemp > -273
        } else {
            return Double(inputTemp) > -459.67
        }
    }

    func setInputUnit(_ tempUnit: TemperatureUnit) {
        switch tempUnit {
        case .celsius:
            isConvertingCtoF = true
        case .fahrenheit:
            isConvertingCtoF = false
        }
    }

    func setInputTemp(_ temp: Int) {
        inputTemp = temp
    }

    func getConvertedTemp() -> Int? {
        convertedTemp
    }

    private func celsiusToFahrenheit() {
        convertedTemp = Int((Double(inputTemp) * 9.0 / 5.0) + 32.0)
    }

    private func fahrenheitToCelsius() {
        convertedTemp = Int((Double(inputTemp) - 32.0) * 5.0 / 9.0)
    }

    func convert() {
        guard isBelowAbsoluteZero() else {
            convertedTemp = nil
            return
        }

        if isConvertingCtoF {
            celsiusToFahrenheit()
        } else {
            fahrenheitToCelsius()
        }
    }
}
