#!/bin/sh -vx
# 将用于MonkeyTalk测试的Target所对应的安装包安装到模拟器上
echo "install app and start simulator..."
echo ./../../build/Debug-iphonesimulator/*\ copy.app
ios-sim launch ./../../build/Debug-iphonesimulator/*\ copy.app --retina --exit
echo "install app and start finished"