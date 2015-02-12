
STM32_DEBUG=1
STM32_BIN=/home/jaypei/Project2.bin

ifndef STM32_BIN
	STM32_BIN=bin.bin
endif

ifndef STM32_CHIP
	STM32_CHIP=STM32F103C8
endif

ifndef STM32_JLINKEXE
	STM32_JLINKEXE=JLinkExe
endif

ifeq ($(STM32_CHIP),STM32F103C8)
	STM32_CHIP_DEVICE=STM32F103C8
	STM32_CHIP_RSETTYPE=0
	STM32_CHIP_SPEED=2000
	STM32_CHIP_SI=1
	STM32_CHIP_START_ADDR=0x8000000
	STM32_CHIP_START_ADDR_FC=,$(STM32_CHIP_START_ADDR)
endif

slt_output = $(info $(1))
slt_debug =
ifeq ($(STM32_DEBUG),1)
	slt_debug = $(call slt_output,DEBUG - $(1))
endif
slt_info = $(call slt_output,INFO - $(1))
slt_err = $(call slt_output,ERR - $(1))

upload: TMP_FILE:=$(call shell,mktemp)
upload:
	$(call file,>>$(TMP_FILE),device $(STM32_CHIP_DEVICE))
	$(call file,>>$(TMP_FILE),RSetType $(STM32_CHIP_RSETTYPE))
ifdef STM32_CHIP_SI
	$(call file,>>$(TMP_FILE),si 1)
endif
	$(call file,>>$(TMP_FILE),speed $(STM32_CHIP_SPEED))
	$(call file,>>$(TMP_FILE),r)
	$(call file,>>$(TMP_FILE),loadbin $(STM32_BIN)$(STM32_CHIP_START_ADDR_FC))
	$(call file,>>$(TMP_FILE),qc)
	-$(STM32_JLINKEXE) $(TMP_FILE)

