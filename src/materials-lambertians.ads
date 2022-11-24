with Rays;      use Rays;
with Types;     use Types;
with Hittables; use Hittables;

package Materials.Lambertians is

   type Lambertian is new Material with record
      Albedo : RGB_Color;
   end record;

   overriding function Scatter
     (Self          : Lambertian;
      Ray_In        : Ray_T;
      Hit_Rec       : Hit_Result;
      Attenuation   : out RGB_Color;
      Scattered_Ray : out Ray_T) return Boolean;

end Materials.Lambertians;