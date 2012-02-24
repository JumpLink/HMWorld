#ifndef __TYPES_H__
#define __TYPES_H__
/**
 * @file
 * Typenschnittstelle.
 * Das Modul kapselt die Typdefinitionen des Programms.
 *
 * Uebung 02: Splinekurvenspiel
 *
 * @author minf8908, minf7481
 */

/* ---- System-Header einbinden ---- */
#ifdef WIN32
#include <windows.h>
#endif
#ifdef MACOSX
#include <OpenGL/gl.h>
#else
#include <GL/gl.h>
#endif

/* ---- Typedeklarationen ---- */

/** Ganzzahlige Punkte in 2d */
typedef GLint Point2i[2];
/** Ganzzahlige Ausmasse in 2d */
typedef GLint Dimensions2i[2];

/** RGB-Farbwert */
typedef GLfloat Color3f[3];
/** RGBA-Farbwert */
typedef GLfloat Color4f[4];
/** Benamsung der Farbindizes */
typedef enum { cR=0, cG=1, cB=2, cA=3 } ColorIndex;

/** Vektor im 2d-Raum */
typedef GLdouble Vector2d[2];

/** 4d-Vektor */
typedef GLdouble Vector4d[4];

/** 4d-Matrix */
typedef GLdouble Matrix4d[4][4];

/** Mauseventarten */
typedef enum { mouseButton, mouseMotion } MouseEventType;

/** Datentyp fuer Vertizes der Kurve und ihrer Normalen */
typedef GLdouble Vertex[2];
/** Benamsung der Vertexindizes */
typedef enum { cX=0, cY=1 } VertexIndex;

/** Interpolationstypen */
typedef enum { intSpline=0, intBezier=1 } InterpolationType;

/** Datentyp fuer die Splinekurve */
typedef struct {
	/** Interpolationstyp (Spline/Bezier). */
	InterpolationType type;
	/** Flag, ob Konvexe Huelle gezeichnet werden soll. */
	GLboolean convex;
	/** Detailstufe der Splinekurve */
	GLuint detail;

	/** Stuetzpunkte */
	Vector2d * basePoints;
	/** Anzahl der Stuetzpunkte */
	GLuint baseCount;
	/** Errechnete Splinefunktionen in x */
	Vector4d * qx;
	/** Errechnete Splinefunktionen in y */
	Vector4d * qy;

	/** Vertizes der Splinekurve und ggf. der konvexen Huelle. */
	Vertex * vertices;
	/** Anzahl der Vertizes */
	GLuint vertexCount;
	/** Indexarray der Splinekurve */
	GLuint * splineIndices;
	/** Anzahl der Splineindizes */
	GLuint splineIndexCount;
	/** Indexarray der konvexen Huelle */
	GLuint * hullIndices;
	/** Anzahl der Huellindizes */
	GLuint hullIndexCount;
	/** Indexarray der Normalen */
	GLuint * normalIndices;
	/** Anzahl der Normalenindizes */
	GLuint normalIndexCount;
} Spline;

/** Aufzaehlung von Entity-Typen (Nichts, Flugzeug, Stern, Wolke) */
typedef enum { entNull=0, entPlane=1, entStar=2, entCloud=3 } EntityType;

/** Datentyp fuer Entities */
typedef struct {
	/* Typ des Entities */
	EntityType type;
	/* Zentrum des Entities */
	Vector2d center;
	/* Radius des Entities */
	GLdouble radius;
	/* Drehung des Entities (Grad) */
	GLdouble arc;
} Entity;

/** Datentyp fuer Flugzeugspez. Daten */
typedef struct {
	/* Flag, ob schon geflogen wird. */
	GLboolean flying;
	/* Kurvenstueck, welches durchflogen wird */
	GLuint qIndex;
	/* t [0..1] innerhalb des Kurvenstuecks */
	GLdouble t;
} Plane;

/** Datentyp fuer Levels */
typedef struct {
	/** Daten der Splinekurve */
	Spline spline;
	/** Daten des Flugzeugs */
	Plane plane;
	/** Array von Objekten im Level */
	Entity * entities;
	/** Anzahl dieser Objekte */
	GLuint entityCount;
	/** Gewonnen-Flag */
	GLboolean won;
	/** Verloren-Flag */
	GLboolean lost;
	/** Levelnummer */
	GLuint number;
} Level;

/** Datentyp mit allen noetigen Szenendaten */
typedef struct {
	/** Daten des aktuellen Levels */
	Level level;
	/** ID des gepickten Knotens (0, wenn nichts gepickt) */
	GLuint picked;
	/** Normalenzeichnen-Flag */
	GLboolean normals;
	/** Pausiert-Flag */
	GLboolean paused;
	/** Hilfefenster-Flag */
	GLboolean help;
} GameStatus;

#endif
