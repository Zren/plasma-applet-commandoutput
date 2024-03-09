import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponent
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
	id: widget

	// https://github.com/KDE/plasma-workspace/blob/master/dataengines/executable/executable.h
	// https://github.com/KDE/plasma-workspace/blob/master/dataengines/executable/executable.cpp
	// https://github.com/KDE/plasma-framework/blob/master/src/declarativeimports/core/datasource.h
	// https://github.com/KDE/plasma-framework/blob/master/src/declarativeimports/core/datasource.cpp
	// https://github.com/KDE/plasma-framework/blob/master/src/plasma/scripting/dataenginescript.cpp
	Plasma5Support.DataSource {
		id: executable
		engine: "executable"
		connectedSources: []
		onNewData: (sourceName, data) => {
			var exitCode = data["exit code"]
			var exitStatus = data["exit status"]
			var stdout = data["stdout"]
			var stderr = data["stderr"]
			exited(sourceName, exitCode, exitStatus, stdout, stderr)
			disconnectSource(sourceName) // cmd finished
		}
		function exec(cmd) {
			if (cmd) {
				connectSource(cmd)
			}
		}
		signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
	}

	function performClick() {
		executable.exec(plasmoid.configuration.clickCommand)
	}

	function performMouseWheelUp() {
		executable.exec(plasmoid.configuration.mousewheelUpCommand)
	}

	function performMouseWheelDown() {
		executable.exec(plasmoid.configuration.mousewheelDownCommand)
	}

	Item {
		id: config
		readonly property bool active: !!command
		readonly property bool waitForCompletion: plasmoid.configuration.waitForCompletion
		readonly property int interval: Math.max(0, plasmoid.configuration.interval)
		readonly property string command: plasmoid.configuration.command || ''
		readonly property string tooltipCommand: plasmoid.configuration.tooltipCommand || ''
		readonly property bool clickEnabled: !!plasmoid.configuration.clickCommand
		readonly property bool mousewheelEnabled: (plasmoid.configuration.mousewheelUpCommand || plasmoid.configuration.mousewheelDownCommand)
		readonly property color textColor: plasmoid.configuration.textColor || Kirigami.Theme.textColor
		readonly property color outlineColor: plasmoid.configuration.outlineColor || Kirigami.Theme.backgroundColor
		readonly property bool showOutline: plasmoid.configuration.showOutline

		onCommandChanged: widget.runCommand()
		onTooltipCommandChanged: widget.runCommand()
		onIntervalChanged: {
			// interval=0 stops the timer even with Timer.repeat=true, so we may
			// need to restart the timer. Might as well restart the interval too.
			timer.restart()
		}
		onWaitForCompletionChanged: {
			if (!waitForCompletion) {
				// The timer needs to be restarted in case the timer was already
				// triggered and the command is running. If we don't restart the
				// timer, it'll stop forever.
				timer.restart()
			}
		}
	}

	// https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
	property var ansiColors: ({
		30: '#000000', // Black
		31: '#aa0000', // Red
		32: '#00aa00', // Green
		33: '#aa6500', // Yellow
		34: '#0000aa', // Blue
		35: '#aa00aa', // Magenta
		36: '#00aaaa', // Cyan
		37: '#aaaaaa', // White
		90: '#656565', // Bright Black
		91: '#ff6565', // Bright Red
		92: '#65ff65', // Bright Green
		93: '#ffff65', // Bright Yellow
		94: '#6565ff', // Bright Blue
		95: '#ff65ff', // Bright Magenta
		96: '#65ffff', // Bright Cyan
		97: '#ffffff', // Bright White
	})
	function resetState(state) {
		var out = state.closeTags.join(' ')
		state.bold = false
		state.closeTags = []
		return out
	}
	function parseAnsiCode(n, i, tokens, state) {
		if (n == 0) { // Reset
			return resetState(state)
		} else if (n == 1) {
			state.closeTags.push('</b>')
			state.bold = true
			return '<b>'
		} else if (30 <= n && n <= 37 || 90 <= n && n <= 97) {
			if (state.bold && 30 <= n && n <= 37) {
				// Bold also intensifies the colors to "Bright".
				// 30 => 90
				n += 60
			}
			var hexColor = ansiColors[n]
			state.closeTags.push('</font>')
			return '<font color="' + hexColor + '">'
		} else {
			return ''
		}
	}
	// https://stackoverflow.com/questions/4745317/converting-integers-to-hex-string-in-javascript
	function formatHexInt(n) {
		var num = Number(n)
		if (isNaN(num)) {
			return "00"
		}
		num = Math.max(0, Math.min(num, 255))
		var str = num.toString(16)
		return str.length == 1 ? '0' + str : str
	}
	function rgbToHex(r, g, b) {
		return '#' + formatHexInt(r) + formatHexInt(g) + formatHexInt(b)
	}
	function parseColorMode(i, tokens) {
		var colorMode = parseInt(tokens[++i], 10)
		if (colorMode == 2) { // RGB
			var r = parseInt(tokens[++i], 10)
			var g = parseInt(tokens[++i], 10)
			var b = parseInt(tokens[++i], 10)
			return rgbToHex(r, g, b)
		} else if (colorMode == 5) { // Preset of 256 colors
			// Logic taken from Konsole
			// https://invent.kde.org/utilities/konsole/-/blob/master/src/autotests/CharacterColorTest.cpp#L159
			var n = parseInt(tokens[++i], 10)
			if (0 <= n && n <= 7) { // Normal
				var u = n + 30
				return ansiColors[u]
			} else if (8 <= n && n <= 15) { // Bright
				var u = n - 8 + 90
				return ansiColors[u]
			} else if (16 <= n && n <= 231) { // 212
				var u = n - 16
				var r = Math.floor(((u / 36) % 6) != 0 ? (40 * ((u / 36) % 6) + 55) : 0)
				var g = Math.floor(((u / 6) % 6) != 0 ? (40 * ((u / 6) % 6) + 55) : 0)
				var b = Math.floor(((u / 1) % 6) != 0 ? (40 * ((u / 1) % 6) + 55) : 0)
				return rgbToHex(r, g, b)
			} else if (232 <= n && n <= 255) {
				var gray = Math.floor((n - 232) * 10 + 8)
				return rgbToHex(gray, gray, gray)
			}
		}
		return null
	}
	function parseAnsiEscape(codes, state) {
		var tokens = codes.split(';')
		var out = ''
		for (var i = 0; i < tokens.length; i++) {
			tokens[i] = parseInt(tokens[i], 10)
		}
		for (var i = 0; i < tokens.length; i++) {
			var token = tokens[i]
			if (token == 38) { // Set FG
				var hexColor = parseColorMode(i, tokens)
				if (hexColor) {
					state.closeTags.push('</font>')
					out += '<font color="' + hexColor + '">'
				}
			} else if (token == 48) { // Set BG
				var hexColor = parseColorMode(i, tokens)
				// Ignore
			} else {
				out += parseAnsiCode(token, i, tokens, state)
			}
		}
		return out
	}

	property string outputText: ''
	property string tooltipText: ''

	function formatOutputText(stdout) {
		var formattedText = stdout

		// Newlines
		if (plasmoid.configuration.replaceAllNewlines) {
			formattedText = formattedText.replace(/\n/g, ' ').trim()
		} else if (formattedText.length >= 1 && formattedText[formattedText.length-1] == '\n') {
			formattedText = formattedText.substr(0, formattedText.length-1)
		}

		// Terminal Colors (Issue #7)
		var state = {
			html: false,
			bold: false,
			closeTags: [],
		}
		formattedText = formattedText.replace(/\033\[(\d+(;\d+)*)?m/g, function(match, p1, p2){
			state.html = true
			if (typeof p1 === 'string') {
				return parseAnsiEscape(p1, state)
			} else { // \033[m is Reset
				return parseAnsiEscape('0', state)
			}
		})
		formattedText += resetState(state)

		// Format Newlines when in HTML mode
		if (state.html) {
			formattedText = formattedText.replace(/\n/g, '<br>')
		}
		return formattedText
	}

	Connections {
		target: executable
		function onExited(cmd, exitCode, exitStatus, stdout, stderr) {
			if ((cmd == config.command) || (cmd == config.tooltipCommand)) {
				var formattedText = formatOutputText(stdout)

				// console.log('[commandoutput]', 'stdout', JSON.stringify(stdout))
				// console.log('[commandoutput]', 'format', JSON.stringify(formattedText))

				if (cmd == config.command) {
					widget.outputText = formattedText
				} else if (cmd == config.tooltipCommand) {
					widget.tooltipText = formattedText
				}

				if (config.waitForCompletion) {
					timer.restart()
				}
			}
		}
	}

	function runCommand() {
		// console.log('[commandoutput]', Date.now(), 'runCommand', config.command)
		executable.exec(config.command)
		executable.exec(config.tooltipCommand)
	}

	Timer {
		id: timer
		interval: config.interval
		running: true
		repeat: !config.waitForCompletion
		onTriggered: widget.runCommand()
		// onIntervalChanged: console.log('interval', interval)
		// onRunningChanged: console.log('running', running)
		// onRepeatChanged: console.log('repeat', repeat)

		Component.onCompleted: {
			// Run right away in case the interval is very long.
			triggered()
		}
	}

	Plasmoid.onActivated: widget.performClick()

	Plasmoid.backgroundHints: plasmoid.configuration.showBackground ? PlasmaCore.Types.DefaultBackground : PlasmaCore.Types.NoBackground

	fullRepresentation: Item {
		id: panelItem

		readonly property bool isHorizontal: plasmoid.formFactor == PlasmaCore.Types.Horizontal
		readonly property bool isVertical: plasmoid.formFactor == PlasmaCore.Types.Vertical
		readonly property bool isInPanel: isHorizontal || isVertical
		readonly property bool isOnDesktop: !isInPanel

		readonly property int itemWidth: {
			if (isOnDesktop) {
				return Math.ceil(output.contentWidth)
			} else if (isHorizontal && plasmoid.configuration.useFixedWidth) {
				return plasmoid.configuration.fixedWidth * Kirigami.Units.devicePixelRatio
			} else { // isHorizontal || isVertical
				return Math.ceil(output.implicitWidth)
			}
		}
		Layout.minimumWidth: isHorizontal ? itemWidth : -1
		Layout.fillWidth: isVertical
		Layout.preferredWidth: itemWidth // Panel widget default
		// width: itemWidth // Desktop widget default
		// onItemWidthChanged: console.log('itemWidth', itemWidth, 'implicitWidth', output.implicitWidth, 'contentWidth', output.contentWidth)

		readonly property int itemHeight: {
			if (isOnDesktop) {
				return Math.ceil(output.contentHeight)
			} else if (isVertical && plasmoid.configuration.useFixedHeight) {
				return plasmoid.configuration.fixedHeight * Kirigami.Units.devicePixelRatio
			} else { // isHorizontal || isVertical
				return Math.ceil(output.implicitHeight)
			}
		}
		Layout.minimumHeight: isVertical ? itemHeight : -1
		Layout.fillHeight: isHorizontal
		Layout.preferredHeight: itemHeight // Panel widget default
		// height: itemHeight // Desktop widget default
		// onItemHeightChanged: console.log('itemHeight', itemHeight, 'implicitHeight', output.implicitHeight, 'contentHeight', output.contentHeight)


		// Note MouseArea is below the Text so
		// that we don't eat the link clicks.
		MouseArea {
			id: mouseArea
			anchors.fill: parent
			hoverEnabled: config.clickEnabled

			cursorShape: output.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor

			onClicked: {
				widget.performClick()
			}

			property int wheelDelta: 0
			onWheel: (wheel) => {
				var delta = wheel.angleDelta.y || wheel.angleDelta.x
				wheelDelta += delta
				// Magic number 120 for common "one click"
				// See: http://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
				while (wheelDelta >= 120) {
					wheelDelta -= 120
					widget.performMouseWheelUp()
				}
				while (wheelDelta <= -120) {
					wheelDelta += 120
					widget.performMouseWheelDown()
				}
				wheel.accepted = true
			}
		}

		Text {
			id: output
			width: parent.width
			height: parent.height

			PlasmaCore.ToolTipArea {
				anchors.fill: parent
				mainText: widget.tooltipText
				enabled: widget.tooltipText
			}

			text: widget.outputText

			color: config.textColor
			style: config.showOutline ? Text.Outline : Text.Normal
			styleColor: config.outlineColor

			linkColor: Kirigami.Theme.linkColor
			onLinkActivated: Qt.openUrlExternally(link)

			font.pointSize: plasmoid.configuration.fontSize
			font.family: plasmoid.configuration.fontFamily || Kirigami.Theme.defaultFont.family
			font.weight: plasmoid.configuration.bold ? Font.Bold : Font.Normal
			font.italic: plasmoid.configuration.italic
			font.underline: plasmoid.configuration.underline
			fontSizeMode: Text.FixedSize
			horizontalAlignment: plasmoid.configuration.textAlign
			verticalAlignment: plasmoid.configuration.vertAlign

			property bool isFixedWidth: {
				if (plasmoid.formFactor == PlasmaCore.Types.Planar) { // Desktop Widget
					return true
				} else if (plasmoid.formFactor == PlasmaCore.Types.Horizontal) {
					return plasmoid.configuration.useFixedWidth
				} else if (plasmoid.formFactor == PlasmaCore.Types.Vertical) {
					return true
				} else {
					return false
				}
			}
			elide: Text.ElideRight
			wrapMode: isFixedWidth ? Text.Wrap : Text.NoWrap
		}

	}

	preferredRepresentation: fullRepresentation
}
