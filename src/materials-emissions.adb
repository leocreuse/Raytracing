with Utils; use Utils;

package body Materials.Emissions is

   -------------
   -- Scatter --
   -------------

   overriding function Scatter
     (Self          : Emission;
      Ray_In        : Ray_T;
      Hit_Rec       : Hit_Result;
      Attenuation   : out RGB_Color;
      Scattered_Ray : out Ray_T) return Boolean
   is
      use RGB_Vecs;
   begin
      Attenuation := (Self.Power) * Self.Color;
      Scattered_Ray := Null_Ray;
      return False;
   end Scatter;

end Materials.Emissions;