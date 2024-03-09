import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

import "../libconfig" as LibConfig

LibConfig.FormKCM {

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
		vertAlignConfigKey: 'vertAlign'
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
		visible: plasmoid.location == PlasmaCore.Types.Floating
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
		visible: plasmoid.formFactor == PlasmaCore.Types.Vertical
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

}
