with Ada.Text_IO; use Ada.Text_IO;

with Hittables; use Hittables;
with Utils;     use Utils;

package body Rays is
   use RGB_Vecs;

   function Direction (Self : Ray_T) return Point is (Self.Direction);

   function Origin (Self : Ray_T) return Point is (Self.Origin);

   function Make (Origin : Point; Direction : Point) return Ray_T is
     (Origin, Direction);

   function P (Self : Ray_T; T : Any_Position) return Point is
     (Self.Origin + T * Self.Direction);

   function Background_Color (Self : Ray_T) return RGB_Color is
      T : Float := 0.5 * (Unit_Vector (Self.Direction)(Y) + 1.0);
      White : constant RGB_Color := [1.0, 1.0, 1.0];
      Light_Blue : constant RGB_Color := [0.2, 0.1, 0.4];
   begin
      return (1.0 - T) * White + T * Light_Blue;
   end Background_Color;

   function Ray_Color
     (Self  : Ray_T;
      Obj   : Hittable'Class;
      Depth : Natural := Max_Ray_Depth) return RGB_Color is
      use Point_Vecs;
      Hit_Rec : constant Hit_Result := Obj.Hit (Self, 0.001, Any_Position'Last);
   begin
      if Depth = 0 then
         return [0.0, 0.0, 0.0];
      end if;
      if not Hit_Rec.Hit then
         return Self.Background_Color;
      end if;

      declare
         use RGB_Vecs;
         Attenuation : RGB_Color;
         Scattered_Ray : Ray_T;
         Scatered : constant Boolean :=
           Hit_Rec.Mat.Scatter (Self, Hit_Rec, Attenuation, Scattered_Ray);
      begin
         if not Scatered then
            return Attenuation;
         end if;
         return Component_Mult
                  (Attenuation, Scattered_Ray.Ray_Color (Obj, Depth -1));
      end;
   end Ray_Color;

end Rays;