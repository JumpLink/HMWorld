## Makefile fuers Harvestmoon-Projekt:

# Variablen und Flags
# Version des Pakets
VERSION       = 0.1

# Name des Pakets
PKG_NAME      = HMP-ALL

# Quelldateien
SRCS          = main.vala scene.vala values.vala io.vala matrix.vala vector.vala layer.vala entity.vala player.vala world.vala texture.vala tileset.vala map.vala mapmanager.vala xml.vala tile.vala subtile.vala regulartile.vala splittile.vala tilesetmanager.vala inventory.vala tool.vala emptyHands.vala spriteset.vala sprite.vala tilesetreference.vala plant.vala hoe.vala axe.vala pickaxe.vala singletool.vala wateringcan.vala sprinkler.vala circletool.vala file.vala

# ausfuehrbares Ziel
TARGET        = hmp
# Pakete
PACKAGES      = gl glu glut sdl sdl-image cairo gdk-x11-2.0 libxml-2.0 gee-1.0 gio-2.0
# C-Compileranweisungen
CFLAGS        = -lglut -lSDL_image

# Quellverzeichnis
SRC_DIR       = src/
# Vapiverzeichnis
VAPI_DIR      = vapi/
# Verzeichnis fuer erzeuge Binaries
BIN_DIR       = bin/
# Verzeichnis fuer Doku
DOC_DIR       = doc/
# Öffentliches Verzeichnis für die Dokumentationsveröffentlichung
PUB_DIR       = ~/Dropbox/Public/hmp/

# Bazaar-Repository
BZR_REPO      = bzr+ssh://bazaar.launchpad.net/%2Bbranch/hmproject/0.1/

# Vala-Compiler
VC            = valac

# Valadoc
VD            = valadoc
# Valadoc Driver
VDD           = 0.15.3

# Bazaar
BZR           = bzr

# Quelldateien mit Pfad
SRC_FILES     = $(SRCS:%.vala=$(SRC_DIR)%.vala)
# Zieldatei mit Pfad
TARGET_FILE   = $(TARGET:%=$(BIN_DIR)%)
# Paketflags
PKG_FLAGS     = $(PACKAGES:%=--pkg %)
# C-Flags
CC_FLAGS      = $(CFLAGS:%=-X %)
# Alle Kombilerobtionen
COMP		  = $(-o $(TARGET_FILE) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES))


# Targets

.PHONY: all run dirs pull commit commit-* push push-* help clean

## * make (all): Programm compilieren
all: dirs $(TARGET_FILE)

## * make run: Programm compilieren und ausfuehren
run: all
	@echo "Running $(TARGET_FILE)..."
	@$(TARGET_FILE)

## * make dirs: Noetige Verzeichnisse erstellen
dirs:
	@echo "Creating output directory..."
	@mkdir -p $(BIN_DIR)

## * make pull: Aktuelle Version ziehen
pull:
	@echo "Pulling from Repository..."
	@$(BZR) pull $(BZR_REPO)

## * make commit: Committet die Aenderungen, falls kompiliert werden kann
commit:
	@echo "Testing compilation..." && $(MAKE) && echo "Committing changes..." && $(BZR) commit
	
## * make commit: Committet die Aenderungen, falls kompiliert werden kann
commit-%:
	@echo "Testing compilation..." && $(MAKE) && echo "Committing changes..." && $(BZR) commit -m "$*"

## * make push: Committet und Pusht dann ins Launchpad-Repo
push: commit
	@echo "Pushing to Repository..."
	@$(BZR) push $(BZR_REPO)
	
## * make push: Committet und Pusht dann ins Launchpad-Repo
push-%: commit-%
	@echo "Pushing to Repository..."
	@$(BZR) push $(BZR_REPO)

$(TARGET_FILE): $(SRC_FILES)
	@echo "Compiling Binary..."
	@$(VC) -o $(TARGET_FILE) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES)
	
c: dirs $(SRC_FILES)
	@echo "Compiling Binary..."
	@$(VC) -o $(TARGET_FILE) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES) -C

doc: $(SRC_FILES)
	@echo "Generating Documentation..."
	@$(VD) --driver $(VDD) -o $(DOC_DIR) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES) --package-name $(PKG_NAME) --package-version=$(VERSION)
	@gnome-open ./doc/index.html

doc-internal: $(SRC_FILES)
	@echo "Generating Documentation..."
	@$(VD) --driver $(VDD) -o $(DOC_DIR) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES) --package-name $(PKG_NAME) --package-version=$(VERSION) --private --internal
	@gnome-open ./doc/index.html

doc-publish: $(SRC_FILES)
	@mkdir -p $(PUB_DIR)
	@cp $(DOC_DIR) $(PUB_DIR) -r
	@gnome-open http://dl.dropbox.com/u/55722973/hmp/doc/index.html

## * make clean: Raeumt die erzeugten Dateien auf
clean:
	@echo "Cleaning up..."
	@rm -rf $(BIN_DIR)
	@rm -rf $(DOC_DIR)
	@rm -rf $(SRC_DIR)*.c

## * make help: Diese Hilfe anzeigen
help:
	@grep '^##' 'Makefile' | sed -e 's/## //g'
