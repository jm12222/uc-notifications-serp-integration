import SwiftUI

// MARK: - Splash Interstitial View

struct SplashInterstitialView: View {
    let onFinished: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            Color("surfaceBackground")
                .ignoresSafeArea()

            VStack {
                Spacer()

                Image("SplashScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .offset(y: -32)

                Spacer()

                VStack(spacing: 4) {
                    Text("from")
                        .meta2Typography()
                        .foregroundStyle(Color("secondaryText"))

                    Image("FacebookFromMeta")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 76, height: 38)
                }
                .padding(.bottom, 72)
            }
        }
        .opacity(appeared ? 1 : 0)
        .onAppear {
            withAnimation(.fadeIn(MotionDuration.extraShortIn)) {
                appeared = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onFinished()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SplashInterstitialView(onFinished: {})
}
