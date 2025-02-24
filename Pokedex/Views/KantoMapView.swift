//
//  KantoMapView.swift
//  Pokedex
//
//  Created by Nicolas TREHOU on 2/24/25.
//

import SwiftUI

struct KantoMapView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var region: Region?
    @State private var locations: [Location] = []
    @State private var selectedLocation: Location?
    @State private var showLocationDetail: Bool = false {
        didSet {
            if showLocationDetail && selectedLocation == nil {
                showLocationDetail = false
            }
        }
    }
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var imageSize: CGSize = .zero
    
    
    var body: some View {
        VStack(spacing: 0) {
            // En-tête avec titre
            VStack(spacing: 8) {
                Text("RÉGION DE KANTO")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Découvrez les Pokémon dans chaque lieu")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color.red, Color.red.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            ZStack {
                // Fond avec l'image de la carte de Kanto
                GeometryReader { geometry in
                    Image("KantoMap")
                        .resizable()
                        .scaledToFit()
                        .background(Color(UIColor.systemBackground))
                        .overlay(
                            GeometryReader { imageGeometry -> Color in
                                DispatchQueue.main.async {
                                    self.imageSize = imageGeometry.size
                                }
                                return Color.clear
                            }
                        )
                    
                    // Points cliquables pour chaque location
                    ForEach(locations) { location in
                        LocationButton(
                            location: location,
                            mapSize: imageSize,
                            viewSize: geometry.size
                        ) {
                            // D'abord définir la location, puis ouvrir la sheet
                            selectedLocation = location
                            DispatchQueue.main.async {
                                // Petit délai pour s'assurer que selectedLocation est bien défini
                                showLocationDetail = true
                            }
                        }
                    }
                }
                
                if isLoading {
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .ignoresSafeArea()
                        
                        VStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                            
                            Text("Chargement de la carte...")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding(20)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                    }
                }
            }
        }
        .navigationBarTitle("Pokémon Map", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                        Text("Retour")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                }
            }
        }
        .sheet(item: $selectedLocation) { location in
            LocationDetailView(location: location)
        }
        .alert("Erreur", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Text(errorMessage ?? "")
            Button("Réessayer") {
                Task {
                    await loadKantoRegion()
                }
            }
        }
        .task {
            await loadKantoRegion()
        }
    }
    
    private func loadKantoRegion() async {
        isLoading = true
        do {
            let kantoRegion = try await PokemonService.shared.fetchKantoRegion()
            locations = []  // Réinitialiser pour éviter les doublons
            for locationResource in kantoRegion.locations {
                if let location = try? await PokemonService.shared.fetchLocation(url: locationResource.url) {
                    locations.append(location)
                }
            }
            self.region = kantoRegion
        } catch {
            errorMessage = "Impossible de charger la région de Kanto: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

struct LocationButton: View {
    let location: Location
    let mapSize: CGSize
    let viewSize: CGSize
    let action: () -> Void
    
    // Détermine le type de lieu pour afficher une couleur différente
    var locationType: LocationType {
        if location.name.contains("city") || location.name.contains("town") {
            return .city
        } else if location.name.contains("route") {
            return .route
        } else {
            return .specialArea
        }
    }
    
    var buttonColor: Color {
        switch locationType {
        case .city:
            return .red
        case .route:
            return .green
        case .specialArea:
            return .blue
        }
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Cercle externe avec animation de pulsation
                Circle()
                    .fill(buttonColor.opacity(0.3))
                    .frame(width: 24, height: 24)
                    .modifier(PulseAnimation())
                
                // Cercle principal
                Circle()
                    .fill(buttonColor)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
        }
        .position(getScaledPosition(for: location))
        
    }
    
    private func getScaledPosition(for location: Location) -> CGPoint {
        // Obtenir les coordonnées de base
        let basePosition = getBasePosition(for: location)
        
        // Calculer le ratio pour la mise à l'échelle
        let widthRatio = viewSize.width / 400  // 400 est la largeur de référence
        let heightRatio = widthRatio           // Maintenir le ratio d'aspect
        
        return CGPoint(
            x: basePosition.x * widthRatio,
            y: basePosition.y * heightRatio
        )
    }
    
    private func getBasePosition(for location: Location) -> CGPoint {
        // Définir les coordonnées pour chaque location
        switch location.name {
        case "pallet-town":
            return CGPoint(x: 119, y: 270)
        case "viridian-city":
            return CGPoint(x: 119, y: 199)
        case "pewter-city":
            return CGPoint(x: 119, y: 92)
        case "cerulean-city":
            return CGPoint(x: 251, y: 92)
        case "vermilion-city":
            return CGPoint(x: 251, y: 211)
        case "lavender-town":
            return CGPoint(x: 333, y: 158)
        case "celadon-city":
            return CGPoint(x: 192, y: 157)
        case "saffron-city":
            return CGPoint(x: 251, y: 157)
        case "fuchsia-city":
            return CGPoint(x: 231, y: 300)
        case "cinnabar-island":
            return CGPoint(x: 121, y: 335)
        case "indigo-plateau":
            return CGPoint(x: 53, y: 77)
        // Ajoutez les autres locations ici
        default:
            return CGPoint(x: -50, y: -50)  // Hors écran
        }
    }
    
    private func getLocalizedName(for location: Location) -> String {
        if let frName = location.names.first(where: { $0.language?.name == "fr" })?.name {
            return frName
        } else if let enName = location.names.first(where: { $0.language?.name == "en" })?.name {
            return enName
        }
        return location.name.capitalized
    }
}

// Types de lieux pour la coloration
enum LocationType {
    case city
    case route
    case specialArea
}

// Animation de pulsation pour les points
struct PulseAnimation: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.2 : 1.0)
            .opacity(isAnimating ? 0.6 : 1.0)
            .animation(
                Animation
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}
struct LocationDetailView: View {
    let location: Location
    @State private var pokemonEncounters: [PokemonEncounter] = []
    @State private var pokemonDetails: [String: PokemonDetail] = [:]
    @State private var encounterMethods: [String: EncounterMethod] = [:]
    @State private var isLoading = false
    @State private var methodGroups: [String: [String: [Int]]] = [:]  // [Méthode: [PokemonName: [Chances]]]
    @Namespace private var namespace
    
