// Version 2

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

RowLayout {
	id: configTextFormat

	property alias boldConfigKey: configBold.configKey
	property alias italicConfigKey: configItalic.configKey
	property alias underlineConfigKey: configUnderline.configKey
	property alias alignConfigKey: configTextAlign.configKey
	property alias vertAlignConfigKey: configVertAlign.configKey

	Button {
		id: configBold
		property string configKey: ''
		visible: configKey
		icon.name: 'format-text-bold-symbolic'
		checkable: true
		checked: configKey ? plasmoid.configuration[configKey] : false
		onClicked: plasmoid.configuration[configKey] = checked
	}

	Button {
		id: configItalic
		property string configKey: ''
		visible: configKey
		icon.name: 'format-text-italic-symbolic'
		checkable: true
		checked: configKey ? plasmoid.configuration[configKey] : false
		onClicked: plasmoid.configuration[configKey] = checked
	}

	Button {
		id: configUnderline
		property string configKey: ''
		visible: configKey
		icon.name: 'format-text-underline-symbolic'
		checkable: true
		checked: configKey ? plasmoid.configuration[configKey] : false
		onClicked: plasmoid.configuration[configKey] = checked
	}

	Item {
		Layout.preferredWidth: Kirigami.Units.smallSpacing
		readonly property bool groupBeforeVisible: configBold.visible || configItalic.visible || configUnderline.visible
		readonly property bool groupAfterVisible: configTextAlign.visible
		visible: groupBeforeVisible && groupAfterVisible
	}

	ConfigTextAlign {
		id: configTextAlign
		visible: configKey
	}

	Item {
		Layout.preferredWidth: Kirigami.Units.smallSpacing
		readonly property bool groupBeforeVisible: configBold.visible || configItalic.visible || configUnderline.visible || configTextAlign.visible
		readonly property bool groupAfterVisible: configVertAlign.visible
		visible: groupBeforeVisible && groupAfterVisible
	}

	ConfigVertAlign {
		id: configVertAlign
		visible: configKey
	}
}
