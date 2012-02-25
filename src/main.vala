//sudo apt-get install valac freeglut3 freeglut3-dev libxi-dev libxi6 libxmu-dev libxi6 libxmu-dev libxmu6
//(sudo apt-get install libxrandr-dev libxrandr2)?
//valac --vapidir=../vapi/ --pkg gl --pkg glu --pkg glut -X -lglut main.vala const.vala io.vala
class Game {
	//public signal void exit();
	
	bool mainloop () {
		bool running = IO.initAndStart ("Titel", 640, 480);

		IO.setProjection((double) 640/480);
		// Main loop
		while (running) {
			IO.registerCallbacks ();
		}

		// Exit program
		return true;
	}

	public static int main (string[] args) {
		Game run = new Game();
		return (int) run.mainloop();;
	}
}
