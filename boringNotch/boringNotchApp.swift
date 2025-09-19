//
//  boringNotchApp.swift
//  boringNotchApp
//
//  Created by Harsh Vardhan  Goswami  on 02/08/24.
//

import AppKit
import Defaults
import SwiftUI

@main
struct DynamicNotchApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Default(.menubarIcon) var showMenuBarIcon

    var body: some Scene {
        MenuBarExtra("boring.notch", systemImage: "note.text", isInserted: $showMenuBarIcon) {
            Button("Quit", role: .destructive) {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut(KeyEquivalent("Q"), modifiers: .command)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow?
    private let vm: BoringViewModel = .init()
    private let coordinator = BoringViewCoordinator.shared

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let notes = promptForNotesText() else {
            NSApplication.shared.terminate(nil)
            return
        }

        coordinator.notesText = notes
        coordinator.currentView = .notes

        setupMainWindow()
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let window = window {
            NotchSpaceManager.shared.notchSpace.windows.remove(window)
        }
    }

    private func setupMainWindow() {
        let targetScreen = NSScreen.main ?? NSScreen.screens.first!

        coordinator.selectedScreen = targetScreen.localizedName
        vm.screen = targetScreen.localizedName
        vm.notchSize = getClosedNotchSize(screen: targetScreen.localizedName)
        vm.closedNotchSize = vm.notchSize

        let notchWindow = createBoringNotchWindow(for: targetScreen, with: vm)
        window = notchWindow
        positionWindow(notchWindow, on: targetScreen)
    }

    private func createBoringNotchWindow(for screen: NSScreen, with viewModel: BoringViewModel) -> NSWindow {
        let window = BoringNotchWindow(
            contentRect: NSRect(
                x: 0,
                y: 0,
                width: openNotchSize.width,
                height: openNotchSize.height
            ),
            styleMask: [.borderless, .nonactivatingPanel, .utilityWindow, .hudWindow],
            backing: .buffered,
            defer: false
        )

        window.contentView = NSHostingView(
            rootView: ContentView()
                .environmentObject(viewModel)
        )

        window.orderFrontRegardless()
        NotchSpaceManager.shared.notchSpace.windows.insert(window)
        return window
    }

    private func positionWindow(_ window: NSWindow, on screen: NSScreen) {
        let screenFrame = screen.frame
        window.setFrameOrigin(
            NSPoint(
                x: screenFrame.origin.x + (screenFrame.width / 2) - window.frame.width / 2,
                y: screenFrame.origin.y + screenFrame.height - window.frame.height
            )
        )
    }

    private func promptForNotesText() -> String? {
        let alert = NSAlert()
        alert.messageText = "Notes"
        alert.informativeText = "Enter the text to display in the Notes tab."
        alert.alertStyle = .informational

        let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 320, height: 160))
        textView.isRichText = false
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.font = .systemFont(ofSize: NSFont.systemFontSize)
        textView.textContainer?.widthTracksTextView = true
        textView.textContainerInset = NSSize(width: 8, height: 8)
        textView.drawsBackground = false
        textView.string = coordinator.notesText

        let scrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: 320, height: 160))
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = true
        scrollView.borderType = .bezelBorder
        scrollView.drawsBackground = false
        scrollView.documentView = textView

        alert.accessoryView = scrollView
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")

        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)

        let response = alert.runModal()

        NSApp.setActivationPolicy(.accessory)

        if response == .alertFirstButtonReturn {
            return textView.string
        }

        return nil
    }
}