    var localizedName: String {
        if let frName = location.names.first(where: { $0.language?.name == "fr" })?.name {
            return frName
        } else if let enName = location.names.first(where: { $0.language?.name == "en" })?.name {
            return enName
        }
        return location.name.capitalized
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(localizedName)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.horizontal)
                
                if isLoading {
                    HStack {
                        Spacer()
                        VStack {
                            ProgressView()
                            Text("Chargement...")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                        }
                        Spacer()
                    }
                    .padding(.top, 30)
                } else if methodGroups.isEmpty {
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "map")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("Aucun Pokémon trouvé dans cette zone")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.top, 30)
                } else {
                    ForEach(getSortedMethods(), id: \.self) { methodName in
                        if let pokemonGroup = methodGroups[methodName], !pokemonGroup.isEmpty {
                            Text(getLocalizedMethodName(methodName: methodName))
                                .font(.headline)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                            
                            pokemonGrid(for: pokemonGroup)
                            
                            Divider()
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle(localizedName)
        .task {
            await loadPokemonEncounters()
        }
    }
    
    private func pokemonGrid(for pokemonGroup: [String: [Int]]) -> some View {
        let pokemonNames = Array(pokemonGroup.keys).sorted()
        
        return VStack(spacing: 8) {
            // Diviser les Pokémon en groupes de 3
            ForEach(0..<(pokemonNames.count + 2) / 3, id: \.self) { rowIndex in
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { colIndex in
                        let index = rowIndex * 3 + colIndex
                        if index < pokemonNames.count {
                            let pokemonName = pokemonNames[index]
                            let chances = pokemonGroup[pokemonName] ?? []
                            pokemonCard(pokemonName: pokemonName, chances: chances)
                        } else {
                            // Cellule vide pour compléter la rangée
                            Color.clear
                                .frame(maxWidth: .infinity)
                                .frame(height: 110)
                        }
                    }
                }
            }
        }
    }
    
    private func pokemonCard(pokemonName: String, chances: [Int]) -> some View {
        return Group {
            if let details = pokemonDetails[pokemonName], let id = details.id {
                NavigationLink(destination: PokemonDetailsView(pokemonId: id, namespace: namespace)) {
                    VStack(spacing: 4) {
                        // Image
                        AsyncImage(url: URL(string: details.sprites?.front_default ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 60, height: 60)
                        }
                        
                        // Nom
                        Text(details.name?.capitalized ?? "")
                            .font(.caption)
                            .fontWeight(.medium)
                            .lineLimit(1)
                        
                        // Chances
                        Text(formatChances(chances))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .frame(height: 110)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
            } else {
                // Placeholder pendant le chargement
                VStack {
                    ProgressView()
                    Text("Chargement...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .background(Color.white)
                .cornerRadius(10)
            }
        }
    }
    
    private func formatChances(_ chances: [Int]) -> String {
        // Trier et dédupliquer les chances
        let uniqueChances = Array(Set(chances)).sorted(by: >)
        
        if uniqueChances.count == 1 {
            return "\(uniqueChances[0])%"
        } else {
            return uniqueChances.map { "\($0)%" }.joined(separator: ", ")
        }
    }
    
    private func getSortedMethods() -> [String] {
        return methodGroups.keys.sorted()
    }
    
    private func getLocalizedMethodName(methodName: String) -> String {
        if let method = encounterMethods[methodName],
           let frName = method.names.compactMap({ $0 }).first(where: { $0.language?.name == "fr" })?.name {
            return frName
        }
        return methodName.capitalized
    }
    
    private func loadPokemonEncounters() async {
        isLoading = true
        
        do {
            var tempMethodGroups: [String: [String: [Int]]] = [:]
            
            for area in location.areas {
                do {
                    let locationArea = try await PokemonService.shared.fetchLocationArea(url: area.url)
                    
                    // Charger les méthodes d'encounter
                    for method in locationArea.encounter_method_rates {
                        if let methodName = method.encounter_method.name,
                           encounterMethods[methodName] == nil {
                            if let methodDetails = try? await PokemonService.shared.fetchMethod(url: method.encounter_method.url) {
                                encounterMethods[methodName] = methodDetails
                            }
                        }
                    }
                    
                    // Traiter les rencontres de Pokémon
                    for encounter in locationArea.pokemon_encounters {
                        let pokemonName = encounter.pokemon.name ?? ""
                        
                        // Charger les détails du Pokémon si pas déjà chargés
                        if !pokemonName.isEmpty && pokemonDetails[pokemonName] == nil {
                            if let details = try? await PokemonService.shared.fetchPokemonFromUrl(url: encounter.pokemon.url) {
                                pokemonDetails[pokemonName] = details
                            }
                        }
                        
                        // Organiser par méthode d'encounter et par nom de Pokémon
                        for versionDetail in encounter.version_details {
                            if let encounterDetails = versionDetail.encounter_details {
                                for detail in encounterDetails {
                                    if let methodName = detail.method?.name {
                                        if tempMethodGroups[methodName] == nil {
                                            tempMethodGroups[methodName] = [:]
                                        }
                                        
                                        if tempMethodGroups[methodName]![pokemonName] == nil {
                                            tempMethodGroups[methodName]![pokemonName] = []
                                        }
                                        
                                        let chance = detail.chance ?? 0
                                        tempMethodGroups[methodName]![pokemonName]!.append(chance)
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print("Erreur lors du chargement de l'area \(area.url): \(error)")
                }
            }
            
            // Mettre à jour les groupes pour l'UI
            self.methodGroups = tempMethodGroups
            
        } catch {
            print("Erreur lors du chargement des Pokémon: \(error)")
        }
        
        isLoading = false
    }
}


struct PokemonGridItem: View {
    let details: PokemonDetail
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: details.sprites?.front_default ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
            } placeholder: {
                ProgressView()
                    .frame(width: 80, height: 80)
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Text(details.name?.capitalized ?? "Unknown")
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
                .padding(.top, 2)
            
            HStack(spacing: 4) {
                ForEach(details.types ?? [], id: \.type?.name) { type in
                    if let typeName = type.type?.name {
                        Text(typeName.prefix(1).uppercased())
                            .font(.system(size: 8))
                            .padding(4)
                            .foregroundColor(.white)
                            .background(PokemonTypeColor.getColor(for: typeName))
                            .cornerRadius(4)
                    }
                }
            }
        }
        .frame(width: 100, height: 130)
        .padding(5)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}


struct PokemonEncounterRow: View {
    let details: PokemonDetail
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: details.sprites?.front_default ?? "")) { image in
                image
                    .resizable()
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
            
            VStack(alignment: .leading) {
                Text(details.name?.capitalized ?? "Unknown")
                    .font(.headline)
                HStack {
                    ForEach(details.types ?? [], id: \.type?.name) { type in
                        if let typeName = type.type?.name {
                            Text(typeName.capitalized)
                                .font(.caption)
                                .padding(5)
                                .background(PokemonTypeColor.getColor(for: typeName))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    KantoMapView()
}
