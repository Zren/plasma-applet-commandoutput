// Version 5

import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

QQC2.TextField {
	id: textField

	property string configKey: ''
	readonly property string configValue: configKey ? plasmoid.configuration[configKey] : ""
	onConfigValueChanged: {
		if (!focus && text != configValue) {
			text = configValue
		}
	}

	text: configValue
	onTextChanged: serializeTimer.start()

	property string defaultValue: ""

	rightPadding: clearButton.width + Kirigami.Units.smallSpacing

	property alias clearButton: clearButton
	QQC2.ToolButton {
		id: clearButton
		visible: textField.text != textField.defaultValue
		icon.name: "edit-clear"
		onClicked: textField.text = defaultValue

		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: parent.bottom

		width: height
	}

	Timer { // throttle
		id: serializeTimer
		interval: 300
		onTriggered: {
			if (configKey) {
				plasmoid.configuration[configKey] = textField.text
			}
		}
	}
}
