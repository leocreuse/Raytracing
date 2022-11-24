with Utils; use Utils;

package body Materials.Metalics is

   ----------
   -- Make --
   ----------

   function Make (Albedo : RGB_Color; Fuzz : Any_Position) return Metalic is
   begin
      return (Albedo, (if Fuzz < 1.0 then Fuzz else 1.0));
   end Make;

   -------------
   -- Scatter --
   -------------

   overriding function Scatter
     (Self          : Metalic;
      Ray_In        : Ray_T;
      Hit_Rec       : Hittables.Hit_Result;
      Attenuation   : out RGB_Color;
      Scattered_Ray : out Ray_T) return Boolean
   is
      use Point_Vecs;
   begin
      Attenuation := Self.Albedo;
      Scattered_Ray := Make
        (Hit_Rec.P,
         Reflect (Ray_In.Direction, Hit_Rec.Normal)
         + Self.Fuzz * Random_Unit_Sphere);
      if Scattered_Ray.Direction * Hit_Rec.Normal <= 0.0 then
         Attenuation := [0.0, 0.0, 0.0];
         return False;
      end if;
      return True;
   end Scatter;

end Materials.Metalics;