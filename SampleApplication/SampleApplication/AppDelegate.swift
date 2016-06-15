//
//  AppDelegate.swift
//  SampleApplication
//
//  Created by Ingmar Stein on 29.03.15.
//  Copyright (c) 2015 Ian MacLeod. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet private weak var window: NSWindow!
	@IBOutlet private var outputTextView: NSTextView!
	@IBOutlet private weak var bundledVersionLabel: NSTextField!

	#if swift(>=3.0)

	func applicationDidFinishLaunching(_ notification: Notification) {
		updateStatus()
	}

	private func appendMessage(_ message: String) {
		self.outputTextView.string! += "\(message)\n"
	}

	#else

	func applicationDidFinishLaunching(notification: NSNotification) {
		updateStatus()
	}

	private func appendMessage(message: String) {
		self.outputTextView.string! += "\(message)\n"
	}

	#endif

	@IBAction func installService(sender: AnyObject!) {
		// In order to test out SMJobKit,
		// SampleApplication is trying to install a new
		// helper tool. Type your password to allow this.
		do {
			#if swift(>=3.0)
			try SampleService.installWithPrompt(prompt: "In order to test out SMJobKit,")
			#else
			try SampleService.installWithPrompt("In order to test out SMJobKit,")
			#endif
			appendMessage("Successfully installed SampleService")
		} catch let error {
			appendMessage("\(error)")
		}

		updateStatus()
	}

	private func updateStatus() {
		self.bundledVersionLabel.stringValue = SampleService.bundledVersion ?? "Unknown Version"

		SampleService.checkForProblems().map { self.appendMessage("\($0)") }
	}

}
