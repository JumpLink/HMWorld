using GL;
using GLU;
using GLUT;

namespace Scene {
	/**
	 * Initialisierung der Szene (inbesondere der OpenGL-Statusmaschine).
	 * Setzt Hintergrund, Zeichenfarbe und sonstige Attribute fuer die
	 * OpenGL-Statusmaschine.
	 * @return Rueckgabewert: im Fehlerfall 0, sonst 1.
	 */
	static bool init ()
	{
		/* Setzen der Farbattribute */
		/* Hintergrundfarbe */
		glClearColor (colBG[ColorIndex.R], colBG[ColorIndex.G], colBG[ColorIndex.B], colBG[ColorIndex.A]);
		/* Zeichenfarbe */
		glColor3f (1.0f, 1.0f, 1.0f);

		/* Vertexarrays erlauben */
		glEnableClientState (GL_VERTEX_ARRAY);

		/* Polygonrueckseiten nicht anzeigen */
		/*glCullFace (GL_BACK);
		glEnable (GL_CULL_FACE);*/

		/* Alles in Ordnung? */
		return (glGetError() == GL_NO_ERROR);
	}
}
