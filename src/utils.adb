package body Utils is

   ------------------------
   -- Random_Unit_Sphere --
   ------------------------

   function Random_Unit_Sphere return Point is
      use Point_Vecs;
      Current_Point : Point;
   begin
      loop
         Current_Point := Random (-1.0, 1.0);
         if Length_Squared (Current_Point) <= 1.0 then
            return Current_Point;
         end if;
      end loop;
   end Random_Unit_Sphere;

   ---------------------
   -- Random_Unit_Vec --
   ---------------------

   function Random_Unit_Vec return Vec3 is
     (Point_Vecs.Unit_Vector (Random_Unit_Sphere));

   -----------
   -- Clamp --
   -----------

   function Clamp (Val, Min, Max : Float) return Float is
   begin
      if Val < Min then
         return Min;
      elsif Val > Max then
         return Max;
      else
         return Val;
      end if;
   end Clamp;

   -----------
   -- cross --
   -----------

   function Cross (Left, Right : Point_Vecs.Vec) return Point_Vecs.Vec is
   ([X => Left (Y) * Right (Z) - Left (Z) * Right (Y),
     Y => Left (Z) * Right (X) - Left (X) * Right (Z),
     Z => Left (X) * Right (Y) - Left (Y) * Right (X)]);


end Utils;