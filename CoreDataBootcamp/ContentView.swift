//
//  ContentView.swift
//  CoreDataBootcamp
//
//  Created by Kirill Streltsov on 08.08.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: FruitEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)])
    private var fruits: FetchedResults<FruitEntity>
    
    @State private var fruitText = ""
    @State private var presentAlert = false
    @State private var updatedFruitName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Add fruit here...", text: $fruitText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .cornerRadius(10)
                    .padding(.horizontal)
                Button {
                    addItem()
                } label: {
                    Text("Button")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                List {
                    ForEach(fruits) { fruit in
                        Text(fruit.name ?? "")
                            .onTapGesture {
                                presentAlert = true
                                print(fruit.name ?? "")
                            }
                            .alert("Update fruit", isPresented: $presentAlert) {
                                TextField("Enter new fruit name...", text: $updatedFruitName)
                                Button("Update") {
                                    updateItem(fruit: fruit)
                                }
                                Button("Cancel", role: .cancel, action: {})
                            } message: {
                                Text("Update the name for \(fruit.name ?? "")")
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                
                .listStyle(.plain)
            }
            .navigationTitle("Fruits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addItem) {
                        Label("Add item", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = FruitEntity(context: viewContext)
            newItem.name = fruitText
            saveItems()
        }
    }
    
    private func updateItem(fruit: FruitEntity) {
        withAnimation {
            fruit.name = updatedFruitName
            saveItems()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else { return }
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)
            
            saveItems()
        }
    }
    
    private func saveItems() {
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
