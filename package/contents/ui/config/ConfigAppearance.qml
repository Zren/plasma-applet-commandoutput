import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.core as PlasmaCore

import "../lib"

KCM.SimpleKCM {

	/*
	property string cfg_fontFamily
	property int cfg_fontSize
	property bool cfg_bold
	property bool cfg_italic
	property bool cfg_underline
	property bool cfg_textAlign
	property bool cfg_vertAlign
	property Color cfg_textColor
	property bool cfg_showOutline
	property Color cfg_outlineColor
	property bool cfg_showBackground
	property bool cfg_useFixedHeight
	property int cfg_fixedHeight
	property bool cfg_useFixedWidth
	property int cfg_fixedWidth
	property bool cfg_replaceAllNewlines
	*/
	
	Kirigami.FormLayout {
		id: page

		Kirigami.Separator {
			Kirigami.FormData.label: "Font"
			Kirigami.FormData.isSection: true
		}
		
		ConfigFontFamily {
			configKey: 'fontFamily'
			before: i18n("Font Family:")
		}
		ConfigSpinBox {
			configKey: 'fontSize'
			before: i18n("Font Size:")
			suffix: i18n("pt")
			decimals: 0
		}
		ConfigTextFormat {
			boldConfigKey: 'bold'
			italicConfigKey: 'italic'
			underlineConfigKey: 'underline'
			alignConfigKey: 'textAlign'
			vertAlignConfigKey: 'vertAlign'
		}
		
		Kirigami.Separator {
			Kirigami.FormData.label: "Colors"
			Kirigami.FormData.isSection: true
		}
		
		ConfigColor {
			configKey: 'textColor'
			defaultColor: Kirigami.Theme.textColor
			label: i18n("Text:")
		}
		RowLayout {
			spacing: 0
			ConfigCheckBox {
				configKey: 'showOutline'
				text: i18n("Outline:")
			}
			ConfigColor {
				configKey: 'outlineColor'
				defaultColor: Kirigami.Theme.backgroundColor
				label: ""
			}
		}

		Kirigami.Separator {
			Kirigami.FormData.label: ""
			Kirigami.FormData.isSection: true
		}

		ConfigCheckBox {
			configKey: 'showBackground'
			text: i18n("Desktop Widget: Show background")
		}
		RowLayout {
			spacing: 0
			visible: plasmoid.formFactor == PlasmaCore.Types.Horizontal
			ConfigCheckBox {
				configKey: 'useFixedWidth'
				text: i18n("Fixed Width:")
			}
			ConfigSpinBox {
				configKey: 'fixedWidth'
				suffix: i18n("px")
			}
		}
		RowLayout {
			spacing: 0
			visible: plasmoid.formFactor == PlasmaCore.Types.Vertical
			ConfigCheckBox {
				configKey: 'useFixedHeight'
				text: i18n("Fixed Height:")
			}
			ConfigSpinBox {
				configKey: 'fixedHeight'
				suffix: i18n("px")
			}
		}
		ConfigCheckBox {
			configKey: 'replaceAllNewlines'
			text: i18n("Replace all newlines with spaces")
		}
	}
}
