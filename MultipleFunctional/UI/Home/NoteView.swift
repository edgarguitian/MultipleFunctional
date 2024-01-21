//
//  NoteView.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import SwiftUI

enum FocusedField {
    case noteTitle, noteDescription
}

struct NoteView: View {

    @ObservedObject private var viewModel: NotesViewModel
    @State var newNoteTitle: String = ""
    @State var newNoteDescription: String = ""
    @FocusState private var focusedField: FocusedField?

    init(viewModel: NotesViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {

            // MARK: new Note fields
            VStack {
                Text("titleNewNote")
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
                    .accessibilityIdentifier("newNoteTitleInfo")
                TextEditor(text: $newNoteTitle)
                    .focused($focusedField, equals: .noteTitle)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.green, lineWidth: 2)
                    )
                    .padding(.horizontal, 12)
                    .cornerRadius(3)
                    .accessibilityIdentifier("newNoteTitleField")
            }

            VStack {
                Text("descriptionNewNote")
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
                    .accessibilityIdentifier("newNoteDescInfo")
                TextEditor(text: $newNoteDescription)
                    .focused($focusedField, equals: .noteDescription)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.green, lineWidth: 2)
                    )
                    .padding(.horizontal, 12)
                    .cornerRadius(3)
                    .accessibilityIdentifier("newNoteDescField")
            }

            // MARK: Create new Note Button
            Button(action: {
                viewModel.createNewNote(title: newNoteTitle, description: newNoteDescription)
                newNoteTitle = ""
                newNoteDescription = ""
                focusedField = .noteTitle
            }, label: {
                Label("newnote", systemImage: "link")
            })
            .tint(.green)
            .controlSize(.regular)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .padding(.top, 10)
            .accessibilityIdentifier("btnNewNote")

            // MARK: Show Error
            if viewModel.showErrorMessageNote != nil {
                Text(viewModel.showErrorMessageNote!)
                    .bold()
                    .font(.body)
                    .foregroundColor(.red)
                    .padding(.top, 20)
                    .accessibilityIdentifier("noteViewErrorMessage")
            }

            // MARK: List Notes
            if viewModel.showLoadingSpinner {
                CustomLoadingView()
                    .accessibilityIdentifier("loadingListNotes")
            } else {
                List {
                    ForEach(viewModel.notes, id: \.id) { note in
                        VStack {
                            Text(note.titulo)
                                .bold()
                                .lineLimit(4)
                                .padding(.bottom, 8)
                            Text(note.descripcion)
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        .accessibilityIdentifier("stackNote")
                        .swipeActions(edge: .trailing) {
                            Button(action: {
                                viewModel.deleteNote(note: note)
                            }, label: {
                                Label("borrar", systemImage: "trash.fill")
                            })
                            .tint(.red)
                            .accessibilityIdentifier("btnDeleteNote")
                        }
                    }
                }
                .accessibilityIdentifier("listNotes")
            }
        }
        .task {
            viewModel.getAllNotes()
        }
        .onAppear {
            focusedField = .noteTitle
        }
    }
}

#Preview {
    NoteFactory().create()
}
