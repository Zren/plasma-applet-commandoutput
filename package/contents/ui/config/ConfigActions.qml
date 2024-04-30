import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

import "../libconfig" as LibConfig

LibConfig.FormKCM {

	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Tooltip")
		label.horizontalAlignment: Text.AlignHCenter
	}
	ColumnLayout {
		Kirigami.FormData.isSection: true
		Layout.preferredWidth: 360 * Screen.devicePixelRatio
		spacing: 0
		QQC2.Label {
			text: i18n("Hover Command:")
		}
		LibConfig.TextField {
			Layout.fillWidth: true
			configKey: 'tooltipCommand'
			wrapMode: LibConfig.TextField.Wrap
		}
	}


	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Click")
		label.horizontalAlignment: Text.AlignHCenter
	}
	ColumnLayout {
		Kirigami.FormData.isSection: true
		Layout.preferredWidth: 360 * Screen.devicePixelRatio
		spacing: 0
		QQC2.Label {
			text: i18n("Run Command:")
		}
		LibConfig.TextField {
			Layout.fillWidth: true
			configKey: 'clickCommand'
			wrapMode: LibConfig.TextField.Wrap
		}
	}


	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Mouse Wheel")
		label.horizontalAlignment: Text.AlignHCenter
	}
	ColumnLayout {
		Kirigami.FormData.isSection: true
		Layout.preferredWidth: 360 * Screen.devicePixelRatio
		spacing: 0
		QQC2.Label {
			text: i18n("Scroll Up:")
		}
		LibConfig.TextField {
			Layout.fillWidth: true
			configKey: 'mousewheelUpCommand'
			wrapMode: LibConfig.TextField.Wrap
		}
	}
	ColumnLayout {
		Kirigami.FormData.isSection: true
		Layout.preferredWidth: 360 * Screen.devicePixelRatio
		spacing: 0
		QQC2.Label {
			text: i18n("Scroll Down:")
		}
		LibConfig.TextField {
			Layout.fillWidth: true
			configKey: 'mousewheelDownCommand'
			wrapMode: LibConfig.TextField.Wrap
		}
	}
}
