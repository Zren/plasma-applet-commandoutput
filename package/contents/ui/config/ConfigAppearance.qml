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
		Kirigami.FormData.label: i18n("Foreground:")
		configKey: 'textColor'
		defaultColor: PlasmaCore.Theme.textColor
	}
	//Black / Bright Black
	RowLayout {
		Kirigami.FormData.label: i18n("Color 1:")
		spacing: 0
		LibConfig.ColorField {
			configKey: 'textc1base'
			defaultColor: '#000000'
		}
		LibConfig.ColorField {
			configKey: 'textc1bright'
			defaultColor: '#656565'
		}
	}
	// Red / Bright Red
	RowLayout {
		Kirigami.FormData.label: i18n("Color 2:")
		spacing: 0
		LibConfig.ColorField {
			configKey: 'textc2base'
			defaultColor: '#aa0000'
		}
		LibConfig.ColorField {
			configKey: 'textc2bright'
			defaultColor: '#ff6565'
		}
	}
	// Green / Bright Green
	RowLayout {
		Kirigami.FormData.label: i18n("Color 3:")
		spacing: 0
		LibConfig.ColorField {
			configKey: 'textc3base'
			defaultColor: '#00aa00'
		}
		LibConfig.ColorField {
			configKey: 'textc3bright'
			defaultColor: '#65ff65'
		}
	}
	// Yellow / Bright Yellow
	RowLayout {
		Kirigami.FormData.label: i18n("Color 4:")
		spacing: 0
		LibConfig.ColorField {
			configKey: 'textc4base'
			defaultColor: '#aa6500'
		}
		LibConfig.ColorField {
			configKey: 'textc4bright'
			defaultColor: '#ffff65'
		}
	}
	//Blue / Bright Blue
	RowLayout {
		Kirigami.FormData.label: i18n("Color 5:")
		spacing: 0
		LibConfig.ColorField {
			configKey: 'textc5base'
			defaultColor: '#0000aa'
		}
		LibConfig.ColorField {
			configKey: 'textc5bright'
			defaultColor: '#6565ff'
		}
	}
	// Magenta / Bright Magenta
	RowLayout {
		Kirigami.FormData.label: i18n("Color 6:")
		spacing: 0
		LibConfig.ColorField {
			configKey: 'textc6base'
			defaultColor: '#aa00aa'
		}
		LibConfig.ColorField {
			configKey: 'textc6bright'
			defaultColor: '#ff65ff'
		}
	}
	// Cyan / Bright Cyan
	RowLayout {
		Kirigami.FormData.label: i18n("Color 7:")
		spacing: 0
		LibConfig.ColorField {
			configKey: 'textc7base'
			defaultColor: '#00aaaa'
		}
		LibConfig.ColorField {
			configKey: 'textc7bright'
			defaultColor: '#65ffff'
		}
	}
	//White / Bright White
	RowLayout {
		Kirigami.FormData.label: i18n("Color 8:")
		spacing: 0
		LibConfig.ColorField {
			configKey: 'textc8base'
			defaultColor: '#aaaaaa'
		}
		LibConfig.ColorField {
			configKey: 'textc8bright'
			defaultColor: '#ffffff'
		}
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
