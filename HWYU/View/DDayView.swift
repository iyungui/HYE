//
//  DDayView.swift
//  HWYU
//
//  Created by 이융의 on 1/6/24.
//

import SwiftUI

struct DDayView: View {
    @EnvironmentObject private var dDayViewModel: DDayViewModel
    @State private var images: [UIImage] = []
    @State private var showLetter: Bool = false
    @State private var showAlbum: Bool = false
    @State private var showSettings: Bool = false
    @State private var isRefreshing: Bool = false
    @State private var isHeartAnimating: Bool = false
    
    // 이모지 관련 상태
    let emojis: [Emoji] = Emoji.emojis
    @State private var currentEmoji: String = "heart.fill"
    @State private var isEmojiAnimating: Bool = false
    @State private var isCountingFinished = true
    
    // 퀴즈 관련 상태
    @State private var showingAlert = false
    @State private var answerString = ""
    @State private var flag = false
    @State private var count = 3
    
    // 애니메이션 타이머
    @State private var animationTimer: Timer? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 배경 이미지와 그라데이션
                backgroundView
                
                // 메인 콘텐츠
                VStack(spacing: 0) {
                    headerSection
                    
                    Spacer()
                    
                    dateSection
                    
                    countSection
                }
                .padding()
                
                // 로딩 인디케이터
                if dDayViewModel.isLoading {
                    loadingOverlay
                }
                
                // 에러 메시지 표시
                if let errorMessage = dDayViewModel.loadingError {
                    errorView(message: errorMessage)
                }
                
