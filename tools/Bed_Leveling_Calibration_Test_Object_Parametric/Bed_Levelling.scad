/**
 * Print designed to check that you bed is level
 *
 * print four small squares in each corner to ensure even print quality and good adhesion.
 */

// Define your printers printable area
// If you are using Sprinter firmware then these come directly from configuration.h

X_MAX_LENGTH = 200;
Y_MAX_LENGTH = 186;

THICKNESS = 0.3; //Square / outline thickness
SIZE = 20; //Square width / height
GAP = 0.5; //Width of border between square and parameter
OUTLINE_WIDTH = 1; //Width of parameter around square
OFFSET = 5; //Offset from limits in each axis

translate([OFFSET, OFFSET, 0]) square(); //Top Left
translate([(X_MAX_LENGTH / 2) - (SIZE / 2), OFFSET, 0]) square(); //Top Middle
translate([X_MAX_LENGTH - OFFSET - SIZE, OFFSET, 0]) square(); //Top Right

translate([OFFSET, (Y_MAX_LENGTH / 2) - (SIZE / 2), 0]) square(); //Middle Left
translate([(X_MAX_LENGTH / 2) - (SIZE / 2), (Y_MAX_LENGTH / 2) - (SIZE / 2), 0]) square(); //Middle Middle
translate([X_MAX_LENGTH - OFFSET - SIZE, (Y_MAX_LENGTH / 2) - (SIZE / 2), 0]) square(); //Middle Right

translate([OFFSET, Y_MAX_LENGTH - OFFSET - SIZE, 0]) square(); //Bottom Left
translate([(X_MAX_LENGTH / 2) - (SIZE / 2), Y_MAX_LENGTH - OFFSET - SIZE, 0]) square(); //Bottom Middle
translate([X_MAX_LENGTH - OFFSET - SIZE, Y_MAX_LENGTH - OFFSET - SIZE, 0]) square(); //Bottom Right

module square() {
	//Center square
	translate([
				OUTLINE_WIDTH + GAP,
				OUTLINE_WIDTH + GAP,
				0
			])
		cube([SIZE, SIZE, THICKNESS]);

	//Parameter
	difference() {
		//Outer square
		cube([
				SIZE + (2 * (GAP + OUTLINE_WIDTH)),
				SIZE + (2 * (GAP + OUTLINE_WIDTH)),
				THICKNESS
			]);

		//Inner square
		translate([OUTLINE_WIDTH, OUTLINE_WIDTH, -5])
			cube([SIZE + (2 * GAP), SIZE + (2 * GAP), 10]);
	}
}