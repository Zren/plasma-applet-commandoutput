import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
	id: simpleKCM
	default property alias _formChildren: formLayout.data

	Kirigami.FormLayout {
		id: formLayout
	}
}