                // 하트 파티클 애니메이션
                if isHeartAnimating {
                    HeartParticlesView()
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 15))
                            .foregroundColor(.gray.opacity(0.15))
                    }
                }
            }
            .task {
                isCountingFinished = false
                await dDayViewModel.countDay()
                isCountingFinished = true
                
                // 푸시 알림 관련 옵저버 등록
                registerForNotifications()
                
                // 10초마다 하트 애니메이션 자동 실행
                startHeartAnimationTimer()
            }
            .refreshable {
                isRefreshing = true
                await refreshData()
                isRefreshing = false
            }
            .alert("용이 하늘로 올라가면?", isPresented: $showingAlert) {
                TextField("여기에 입력하세요", text: $answerString)
                Button("확인", action: submit)
            } message: {
                Text((flag == false) ? "정답을 입력하세요~" : "땡!")
            }
            .alert("땡!", isPresented: $flag) {
                Button(role: .cancel) {
                    flag = false
                    if(count > 0) {
                        showingAlert = true
                    }
                } label: {
                    if(count > 0) {
                        Text("다시하기")
                    } else {
                        Text("닫기")
                    }
                }
            } message: {
                if(count > 0) {
                    Text("기회 \(count)번 남았습니다.")
                        .foregroundStyle(.red)
                } else {
                    Text("다음 기회에...")
                }
            }
            .fullScreenCover(isPresented: $showLetter) {
                LetterListView()
            }
            .fullScreenCover(isPresented: $showAlbum) {
                if #available(iOS 18.0, *) {
                    ImageListView().environmentObject(dDayViewModel)
                } else {
                    LegacyImageListView().environmentObject(dDayViewModel)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(dDayViewModel)
            }
            .onDisappear {
                // 화면 이탈 시 타이머 정리
                animationTimer?.invalidate()
                animationTimer = nil
            }
        }
    }
    
    // MARK: - 배경 뷰
    private var backgroundView: some View {
        ZStack {
            // 배경 이미지
            if let image = dDayViewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .clipped()
                    .transition(.opacity.animation(.easeInOut(duration: 0.8)))
                    .id(image)  // ID 추가로 이미지 변경 시 애니메이션 적용
            } else {
                Color.black.opacity(0.1)
            }
            
            // 그라데이션 오버레이
            LinearGradient(
                gradient: Gradient(colors: [
                    .clear,
                    .black.opacity(0.1),
                    .black.opacity(0.4)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
    
    // MARK: - 헤더 섹션
    private var headerSection: some View {
        VStack(spacing: 12) {
            // 이름과 이모지
            HStack {
                Text("혜원")
                    .font(Font.custom("GowunBatang-Bold", size: 17))
                
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                        isEmojiAnimating = true
                        currentEmoji = emojis.randomElement()?.content ?? "heart.fill"
                    }
                    
                    // 애니메이션 종료 후 상태 리셋
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isEmojiAnimating = false
                    }
                } label: {
                    Group {
                        if currentEmoji == "heart.fill" {
                            Image(systemName: currentEmoji)
                                .foregroundColor(.pink)
                        } else {
                            Text(currentEmoji)
                        }
                    }
                    .font(.system(size: 20))
                    .scaleEffect(isEmojiAnimating ? 1.4 : 1.0)
                    .rotationEffect(isEmojiAnimating ? .degrees(25) : .degrees(0))
                }
                .buttonStyle(ScaleButtonStyle())
                
                Text("융의")
                    .font(Font.custom("GowunBatang-Bold", size: 17))
            }
            
            HStack(spacing: 0) {
                Button("우리") {
                }
                .simultaneousGesture(LongPressGesture(minimumDuration: 1.3).onEnded { _ in
                    if(count > 0) {
                        showingAlert = true
                    }
                })
                .font(Font.custom("GowunBatang-Bold", size: 13))
                .foregroundStyle(.white.opacity(0.9))
                
                Text("가 함께한 지 벌써")
                    .font(Font.custom("GowunBatang-Bold", size: 13))
                    .foregroundStyle(.white.opacity(0.9))
                
                // 숫자 부분을 강조
                Text(" \(dDayViewModel.currentDaysCount)일!")
                    .font(Font.custom("GowunBatang-Bold", size: 13))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.25))
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            )
        }
    }
    
    // MARK: - 날짜 섹션
    private var dateSection: some View {
        VStack {
            HStack {
                Text(dDayViewModel.formatDate(dDayViewModel.startDate))
                    .font(Font.custom("GowunBatang-Bold", size: 18))
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isHeartAnimating = true
                        showAlbum = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        isHeartAnimating = false
                    }
                }) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 18))
                        .foregroundColor(isCountingFinished ? Color.pink : Color.gray)
                }
                .disabled(!isCountingFinished || dDayViewModel.isLoading)
                .scaleEffect(isCountingFinished ? 0.9 : 0.8)
                .animation(.easeInOut, value: isCountingFinished)
                .buttonStyle(HeartBeatButtonStyle())
                
                Text("~")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .font(.headline)
            .foregroundColor(.white)
            
            Text(dDayViewModel.formatDate(Date()))
                .font(Font.custom("GowunBatang-Bold", size: 18))
                .foregroundColor(.white)
                .padding(.bottom, 5)
        }
        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
    }
    
    // MARK: - D-Day 카운트 섹션
    private var countSection: some View {
        VStack {
            Button {
                Task {
                    isCountingFinished = false
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isHeartAnimating = true
                    }
                    await dDayViewModel.loadRandomImage()
                    await dDayViewModel.countDay()
                    isCountingFinished = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        isHeartAnimating = false
                    }
                }
            } label: {
                Text("\(dDayViewModel.currentDaysCount)")
                    .font(.system(size: 45, weight: .black, design: .monospaced))
                    .italic()
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
            }
            .disabled(dDayViewModel.isLoading)
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.top, 10)
        .padding(.bottom, 30)
    }
    
    // MARK: - 로딩 오버레이
    private var loadingOverlay: some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.4))
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
//                
//                Text("이미지 로딩 중...")
//                    .foregroundColor(.white)
//                    .font(.caption)
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 10)
//                    .background(
//                        Capsule()
//                            .fill(Color.black.opacity(0.5))
//                    )
            }
        }
    }
    
    // MARK: - 에러 표시 뷰
    private func errorView(message: String) -> some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                VStack(spacing: 15) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.yellow)
                    
                    Text(message)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("다시 시도") {
                        Task {
                            await dDayViewModel.loadRandomImage()
                        }
                    }
                    .font(.headline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.25))
                    )
                    .foregroundColor(.white)
                }
                .padding(25)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.8))
                )
                .shadow(radius: 10)
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
    }
    
    // MARK: - 하트 파티클 애니메이션 뷰
    struct HeartParticlesView: View {
        @State private var hearts: [HeartParticle] = []
        
        var body: some View {
            ZStack {
                ForEach(hearts) { heart in
                    Text(heart.emoji)
                        .font(.system(size: heart.size))
                        .position(heart.position)
                        .opacity(heart.opacity)
                }
            }
            .onAppear {
                generateHearts()
            }
        }
        
        func generateHearts() {
            for _ in 0..<20 {
                let screenWidth = UIScreen.main.bounds.width
                let screenHeight = UIScreen.main.bounds.height
                
                let randomX = CGFloat.random(in: 0...screenWidth)
                let randomEndY = CGFloat.random(in: 0...screenHeight/2)
                let randomSize = CGFloat.random(in: 15...35)
                let randomDuration = Double.random(in: 1.0...3.0)
                let randomDelay = Double.random(in: 0...0.5)
                let randomEmoji = ["❤️", "💗", "💓", "💕", "💖", "💘", "💝"].randomElement() ?? "❤️"
                
                var heart = HeartParticle(
                    id: UUID(),
                    position: CGPoint(x: randomX, y: screenHeight + randomSize),
                    size: randomSize,
                    emoji: randomEmoji
                )
                
                hearts.append(heart)
                
                // 애니메이션 시작
                withAnimation(Animation.easeOut(duration: randomDuration).delay(randomDelay)) {
                    if let index = hearts.firstIndex(where: { $0.id == heart.id }) {
                        hearts[index].position.y = randomEndY
                        hearts[index].opacity = 0
                    }
                }
            }
        }
        
        struct HeartParticle: Identifiable {
            let id: UUID
            var position: CGPoint
            let size: CGFloat
            let emoji: String
            var opacity: Double = 1.0
        }
    }
    
    // 알림 등록
    private func registerForNotifications() {
        // 새 사진 업로드 알림 수신 시 처리
        NotificationCenter.default.addObserver(
            forName: .newPhotoUploaded,
            object: nil,
            queue: .main
        ) { _ in
            Task {
                // 새 이미지가 업로드되면 카운트 업데이트 및 이미지 새로고침
                await refreshData()
            }
        }
    }
    
    // 데이터 새로고침
    private func refreshData() async {
        // 데이터 새로고침 시 순차적으로 처리
        await dDayViewModel.loadRandomImage()
        await dDayViewModel.countDay()
    }
    
    // 퀴즈 제출
    private func submit() {
        if(answerString == "올라가용~") {
            flag = false
            showLetter = true
        }
        else {
            flag = true
            count -= 1
            answerString = ""
        }
    }
    
    // 애니메이션 타이머 시작
    private func startHeartAnimationTimer() {
        // 10초마다 하트 애니메이션 자동 실행
        animationTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isHeartAnimating = true
            }
            
            // 2초 후에 하트 애니메이션 종료
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isHeartAnimating = false
            }
        }
    }
}

