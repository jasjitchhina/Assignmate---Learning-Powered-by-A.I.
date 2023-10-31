import SwiftUI
import FirebaseAuth

struct MakeFlashcardsView: View {
    @StateObject private var viewModel = FlashcardViewModel()
    @State private var isNavigationActive = false
    @EnvironmentObject var flashcardStore: FlashcardStore
    @State private var isScanning = false
    @State private var showScannerSheet = false
    @State private var showError = false // To show the error alert
    @State private var presentingScanner = false

    // Define a button style with custom colors
    private var buttonStyle: some ButtonStyle {
        ButtonStyleImpl(backgroundColor: .purple, foregroundColor: .white)
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    Spacer()

                    Text("Flashcard Generator")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .padding(.top, 10)

                    // Button to initiate or stop scanning
                    Button(action: {
                        isScanning.toggle() // Toggle the scanning state
                    }) {
                        HStack {
                            Image(systemName: "doc.text.magnifyingglass")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Scan Textbook")
                        }
                        .padding(.horizontal, 20)
                    }
                    .buttonStyle(buttonStyle)
                    .sheet(isPresented: $isScanning) {
                        // Present the ScannerView when scanning is active
                        ScannerView { scannedText in
                            if let text = scannedText {
                                viewModel.inputText = text.joined(separator: "\n")
                            }
                            isScanning = false // Dismiss the scanner sheet
                        }
                    }

                    if !isScanning {
                        ZStack(alignment: .topLeading) {
                            // TextEditor for input text
                            TextEditor(text: $viewModel.inputText)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                .font(.title2)

                            if viewModel.inputText.isEmpty {
                                // Placeholder text when input is empty
                                Text("Enter text here to see the magic happen...")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                    .padding(.top, 23)
                                    .padding(.leading, 18)
                            }

                            HStack {
                                Spacer()
                                VStack {
                                    // Clear button for input text
                                    Button(action: {
                                        viewModel.inputText = "" // Clear the input text
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.gray)
                                            .padding(10)
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: 300)
                    } else {
                        // Display the ScannerView if scanning is in progress
                        ScannerView { scannedText in
                            if let text = scannedText {
                                viewModel.inputText = text.joined(separator: "\n")
                            }
                            isScanning = false // Dismiss the scanner sheet
                        }
                    }

                    // Button to generate flashcards or show an error if word count is insufficient
                    Button(action: {
                        if viewModel.inputText.split(separator: " ").count < 10 { // Check if the word count is less than 10
                            showError = true // Show an error if word count is insufficient
                        } else {
                            if isScanning {
                                self.showScannerSheet = true // Show scanner sheet if scanning is in progress
                            } else {
                                viewModel.sendText() // Send the input text to the view model
                                if let newSet = viewModel.currentFlashcardSet {
                                    flashcardStore.addFlashcardSet(newSet) // Add the new flashcard set to the store
                                }
                                isNavigationActive = true // Navigate to the flashcard content view
                            }
                        }
                    }) {
                        Text("Generate Flashcards")
                    }
                    .buttonStyle(buttonStyle)
                    .alert(isPresented: $showError) { // Alert if the word count is less than 10
                        Alert(title: Text("Error"), message: Text("Please write at least 10 words."), dismissButton: .default(Text("Okay")))
                    }

                    Spacer()

                    // Navigation link to the flashcard content view
                    NavigationLink(
                        destination: FlashcardContentView(viewModel: viewModel),
                        isActive: $isNavigationActive,
                        label: {
                            EmptyView()
                        }
                    )
                }
                .padding()
                .onTapGesture {
                    endEditing() // Dismiss the keyboard when tapped outside of the text editor
                }
                .background(Color.clear)
            }
            .padding(.bottom, 100)
        }
    }

    // Function to dismiss the keyboard
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    // Custom button style implementation with background and foreground colors
    struct ButtonStyleImpl: ButtonStyle {
        var backgroundColor: Color
        var foregroundColor: Color

        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .padding()
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(10)
                .font(.headline)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
}
