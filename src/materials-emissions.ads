with Hittables; use Hittables;
with Rays;      use Rays;
with Types;     use Types;

package Materials.Emissions is

   type Emission is new Material with record
      Color : RGB_Color;
      Power : Float;
   end record;

   overriding function Scatter
     (Self          : Emission;
      Ray_In        : Ray_T;
      Hit_Rec       : Hit_Result;
      Attenuation   : out RGB_Color;
      Scattered_Ray : out Ray_T) return Boolean;

end Materials.Emissions;