import Combine
import Foundation

/// Observable controller that connects the SwiftUI views to the model.
final class ViewController: ObservableObject {
    private let tempConverter = TempConverter()

    @Published var inputTempString = "Temp"
    @Published var convertedTempString = "Temp"
    @Published var isConvertingCtoF = true {
        didSet {
            // Do not display an old value beside the newly selected unit.
            convertedTempString = "Temp"
        }
    }

    func setInputTempString(_ input: String) {
        inputTempString = input
    }

    func setConvertedTempString() {
        if let convertedTemp = tempConverter.getConvertedTemp() {
            convertedTempString = String(convertedTemp)
        } else {
            convertedTempString = "N/A"
        }
    }

    func setInputTempUnit() {
        if isConvertingCtoF {
            tempConverter.setInputUnit(.celsius)
        } else {
            tempConverter.setInputUnit(.fahrenheit)
        }
    }

    func convert() {
        let trimmedInput = inputTempString.trimmingCharacters(in: .whitespacesAndNewlines)
        let inputTemp = Int(trimmedInput) ?? -500

        setInputTempUnit()
        tempConverter.setInputTemp(inputTemp)
        tempConverter.convert()
        setConvertedTempString()
    }
}
