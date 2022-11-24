with Hittables; use Hittables;
with Types;     use Types;
with Rays;      use Rays;

package Materials.Metalics is

   type Metalic is new Material with private;

   function Make (Albedo : RGB_Color; Fuzz : Any_Position) return Metalic;

   overriding function Scatter
     (Self          : Metalic;
      Ray_In        : Ray_T;
      Hit_Rec       : Hittables.Hit_Result;
      Attenuation   : out RGB_Color;
      Scattered_Ray : out Ray_T) return Boolean;

private

   type Metalic is new Material with record
      Albedo : RGB_Color;
      Fuzz   : Any_Position;
   end record;

end Materials.Metalics;