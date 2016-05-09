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
	@IBOutlet private weak var installedVersionLabel: NSTextField!

	func applicationDidFinishLaunching(notification: NSNotification) {
		updateStatus()
	}

	@IBAction func installService(sender: AnyObject!) {
		var error: NSError? = nil
		// In order to test out SMJobKit,
		// SampleApplication is trying to install a new
		// helper tool.  Type your password to allow this.
		if SampleService.installWithPrompt("In order to test out SMJobKit,", error: &error) {
			appendMessage(error!.description)
		} else {
			appendMessage("Successfully installed SampleService")
		}

		updateStatus()
	}

	@IBAction func uninstallService(sender: AnyObject!) {
		var error: NSError? = nil
		// In order to test out SMJobKit,
		// SampleApplication is trying to install a new
		// helper tool.  Type your password to allow this.
		if !SampleService.uninstallWithPrompt("In order to test out SMJobKit,", error: &error) {
			appendMessage(error!.description)
		} else {
			appendMessage("Successfully uninstalled SampleService")
		}

		updateStatus()
	}

	private func updateStatus() {
		self.bundledVersionLabel.stringValue = SampleService.bundledVersion ?? "Unknown Version"
		self.installedVersionLabel.stringValue = SampleService.installedVersion ?? "Not Installed"

		SampleService.checkForProblems().map { self.appendMessage($0.description) }
	}

	private func appendMessage(message: String) {
		self.outputTextView.string! += "\(message)\n"
	}

}
