import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

RowLayout {
	id: configFontFamily

	property string configKey: ''
	readonly property var currentItem: fontfamilyComboBox.model[fontfamilyComboBox.currentIndex]
	readonly property string value: currentItem ? currentItem.value : ""
	readonly property string configValue: configKey ? plasmoid.configuration[configKey] : ""
	onConfigValueChanged: {
		if (!fontfamilyComboBox.focus && value != configValue) {
			setFont(configValue)
		}
	}

	property alias before: labelBefore.text
	property alias after: labelAfter.text

	property bool populated: false

	function setFont(fontName) {
		for (var i = 0; i < fontfamilyComboBox.model.length; i++) {
			if (fontfamilyComboBox.model[i].value == fontName) {
				fontfamilyComboBox.currentIndex = i
				break
			}
		}
	}

	Label {
		id: labelBefore
		text: ""
		visible: text
	}

	ComboBox {
		// Based on: org.kde.plasma.digitalclock
		id: fontfamilyComboBox
		textRole: "text" // Doesn't autodeduce from model because we manually populate it


		function populate() {
			var arr = [] // Use temp array to avoid constant binding stuff
			arr.push({ text: i18nc("Use default font", "Default"), value: "" })

			var fonts = Qt.fontFamilies()
			for (var i = 0; i < fonts.length; i++) {
				arr.push({ text: fonts[i], value: fonts[i] })
			}
			model = arr
			populated = true
		}

		Component.onCompleted: {
			populate()
			setFont(configValue)
		}

		onCurrentIndexChanged: {
			var current = model[currentIndex]
			if (populated && current) {
				plasmoid.configuration[configKey] = current.value
			}
		}
	}

	Label {
		id: labelAfter
		text: ""
		visible: text
	}
}
