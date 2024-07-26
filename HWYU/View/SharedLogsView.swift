//
//  SharedLogsView.swift
//  HWYU
//
//  Created by Yungui Lee on 7/25/24.
//

import SwiftUI

struct SharedLog: Identifiable {
    let id = UUID()
    let author: String
    let content: String
    let photo: Image
}

extension SharedLog {
    static let sampleLogs: [SharedLog] = [
        SharedLog(author: "혜원", content: "안녕!", photo: Image("image01")),
        SharedLog(author: "융의", content: "나도 안녕", photo: Image("image02")),
        SharedLog(author: "혜원", content: "안녕!", photo: Image("image03")),
        SharedLog(author: "융의", content: "호호", photo: Image("image04")),
        SharedLog(author: "혜원", content: "안녕!", photo: Image("image01")),
        SharedLog(author: "융의", content: "나도 안녕", photo: Image("image02")),
        SharedLog(author: "혜원", content: "안녕!", photo: Image("image03")),
        SharedLog(author: "융의", content: "호호", photo: Image("image04"))
    ]
}

struct SharedLogsView: View {
    let sampleLogs = SharedLog.sampleLogs
    
    @State private var zoomLevel: CGFloat = 1.0
    
    var columns: [GridItem] {
        let columnCount = zoomLevel < 1.5 ? 3 : 2
        return Array(repeating: .init(.flexible(), spacing: 6), count: columnCount)
    }
    
    @State var selectedLog: SharedLog?
    @State private var showAddLogSheet: Bool = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 3, pinnedViews: []) {
                ForEach(sampleLogs) { log in
                    
                    Button(action: {
                        selectedLog = log
                    }) {
                        log.photo
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width / CGFloat(columns.count), height: UIScreen.main.bounds.width / CGFloat(columns.count))
                            .clipped()
                    }
                }
            }
            .padding(.top, 10)
            .navigationTitle("공유 앨범")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    HStack {
                        Button(action: {
                            
                        }) {
                            Image(systemName: "person.crop.circle.badge.checkmark")
                        }
                        
                        Button(action: {
                            showAddLogSheet = true
                        }) {
                            Image(systemName: "plus.circle")
                        }
                    }
                    .foregroundStyle(.green)
                }
            }
            .sheet(item: $selectedLog) { log in
                LogDetailView(log: log)
            }
            .sheet(isPresented: $showAddLogSheet) {
                AddLogView()
            }
        }
        .gesture(
            MagnifyGesture()
                .onChanged { value in
                    let newZoomLevel = zoomLevel * value.magnification
                    if newZoomLevel >= 1.0 && newZoomLevel <= 2.0 {
                        withAnimation {
                            zoomLevel = newZoomLevel
                        }
                    }
                }
        )
    }
}


struct LogDetailView: View {
    let log: SharedLog
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                log.photo
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SharedLogsView()
    }
}

#Preview {
    LogDetailView(log: SharedLog(author: "혜원", content: "안녕!", photo: Image("image01")))
}
