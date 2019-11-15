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
	}

	property string outputText: ''
	Connections {
		target: executable
		onExited: {
			if (cmd == config.command) {
				widget.outputText = stdout.replace('\n', ' ').trim()
				if (config.waitForCompletion) {
					timer.restart()
				}
			}
		}
	}

	Timer {
		id: timer
		interval: config.interval
		running: true
		repeat: !config.waitForCompletion
		triggeredOnStart: true
		onTriggered: {
			// console.log('tick', Date.now())
			executable.exec(config.command)
		}
	}

	Plasmoid.onActivated: widget.performClick()

	Plasmoid.backgroundHints: plasmoid.configuration.showBackground ? PlasmaCore.Types.DefaultBackground : PlasmaCore.Types.NoBackground

	Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
	Plasmoid.fullRepresentation: Item {
		id: panelItem
		Layout.minimumWidth: output.implicitWidth
		Layout.preferredWidth: output.implicitWidth
		// Layout.preferredHeight: output.implicitHeight

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
			fontSizeMode: Text.Fit
			horizontalAlignment: plasmoid.configuration.textAlign
			verticalAlignment: Text.AlignVCenter
		}

	}

}
