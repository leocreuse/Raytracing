with Rays;  use Rays;
with Types; use Types;

package Cameras is

   type Camera_T is private;

   function Make
     (Origin       : Point;
      Look_At      : Point;
      Aspect_Ratio : Float;
      Vertical_FOV : Float;
      VUp          : Point) return Camera_T;
   --  Vertical_FOV is in degrees. VUp defines the rotation of the camera.

   function Get_Ray (Self : Camera_T; S, T : Float) return Ray_T;
   --  Get a ray originating from the origin of Self an going through the (U,V)
   --  point, in screen space coordinates.

private

   type Camera_T is record
      Origin : Point;
      --  Position of the camera

      Lower_Left_Corner : Point;
      --  Lower left corner of the viewport

      Vertical : Vec3;
      --  Vertical vector of the view port

      Horizontal : Vec3;
      --  Vertical vector of the view port
   end record;

end Cameras;