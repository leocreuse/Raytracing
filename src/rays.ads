with Types; use Types;
limited with Hittables;

package Rays is
   use Types.Point_Vecs;

   Max_Ray_Depth : constant := 50;

   type Ray_T is tagged private;

   Null_Ray : constant Ray_T;

   function Direction (Self : Ray_T) return Point;

   function Origin (Self : Ray_T) return Point;

   function Make (Origin : Point; Direction : Point) return Ray_T;

   function P (Self : Ray_T; T : Any_Position) return Point;

   function Background_Color (Self : Ray_T) return RGB_Color;

   function Ray_Color
     (Self  : Ray_T;
      Obj   : Hittables.Hittable'Class;
      Depth : Natural := Max_Ray_Depth) return RGB_Color;

private

   Show_Norms : constant Boolean := False;

   type Ray_T is tagged record
      Origin    : Point;
      Direction : Point;
   end record;

   Null_Ray : constant Ray_T :=
     (Origin    => [0.0, 0.0, 0.0],
      Direction => [0.0, 0.0, 0.0]);

end Rays;