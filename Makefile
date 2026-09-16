TFM      := netstandard2.1
CONFIG   := Debug
DLL      := VGLootTint.dll

BUILDDIR := VGLootTint/bin/$(CONFIG)/$(TFM)
BUILDDLL := $(BUILDDIR)/$(DLL)

# WSL path to the game install — adjust if Steam lives elsewhere
GAME_DIR := /mnt/c/Program Files (x86)/Steam/steamapps/common/Vanguard Galaxy
PLUGIN_DIR := $(GAME_DIR)/BepInEx/plugins

# Resolve dotnet — prefer explicit local SDK, fall back to PATH
DOTNET   ?= $(shell command -v dotnet 2>/dev/null || echo /tmp/dnsdk/dotnet/dotnet)

VGAPI_DLL ?= ../vanguard-galaxy-api/VGModAPI.Abstractions/bin/Debug/netstandard2.1/VGModAPI.Abstractions.dll

.PHONY: all build clean deploy check-bepinex

all: build

check-bepinex:
	@test -d "$(GAME_DIR)/BepInEx/plugins" || { \
		echo "BepInEx plugins dir not found at $(GAME_DIR)/BepInEx/plugins." ; \
		echo "Install BepInEx 5.x into the game folder and launch the game once." ; \
		exit 1 ; \
	}

build:
	@test -s "$(VGAPI_DLL)" || { echo 'Set VGAPI_DLL to the pickup-presentation API build.'; exit 1; }
	DOTNET_ROOT=$(dir $(DOTNET)) $(DOTNET) build VGLootTint/VGLootTint.csproj -c $(CONFIG) -p:VGAPI_DLL="$(abspath $(VGAPI_DLL))"

deploy: build check-bepinex
	@mkdir -p "$(PLUGIN_DIR)"
	cp "$(BUILDDLL)" "$(PLUGIN_DIR)/"
	@if [ -f "$(BUILDDIR)/VGLootTint.pdb" ]; then cp "$(BUILDDIR)/VGLootTint.pdb" "$(PLUGIN_DIR)/"; fi
	@echo "Deployed $(DLL) to $(PLUGIN_DIR)"

clean:
	$(DOTNET) clean VGLootTint/VGLootTint.csproj
	rm -rf VGLootTint/bin VGLootTint/obj
