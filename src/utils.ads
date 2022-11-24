With Ada.Numerics;
with Ada.Numerics.Float_Random;

with Types; use Types;

package Utils is

   Float_Gen : Ada.Numerics.Float_Random.Generator;

   function Random return Float is
     (Ada.Numerics.Float_Random.Random (Float_Gen));

   function Random (Min, Max : Float) return Float is
     (Min + (Max - Min) * Random);

   function Random return Vec3 is
     ([Random, Random, Random]);

   function Random (Min, Max : Float) return Vec3 is
     ([Random (Min, Max), Random (Min, Max), Random (Min, Max)]);

   function Random_Unit_Sphere return Point;
   --  Return a random point within the unit sphere

   function Random_Unit_Vec return Vec3;
   --  Return a random point within the unit sphere

   function Clamp (Val, Min, Max : Float) return Float with Inline;

   function Deg_To_Rad (Deg : Float) return Float is
     (Deg * Ada.Numerics.Pi / 180.0);

   function Cross (Left, Right : Point_Vecs.Vec) return Point_Vecs.Vec;
   --  Cross product
   pragma Inline (Cross);

end Utils;