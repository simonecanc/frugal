# Frugal - iOS 26 Liquid Glass 🚀

Boilerplate professionale per app iOS con SwiftUI, componenti nativi Liquid Glass di iOS 26, autenticazione Supabase, e architettura MVVM clean.

## ✨ Features

- 🎨 **Liquid Glass Design System** - Componenti UI con effetti glassmorphism e animazioni fluide
- 🔐 **Autenticazione Sicura** - Google Sign-In, Apple Sign-In e Supabase Auth
- 💾 **Database** - Integrazione completa con Supabase
- 🔒 **Sicurezza** - Keychain storage per token e dati sensibili
- 🏗 **Architettura Clean** - MVVM pattern con separazione tra Core e Features
- 🛠 **Development Mode** - Skip login per velocizzare lo sviluppo
- 📱 **iOS 17+** - Supporto per le ultime features di SwiftUI

## 📦 Struttura del Progetto

```
Frugal/
├── App/
│   ├── FrugalApp.swift        # Entry point
│   └── Config/
│       └── Environment.swift          # Configurazioni ambiente
│
├── Core/                               # Logica di business
│   ├── Services/
│   │   ├── AuthService.swift          # Gestione autenticazione
│   │   ├── SupabaseService.swift      # Client Supabase
│   │   └── KeychainService.swift      # Storage sicuro
│   ├── Models/
│   │   └── User.swift                 # Modelli dati
│   └── Extensions/
│
├── Features/                           # UI e ViewModels
│   ├── Auth/
│   │   ├── Views/
│   │   │   └── LoginView.swift
│   │   └── ViewModels/
│   ├── Home/
│   │   ├── Views/
│   │   │   └── HomeView.swift
│   │   └── ViewModels/
│   └── Components/
│       └── LiquidGlass/               # Componenti Liquid Glass
│           ├── LiquidGlassBackground.swift
│           ├── LiquidGlassButton.swift
│           ├── LiquidGlassCard.swift
│           └── LiquidGlassTabBar.swift
│
└── Resources/
    └── Assets.xcassets
```

## 🚀 Getting Started

### Prerequisiti

- Xcode 15+
- iOS 17.0+
- Account Supabase (gratuito su [supabase.com](https://supabase.com))

### Setup Iniziale

1. **Clona o copia il boilerplate**
   ```bash
   cp -r Frugal MyNewApp
   cd MyNewApp
   ```

2. **Configura Supabase**
   - Crea un nuovo progetto su [Supabase](https://supabase.com)
   - Copia URL e Anon Key dal dashboard
   - Aggiorna `Environment.swift`:
   ```swift
   var supabaseURL: String {
       return "YOUR_SUPABASE_URL"
   }
   
   var supabaseAnonKey: String {
       return "YOUR_SUPABASE_ANON_KEY"
   }
   ```

3. **Configura Google Sign-In**
   - Segui la [guida Google](https://developers.google.com/identity/sign-in/ios/start)
   - Aggiungi il tuo Google Client ID in `Environment.swift`

4. **Configura Apple Sign-In**
   - Abilita Sign in with Apple nelle Capabilities del progetto
   - Configura nel tuo Apple Developer Account

### Development Mode

Durante lo sviluppo, puoi skippare il login:

1. Avvia l'app in modalità Debug
2. Nella schermata di login, trova il pulsante "Enable Skip Login"
3. L'app userà un utente mock per lo sviluppo

## 🎨 Componenti Liquid Glass

### LiquidGlassButton
```swift
LiquidGlassButton(
    title: "Get Started",
    icon: "arrow.right",
    action: {
        // Your action
    }
)
```

### LiquidGlassCard
```swift
LiquidGlassCard {
    // Your content
    Text("Card Content")
}
```

### LiquidGlassBackground
```swift
ZStack {
    LiquidGlassBackground()
    // Your content
}
```

### LiquidGlassTabBar
Già integrata in `MainTabView`, personalizzabile modificando l'enum `Tab`.

## 🔐 Sicurezza

### Keychain Storage
Tutti i token sono salvati in modo sicuro nel Keychain:
```swift
// Save token
KeychainService.shared.saveToken(token)

// Get token
let token = KeychainService.shared.getToken()

// Delete token
KeychainService.shared.deleteToken()
```

### Best Practices Implementate
- ✅ Token storage nel Keychain
- ✅ SSL Pinning ready
- ✅ Nessun dato sensibile nei logs
- ✅ Autenticazione con provider OAuth sicuri
- ✅ Validazione sessione all'avvio

## 📱 Supporto iOS Versions

- **iOS 17+**: Pieno supporto con tutte le features
- **iOS 18+**: Ottimizzazioni per Liquid Glass quando disponibili
- **iOS 26**: Preparato per future Liquid Glass APIs

## 🛠 Personalizzazione

### Cambiare i Colori del Tema
Modifica i colori in `LiquidGlassBackground.swift`:
```swift
LinearGradient(
    colors: [
        Color(red: 0.1, green: 0.2, blue: 0.45),  // Personalizza
        Color(red: 0.1, green: 0.1, blue: 0.3),   // questi
        Color(red: 0.05, green: 0.05, blue: 0.2)  // colori
    ],
    ...
)
```

### Aggiungere Nuove Features
1. Crea una nuova cartella in `Features/`
2. Aggiungi Views e ViewModels
3. Importa i componenti Liquid Glass necessari

### Modificare la Tab Bar
Edita l'enum `Tab` in `LiquidGlassTabBar.swift`:
```swift
enum Tab: String, CaseIterable {
    case home = "house.fill"
    case search = "magnifyingglass"
    // Aggiungi nuovi tab qui
}
```

## 📄 Prossimi Passi per i Tuoi Progetti

1. **Rinomina il progetto** con il nome della tua app
2. **Configura i servizi** (Supabase, Google, Apple)
3. **Personalizza il tema** secondo il tuo brand
4. **Aggiungi le tue features** nella cartella Features
5. **Configura CI/CD** per deployment automatico
6. **Aggiungi analytics** se necessario
7. **Implementa push notifications** se richieste

## 🤝 Contributing

Questo è un boilerplate base. Sentiti libero di:
- Aggiungere nuovi componenti Liquid Glass
- Migliorare la sicurezza
- Ottimizzare le performance
- Aggiungere nuove integrazioni

## 📜 License

Usa questo boilerplate liberamente per i tuoi progetti commerciali e non.

## 🙏 Credits

Creato con ❤️ per la community iOS italiana.

---

**Happy Coding! 🚀**
