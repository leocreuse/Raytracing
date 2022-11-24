with Hittables; use Hittables;
with Rays; use Rays;
with Types; use Types;

package Materials.Norm is

   type Normal is new Material with null record;

   overriding function Scatter
     (Self          : Normal;
      Ray_In        : Ray_T;
      Hit_Rec       : Hittables.Hit_Result;
      Attenuation   : out RGB_Color;
      Scattered_Ray : out Ray_T) return Boolean;

end Materials.Norm;