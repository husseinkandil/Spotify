//
//  SceneDelegate.swift
//  Spotify
//
//  Created by Hussein Kandil on 18/05/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private let apiClient = APIClient()
    private lazy var loginViewModel = LoginViewModel(with: apiClient)
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        
        if AuthenticationManager.shared.isSignedIn,
           let user = AuthenticationManager.shared.getUser() {
            
            let username =  user.display_name
            let image = user.images.first?.url
            let id = user.id
            
            let user = SignedinUserProfile(image: image, username: username, id: id)
            let viewModel = SearchViewModel(user: user)
            let isAuthVc = UINavigationController(rootViewController: SearchViewController(viewModel: viewModel))
            window.makeKeyAndVisible()
            self.window = window
            window.rootViewController = isAuthVc
        } else {
        
        let navViewController = UINavigationController(rootViewController: LoginViewController(viewModel: loginViewModel))
        window.rootViewController = navViewController
        
        
        window.makeKeyAndVisible()
        self.window = window
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: { $0.name == "code"})?.value else { return }
        print("code :\(code)")
        
        loginViewModel.code.accept(code)
    }
}
