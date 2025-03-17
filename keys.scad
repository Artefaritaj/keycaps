// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>

max_row = 7; // Maximum row width (in units)

// Each key is defined as [label, size]
keys = [
  // Top row of Bépo letters
  ["B", 1],
  ["É", 1],
  ["P", 1],
  ["O", 1],
  ["È", 1],
  ["^", 1],
  ["V", 1],
  ["D", 1],
  ["L", 1],
  ["J", 1],
  ["Z", 1],
  
  // Home row of Bépo letters
  ["A", 1],
  ["U", 1],
  ["I", 1],
  ["E", 1],
  ["'", 1],
  ["C", 1],
  ["T", 1],
  ["S", 1],
  ["R", 1],
  ["N", 1],
  
  // Bottom row of Bépo letters
  ["Q", 1],
  ["W", 1],
  ["F", 1],
  ["H", 1],
  ["M", 1],
  ["?", 1],
  [".", 1],
  ["K", 1],
  ["X", 1],
  ["Y", 1],
  
  // Unicode keys
  ["\U0f0311", 1],
  ["\U0f1969", 1.5],
  ["\U0f05e8", 1.5],
  ["", 1.5],
  ["\U0f006e", 1.5]
];


$font = "monaspaceargon-regular";

// Define the boolean variable for swapping
render_legend_or_keycap = false;  // Set to false to swap the order

// Module for rendering legend (debug call first)
module render_legend() {
  debug() key(true);
  dished() { legend($inset_legend_depth); }
}

// Module for rendering keycap (debug call second)
module render_keycap() {
  key(true);
  debug() dished() { legend($inset_legend_depth); }
}

// Compute a vector that contains the cumulative x positions as if all keys were on one line.
// For each key index i, linear_x[i] is the sum of sizes for keys[0] to keys[i-1].
linear_x = [ for (i = [0 :1: len(keys)-1]) 
              sum([ for (j = [0 :1: i-1]) keys[j][1] ]) 
           ];

for (i = [0 : len(keys)-1]) {
    // Use the cumulative value modulo max_row for x, and floor division for y.
    x = (linear_x[i] % max_row) + keys[i][1]/2;
    y = floor(linear_x[i] / max_row);
    key_label = keys[i][0];
    key_size  = keys[i][1];
    
    rounded_cherry(0.45) tined_stem_support() translate_u(x, y)
    u(key_size) legend(key_label) dsa_row() {
      if (render_legend_or_keycap)
         render_legend();
      else
         render_keycap();
    }
}
