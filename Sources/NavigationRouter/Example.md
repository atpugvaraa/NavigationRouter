How a Developer Uses Your Package
Because Route is a struct, developers can just extend it in their application. It feels exactly like adding cases to an enum!

1. They define their routes in an extension:

``` swift
import AppRouter
import SwiftUI
extension Route {
    // Acts like `case home`
    static var home: Route {
        Route(id: "home") {
            HomeView()
        }
    }
    
    // Acts like `case profile(String)`
    static func profile(id: String) -> Route {
        Route(id: "profile_\(id)") {
            ProfileView(userId: id)
        }
    }
}
```

2. They use it in their app:

``` swift
struct RootAppView: View {
    @State private var router = Router()
    
    var body: some View {
        VStack {
            Button("Go to Home") {
                router.navigate(to: .home) // Beautiful dot syntax!
            }
            
            Button("Go to Profile") {
                router.navigate(to: .profile(id: "456")) 
            }
        }
        .usingAppRouter(router) // One line setup
    }
}

struct HomeView: View {
    @Environment(Router.self) private var router // Router is automatically injected
    
    var body: some View {
        Button("Go Back") { router.pop() }
    }
}
```