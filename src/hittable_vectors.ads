with Ada.Containers.Vectors;

with Hittables; use Hittables;
with Rays;      use Rays;
with Types;     use Types;

package Hittable_Vectors is

   package Hittable_Vecs is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Hittable_Acc);

   type Hittable_Vec is new Hittable with record
      Vec : Hittable_Vecs.Vector;
   end record;

   overriding function Hit
     (Self         : Hittable_Vec;
      Ray          : Ray_T;
      Min_T, Max_T : Any_Position) return Hit_Result;

end Hittable_Vectors;