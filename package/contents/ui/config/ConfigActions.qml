import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

import "../libconfig" as LibConfig

LibConfig.FormKCM {

	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Tooltip")
	}
	LibConfig.TextField {
		Kirigami.FormData.label: i18n("Hover Command:")
		configKey: 'tooltipCommand'
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
