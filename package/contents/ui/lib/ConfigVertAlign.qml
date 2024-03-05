// Version 3

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
	id: configTextAlign

	property string configKey: ''
	readonly property string configValue: configKey ? plasmoid.configuration[configKey] : ""
	
	property alias before: labelBefore.text
	property alias after: labelAfter.text

	function setValue(val) {
		if (configKey) {
			plasmoid.configuration[configKey] = val
		}
		updateChecked()
	}

	function updateChecked() {
		// button.checked bindings are unbound when clicked
		vertTopButton.checked = Qt.binding(function(){ return configValue == Text.AlignTop })
		vertCenterButton.checked = Qt.binding(function(){ return configValue == Text.AlignVCenter })
		vertBottomButton.checked = Qt.binding(function(){ return configValue == Text.AlignBottom })
	}

	Component.onCompleted: updateChecked()

	Label {
		id: labelBefore
		text: ""
		visible: text
	}
	
	Button {
		id: vertTopButton
		icon.name: "align-vertical-top"
		checkable: true
		onClicked: setValue(Text.AlignTop)
	}

	Button {
		id: vertCenterButton
		icon.name: "align-vertical-center"
		checkable: true
		onClicked: setValue(Text.AlignVCenter)
	}

	Button {
		id: vertBottomButton
		icon.name: "align-vertical-bottom"
		checkable: true
		onClicked: setValue(Text.AlignBottom)
	}

	Label {
		id: labelAfter
		text: ""
		visible: text
	}
}
