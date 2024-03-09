// Version 4

import QtQuick

import "." as LibConfig

LibConfig.ComboBox {
	id: configFontFamily

	populated: false

	// Based on: org.kde.plasma.digitalclock
	onPopulate: {
		var arr = [] // Use temp array to avoid constant binding stuff
		arr.push({ text: i18nc("Use default font", "Default"), value: "" })

		var fonts = Qt.fontFamilies()
		for (var i = 0; i < fonts.length; i++) {
			arr.push({ text: fonts[i], value: fonts[i] })
		}
		model = arr
		populated = true
	}
}
