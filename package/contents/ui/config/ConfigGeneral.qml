import QtQuick 2.0
import QtQuick.Layouts 1.0

import org.kde.kirigami 2.5 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore

import "../libconfig" as LibConfig


Kirigami.FormLayout {

	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Command")
	}
	LibConfig.TextField {
		Kirigami.FormData.label: i18n("Command")
		configKey: 'command'
		Layout.fillWidth: true
	}
	LibConfig.SpinBox {
		Kirigami.FormData.label: i18n("Run every ")
		configKey: 'interval'
		suffix: "ms"
		stepSize: 500
	}
	LibConfig.CheckBox {
		Kirigami.FormData.label: i18n("Wait for completion")
		configKey: 'waitForCompletion'
		text: i18n("Enabled")
	}


	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Font")
	}
	LibConfig.FontFamily {
		Kirigami.FormData.label: i18n("Font Family:")
		configKey: 'fontFamily'
	}
	LibConfig.SpinBox {
		Kirigami.FormData.label: i18n("Font Size:")
		configKey: 'fontSize'
		suffix: i18n("px")
	}
	LibConfig.TextFormat {
		boldConfigKey: 'bold'
		italicConfigKey: 'italic'
		underlineConfigKey: 'underline'
		alignConfigKey: 'textAlign'
		// vertAlignConfigKey: 'vertAlign'
	}


	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Colors")
	}
	LibConfig.ColorField {
		Kirigami.FormData.label: i18n("Text:")
		configKey: 'textColor'
		defaultColor: PlasmaCore.Theme.textColor
	}
	RowLayout {
		Kirigami.FormData.label: i18n("Outline:")
		spacing: 0
		LibConfig.CheckBox {
			configKey: 'showOutline'
		}
		LibConfig.ColorField {
			configKey: 'outlineColor'
			defaultColor: PlasmaCore.Theme.backgroundColor
		}
	}


	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Misc")
	}
	LibConfig.CheckBox {
		Kirigami.FormData.label: i18n("Desktop Widget:")
		configKey: 'showBackground'
		text: i18n("Show background")
	}
	RowLayout {
		Kirigami.FormData.label: i18n("Fixed Width:")
		spacing: 0
		visible: plasmoid.formFactor == PlasmaCore.Types.Horizontal
		LibConfig.CheckBox {
			configKey: 'useFixedWidth'
		}
		LibConfig.SpinBox {
			configKey: 'fixedWidth'
			suffix: i18n("px")
		}
	}
	RowLayout {
		Kirigami.FormData.label: i18n("Fixed Height:")
		spacing: 0
		visible: plasmoid.formFactor == PlasmaCore.Types.Horizontal
		LibConfig.CheckBox {
			configKey: 'useFixedHeight'
		}
		LibConfig.SpinBox {
			configKey: 'fixedHeight'
			suffix: i18n("px")
		}
	}
	LibConfig.CheckBox {
		Kirigami.FormData.label: i18n("Replace all newlines with spaces")
		configKey: 'replaceAllNewlines'
	}


	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Click")
	}
	LibConfig.TextField {
		// id: clickCommand
		Kirigami.FormData.label: i18n("Run Command:")
		configKey: 'clickCommand'
	}


	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Mouse Wheel")
	}
	LibConfig.TextField {
		// id: mousewheelUpCommand
		Kirigami.FormData.label: i18n("Scroll Up:")
		configKey: 'mousewheelUpCommand'
	}
	LibConfig.TextField {
		// id: mousewheelDownCommand
		Kirigami.FormData.label: i18n("Scroll Down:")
		configKey: 'mousewheelDownCommand'
	}

}
