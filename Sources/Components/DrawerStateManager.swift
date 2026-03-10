import SwiftUI
import Combine

// MARK: - Drawer State Manager

class DrawerStateManager: ObservableObject {
    @Published var isDrawerOpen: Bool = false
    
    /// Signal for navigation requests from the drawer.
    /// External code sets this, target components listen and handle navigation themselves.
    @Published var pendingNavigation: String? = nil
    
    /// Signal for tab switching requests from the drawer.
    @Published var pendingTabSwitch: String? = nil
    
    func openDrawer() {
        withAnimation(.swapShuffleIn(MotionDuration.mediumIn)) {
            isDrawerOpen = true
        }
    }
    
    func closeDrawer() {
        withAnimation(.swapShuffleOut(MotionDuration.mediumOut)) {
            isDrawerOpen = false
        }
    }
    
    func toggleDrawer() {
        if isDrawerOpen {
            closeDrawer()
        } else {
            openDrawer()
        }
    }
    
    /// Request navigation to a destination. Closes the drawer and signals the target.
    func navigateTo(_ destination: String) {
        closeDrawer()
        // Delay slightly to let drawer close animation start
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pendingNavigation = destination
        }
    }
    
    /// Request switching to a specific tab.
    func switchToTab(_ tabName: String) {
        closeDrawer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pendingTabSwitch = tabName
        }
    }
    
    /// Switch to a tab and then navigate to a destination within that tab.
    /// Useful for navigating to views that live within a specific tab's NavigationStack.
    func switchToTabAndNavigate(tab: String, destination: String) {
        closeDrawer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pendingTabSwitch = tab
            // Give the tab switch time to complete before triggering navigation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.pendingNavigation = destination
            }
        }
    }
    
    /// Clear pending navigation after it's been handled.
    func clearPendingNavigation() {
        pendingNavigation = nil
    }
    
    /// Clear pending tab switch after it's been handled.
    func clearPendingTabSwitch() {
        pendingTabSwitch = nil
    }
}
