generic

   type Element_Type is digits <>;
   type Index_Type is (<>);
   with function Sqrt (Right : Element_Type) return Element_Type;

package Vec_N is
   pragma Pure (Vec_N);

   type Vec is array (Index_Type) of Element_Type;

   --  Vec arithmetic operations

   function "+"   (Right : Vec)       return Vec;
   function "-"   (Right : Vec)       return Vec;

   function "+"   (Left, Right : Vec) return Vec;
   function "-"   (Left, Right : Vec) return Vec;

   function "*"   (Left, Right : Vec) return Element_Type'Base;
   --  Dot product

   function Component_Mult (Left, Right : Vec) return Vec;
   --  Cpmponent wise multiplication

   function Length_Squared (Right : Vec) return Element_Type'Base;
   function Norm (Right : Vec) return Element_Type'Base;

   --  Vec scaling operations

   function "*" (Left : Element_Type'Base;   Right : Vec) return Vec;
   function "*" (Left : Vec; Right : Element_Type'Base)   return Vec;
   function "/" (Left : Vec; Right : Element_Type'Base)   return Vec;

   --  Other Vec operations

   function Unit_Vector (Right : Vec) return Vec;

   function Near_Zero (Right : Vec) return Boolean;
   --  Wether Right has all of its dimentions close to zero

   function Reflect (Left : Vec; Normal : Vec) return Vec;
   --  Reflect Left on the sufrace normal to Normal

   function Refract
     (Unit_Vec : Vec; Normal : Vec; Etai_Over_Etat : Element_Type) return Vec;
   --  Vector comming from the refraction of Unit_Vec through a surface defined
   --  by Normal and with a ratio of Etai_Over_Etat of their refractive
   --  indices. Unit_Vec should be as it name implies, a unit vector.

   --  I/O

   function Image (Right : Vec) return String;
   --  Human readable

private

   pragma Inline ("+");
   pragma Inline ("-");
   pragma Inline ("*");
   pragma Inline ("/");
   pragma Inline (Length_Squared);
   pragma Inline (Norm);
   pragma Inline (Unit_Vector);
   pragma Inline (Component_Mult);
   pragma Inline (Near_Zero);
   pragma Inline (Reflect);

end Vec_N;
