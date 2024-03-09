import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

import "../libconfig" as LibConfig

LibConfig.FormKCM {

	property alias cfg_command: command.text
	property alias cfg_interval: interval.value
	property alias cfg_waitForCompletion: waitForCompletion.checked

	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Command")
	}
	LibConfig.TextField {
		id: command
		Kirigami.FormData.label: i18n("Command")
		// configKey: 'command'
		Layout.fillWidth: true
	}
	LibConfig.SpinBox {
		id: interval
		Kirigami.FormData.label: i18n("Run every ")
		configKey: 'interval'
		suffix: "ms"
		stepSize: 500
	}
	LibConfig.CheckBox {
		id: waitForCompletion
		Kirigami.FormData.label: i18n("Wait for completion")
		// configKey: 'waitForCompletion'
		text: i18n("Enabled")
	}

}
