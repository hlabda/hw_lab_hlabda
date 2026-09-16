import Charts
import SwiftUI

struct ChartsView: View {
    @EnvironmentObject private var library: Library

    private var genderCounts: [(gender: String, count: Int)] {
        [
            (Gender.male.rawValue, library.getMaleAuthoredBooks().count),
            (Gender.female.rawValue, library.getFemaleAuthoredBooks().count)
        ]
    }

    private var popularAuthorCounts: [(author: String, count: Int)] {
        [
            ("Shakespeare", library.getBooksFor("William Shakespeare").count),
            ("Tolkien", library.getBooksFor("J.R.R. Tolkien").count),
            ("Austen", library.getBooksFor("Jane Austen").count),
            ("Dickens", library.getBooksFor("Charles Dickens").count),
            ("Bronte", library.getBooksFor("Charlotte Bronte").count)
        ]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    chartSection(title: "Books by Author Gender") {
                        Chart(genderCounts, id: \.gender) { item in
                            BarMark(
                                x: .value("Gender", item.gender),
                                y: .value("Books", item.count)
                            )
                            .foregroundStyle(
                                item.gender == Gender.female.rawValue ? .pink : .blue
                            )
                            .annotation(position: .top) {
                                Text("\(item.count)")
                                    .font(.caption)
                            }
                        }
                        .frame(height: 240)
                    }

                    chartSection(title: "Books by Popular Authors") {
                        Chart(popularAuthorCounts, id: \.author) { item in
                            BarMark(
                                x: .value("Author", item.author),
                                y: .value("Books", item.count)
                            )
                            .foregroundStyle(.green)
                            .annotation(position: .top) {
                                Text("\(item.count)")
                                    .font(.caption)
                            }
                        }
                        .frame(height: 240)
                    }
                }
                .padding()
            }
            .navigationTitle("Charts")
        }
    }

    private func chartSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ChartsView()
        .environmentObject(Library())
}
