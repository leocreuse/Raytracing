with Utils; use Utils;

package body Materials.Lambertians is

   overriding function Scatter
     (Self          : Lambertian;
      Ray_In        : Ray_T;
      Hit_Rec       : Hit_Result;
      Attenuation   : out RGB_Color;
      Scattered_Ray : out Ray_T) return Boolean
   is
      use Point_Vecs;
      Scatter_Direction : Vec3 := Hit_Rec.Normal + Random_Unit_Vec;
   begin
      Attenuation := Self.Albedo;
      if Near_Zero (Scatter_Direction) then
         Scattered_Ray := Make (Hit_Rec.P, Hit_Rec.Normal);
      else
         Scattered_Ray := Make (Hit_Rec.P, Scatter_Direction);
      end if;
      return True;
   end Scatter;

end Materials.Lambertians;