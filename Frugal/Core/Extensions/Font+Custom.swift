import SwiftUI

extension Font {
    // MARK: - App Typography

    struct Style {
        let size: CGFloat
        let weight: Weight
        let tracking: CGFloat

        fileprivate var font: Font {
            .sfPro(size: size, weight: weight)
        }
    }

    // MARK: - Font Factory Methods

    /// SF Pro is the native system font on Apple platforms.
    static func sfPro(size: CGFloat, weight: Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }

    static func custom(_ style: Style) -> Font {
        style.font
    }

    static func customRegular(size: CGFloat) -> Font {
        .sfPro(size: size, weight: .regular)
    }

    static func customBold(size: CGFloat) -> Font {
        .sfPro(size: size, weight: .bold)
    }

    static func customLight(size: CGFloat) -> Font {
        .sfPro(size: size, weight: .light)
    }

    static func customMedium(size: CGFloat) -> Font {
        .sfPro(size: size, weight: .medium)
    }

    // MARK: - Predefined Sizes

    static var customTitle: Font {
        .custom(.title)
    }

    static var customTitleBold: Font {
        .custom(.titleBold)
    }

    static var customTitleRegular: Font {
        .custom(.toolbarTitle)
    }

    static var customHeadline: Font {
        .custom(.headline)
    }

    static var customSubheadline: Font {
        .custom(.subheadline)
    }

    static var customSubheadlineLight: Font {
        .custom(.subheadlineLight)
    }

    static var customBody: Font {
        .custom(.body)
    }

    static var customCaption: Font {
        .custom(.caption)
    }

    static var customSmall: Font {
        .custom(.small)
    }

    static var customHeroSymbol: Font {
        .sfPro(size: 80)
    }

    static var customLogoSymbol: Font {
        .sfPro(size: 50)
    }
}

extension Font.Style {
    static let largeTitle = Self(size: 34, weight: .bold, tracking: -1.1)
    static let title = Self(size: 28, weight: .semibold, tracking: -0.9)
    static let titleBold = Self(size: 28, weight: .bold, tracking: -1.0)
    static let toolbarTitle = Self(size: 22, weight: .medium, tracking: -0.7)
    static let headline = Self(size: 22, weight: .semibold, tracking: -0.7)
    static let subheadline = Self(size: 18, weight: .regular, tracking: -0.35)
    static let subheadlineLight = Self(size: 18, weight: .light, tracking: -0.35)
    static let body = Self(size: 16, weight: .regular, tracking: -0.24)
    static let caption = Self(size: 14, weight: .regular, tracking: -0.18)
    static let small = Self(size: 12, weight: .regular, tracking: -0.1)
    static let button = Self(size: 17, weight: .semibold, tracking: -0.4)
}

extension Text {
    func customStyle(_ style: Font.Style) -> Text {
        font(.custom(style))
            .tracking(style.tracking)
    }
}

extension View {
    func customFont(_ style: Font.Style) -> some View {
        font(.custom(style))
    }
}

// MARK: - Font Utility
extension Font {
    /// Utility per verificare i font disponibili a runtime.
    static func printAvailableFonts() {
        for family in UIFont.familyNames.sorted() {
            print("Font Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family).sorted() {
                print("  Font Name: \(name)")
            }
        }
    }

    /// Verifica se un font specifico è disponibile.
    static func isCustomFontAvailable(_ fontName: String) -> Bool {
        UIFont(name: fontName, size: 16) != nil
    }
}
