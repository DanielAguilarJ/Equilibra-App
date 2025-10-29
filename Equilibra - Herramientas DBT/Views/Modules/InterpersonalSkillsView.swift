//
//  InterpersonalSkillsView.swift
//  Equilibra - Herramientas DBT
//
//  Vista principal del módulo de habilidades interpersonales
//

import SwiftUI
import SwiftData

struct InterpersonalSkillsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: InterpersonalSkillsViewModel?
    
    @State private var showingSituationSelector = false
    @State private var showingSkillPicker = false
    @State private var selectedSkill: InterpersonalSkillType?
    @State private var showingHistory = false
    @State private var showingWizard = false
    
    var body: some View {
        Group {
            if let viewModel = viewModel {
                mainContent(viewModel: viewModel)
            } else {
                ProgressView()
                    .onAppear {
                        viewModel = InterpersonalSkillsViewModel(modelContext: modelContext)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func mainContent(viewModel: InterpersonalSkillsViewModel) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .pink, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Habilidades Interpersonales")
                        .font(.title.bold())
                    
                    Text("Mejora tus relaciones y comunicación con guías DBT interactivas")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top)
                
                // Quick Start
                VStack(alignment: .leading, spacing: 16) {
                    Text("Inicio Rápido")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Button {
                        showingSituationSelector = true
                    } label: {
                        HStack {
                            Image(systemName: "sparkles")
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("¿Qué situación enfrentas?")
                                    .font(.headline)
                                Text("Te ayudaremos a elegir la mejor habilidad")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.cyan.opacity(0.3), .blue.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.cyan, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                }
                
                // Skills Cards
                VStack(alignment: .leading, spacing: 16) {
                    Text("Elige una Habilidad")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(InterpersonalSkillType.allCases, id: \.self) { skill in
                            SkillCard(
                                skill: skill,
                                viewModel: viewModel,
                                onTap: {
                                    selectedSkill = skill
                                    showingSkillPicker = true
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Active Plans
                if hasActivePlans(viewModel: viewModel) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Planes Activos")
                                .font(.headline)
                            Spacer()
                            Button("Ver Todos") {
                                showingHistory = true
                            }
                            .font(.subheadline)
                        }
                        .padding(.horizontal)
                        
                        ActivePlansSection(viewModel: viewModel, showingWizard: $showingWizard)
                    }
                }
                
                // Statistics
                StatisticsSection(viewModel: viewModel)
                    .padding(.horizontal)
                
                // Info
                InfoSection()
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
        .navigationTitle("Habilidades Interpersonales")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingHistory = true
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                }
            }
        }
        .sheet(isPresented: $showingSituationSelector) {
            SituationSelectorView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingSkillPicker) {
            if let skill = selectedSkill {
                SkillActionSheet(skill: skill, viewModel: viewModel)
            }
        }
        .sheet(isPresented: $showingHistory) {
            InterpersonalSkillsHistoryView()
        }
        .sheet(isPresented: $showingWizard) {
            if let plan = viewModel.activeDearManPlan {
                DearManWizardView(viewModel: viewModel, plan: plan)
            }
        }
    }
    
    private func hasActivePlans(viewModel: InterpersonalSkillsViewModel) -> Bool {
        !viewModel.dearManPlans.filter { !$0.completed }.isEmpty ||
        !viewModel.givePlans.filter { !$0.completed }.isEmpty ||
        !viewModel.fastPlans.filter { !$0.completed }.isEmpty
    }
}

// MARK: - Skill Card

struct SkillCard: View {
    let skill: InterpersonalSkillType
    let viewModel: InterpersonalSkillsViewModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Circle()
                    .fill(skillColor.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: skill.icon)
                            .font(.title2)
                            .foregroundColor(skillColor)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(skill.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(skill.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(viewModel.completedPlansCount(for: skill))")
                        .font(.title3.bold())
                        .foregroundColor(skillColor)
                    Text("planes")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
    
    private var skillColor: Color {
        switch skill {
        case .dearMan:
            return .blue
        case .give:
            return .pink
        case .fast:
            return .purple
        }
    }
}

struct ActivePlanCard: View {
    let title: String
    let subtitle: String
    let color: Color
    let date: Date
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Circle()
                        .fill(color)
                        .frame(width: 8, height: 8)
                    Text(subtitle)
                        .font(.caption.bold())
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(date, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(width: 200, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Active Plans Section

struct ActivePlansSection: View {
    @Bindable var viewModel: InterpersonalSkillsViewModel
    @Binding var showingWizard: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(activeDearManPlans, id: \.id) { plan in
                    ActivePlanCard(
                        title: plan.goal,
                        subtitle: "DEAR MAN",
                        color: .blue,
                        date: plan.createdAt
                    ) {
                        viewModel.activeDearManPlan = plan
                        showingWizard = true
                    }
                }
                
                ForEach(activeGivePlans, id: \.id) { plan in
                    ActivePlanCard(
                        title: plan.relationship,
                        subtitle: "GIVE",
                        color: .pink,
                        date: plan.createdAt
                    ) {
                        viewModel.activeGivePlan = plan
                    }
                }
                
                ForEach(activeFastPlans, id: \.id) { plan in
                    ActivePlanCard(
                        title: plan.situation,
                        subtitle: "FAST",
                        color: .purple,
                        date: plan.createdAt
                    ) {
                        viewModel.activeFastPlan = plan
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var activeDearManPlans: [DearManPlan] {
        Array(viewModel.dearManPlans.filter { !$0.completed }.prefix(5))
    }
    
    private var activeGivePlans: [GivePlan] {
        Array(viewModel.givePlans.filter { !$0.completed }.prefix(5))
    }
    
    private var activeFastPlans: [FastPlan] {
        Array(viewModel.fastPlans.filter { !$0.completed }.prefix(5))
    }
}

// MARK: - Statistics Section

struct StatisticsSection: View {
    let viewModel: InterpersonalSkillsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Estadísticas")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(InterpersonalSkillType.allCases, id: \.self) { skill in
                    InterpersonalStatCard(
                        title: skill.title,
                        value: String(format: "%.1f", viewModel.averageEffectiveness(for: skill)),
                        icon: "chart.bar.fill",
                        color: colorForSkill(skill)
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func colorForSkill(_ skill: InterpersonalSkillType) -> Color {
        switch skill {
        case .dearMan: return .blue
        case .give: return .pink
        case .fast: return .purple
        }
    }
}

private struct InterpersonalStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Info Section

struct InfoSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sobre las Habilidades Interpersonales")
                .font(.headline)
            
            Text("Las habilidades interpersonales de DBT te ayudan a:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                InterpersonalInfoRow(icon: "target", text: "Obtener lo que necesitas (DEAR MAN)")
                InterpersonalInfoRow(icon: "heart.circle", text: "Mantener relaciones saludables (GIVE)")
                InterpersonalInfoRow(icon: "shield.checkered", text: "Preservar tu autorespeto (FAST)")
            }
        }
        .padding()
        .background(Color.cyan.opacity(0.1))
        .cornerRadius(16)
    }
}

private struct InterpersonalInfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.cyan)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack {
        InterpersonalSkillsView()
            .modelContainer(for: [DearManPlan.self, GivePlan.self, FastPlan.self])
    }
}
