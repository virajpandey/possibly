import SwiftUI

struct NotesView: View {
    @State private var notesText: String = ""

    private let cornerRadius: CGFloat = 16
    private let placeholder = "Write a quick note…"

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            editor
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
    }

    private var editor: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(0.03))
            )
            .overlay(alignment: .topLeading) {
                ZStack(alignment: .topLeading) {
                    if notesText.isEmpty {
                        Text(placeholder)
                            .foregroundStyle(.gray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                    }

                    textEditor
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var textEditor: some View {
        TextEditor(text: $notesText)
            .font(.system(.body, design: .rounded))
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            .background(Color.clear)
#if os(macOS)
            .scrollContentBackground(.hidden)
#endif
    }
}
