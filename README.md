# NavigationRouter

NavigationRouter is a lightweight, centralized navigation manager for SwiftUI.

### Why use NavigationRouter?

Managing state with standard SwiftUI `NavigationLink` setups can quickly become messy and scattered across multiple files. AppRouter solves this by extracting navigation logic out of your views and into a clean, reusable `@Observable` class. 

Instead of wrapping your UI elements in complex and deeply nested navigation hierarchies, you simply inject a router into the environment. This allows you to trigger navigation programmatically from anywhere in your app:

```swift
@Environment(\.router) private var router

Button("Go to Profile") {
    router.navigate(to: Route(id: "Profile") { ProfileView() })
}
```

Whether you need to handle deep linking, complex tab bar navigation, or global pop-to-root events, NavigationRouter makes your navigation predictable and easy to manage!

### How to Use

Because `Route` is a struct, you can easily extend it in your application to create a beautiful, enum-like dot syntax for all your routes.

**1. Define your routes in an extension:**

```swift
import NavigationRouter
import SwiftUI

extension Route {
    // Acts like a static route
    static var home: Route {
        Route(id: "home") {
            HomeView()
        }
    }
    
    // Acts like a route with parameters
    static func profile(id: String) -> Route {
        Route(id: "profile_\(id)") {
            ProfileView(userId: id)
        }
    }
}
```

**2. Use it in your app:**

```swift
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
        .useAppRouter(router) // One line setup
    }
}

struct HomeView: View {
    @Environment(\.router) private var router // Router is automatically injected
    
    var body: some View {
        Button("Go Back") { router.pop() }
    }
}
```
