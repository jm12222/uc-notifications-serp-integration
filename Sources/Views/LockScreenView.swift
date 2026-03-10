import SwiftUI

// MARK: - Lock Screen View

struct LockScreenView: View {
    let onNotificationTap: () -> Void

    @State private var currentTime = ""
    @State private var currentDate = ""
    @State private var notificationAppeared = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                wallpaper

                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geo.safeAreaInsets.top + 56)

                    dateDisplay

                    timeDisplay

                    Spacer()
                        .frame(height: 16)

                    if notificationAppeared {
                        notificationBanner
                            .transition(.asymmetric(
                                insertion: .move(edge: .top).combined(with: .opacity).animation(.enterIn(MotionDuration.mediumIn)),
                                removal: .opacity.animation(.fadeOut(MotionDuration.extraShortOut))
                            ))
                    }

                    Spacer()

                    bottomControls
                        .padding(.bottom, geo.safeAreaInsets.bottom + 8)
                }
            }
            .ignoresSafeArea()
        }
        .onReceive(timer) { _ in
            updateTime()
        }
        .onAppear {
            updateTime()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    notificationAppeared = true
                }
            }
        }
    }

    // MARK: - Wallpaper

    private var wallpaper: some View {
        Image("lockscreen-wallpaper")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }

    // MARK: - Date Display

    private var dateDisplay: some View {
        Text(currentDate)
            .headline3Typography()
            .foregroundStyle(.white.opacity(0.9))
            .textOnMediaShadow()
    }

    // MARK: - Time Display

    private var timeDisplay: some View {
        Text(currentTime)
            .font(.system(size: 82, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .textOnMediaShadow()
            .contentTransition(.numericText())
    }

    // MARK: - Notification Banner

    private var notificationBanner: some View {
        Button(action: onNotificationTap) {
            HStack(alignment: .center, spacing: 10) {
                Image("favicon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 1) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Trending now")
                            .body4LinkTypography()
                            .foregroundStyle(.black)

                        Spacer()

                        Text("now")
                            .meta4Typography()
                            .foregroundStyle(.black.opacity(0.4))
                    }

                    Text("Everyone's talking: Selena Gomez wedding details")
                        .body4Typography()
                        .foregroundStyle(.black.opacity(0.6))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }

                Image("profile1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.85))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .responsiveUIShadow(cornerRadius: 16)
        }
        .buttonStyle(FDSPressedState(cornerRadius: 16, scale: .small))
        .padding(.horizontal, 16)
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 50, height: 50)

                Image("flash-default-filled")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white)
                    .iconOnMediaShadow()
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 50, height: 50)

                Image("camera-filled")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white)
                    .iconOnMediaShadow()
            }
        }
        .padding(.horizontal, 48)
    }

    // MARK: - Helpers

    private func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        currentTime = formatter.string(from: Date())

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        currentDate = dateFormatter.string(from: Date())
    }
}

// MARK: - Preview

#Preview {
    LockScreenView(onNotificationTap: {})
}
