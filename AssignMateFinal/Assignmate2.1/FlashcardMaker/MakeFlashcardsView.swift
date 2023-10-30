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

                    Button(action: {
                        isScanning.toggle()
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
                        ScannerView { scannedText in
                            if let text = scannedText {
                                viewModel.inputText = text.joined(separator: "\n")
                            }
                            isScanning = false
                        }
                    }
                    
                    if !isScanning {
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $viewModel.inputText)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                .font(.title2)
                            
                            if viewModel.inputText.isEmpty {
                                Text("Enter text here to see the magic happen...")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                    .padding(.top, 23)
                                    .padding(.leading, 18)
                            }
                            
                            HStack {
                                Spacer()
                                VStack {
                                    Button(action: {
                                        viewModel.inputText = ""
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
                        ScannerView { scannedText in
                            if let text = scannedText {
                                viewModel.inputText = text.joined(separator: "\n")
                            }
                            isScanning = false
                        }
                    }

                    Button(action: {
                        if viewModel.inputText.split(separator: " ").count < 10 { // Check if the word count is less than 10
                            showError = true
                        } else {
                            if isScanning {
                                self.showScannerSheet = true
                            } else {
                                viewModel.sendText()
                                if let newSet = viewModel.currentFlashcardSet {
                                    flashcardStore.addFlashcardSet(newSet)
                                }
                                isNavigationActive = true
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
                    endEditing()
                }
                .background(Color.clear)
            }
            .padding(.bottom, 100)
        }
    }

    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

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
