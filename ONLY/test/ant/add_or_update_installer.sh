#!/bin/sh -vx
#获取参数
setup(){
    #获取bundle identifier, 指向info.plist文件所在路径，如果目录下存在多个Info.plist文件，需指定文件名字
	bundle_identifier="$(/usr/libexec/PlistBuddy -c "print :CFBundleIdentifier" ../../*/LingZhi-Info.plist)"
    #获取bundle display name
	bundle_display_name="$(/usr/libexec/PlistBuddy -c "print :CFBundleDisplayName" ../../*/LingZhi-Info.plist)"
	#获取app版本号
	version="$(/usr/libexec/PlistBuddy -c "print :CFBundleVersion" ../../*/LingZhi-Info.plist)"
	#查找icon.png文件获取路径, ${WORKSPACE}表示的是当前.xcodeproj文件所在路径，各项目根据实际目录结构修改
	photo=$(find ${WORKSPACE}/icon -name Icon@2x.png)
	echo photo path $photo
	#取值范围 iPhone iPad iPhone_iPad Android
	platform=iPhone
	#拼接在Installer显示所需要的名字
	bundle_display_name=${bundle_display_name}"_"${platform}
	#应用描述信息
	desc="凌志时装"
	#查找ipa文件，默认即可
	package=$(find ${WORKSPACE}/build/Release-iphoneos -name *.ipa)
	echo package path $package
	#客户描述信息
	client=凌志时装
	#客户简介
	client_desc=凌志
	#取值范围 0:开发中 1:已上线 2:提交中 3:未上线
	development_status=0
	echo bundle_identifier:$bundle_identifier
	echo bundle_display_name:$bundle_display_name
	echo version:$version
	echo photo:$photo
	echo platform:$platform
	echo package:$package
	echo development_status:$development_status
	echo client:$client
}
#提交app信息到Installer
#请求参数:
# application_name			应用名称
# application_version		版本号
# application_mark			bundle identifier
# application_pratform		平台
# application_condition		开发状态
# client_name				客户名称
# application_introduce		应用介绍
# client_introduce			客户介绍
# application_photo         应用icon, Intaller显示用
# client_photo				客户log
# application_package		安装包路径
# "m=client" -F "c=api" -F "a=api_client"   接口控制参数
add_or_update_installer(){
	echo add_or_update_installer...
	curl -v -S -k        \
	-F "application_name=${bundle_display_name}"  \
	-F "application_version=${version}"   \
	-F "application_mark=${bundle_identifier}"   \
	-F "application_pratform=${platform}"   \
	-F "application_condition=${development_status}"   \
	-F "client_name=${client}"   \
	-F "application_introduce=${desc}"   \
	-F "client_introduce=${client_desc}"   \
	-F "application_photo=@${photo}"   \
	-F "client_photo=@${photo}"   \
	-F "application_package=@${package}"   \
	-F "m=client" -F "c=api" -F "a=api_client"   \
	https://172.16.10.198/iss_apps/public_admin/index.php > /Library/WebServer/Documents/installer/log/update_installer.log
    #http://172.16.10.198/iss_apps/public_admin/index.php > /Library/WebServer/Documents/installer/update_installer.php
}
setup
add_or_update_installer

