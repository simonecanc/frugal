import SwiftUI

extension Font {
    // MARK: - Custom Fonts
    
    /// Kefir font names (PostScript names)
    struct CustomFontNames {
        static let regular = "Kefir-Regular"
        static let bold = "Kefir-Bold"
        static let light = "Kefir-Light"
        static let medium = "Kefir-Medium"
    }
    
    // MARK: - Font Factory Methods
    
    static func customRegular(size: CGFloat) -> Font {
        return .custom(CustomFontNames.regular, size: size)
    }
    
    static func customBold(size: CGFloat) -> Font {
        return .custom(CustomFontNames.bold, size: size)
    }
    
    static func customLight(size: CGFloat) -> Font {
        return .custom(CustomFontNames.light, size: size)
    }
    
    static func customMedium(size: CGFloat) -> Font {
        return .custom(CustomFontNames.medium, size: size)
    }
    
    // MARK: - Predefined Sizes
    
    static var customTitle: Font {
        return .customBold(size: 28)
    }
    
    static var customTitleBold: Font {
        return .customBold(size: 28)
    }
    
    static var customTitleRegular: Font {
        return .customRegular(size: 22)
    }
    
    static var customHeadline: Font {
        return .customBold(size: 22)
    }
    
    static var customSubheadline: Font {
        return .customRegular(size: 18)
    }
    
    static var customSubheadlineLight: Font {
        return .customLight(size: 18)
    }
    
    static var customBody: Font {
        return .customRegular(size: 16)
    }
    
    static var customCaption: Font {
        return .customLight(size: 14)
    }
    
    static var customSmall: Font {
        return .customLight(size: 12)
    }
}

// MARK: - Font Loading Utility
extension Font {
    /// Utility per verificare se i font sono caricati correttamente
    static func printAvailableFonts() {
        for family in UIFont.familyNames.sorted() {
            print("Font Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family).sorted() {
                print("  Font Name: \(name)")
            }
        }
    }
    
    /// Verifica se un font personalizzato è disponibile
    static func isCustomFontAvailable(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 16) != nil
    }
}