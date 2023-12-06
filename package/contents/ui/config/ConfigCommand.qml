import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami

import "../lib"

Kirigami.FormLayout {
	id: pageConfigCommand
	showAppletVersion: true
	
	property alias cfg_command: command.text
	property alias cfg_tooltipCommand: tooltipCommand.text
	property alias cfg_waitForCompletion: waitForCompletion.checked
	property alias cfg_interval: interval.value
	
	TextField {
		id: command
		Layout.fillWidth: true
	}

	RowLayout {
		Label {
			text: i18n("Tooltip command")
		}

		TextField {
			id: tooltipCommand
			Layout.fillWidth: true
		}
	}

	RowLayout {
		Label {
			text: i18n("Run every ")
		}
		SpinBox {
			id: interval
			minimumValue: 0
			stepSize: 500
			maximumValue: 2000000000 // Close enough.
			suffix: "ms"
		}
	}

	CheckBox {
		id: waitForCompletion
		text: i18n("Wait for completion")
	}
}
