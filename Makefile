## Makefile fuers Harvestmoon-Projekt:

# Variablen und Flags

# Quelldateien
SRCS          = main.vala scene.vala values.vala io.vala
# ausfuehrbares Ziel
TARGET        = hmp
# Pakete
PACKAGES      = gl glu glut
# C-Compileranweisungen
CFLAGS        = -lglut

# Quellverzeichnis
SRC_DIR       = src/
# Vapiverzeichnis
VAPI_DIR      = vapi/
# Verzeichnis fuer erzeuge Binaries
BIN_DIR       = bin/
# Verzeichnis fuer Doku
DOC_DIR       = doc/

# Bazaar-Repository
BZR_REPO      = bzr+ssh://bazaar.launchpad.net/%2Bbranch/hmproject/0.1/

# Vala-Compiler
VC            = valac
# Bazaar
BZR           = bzr

# Quelldateien mit Pfad
SRC_FILES     = $(SRCS:%.vala=$(SRC_DIR)%.vala)
# Zieldatei mit Pfad
TARGET_FILE   = $(TARGET:%=$(BIN_DIR)%)
# Paketflags
PKG_FLAGS     = $(PACKAGES:%=--pkg %)

# Targets

.PHONY: all run dirs pull commit push help clean

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
	@$(BZR) pull

## * make commit: Committet die Aenderungen, falls kompiliert werden kann
commit:
	@echo "Testing compilation..." && $(MAKE) && echo "Committing changes..." && $(BZR) commit

## * make push: Committet und Pusht dann ins Launchpad-Repo
push: commit
	@echo "Pushing to Repository..."
	@$(BZR) push $(BZR_REPO)

$(TARGET_FILE): $(SRC_FILES)
	@echo "Compiling Binary..."
	@$(VC) -o $(TARGET_FILE) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) -X $(CFLAGS) $(SRC_FILES)

## * make clean: Raeumt die erzeugten Dateien auf
clean:
	@echo "Cleaning up..."
	@rm -r $(BIN_DIR)

## * make help: Diese Hilfe anzeigen
help:
	@grep '^##' 'Makefile' | sed -e 's/## //g'
