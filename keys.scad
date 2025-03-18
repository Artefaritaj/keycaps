// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>

max_row = 10; // Maximum row width (in units)

// Each key is defined as [label, size]
keys = [
  // FXX
  ["F1", 1, 4],
  ["F2", 1, 4],
  ["F3", 1, 4],
  ["F4", 1, 4],
  ["F5", 1, 4],
  ["F6", 1, 4],
  ["F7", 1, 4],
  ["F8", 1, 4],
  ["F9", 1, 4],
  ["F10", 1, 4],
  ["F11", 1, 4],
  ["F12", 1, 4],
  
  //Number row
  
  ["$", 1, 6],
  ["\"", 1, 6],
  ["«", 1, 6],
  ["»", 1, 6],
  ["(", 1, 6],
  [")", 1, 6],
  ["@", 1, 6],
  ["+", 1, 6],
  ["-", 1, 6],
  ["/", 1, 6],
  ["*", 1, 6],
  ["=", 1, 6],
  ["%", 1, 6],

  // Top row of Bépo letters
  ["B", 1, 6],
  ["É", 1, 6],
  ["P", 1, 6],
  ["O", 1, 6],
  ["È", 1, 6],
  ["^", 1, 6],
  ["V", 1, 6],
  ["D", 1, 6],
  ["L", 1, 6],
  ["J", 1, 6],
  ["Z", 1, 6],
  ["W", 1, 6],
  
  // Home row of Bépo letters
  ["A", 1, 6],
  ["U", 1, 6],
  ["I", 1, 6],
  ["E", 1, 6],
  [",", 1, 6],
  ["C", 1, 6],
  ["T", 1, 6],
  ["S", 1, 6],
  ["R", 1, 6],
  ["N", 1, 6],
  ["M", 1, 6],
  
  // Bottom row of Bépo letters
  ["Ê", 1, 6],
  ["À", 1, 6],
  ["Q", 1, 6],
  ["Y", 1, 6],
  ["X", 1, 6],
  [".", 1, 6],
  
  ["K", 1, 6],
  ["'", 1, 6],
  ["Q", 1, 6],
  ["G", 1, 6],
  ["H", 1, 6],
  ["F", 1, 6],
  ["Ç", 1, 6],
  
  // Others,
  ["\U0f0328", 1, 6],
  ["", 1, 6], //blank
  
  // Thumbs
  
  //left
  ["\U0f0206", 1.5, 8], // escape
  ["\U0f02dc", 1.5, 8], //home
  
  ["\U0f1050", 1, 8], //space
  ["\U0f0636", 1, 8], //shift
  ["Alt", 1, 4], 
  ["Ctr", 1, 4], 
  
  //right
  ["\U0f01b4", 1.5, 7], // delete
  ["\U0f006e", 1.5, 8], // back
  
  ["\U0f0311", 1, 8], // enter
  ["\U0f0636", 1, 8], //shift
  
  ["Alt", 1, 4], 
  ["Ctr", 1, 4], 

];



$font = "monaspaceargon-regular";
$rounded_cherry_stem_d = 5.5;
$inset_legend_depth = 0.3;
$stem_inner_slop = 0.05;
$cherry_bevel = true;

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
    font_size = keys[i][2];
    
    rounded_cherry(0) no_stem_support() translate_u(x, y)
    u(key_size) legend(key_label, size=font_size)  dsa_row() dishless() {
      if (render_legend_or_keycap)
         render_legend();
      else
         render_keycap();
    }
}
