with Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Float_Random;

with Vec_N;

package Types is

   subtype Any_Pixel_Val is Float range 0.0 .. Float'Last;

   type Any_Int_Pixel_Val is new Natural range 0 .. 255;

   type Channel_T is (Red, Green, Blue, Alpha);

   subtype RGB_T is Channel_T range Red .. Blue;

   package RGB_Vecs is new Vec_N
     (Index_Type   => RGB_T,
      Element_Type => Any_Pixel_Val,
      Sqrt         => Ada.Numerics.Elementary_Functions.Sqrt);

   subtype RGB_Color is RGB_Vecs.Vec;

   type Image_T is array
     (Positive range <>, Positive range <>) of RGB_Color;

   type Image_T_Acc is access all Image_T;

   subtype Any_Position is Float;

   type Any_Axis is (X, Y, Z);

   package Point_Vecs is new Vec_N
     (Index_Type   => Any_Axis,
      Element_Type => Any_Position,
      Sqrt         => Ada.Numerics.Elementary_Functions.Sqrt);

   subtype Point is Point_Vecs.Vec;

   subtype Vec3 is Point_Vecs.Vec;

end Types;
