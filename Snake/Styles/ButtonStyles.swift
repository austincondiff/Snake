import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(Color(uiColor: .systemBackground))
            .background(Color(uiColor: .label))
            .fontDesign(.monospaced)
            .fontWeight(.bold)
            .textCase(.uppercase)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(Color(uiColor: .label))
            .background(Color(uiColor: .label).opacity(0.15))
            .fontDesign(.monospaced)
            .fontWeight(.bold)
            .textCase(.uppercase)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { .init() }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle { .init() }
} 
