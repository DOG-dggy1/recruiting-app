
// Recruiting App in Swift
import SwiftUI
import CoreML
import NaturalLanguage
import Combine

struct Candidate: Identifiable, Codable {
    let id: UUID
    let name: String
    let skills: [String]
    let experience: Int
}

struct JobListing: Identifiable, Codable {
    let id: UUID
    let title: String
    let requiredSkills: [String]
    let minExperience: Int
}

class RecruitmentAI {
    private var model: NLModel

    init() {
        guard let modelURL = Bundle.main.url(forResource: "JobMatchingModel", withExtension: "mlmodelc") else {
            fatalError("Model not found")
        }
        do {
            self.model = try NLModel(contentsOf: modelURL)
        } catch {
            fatalError("Failed to load model: \(error.localizedDescription)")
        }
    }

    func match(candidate: Candidate, to job: JobListing) -> Double {
        let input = "\(candidate.name) \(candidate.skills.joined(separator: ", ")) \(candidate.experience)"
        let prediction = model.predictedLabel(for: input) ?? "0"
        return Double(prediction) ?? 0.0
    }
}
