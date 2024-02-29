import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
	id: configSpinBox

	property string configKey: ''
	property alias decimals: spinBox.decimals
	property alias horizontalAlignment: spinBox.horizontalAlignment
	property alias maximumValue: spinBox.to
	property alias minimumValue: spinBox.from
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
		to: 2147483647
		
		property string suffix: ""
		
		/* copied from https://doc.qt.io/qt-6/qml-qtquick-controls-spinbox.html
		 * because QtQuick 6.0 does not include properties that where in QtQuick.Controls 1.2 */
		property int decimals: 2
		property real realValue: value / decimalFactor
		readonly property int decimalFactor: Math.pow(10, decimals)
		
		function decimalToInt(decimal) {
			return decimal * decimalFactor
		}
		
		validator: DoubleValidator {
			bottom: Math.min(spinBox.from, spinBox.to)
			top:  Math.max(spinBox.from, spinBox.to)
			decimals: spinBox.decimals
			notation: DoubleValidator.StandardNotation
		}
		
		textFromValue: function(value, locale) {
			return (suffix == "" ? qsTr("%1") : qsTr("%1 " + suffix)).arg(
				Number(value / decimalFactor).toLocaleString(locale, 'f', spinBox.decimals))
		}
		
		valueFromText: function(text, locale) {
			return Math.round(Number.fromLocaleString(locale, text) * decimalFactor)
		}
		
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
