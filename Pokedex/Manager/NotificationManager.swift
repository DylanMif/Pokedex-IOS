//
//  NotificationManager.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/24/25.
//

import Foundation
import UserNotifications
import Foundation


class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func scheduleRandomPokemonNotification() async throws {
        let center = UNUserNotificationCenter.current()
        
        // Créer le contenu de la notification
        let content = UNMutableNotificationContent()
        content.title = "Découvrir un nouveau pokémon"
        content.body = "Cliquez pour découvrir un Pokémon mystère !"
        content.sound = .default
        content.userInfo = ["showPokemon": true]  // Ajout d'information pour identifier la notification
        
        // Configurer pour chaque jour à 9h
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        // Créer le trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Créer la requête
        let request = UNNotificationRequest(
            identifier: "dailyPokemon",
            content: content,
            trigger: trigger
        )
        
        // Ajouter la notification
        try await center.add(request)
    }
    
    // Notification reçue quand l'app est en arrière-plan
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("Notification reçue en arrière-plan")
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: NSNotification.Name("ShowPokemonDetail"),
                object: nil
            )
        }
        
        completionHandler()
    }
    
    // Notification reçue quand l'app est au premier plan
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("Notification reçue au premier plan")
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: NSNotification.Name("ShowPokemonDetail"),
                object: nil
            )
        }
        
        completionHandler([.banner, .sound])
    }
}
