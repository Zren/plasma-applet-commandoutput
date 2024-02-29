import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.core as PlasmaCore

import "../lib"

KCM.SimpleKCM {
	
	property alias cfg_clickCommand: clickCommand.text
	property alias cfg_mousewheelUpCommand: mousewheelUpCommand.text
	property alias cfg_mousewheelDownCommand: mousewheelDownCommand.text
	
	Kirigami.FormLayout {
		id: page

		Kirigami.Separator {
			Kirigami.FormData.label: "Mouse Click"
			Kirigami.FormData.isSection: true
		}
		
		RowLayout {
			Label {
				text: i18n("Command:")
			}
			TextField {
				id: clickCommand
				Layout.fillWidth: true
			}
		}
		
		Kirigami.Separator {
			Kirigami.FormData.label: "Mouse Wheel"
			Kirigami.FormData.isSection: true
		}
		
		RowLayout {
			Label {
				text: i18n("Scroll Up:")
			}
			TextField {
				id: mousewheelUpCommand
				Layout.fillWidth: true
			}
		}
		
		RowLayout {
			Label {
				text: i18n("Scroll Down:")
			}
			TextField {
				id: mousewheelDownCommand
				Layout.fillWidth: true
			}
		}
	}
}
