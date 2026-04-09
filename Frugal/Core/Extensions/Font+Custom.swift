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

    static var customHero: Font { .custom(.hero) }
    static var customDisplay: Font { .custom(.display) }
    static var customLargeTitle: Font { .custom(.largeTitle) }
    static var customTitle1: Font { .custom(.title1) }
    static var customTitle2: Font { .custom(.title2) }
    static var customHeadline: Font { .custom(.headline) }
    static var customSubheadline: Font { .custom(.subheadline) }
    static var customBody: Font { .custom(.body) }
    static var customCallout: Font { .custom(.callout) }
    static var customCaption: Font { .custom(.caption) }
    static var customFootnote: Font { .custom(.footnote) }
    static var customLabel: Font { .custom(.label) }
    
    static var customTitleBold: Font { .sfPro(size: 28, weight: .bold) }
    static var customHeroSymbol: Font { .sfPro(size: 80) }
    static var customLogoSymbol: Font { .sfPro(size: 50) }
}

extension Font.Style {
    // Large, impactful heading styles
    static let hero = Self(size: 48, weight: .bold, tracking: -1.2)
    static let display = Self(size: 40, weight: .bold, tracking: -1.0)
    static let largeTitle = Self(size: 34, weight: .bold, tracking: -0.8)
    
    // Standard titles
    static let title1 = Self(size: 28, weight: .semibold, tracking: -0.6)
    static let title2 = Self(size: 22, weight: .semibold, tracking: -0.4)
    static let title3 = Self(size: 20, weight: .semibold, tracking: -0.3)
    
    // UI Elements
    static let headline = Self(size: 17, weight: .semibold, tracking: -0.2)
    static let subheadline = Self(size: 15, weight: .medium, tracking: -0.1)
    
    // Content body
    static let body = Self(size: 17, weight: .regular, tracking: -0.2)
    static let callout = Self(size: 16, weight: .regular, tracking: -0.1)
    
    // Secondary info
    static let caption = Self(size: 13, weight: .medium, tracking: 0.0)
    static let footnote = Self(size: 13, weight: .regular, tracking: 0.1)
    static let small = Self(size: 12, weight: .regular, tracking: 0.1)
    
    // Labels & Metadata
    static let label = Self(size: 11, weight: .bold, tracking: 0.6)
    static let button = Self(size: 17, weight: .semibold, tracking: -0.2)
}

extension Text {
    func customStyle(_ style: Font.Style) -> Text {
        font(.custom(style))
            .tracking(style.tracking)
    }
}

extension View {
    func customStyle(_ style: Font.Style) -> some View {
        font(.custom(style))
    }
    
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
