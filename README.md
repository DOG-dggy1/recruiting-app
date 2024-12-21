# AI Recruiting App

This project is a Swift-based recruiting application that uses AI to match candidates with job listings. It leverages CoreML and NaturalLanguage to perform candidate-job matching based on skills and experience.

## Features
- AI-powered candidate and job matching
- Dynamic list of candidates and job listings
- Simple and intuitive SwiftUI interface

## Requirements
- iOS 15.0+
- Xcode 13+
- Swift 5+
- CoreML and NaturalLanguage frameworks

## Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/recruiting-app.git
    ```
2. Open the project in Xcode.
3. Build and run the app on a simulator or a physical device.

## Usage
- The app automatically loads sample candidates and job listings.
- AI matching generates scores to indicate the best fit between candidates and jobs.
- Results are displayed in a SwiftUI list view.

## Code Overview

### Candidate and JobListing Models
```swift
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
```
- **Candidate**: Represents a job seeker with an ID, name, skills, and years of experience.
- **JobListing**: Represents a job opening with required skills and minimum experience.

### RecruitmentAI Class
```swift
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
```
- **RecruitmentAI**: Handles AI-driven matching using CoreML. It loads the machine learning model and predicts match scores between candidates and job listings.
- **match(candidate:to:)**: Accepts a candidate and a job listing, returns a match score as a Double. This method utilizes an NLModel to process input data and generate predictions based on the candidate's skills and experience.

### RecruitmentViewModel Class
```swift
class RecruitmentViewModel: ObservableObject {
    @Published var candidates: [Candidate] = []
    @Published var jobListings: [JobListing] = []
    
    private var recruitmentAI = RecruitmentAI()
    
    func loadCandidates() {
        candidates = [
            Candidate(id: UUID(), name: "Alice", skills: ["Swift", "Machine Learning"], experience: 5),
            Candidate(id: UUID(), name: "Bob", skills: ["JavaScript", "React"], experience: 3)
        ]
    }
    
    func loadJobListings() {
        jobListings = [
            JobListing(id: UUID(), title: "iOS Developer", requiredSkills: ["Swift"], minExperience: 3),
            JobListing(id: UUID(), title: "Frontend Engineer", requiredSkills: ["JavaScript"], minExperience: 2)
        ]
    }
    
    func matchCandidates() -> [(Candidate, JobListing, Double)] {
        var results: [(Candidate, JobListing, Double)] = []
        for candidate in candidates {
            for job in jobListings {
                let score = recruitmentAI.match(candidate: candidate, to: job)
                if score > 0.5 {
                    results.append((candidate, job, score))
                }
            }
        }
        return results.sorted { $0.2 > $1.2 }
    }
}
```
- **RecruitmentViewModel**: Manages application state, loads sample data, and performs candidate-job matching.
- **matchCandidates()**: Compares all candidates with job listings and returns the best matches. The method iterates over each candidate and job to compute a match score and filters results based on a threshold.

### ContentView (SwiftUI Interface)
```swift
struct ContentView: View {
    @StateObject private var viewModel = RecruitmentViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.matchCandidates(), id: \.(0).id) { candidate, job, score in
                VStack(alignment: .leading) {
                    Text("\(candidate.name) -> \(job.title)")
                    Text("Match Score: \(String(format: "%.2f", score))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("AI Recruiting")
            .onAppear {
                viewModel.loadCandidates()
                viewModel.loadJobListings()
            }
        }
    }
}
```
- **ContentView**: The main SwiftUI view that displays matching results in a list. It listens to the view model and dynamically updates the UI as data changes.

## License
This project is licensed under the MIT License.