// MARK: - 커스텀 버튼 스타일
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// 심장 박동 버튼 스타일
struct HeartBeatButtonStyle: ButtonStyle {
    @State private var isAnimating = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : (isAnimating ? 1.2 : 1.0))
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .onAppear {
                // 자동 펄스 애니메이션
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    DDayView()
        .environmentObject(DDayViewModel(cloudKitManager: CloudKitManager()))
}


import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dDayViewModel: DDayViewModel
    @State private var showConfirmationDialog = false
    @State private var isClearingCache = false
    @State private var clearCacheSuccess = false
    @State private var isTogglingNotification = false
    
    // 푸시 알림 상태
    @State private var pushNotificationsEnabled: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("알림 설정")) {
                    Toggle(isOn: $pushNotificationsEnabled) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.blue)
                                .frame(width: 25, height: 25)
                            
                            VStack(alignment: .leading) {
                                Text("푸시 알림")
                                    .font(.headline)
                                Text("새 사진이 공유될 때 알림 받기")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .disabled(isTogglingNotification)
                    .onChange(of: pushNotificationsEnabled) { _, newValue in
                        Task {
                            await togglePushNotifications(enabled: newValue)
                        }
                    }
                    
                    if isTogglingNotification {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                            Spacer()
                        }
                    }
                }
                
                Section(header: Text("앱 데이터")) {
                    Button {
                        showConfirmationDialog = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .frame(width: 25, height: 25)
                            
                            VStack(alignment: .leading) {
                                Text("캐시 지우기")
                                    .foregroundColor(.primary)
                                Text("로컬에 저장된 이미지 캐시를 삭제합니다")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    if isClearingCache {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                            Spacer()
                        }
                    }
                    
                    if clearCacheSuccess {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("캐시가 성공적으로 삭제되었습니다")
                                .font(.caption)
                                .foregroundColor(.green)
                            Spacer()
                        }
                    }
                }
                
                Section(header: Text("앱 정보")) {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                            .frame(width: 25, height: 25)
                        
                        VStack(alignment: .leading) {
                            Text("버전")
                                .foregroundColor(.primary)
                            Text(getAppVersion())
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        dismiss()
                    }
                }
            }
            .confirmationDialog("캐시 삭제", isPresented: $showConfirmationDialog) {
                Button("삭제", role: .destructive) {
                    Task {
                        await clearCache()
                    }
                }
                Button("취소", role: .cancel) {}
            } message: {
                Text("모든 이미지 캐시를 삭제하시겠습니까? 다음 번 로딩 시 더 오래 걸릴 수 있습니다.")
            }
            .onAppear {
                // CloudKit Manager에서 현재 푸시 알림 상태 가져오기
                pushNotificationsEnabled = dDayViewModel.cloudKitManager.subscriptionActive
            }
        }
    }
    
    // 푸시 알림 설정 토글
    private func togglePushNotifications(enabled: Bool) async {
        isTogglingNotification = true
        defer { isTogglingNotification = false }
        
        // 현재 상태와 다를 때만 작업 수행
        if enabled != dDayViewModel.cloudKitManager.subscriptionActive {
            await dDayViewModel.togglePushNotifications()
        }
        
        // 토글 후 실제 상태 확인하여 UI 업데이트
        await MainActor.run {
            self.pushNotificationsEnabled = dDayViewModel.cloudKitManager.subscriptionActive
        }
    }
    
    // 앱 버전 가져오기
    private func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "\(version) (\(build))"
        }
        return "알 수 없음"
    }
    
    // 캐시 비우기
    private func clearCache() async {
        await MainActor.run {
            isClearingCache = true
            clearCacheSuccess = false
        }
        
        // 이미지 캐시 삭제
        let fileManager = FileManager.default
        let cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        do {
            let urls = try fileManager.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil)
            for url in urls where url.pathExtension == "jpg" {
                try fileManager.removeItem(at: url)
            }
            
            // NSCache 비우기 수정
            // 타입 캐스팅 제거 - 이미 올바른 타입이기 때문에 불필요
            // CloudKitManager에 clearCache 메서드 추가 필요
            await dDayViewModel.cloudKitManager.clearCache()
            
            // 성공 표시 후 자동으로 숨기기
            await MainActor.run {
                clearCacheSuccess = true
                isClearingCache = false
                
                // 3초 후 성공 메시지 숨기기
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    clearCacheSuccess = false
                }
            }
        } catch {
            print("캐시 삭제 오류: \(error.localizedDescription)")
            await MainActor.run {
                isClearingCache = false
            }
        }
    }
}

// iOS 18 이전 버전을 위한 레거시 이미지 리스트 뷰
struct LegacyImageListView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dDayViewModel: DDayViewModel
    @State private var images: [UIImage] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if images.isEmpty {
                    VStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.largeTitle)
                            .padding()
                        
                        Text("이미지가 없습니다")
                            .font(.headline)
                        
                        Text("CloudKit에 저장된 이미지가 없습니다")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 10) {
                            ForEach(images.indices, id: \.self) { index in
                                Image(uiImage: images[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("추억들")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("닫기") {
                        dismiss()
                    }
                }
            }
            .task {
                await loadImages()
            }
        }
    }
    
    private func loadImages() async {
        isLoading = true
        defer { isLoading = false }
        
        if let cloudKitManager = dDayViewModel.cloudKitManager as? CloudKitManager {
            await cloudKitManager.fetchImages()
            await MainActor.run {
                self.images = cloudKitManager.images
            }
        }
    }
}
