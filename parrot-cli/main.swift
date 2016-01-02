import Foundation
import Darwin.ncurses

// The string we want to show in the window for now.
let str1 = "Parrot is not yet implemented as a CLI."
let str2 = "Please try again later though!"

// A nifty utility function for determining the centers of dimensions.
func center(dimension: Int) -> Int32 {
	return Int32((dimension / 2) - 1)
}

// Create a new window first.
var win = initscr()

// Catch all terminal resizes and call it initially for drawing.
func redraw(sig: Int32) {
	signal(SIGWINCH, SIG_IGN)
	
	// Reinitialize the window to update data structures.
	endwin()
	win = initscr()
	Terminal.startColors()
	wrefresh(win)
	wclear(win)
	
	// Draw our text in the middle of the window.
	// Set ColorPairs that we can use and looks cool!
	wattron(win, COLOR_PAIR(ColorPair(1, colors: (.Black, .Red)).rawValue))
	mvaddstr(center(Terminal.size().rows), center(Terminal.size().columns) - center(str1.characters.count), str1)
	wattron(win, COLOR_PAIR(ColorPair(2, colors: (.Black, .Blue)).rawValue))
	mvaddstr(center(Terminal.size().rows) + 1, center(Terminal.size().columns) - center(str2.characters.count), str2)
	wrefresh(win)
	
	// Draw a window border.
	wattron(win, COLOR_PAIR(ColorPair(3, colors: (.Yellow, .Black)).rawValue))
	let border = Border.fromString("||--****")!
	wborder(win, border.leftSide, border.rightSide, border.topSide, border.bottomSide,
				 border.topLeft, border.topRight, border.bottomLeft, border.bottomRight)
	wrefresh(win)
	
	signal(SIGWINCH, redraw);
}
signal(SIGWINCH, redraw)
redraw(Int32(0))

// End the program when ESC is pressed.
while wgetch(win) != 27 {}
endwin()