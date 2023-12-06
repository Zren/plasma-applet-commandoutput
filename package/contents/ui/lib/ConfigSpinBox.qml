import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
	id: configSpinBox

	property string configKey: ''
	property alias decimals: spinBox.decimals
	property alias horizontalAlignment: spinBox.horizontalAlignment
	property alias maximumValue: spinBox.maximumValue
	property alias minimumValue: spinBox.minimumValue
	property alias prefix: spinBox.prefix
	property alias stepSize: spinBox.stepSize
	property alias suffix: spinBox.suffix
	property alias value: spinBox.value

	property alias before: labelBefore.text
	property alias after: labelAfter.text

	Label {
		id: labelBefore
		text: ""
		visible: text
	}
	
	SpinBox {
		id: spinBox

		value: plasmoid.configuration[configKey]
		// onValueChanged: plasmoid.configuration[configKey] = value
		onValueChanged: serializeTimer.start()
		maximumValue: 2147483647
	}

	Label {
		id: labelAfter
		text: ""
		visible: text
	}

	Timer { // throttle
		id: serializeTimer
		interval: 300
		onTriggered: plasmoid.configuration[configKey] = value
	}
}
