using GL;
using SDL;

//TODO untested
class Image {
	Gdk.Pixbuf pixbuf;
	public load_from_file (string filename) {
		pixbuf = new Gdk.Pixbuf.from_file ("data/"+filename);
		
		if (pixbuf != null)
		{
			glGenTextures(1, out texID);
			glBindTexture(GL_TEXTURE_2D, texID[0]);

			GLvoid[] v = new GLvoid[tex.w*tex.h*4];
			v.insert_vals (0, tex.pixels, tex.w * tex.h * tex.format.BytesPerPixel);

			glTexImage2D(GL_TEXTURE_2D, 0, 3, tex.w, tex.h, 0, GL_BGR, GL_UNSIGNED_BYTE, v);

			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		}
	}
}

GLvoid *
