import SwiftUI

struct InfoView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.65), Color.gray.opacity(0.45)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "thermometer.medium")
                    .font(.system(size: 64))
                    .foregroundStyle(.white)

                Text("About TempConverter")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("TempConverter quickly converts whole-number temperatures between Celsius and Fahrenheit. Enter a value, choose the direction, and tap Convert.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text("Values below absolute zero and non-numeric entries are shown as N/A.")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Information")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InfoView()
        }
    }
}
