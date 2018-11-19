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
			exited(exitCode, exitStatus, stdout, stderr)
			disconnectSource(sourceName) // cmd finished
		}
		function exec(cmd) {
			connectSource(cmd)
		}
		signal exited(int exitCode, int exitStatus, string stdout, string stderr)
	}

	Item {
		id: config
		property bool active: !!command
		property bool waitForCompletion: plasmoid.configuration.waitForCompletion
		property bool tooltipRichText: plasmoid.configuration.tooltipRichText
		property int interval: Math.max(1000, plasmoid.configuration.interval)
		property string command: plasmoid.configuration.command || 'sleep 2 && echo "Test: $(date +%s)"'
	}

	property string outputText: ''
	property string tooltipText: ''
	Connections {
		target: executable
		onExited: {
			widget.outputText = stdout.replace('\n', ' ').trim()
			widget.tooltipText = stderr;
			if (config.waitForCompletion) {
				timer.restart()
			}
		}
	}

	Timer {
		id: timer
		interval: config.interval
		running: true
		repeat: !config.waitForCompletion
		onTriggered: {
			// console.log('tick', Date.now())
			executable.exec(config.command)
		}

		Component.onCompleted: {
			// Run right away in case the interval is very long.
			triggered()
		}
	}

	Plasmoid.backgroundHints: plasmoid.configuration.showBackground ? PlasmaCore.Types.DefaultBackground : PlasmaCore.Types.NoBackground

	Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
	Plasmoid.fullRepresentation: Item {
		id: panelItem
		Layout.minimumWidth: output.implicitWidth
		Layout.preferredWidth: output.implicitWidth
		// Layout.preferredHeight: output.implicitHeight

		Text {
			id: output
			width: parent.width
			height: parent.height

			text: widget.outputText

			color: theme.textColor

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

		PlasmaCore.ToolTipArea {
			anchors.fill: parent
			icon: 'utilities-terminal'
			mainText: widget.outputText
			subText: widget.tooltipText
			textFormat: config.tooltipRichText ? Text.RichText : Text.PlainText
		}

	}

}
