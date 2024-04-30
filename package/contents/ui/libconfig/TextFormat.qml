// Version 6

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

import "." as LibConfig

Flow {
	id: configTextFormat

	spacing: Kirigami.Units.smallSpacing * 2
	Layout.fillWidth: true

	property alias boldConfigKey: configBold.configKey
	property alias italicConfigKey: configItalic.configKey
	property alias underlineConfigKey: configUnderline.configKey
	property alias alignConfigKey: configTextAlign.configKey
	property alias vertAlignConfigKey: configVertAlign.configKey

	RowLayout {
		QQC2.Button {
			id: configBold
			property string configKey: ''
			visible: configKey
			icon.name: 'format-text-bold-symbolic'
			checkable: true
			checked: configKey ? plasmoid.configuration[configKey] : false
			onClicked: plasmoid.configuration[configKey] = checked
		}

		QQC2.Button {
			id: configItalic
			property string configKey: ''
			visible: configKey
			icon.name: 'format-text-italic-symbolic'
			checkable: true
			checked: configKey ? plasmoid.configuration[configKey] : false
			onClicked: plasmoid.configuration[configKey] = checked
		}

		QQC2.Button {
			id: configUnderline
			property string configKey: ''
			visible: configKey
			icon.name: 'format-text-underline-symbolic'
			checkable: true
			checked: configKey ? plasmoid.configuration[configKey] : false
			onClicked: plasmoid.configuration[configKey] = checked
		}
	}

	LibConfig.TextAlign {
		id: configTextAlign
		visible: configKey
	}

	LibConfig.VertAlign {
		id: configVertAlign
		visible: configKey
	}
}
