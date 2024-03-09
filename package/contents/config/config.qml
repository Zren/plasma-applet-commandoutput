import QtQuick

import org.kde.plasma.configuration

ConfigModel {
	ConfigCategory {
		name: i18n("Command")
		icon: "configure"
		source: "config/ConfigCommand.qml"
	}

	ConfigCategory {
		name: i18n("Appearance")
		icon: "preferences-desktop-color"
		source: "config/ConfigAppearance.qml"
	}

	ConfigCategory {
		name: i18n("Actions")
		icon: "preferences-desktop-mouse"
		source: "config/ConfigActions.qml"
	}
}
