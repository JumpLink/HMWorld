## Makefile fuers Harvestmoon-Projekt:

# Variablen und Flags
# Version des Pakets
VERSION       = 0.1

# Name des Pakets
PKG_NAME      = HMP-ALL

# ausfuehrbares Ziel
TARGET        = hmp
# Pakete
PACKAGES      = gdk-pixbuf-2.0 gee-1.0 gio-2.0 posix webkit-1.0
# C-Compileranweisungen
CFLAGS        = 

# Quellverzeichnis
SRC_DIR       = src/
# Test-Quellverzeichnis
TSRC_DIR      = test/
# Vapiverzeichnis
VAPI_DIR      = vapi/
# Verzeichnis fuer erzeuge Binaries
BIN_DIR       = bin/
# Verzeichnis fuer Doku
DOC_DIR       = doc/
# Verzeichnis fuer Temporaere Dateien
TMP_DIR		  = tmp/

# Vala-Compiler
VC            = valac

# Valadoc
VD            = valadoc

# Quelldateien mit Pfad
SRC_FILES     = $(wildcard src/*.vala) $(wildcard libsxml/src/*.vala) $(wildcard librpg/src/*.vala) $(wildcard librpg/src/Gdk/*.vala) $(wildcard librpg/src/XML/*.vala) $(wildcard librpggl/src/*.vala)
# Zieldatei mit Pfad
TARGET_FILE   = $(TARGET:%=$(BIN_DIR)%)
# Paketflags
PKG_FLAGS     = $(PACKAGES:%=--pkg %)
# C-Flags
CC_FLAGS      = $(CFLAGS:%=-X %)
# Alle Kombilerobtionen
COMP		  = $(-o $(TARGET_FILE) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES))


# Targets

.PHONY: all node run dirs pull commit commit-* push push-* help clean test

## * make (all): Programm compilieren
all: clean dirs $(TARGET_FILE) node

## * make dirs: Noetige Verzeichnisse erstellen
dirs:
	@echo "Creating output directory..."
	@mkdir -p $(BIN_DIR)

$(TARGET_FILE): $(SRC_FILES)
	@echo "Compiling Binary..."
	@$(VC) -o $(TARGET_FILE) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES)

node:
	@echo "Erzeuge Node.js JavaScript Code"
	@tsc ./node/app.ts --module Node
	
c: dirs $(SRC_FILES)
	@echo "Compiling Binary..."
	@$(VC) -o $(TARGET_FILE) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES) -C
## * make doc: Dokumentation generieren
doc: $(SRC_FILES)
	@echo "Generating Documentation..."
	@$(VD) --driver $(VDD) -o $(DOC_DIR) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES) --package-name $(PKG_NAME) --package-version=$(VERSION)
	@gnome-open ./doc/index.html

## * make doc-internal: Dokumentation generieren, inkl. nicht oeffentlicher Bereiche
doc-internal: $(SRC_FILES)
	@echo "Generating internal Documentation"
	@$(VD) --driver $(VDD) -o $(DOC_DIR) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES) --package-name $(PKG_NAME) --package-version=$(VERSION) --private --internal --importdir=$(TST_DOC_DIR) #fix importdir
	@gnome-open ./doc/index.html

## * make clean: Raeumt die erzeugten Dateien auf
clean:
	@echo "Cleaning up..."
	@rm -rf $(BIN_DIR)
	@rm -rf $(DOC_DIR)
	@rm -rf $(SRC_DIR)*.c
	@rm -rf $(SRC_DIR)/*/*.c
	@rm -rf libsxml/src/*.c
	@rm -rf libsxml/src/*/*.c
	@rm -rf librpg/src/*.c
	@rm -rf librpg/src/*/*.c
	@rm -rf librpggl/src/*.c
	@rm -rf librpggl/src/*/*.c
	@rm -rf $(TMP_DIR)
	@rm -rf $(TST_DOC_DIR)
	@rm -rf node/*.js

## * make help: Diese Hilfe anzeigen
help:
	@grep '^##' 'Makefile' | sed -e 's/## //g'

## * Valadate aus dem Repo installieren, unfollstaendig, fehlerhaft.
install-valadate:
	@sudo apt-get install gobject-introspection -y
	@rm tmp -rf
	@mkdir tmp
	@git clone git://gitorious.org/~serbanjora/valadate/serbanjora-valadate.git ./tmp/
	@cd ./tmp && ./waf configure && ./waf install
## * Fuert das Testprogramm aus.
test: dirs
	@mkdir -p $(TMP_DIR)
	@echo "Compiling Test Binary..."
	@$(VC) -o $(TARGET_FILE) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(TSRC_FILES)
	@echo "Running $(TARGET_FILE)..."
	@$(TARGET_FILE)
## * Fuert das Testprogramm aus.
debug: dirs $(SRC_FILES)
	@echo "Debuging.."
	@$(VC) -g --save-temps -o $(TARGET_FILE) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES)
	@nemiver $(TARGET_FILE)
	#gdb $(TARGET_FILE)