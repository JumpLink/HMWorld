using GL;
using SDL;

//TODO untested and no class
class Image {
	int count = 1;
	uint[] texture = new uint[1];
	
	public void addTextureFromSdlSurface(SDL.Surface surface) {
		count++;
		texture.resize(count);
	 	/*texture[count-1] = this.surfaceToTexture(surface);*/
	 	if (texture[count] == 0) {
	 		print("Textur konnte nicht hinzugefuegt werden\n");
	 	}
	}
	
	private GL.GLuint surfaceToTexture (SDL.Surface surface) {
		GL.GLuint[] tex = new GL.GLuint[1];
		GLvoid[] pixel;
		GLenum texture_format;
		// surface = SDL_LoadBMP("image.bmp")
		if ( surface != null ) { 
		 
			// Check that the image's width is a power of 2
			if ( (surface.w & (surface.w - 1)) != 0 ) {
				print("warning: image.bmp's width is not a power of 2\n");
			}
		 
			// Also check if the height is a power of 2
			if ( (surface.h & (surface.h - 1)) != 0 ) {
				print("warning: image.bmp's height is not a power of 2\n");
			}
		 
				// get the number of channels in the SDL surface
				switch (surface.format.BytesPerPixel) {
					case 4:	// with alpha channel
						    if (surface.format.Rmask == 0x000000ff)
						            texture_format = GL_RGBA;
						    else
						            texture_format = GL_BGRA;
					break;
					case 3:     // no alpha channel
						    if (surface.format.Rmask == 0x000000ff)
						            texture_format = GL_RGB;
						    else
						            texture_format = GL_BGR;
					break;
					default:
						texture_format = 0;
					    print("warning: the image is not truecolor..  this will probably break\n");
					    // this error should not go unhandled
					break;
				}
			// Have OpenGL generate a texture object handle for us
			// ERROR:valaccodearraymodule.c:1182:vala_ccode_array_module_real_get_array_length_cvalue: assertion failed: (_tmp48_)
			//glGenTextures( 1, out tex );
		 
			// Bind the texture object
			glBindTexture( GL_TEXTURE_2D, tex[0] );
		 
			// Set the texture's stretching properties
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
			
			//pixelsToArray(surface.format.BytesPerPixel, surface.w, surface.h, surface.pixels, out pixel);
		 
			// Edit the texture object's image data using the information SDL_Surface gives us
			/* Cannot convert from `void*' to `GL.GLvoid[]?' */
			//glTexImage2D( GL_TEXTURE_2D, 0, surface.format.BytesPerPixel, surface.w, surface.h, 0, texture_format, GL_UNSIGNED_BYTE, pixel );
			return tex[0];
		} 
		else {
			print("SDL could not load the image: %s\n", SDL.get_error() );
			return 0;
		}
	}
	/* Variable oder Feld »_tmp15_« als »void« deklariert
	private void pixelsToArray (uint bpp, uint w, uint h, void* pixel, out GLvoid[] pix) {
		
		pix = new GLvoid[w*h*bpp];
		int i;
		uchar* x = (uchar*) pixel;
		for (i=0;i < w*h*bpp;i++) {
			
			pix[i] = (GL.GLvoid) pixel[i];
		}

	}*/
}
