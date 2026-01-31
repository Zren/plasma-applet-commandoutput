// Version 3

import QtQuick
import QtQuick.Window
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
	id: simpleKCM
	default property alias _formChildren: formLayout.data

	Kirigami.FormLayout {
		id: formLayout
	}

	// https://invent.kde.org/plasma/plasma-desktop/-/blame/master/desktoppackage/contents/configuration/AppletConfiguration.qml
	// AppletConfiguration.implicitWidth: Kirigami.Units.gridUnit * 40 = 720
	// AppletConfiguration.Layout.minimumWidth: Kirigami.Units.gridUnit * 30 = 540
	// In practice, Window.width = 744px is a typical FormLayout.wideMode switchWidth
	// A rough guess is 128+24+180+10+360+24+20 = 746px
	// TabSidebar=128x, Padding=24px, Labels=180px, Spacing=10px, Controls=360px, Padding=24px, Scrollbar=20px
	// However the default is only 720px. So we'll set it to a 800px minimum to avoid wideMode=false
	property int wideModeMinWidth: 800 * Screen.devicePixelRatio
	Window.onWindowChanged: {
		if (Window.window) {
			Window.window.visibleChanged.connect(function(){
				if (Window.window && Window.window.visible && Window.window.width < wideModeMinWidth) {
					Window.window.width = wideModeMinWidth
				}
			})
		}
	}

	property var cfg_interval
	property var cfg_intervalDefault
	property var cfg_command
	property var cfg_commandDefault
	property var cfg_tooltipCommand
	property var cfg_tooltipCommandDefault
	property var cfg_waitForCompletion
	property var cfg_waitForCompletionDefault
	property var cfg_fontSize
	property var cfg_fontSizeDefault
	property var cfg_fontFamily
	property var cfg_fontFamilyDefault
	property var cfg_bold
	property var cfg_boldDefault
	property var cfg_italic
	property var cfg_italicDefault
	property var cfg_underline
	property var cfg_underlineDefault
	property var cfg_textAlign
	property var cfg_textAlignDefault
	property var cfg_vertAlign
	property var cfg_vertAlignDefault
	property var cfg_textColor
	property var cfg_textColorDefault
	property var cfg_outlineColor
	property var cfg_outlineColorDefault
	property var cfg_showOutline
	property var cfg_showOutlineDefault
	property var cfg_showBackground
	property var cfg_showBackgroundDefault
	property var cfg_clickCommand
	property var cfg_clickCommandDefault
	property var cfg_mousewheelUpCommand
	property var cfg_mousewheelUpCommandDefault
	property var cfg_mousewheelDownCommand
	property var cfg_mousewheelDownCommandDefault
	property var cfg_useFixedWidth
	property var cfg_useFixedWidthDefault
	property var cfg_fixedWidth
	property var cfg_fixedWidthDefault
	property var cfg_useFixedHeight
	property var cfg_useFixedHeightDefault
	property var cfg_fixedHeight
	property var cfg_fixedHeightDefault
	property var cfg_replaceAllNewlines
	property var cfg_replaceAllNewlinesDefault
	property var cfg_runCommandAfterAction
	property var cfg_runCommandAfterActionDefault
	property var cfg_actionCompletionTimeout
	property var cfg_actionCompletionTimeoutDefault
}
