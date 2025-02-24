//
//  PokemonDetailsView.swift
//  Pokedex
//
//  Created by Nicolas TREHOU on 2/17/25.
//

import SwiftUI

struct PokemonDetailsView: View {
    @StateObject private var viewModel = PokemonDetailsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedTab = "Forms"
    let pokemonId: Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let pokemon = viewModel.pokemon {
                    // Pokemon image et info
                    VStack(spacing: 0) {
                        // Pokemon image with bounce animation
                        if let imageUrl = pokemon.sprites?.front_default,
                           let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 200, height: 200)
                                        .modifier(PokemonBounceAnimation())
                                case .failure(_):
                                    Image(systemName: "photo")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .padding(.top, 32)
                        }
                        
                        // Pokemon info
                        VStack(spacing: 8) {
                            Text(pokemon.name?.capitalized ?? "")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            
                            Text(String(format: "#%03d", pokemon.id ?? 0))
                                .font(.subheadline)
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
                        }
                        .padding(.bottom, 16)
                        .frame(maxWidth: .infinity)
                        // Types
                        HStack(spacing: 12) {
                            ForEach(pokemon.types ?? [], id: \.slot) { type in
                                TypeBadge(type: type.type?.name ?? "Unknown")
                            }
                        }
                        .padding(.vertical, 16)
                    }
                    .background(
                        LinearGradient(
                            colors: getTypeColors(for: pokemon).map { $0.opacity(colorScheme == .dark ? 0.6 : 1.0) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    
                    // Tab selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            ForEach(["Forms", "Detail", "Types", "Stats"], id: \.self) { tab in
                                TabButton(text: tab, isSelected: selectedTab == tab) {
                                    withAnimation { selectedTab = tab }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    
                    // Content based on selected tab
                    switch selectedTab {
                    case "Forms":
                        FormsTabView(pokemon: pokemon, forms: viewModel.pokemonForms)
                    case "Detail":
                        DetailTabView(pokemon: pokemon)
                    case "Types":
                        TypesTabView(pokemon: pokemon)
                    case "Stats":
                        StatsTabView(pokemon: pokemon)
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { viewModel.toggleFavorite() }) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? .red : .primary)
                }
            }
        }
        
                .navigationBarBackButtonHidden(true)
                .edgesIgnoringSafeArea(.top)
                .onAppear {
                    viewModel.loadPokemonDetails(id: pokemonId)
                }
    }
    
    private func getTypeColors(for pokemon: PokemonDetail) -> [Color] {
        guard let types = pokemon.types else {
            return [Color(hex: 0x919AA2)]
        }
        
        let colors = types.prefix(2).map { type in
            PokemonTypeColor.getColor(for: type.type?.name ?? "")
        }
        
        return colors.count == 1 ? [colors[0], colors[0].opacity(0.7)] : colors
    }
}
    
    
// Pokemon bounce animation modifier
struct PokemonBounceAnimation: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .offset(y: isAnimating ? -20 : 0)
            .animation(
                Animation
                    .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}


struct TypeBadge: View {
    let type: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Text(type.capitalized)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.2))
            .cornerRadius(20)
    }
}

struct TabButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(text)
                    .foregroundColor(isSelected ? .black : .gray)
                    .fontWeight(isSelected ? .semibold : .regular)
                
                if isSelected {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct FormsTabView: View {
    let pokemon: PokemonDetail
    let forms: [PokemonForm]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(forms) { form in
                FormCard(form: form)
            }
        }
        .padding(.vertical)
    }
}

struct FormCard: View {
    let form: PokemonForm
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                // Pokemon sprite
                if let imageUrl = form.sprites?.front_default,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .background(getTypeColor(for: form.types ?? []).opacity(0.2))
                                .cornerRadius(12)
                        case .failure, .empty:
                            Color.gray.opacity(0.2)
                                .frame(width: 60, height: 60)
                                .cornerRadius(12)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    // Form name
                    Text((form.form_name?.isEmpty ?? true ? form.name?.capitalized : form.form_name?.capitalized) ?? "Unknown")
                        .font(.headline)
                    
                    // Form details
                    HStack(spacing: 8) {
                        if form.is_mega ?? false {
                            Label("Mega", systemImage: "bolt.fill")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        
                        if form.is_battle_only ?? false {
                            Label("Battle Only", systemImage: "sword.fill")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        if form.is_default ?? false {
                            Label("Default", systemImage: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                    
                    // Types
                    HStack(spacing: 8) {
                        ForEach(form.types ?? [], id: \.slot) { type in
                            Text((type.type?.name ?? "Unknown").capitalized)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(getTypeColor(for: [type]).opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    private func getTypeColor(for types: [PokemonFormType]) -> Color {
        guard let firstType = types.first?.type?.name else {
            return .gray
        }
        return PokemonTypeColor.getColor(for: firstType)
    }
}

struct DetailTabView: View {
    let pokemon: PokemonDetail
    
    var body: some View {
        VStack(spacing: 24) {
            InfoSection(title: "Physical Characteristics") {
                InfoRow(title: "Height", value: "\(Double(pokemon.height ?? 0) / 10) m")
                InfoRow(title: "Weight", value: "\(Double(pokemon.weight ?? 0) / 10) kg")
            }
            
            InfoSection(title: "Abilities") {
                
                ForEach(pokemon.abilities ?? [], id: \.slot) { ability in
                    HStack {
                        Text(ability.ability?.name?.capitalized ?? "Unknown")
                        if ability.is_hidden ?? false {
                            Text("(Hidden)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding()
    }
}

struct InfoSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            content
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

struct TypesTabView: View {
    let pokemon: PokemonDetail
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(pokemon.types ?? [], id: \.slot) { type in
                HStack(spacing: 16) {
                    Circle()
                        .fill(PokemonTypeColor.getColor(for: type.type?.name ?? ""))
                        .frame(width: 32, height: 32)
                    
                    Text((type.type?.name ?? "Unknown").capitalized)
                        .font(.headline)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

struct StatsTabView: View {
    let pokemon: PokemonDetail
    
    var body: some View {
        VStack(spacing: 16) {
            if let stats = pokemon.stats {
                ForEach(stats.indices, id: \.self) { index in
                    let stat = stats[index]
                    StatRowView(stat: stat)
                }
            }
        }
        .padding()
    }
}

struct StatRowView: View {
    let stat: PokemonStat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(formatStatName(stat.stat?.name ?? "Unknown"))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("\(stat.base_stat ?? 0)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(getColorForStat(stat.stat?.name ?? "Unknown"))
                        .frame(width: CGFloat(stat.base_stat ?? 0) / 255.0 * geometry.size.width, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
    
    
    private func formatStatName(_ name: String) -> String {
        switch name {
        case "special-attack": return "Sp. Attack"
        case "special-defense": return "Sp. Defense"
        default: return name.capitalized
        }
    }
    
    private func getColorForStat(_ statName: String) -> Color {
        switch statName {
        case "hp": return .green
        case "attack": return .red
        case "defense": return .blue
        case "special-attack": return .purple
        case "special-defense": return .indigo
        case "speed": return .orange
        default: return .gray
        }
    }
}

#Preview {
    PokemonDetailsView(pokemonId: 666)
}
