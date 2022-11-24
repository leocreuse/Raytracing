with Materials;
with Types;     use Types;
with Rays;      use Rays;
with Hittables; use Hittables;

package Spheres is
   use Point_Vecs;

   type Sphere is new Hittable with private;

   function Make
     (Origin : Point;
      Radius : Any_Position;
      Mat    : Materials.Mat_Acc) return Sphere;

   overriding function Hit
     (Self         : Sphere;
      Ray          : Ray_T;
      T_Min, T_Max : Any_Position) return Hit_Result;

private

   type Sphere is new Hittable with record
      Radius : Any_Position;
      Origin : Point;
      Mat    : Materials.Mat_Acc;
   end record;

end Spheres;