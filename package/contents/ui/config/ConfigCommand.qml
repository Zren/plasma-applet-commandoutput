import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.core as PlasmaCore

import "../lib"

KCM.SimpleKCM {

	property alias cfg_command: command.text
	property alias cfg_tooltipCommand: tooltipCommand.text
	property alias cfg_interval: interval.value
	property alias cfg_waitForCompletion: waitForCompletion.checked
	
	Kirigami.FormLayout {
		id: pageConfigCommand
	
		Kirigami.Separator {
			Kirigami.FormData.label: i18n("Command")
			Kirigami.FormData.isSection: true
		}
	
		TextField {
			id: command
			Layout.fillWidth: true
		}

		Kirigami.Separator {
			Kirigami.FormData.label: i18n("Tooltip Command")
			Kirigami.FormData.isSection: true
		}
		
		TextField {
			id: tooltipCommand
			Layout.fillWidth: true
		}

		Kirigami.Separator {
			Kirigami.FormData.label: i18n("Run")
			Kirigami.FormData.isSection: true
		}
		
		RowLayout {
			Label {
				text: i18n("Run every ")
			}
			SpinBox {
				id: interval
				from: 0
				stepSize: 500
				to: 2000000000 // Close enough.
				textFromValue: function(value, locale) {
					return qsTr("%1").arg(value);
				}
			}
			Label {
				text: i18n(" ms")
			}
		}

		CheckBox {
			id: waitForCompletion
			text: i18n("Wait for completion")
		}
	}
}
