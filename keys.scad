// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>

legends = ["B", "É", "P", "O", "È", "^", "V", "D", "L", "J", "Z", "\U0f0311", "\U0f1969", "\U0f05e8", "", "\U0f006e"];
 
$font="monaspaceargon-regular";

// Define the boolean variable for swapping
render_legend_or_keycap = false;  // Set to false to swap the order

// Module for rendering legend (debug call first)
module render_legend() {
  debug() key(true);
  dished() { legends($inset_legend_depth); }
}

// Module for rendering keycap (debug call second)
module render_keycap() {
  key(true);
  debug() dished() { legends($inset_legend_depth); }
}

for (x = [0:1:3]) {
  for (y = [0:1:3]) {
    rounded_cherry(0.45) tined_stem_support() translate_u(x,y) legend(legends[y*4+x]) dsa_row() {
      if (render_legend_or_keycap)
         render_legend();
      else
         render_keycap();
    }
  }
}
