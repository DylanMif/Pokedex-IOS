## Pokédex SwiftUI

Ce projet est une application iOS développée en SwiftUI permettant d’afficher un Pokédex interactif. L’application récupère les données depuis l’API PokéAPI, 
affiche les détails des Pokémon, propose des fonctionnalités de recherche, de filtrage, de tri, et intègre des animations ainsi que des notifications 
locales.

### Fonctionnalités
- Liste des Pokémon : Affichage de la liste complète des Pokémon avec leurs images et noms.
- Détails d’un Pokémon : Affichage des informations détaillées d’un Pokémon sélectionné, incluant son image, ses types et ses statistiques principales.
- Recherche et filtrage : Recherche par nom et filtrage par type de Pokémon.
- Tri : Options de tri par ordre alphabétique ou par statistiques.
- Animations : Animations lors de l’affichage des cartes de Pokémon et des interactions utilisateur.
- Notifications locales : Rappels quotidiens pour découvrir un Pokémon aléatoire et notifications lors de changements de type des Pokémon favoris.

### Prérequis
- Xcode 13 ou version ultérieure
- iOS 15 ou version ultérieure

### Installation
- Clonez le dépôt du projet : `git clone https://github.com/votre_nom_utilisateur/pokedex-swiftui.git`


- Ouvrez le projet dans Xcode :

```bash
cd pokedex-swiftui
open PokedexSwiftUI.xcodeproj
```
- Assurez-vous de sélectionner le simulateur ou l’appareil iOS approprié.
- Compilez et exécutez l’application en cliquant sur le bouton “Run” ou en utilisant le raccourci Cmd + R.

### Utilisation
- Navigation : Parcourez la liste des Pokémon et appuyez sur un Pokémon pour afficher ses détails.
- Recherche : Utilisez la barre de recherche pour trouver un Pokémon par son nom.
- Filtrage : Sélectionnez un type spécifique pour afficher uniquement les Pokémon correspondants.
- Tri : Choisissez l’option de tri souhaitée pour organiser la liste des Pokémon.
- Favoris : Dans les détails d’un Pokémon, appuyez sur le bouton “Ajouter aux favoris” pour le sauvegarder localement.

### Structure du Projet
- Models/ : Contient les structures de données représentant les Pokémon et leurs attributs.
- Views/ : Regroupe les vues SwiftUI pour l’affichage de la liste et des détails des Pokémon.
- ViewModels/ : Inclut les modèles de vue gérant la logique métier et l’interaction entre les vues et les données.
- Services/ : Contient les services responsables de la récupération des données depuis l’API et de la gestion de la base de données locale avec CoreData.

### Ressources
- PokéAPI : API publique fournissant les données des Pokémon. Site officiel
- Documentation SwiftUI : Guide officiel d’Apple pour SwiftUI. Lien

### Auteur
- PHAM HUYNH Tuong Vy :
  - Récupération des données via l'API, et implémentation cache local
  - Filtrage et tri avancé
  - Ajout d'animations et intéractions avancées
  - Ajout thème sombre et claire
  - Design
- MIFTARI Dylan :
  - Liste des pokémons et chargement dynamique via l'API
  - Notification quotidienne
  - Jeu Guess the types
  - Design
- TREHOU Nicolas :
  - Cartes intéractive
  - Page de détail des Pokémons
  - Récupération des données via l'API
  - Animations
  - Design

Licence

Ce projet est sous licence MIT. Veuillez consulter le fichier LICENSE pour plus d’informations.

Ce fichier README fournit une vue d’ensemble complète du projet, incluant ses fonctionnalités, les instructions d’installation, la structure du projet et les ressources utiles.
