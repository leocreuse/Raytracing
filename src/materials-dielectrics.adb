with Ada.Numerics.Elementary_Functions;

with Utils; use Utils;

package body Materials.Dielectrics is

   -------------
   -- Scatter --
   -------------

   overriding function Scatter
     (Self          : Dielectric;
      Ray_In        : Ray_T;
      Hit_Rec       : Hittables.Hit_Result;
      Attenuation   : out RGB_Color;
      Scattered_Ray : out Ray_T) return Boolean
   is
      use Point_Vecs;
      use Ada.Numerics.Elementary_Functions;
      Actual_RR : constant Float :=
        (if Hit_Rec.Front_Face
         then 1.0 / Self.Refraction_Idx
         else Self.Refraction_Idx);

      Unit_Direction : constant Vec :=  Unit_Vector (Ray_In.Direction);

      Cos_Theta : constant Float :=
        Float'Min (Unit_Direction * Ray_In.Direction, 1.0);
      Sin_Theta : constant Float := Sqrt (1.0 - Cos_Theta * Cos_Theta);

      Total_Reflexion : constant Boolean := Actual_RR * Sin_Theta > 1.0;
   begin
      Attenuation := [1.0, 1.0, 1.0];
      if Total_Reflexion
         or else Reflectance (Cos_Theta, Actual_RR) > Random
      then
         declare
            Reflected : constant Vec
              := Reflect (Ray_In.Direction, Hit_Rec.Normal);
         begin
            Scattered_Ray := Make (Hit_Rec.P, Reflected);
         end;
      else
         declare
            Refracted : constant Vec :=
              Refract (Unit_Direction, Hit_Rec.Normal, Actual_RR);
         begin
            Scattered_Ray := Make (Hit_Rec.P, Refracted);
         end;
      end if;
      return True;
   end Scatter;

   -----------------
   -- Reflectance --
   -----------------

   function Reflectance (Cosine : Float; Ref_Idx : Float) return Float is
      R0 : Float := (1.0 - Ref_Idx) / (1.0 + Ref_Idx);
   begin
      R0 := R0 * R0;
      return r0 + (1.0 - R0) * (1.0 - Cosine) ** 5;
   end;


end Materials.Dielectrics;