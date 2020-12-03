import QtQuick 2.1
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponent

Item {
	id: widget

	// https://github.com/KDE/plasma-workspace/blob/master/dataengines/executable/executable.h
	// https://github.com/KDE/plasma-workspace/blob/master/dataengines/executable/executable.cpp
	// https://github.com/KDE/plasma-framework/blob/master/src/declarativeimports/core/datasource.h
	// https://github.com/KDE/plasma-framework/blob/master/src/declarativeimports/core/datasource.cpp
	// https://github.com/KDE/plasma-framework/blob/master/src/plasma/scripting/dataenginescript.cpp
	PlasmaCore.DataSource {
		id: executable
		engine: "executable"
		connectedSources: []
		onNewData: {
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
		readonly property string command: plasmoid.configuration.command || 'sleep 2 && echo "Test: $(date +%s)"'
		readonly property bool clickEnabled: !!plasmoid.configuration.clickCommand
		readonly property bool mousewheelEnabled: (plasmoid.configuration.mousewheelUpCommand || plasmoid.configuration.mousewheelDownCommand)
		readonly property color textColor: plasmoid.configuration.textColor || theme.textColor
		readonly property color outlineColor: plasmoid.configuration.outlineColor || theme.backgroundColor
		readonly property bool showOutline: plasmoid.configuration.showOutline

		onCommandChanged: widget.runCommand()
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

	property string outputText: ''
	Connections {
		target: executable
		onExited: {
			if (cmd == config.command) {
				var formattedText = stdout
				if (plasmoid.configuration.replaceAllNewlines) {
					formattedText = formattedText.replace('\n', ' ').trim()
				} else if (formattedText.length >= 1 && formattedText[formattedText.length-1] == '\n') {
					formattedText = formattedText.substr(0, formattedText.length-1)
				}
				// console.log('[commandoutput]', 'stdout', JSON.stringify(stdout))
				// console.log('[commandoutput]', 'format', JSON.stringify(formattedText))
				widget.outputText = formattedText

				if (config.waitForCompletion) {
					timer.restart()
				}
			}
		}
	}

	function runCommand() {
		// console.log('[commandoutput]', Date.now(), 'runCommand', config.command)
		executable.exec(config.command)
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

	Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
	Plasmoid.fullRepresentation: Item {
		id: panelItem

		readonly property bool isHorizontal: plasmoid.formFactor == PlasmaCore.Types.Horizontal
		readonly property bool isVertical: plasmoid.formFactor == PlasmaCore.Types.Vertical
		readonly property bool isInPanel: isHorizontal || isVertical
		readonly property bool isOnDesktop: !isInPanel

		readonly property int itemWidth: {
			if (isOnDesktop) {
				return Math.ceil(output.contentWidth)
			} else if (isHorizontal && plasmoid.configuration.useFixedWidth) {
				return plasmoid.configuration.fixedWidth * units.devicePixelRatio
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
				return plasmoid.configuration.fixedHeight * units.devicePixelRatio
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
			onWheel: {
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

		PlasmaCore.ToolTipArea {
			anchors.fill: parent
			subText: output.text
			enabled: output.truncated
		}

		Text {
			id: output
			width: parent.width
			height: parent.height

			text: widget.outputText

			color: config.textColor
			style: config.showOutline ? Text.Outline : Text.Normal
			styleColor: config.outlineColor

			linkColor: theme.linkColor
			onLinkActivated: Qt.openUrlExternally(link)

			font.pointSize: -1
			font.pixelSize: plasmoid.configuration.fontSize * units.devicePixelRatio
			font.family: plasmoid.configuration.fontFamily || theme.defaultFont.family
			font.weight: plasmoid.configuration.bold ? Font.Bold : Font.Normal
			font.italic: plasmoid.configuration.italic
			font.underline: plasmoid.configuration.underline
			fontSizeMode: Text.FixedSize
			horizontalAlignment: plasmoid.configuration.textAlign
			verticalAlignment: Text.AlignVCenter

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

}
