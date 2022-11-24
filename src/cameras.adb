with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Utils; use Utils;

package body Cameras is

   ----------
   -- Make --
   ----------

   function Make
     (Origin       : Point;
      Look_At      : Point;
      Aspect_Ratio : Float;
      Vertical_FOV : Float;
      VUp          : Point) return Camera_T
   is
      use Point_Vecs;
      Theta : constant Float := Deg_To_Rad (Vertical_FOV);
      H : constant Float := Tan (Theta / 2.0);

      Viewport_Height : constant Float := 2.0 * H;
      Viewport_Width  : constant Any_Position :=
        Aspect_Ratio * Viewport_Height;

      W : constant Vec3 := Unit_Vector (Origin - Look_At);
      U : constant Vec3 := Unit_Vector (Cross (VUp, W));
      V : constant Vec3 := Unit_Vector (Cross (W, U));

   begin
      return Res : Camera_T do
         Res.Origin := Origin;
         Res.Horizontal := Viewport_Width * U;
         Res.Vertical := Viewport_Height * V;
         Res.Lower_Left_Corner :=
           Origin - Res.Horizontal / 2.0 - Res.Vertical / 2.0 - W;
      end return;
   end Make;

   -------------
   -- Get_Ray --
   -------------

   function Get_Ray (Self : Camera_T; S, T : Float) return Ray_T is
      use Point_Vecs;
   begin
      return Make
        (Self.Origin,
         Self.Lower_Left_Corner + S * Self.Horizontal + T * Self.Vertical - Self.Origin);
   end Get_Ray;

end Cameras;