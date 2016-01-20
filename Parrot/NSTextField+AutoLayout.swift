import Cocoa

// Extensions to easily create labels and views without a frame.
public typealias NSLabel = NSTextField

public extension NSView {
	public convenience init(_ layerBacked: Bool) {
		self.init(frame: NSZeroRect)
		self.wantsLayer = layerBacked
		self.translatesAutoresizingMaskIntoConstraints = false
	}
}

public extension NSTextField {
	public convenience init(_ layerBacked: Bool, _ wraps: Bool) {
		self.init(layerBacked)
		self.bezeled = false
		self.bordered = false
		self.editable = false
		self.selectable = false
		self.drawsBackground = false
		self.usesSingleLineMode = wraps
		self.allowsEditingTextAttributes = false
	}
}
