package body Materials.Norm is

   -------------
   -- Scatter --
   -------------

   overriding function Scatter
     (Self          : Normal;
      Ray_In        : Ray_T;
      Hit_Rec       : Hittables.Hit_Result;
      Attenuation   : out RGB_Color;
      Scattered_Ray : out Ray_T) return Boolean
   is
      use RGB_Vecs;
   begin
      Attenuation := 0.5 *
        [Hit_Rec.Normal (X) + 1.0,
         Hit_Rec.Normal (Y) + 1.0,
         Hit_Rec.Normal (Z) + 1.0];
      return False;
   end Scatter;

end Materials.Norm;