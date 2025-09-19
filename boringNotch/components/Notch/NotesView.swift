import SwiftUI

struct NotesView: View {
    let text: String

    private let cornerRadius: CGFloat = 16
    private let placeholder = "No notes provided."

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white.opacity(0.03))
                )
                .overlay(alignment: .topLeading) {
                    ScrollView {
                        content
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
    }

    @ViewBuilder
    private var content: some View {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            Text(placeholder)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
        } else {
            Text(text)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .textSelection(.enabled)
        }
    }
}
