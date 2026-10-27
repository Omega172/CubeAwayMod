ARCHS = arm64
TARGET = iphone:clang:16.5:15.0
THEOS ?= $(HOME)/theos
include $(THEOS)/makefiles/common.mk
LIBRARY_NAME = ToolchainCheck
ToolchainCheck_FILES = ToolchainCheck.m
ToolchainCheck_FRAMEWORKS = Foundation
include $(THEOS_MAKE_PATH)/library.mk
