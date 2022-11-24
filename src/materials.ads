with Rays;  use Rays;
with Types; use Types;
limited with Hittables;

package Materials is

   type Material is abstract tagged null record;
   type Mat_Acc is access all Material'Class;

   function Scatter
     (Self          : Material;
      Ray_In        : Ray_T;
      Hit_Rec       : Hittables.Hit_Result;
      Attenuation   : out RGB_Color;
      Scattered_Ray : out Ray_T) return Boolean is abstract;
   --  Scatter a ray

end Materials;