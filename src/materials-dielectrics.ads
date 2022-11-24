with Hittables; use Hittables;
with Rays;      use Rays;
with Types;     use Types;

package Materials.Dielectrics is

   type Dielectric is new Material with record
      Refraction_Idx : Float;
   end record;

   overriding function Scatter
     (Self          : Dielectric;
      Ray_In        : Ray_T;
      Hit_Rec       : Hittables.Hit_Result;
      Attenuation   : out RGB_Color;
      Scattered_Ray : out Ray_T) return Boolean;

private

   function Reflectance (Cosine : Float; Ref_Idx : Float) return Float;
   --  Reflection probability based on the angle theta and the refraction
   --  index. Uses Schlick's approximation.

end Materials.Dielectrics;