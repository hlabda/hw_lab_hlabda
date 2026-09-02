import SwiftUI

struct ContentView: View {
    @StateObject private var viewController = ViewController()
    @State private var inputTemp = ""

    private var inputUnit: String {
        viewController.isConvertingCtoF ? "°C" : "°F"
    }

    private var outputUnit: String {
        viewController.isConvertingCtoF ? "°F" : "°C"
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                    .opacity(0.50)

                LinearGradient(
                    gradient: Gradient(colors: [.white, .gray]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .opacity(0.45)

                VStack(spacing: 24) {
                    Spacer()

                    Text("\(viewController.convertedTempString) \(outputUnit)")
                        .font(.largeTitle)
                        .fontWeight(.ultraLight)
                        .accessibilityIdentifier("convertedTemperature")

                    Spacer()

                    VStack(spacing: 10) {
                        Text("Enter Temperature:")
                            .fontWeight(.bold)

                        HStack(spacing: 10) {
                            TextField("temperature", text: $inputTemp)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numbersAndPunctuation)
                                .textFieldStyle(.plain)
                                .padding(.horizontal, 10)
                                .frame(width: 200, height: 38)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.white, lineWidth: 1)
                                }
                                .accessibilityIdentifier("temperatureInput")
                                .onSubmit(performConversion)

                            Text(inputUnit)
                                .fontWeight(.medium)
                        }
                    }

                    Spacer()

                    HStack(alignment: .center, spacing: 12) {
                        Text("°F → °C")
                            .fontWeight(.bold)

                        Toggle("Conversion direction", isOn: $viewController.isConvertingCtoF)
                            .labelsHidden()
                            .frame(width: 50)
                            .accessibilityIdentifier("conversionDirectionToggle")

                        Text("°C → °F")
                            .fontWeight(.bold)
                    }
                    .padding()

                    Button("Convert", action: performConversion)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .accessibilityIdentifier("convertButton")

                    Spacer()

                    NavigationLink(destination: InfoView()) {
                        Image(systemName: "info.circle")
                            .font(.title2)
                            .foregroundColor(.white)
                            .accessibilityLabel("About TempConverter")
                    }
                    .padding(.bottom, 30)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }

    private func performConversion() {
        viewController.setInputTempString(inputTemp)
        viewController.convert()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
