with Ada.Text_IO; use Ada.Text_IO;

with Cameras;               use Cameras;
with Hittable_Vectors;      use Hittable_Vectors;
with Materials.Dielectrics; use Materials.Dielectrics;
with Materials.Emissions;   use Materials.Emissions;
with Materials.Lambertians; use Materials.Lambertians;
with Materials.Metalics;    use Materials.Metalics;
with Output;                use Output;
with Rays;                  use Rays;
with Spheres;               use Spheres;
with Types;                 use Types;
with Utils;                 use Utils;

procedure Main is
   use Point_Vecs;
   use RGB_Vecs;

   --  Image specs

   Aspect_Ratio : constant := 16.0 / 9.0;
   Image_Height : constant Integer := 400;
   Image_Width  : constant Integer :=
     Integer (Aspect_Ratio * Float (Image_Height));
   Total_Pixels : constant Integer := Image_Height * Image_Width;
   Samples      : constant Positive := 5000;

   --  Useful geometry

   Origin : constant Point := [0.0, 0.0, 0.0];


   --  Camera

   Camera : constant Camera_T := Make
     (Origin       => [-2.0, 2.0, 1.0],
      Look_At      => [0.0, 0.0, -1.0],
      VUp          => Point'([0.0, 1.0, 0.0]),
      Aspect_Ratio => Aspect_Ratio,
      Vertical_FOV => 45.0);

   --  Global objects

   Buffer : Image_T_Acc;

   U, V : Float;
   Current_Ray : Ray_T;

   World : Hittable_Vec;

begin
   World.Vec.Append (new Sphere'(Make
     (Origin => [1.0, 0.0, -1.0],
      Radius => 0.5,
      Mat    => new Metalic'(Make (Albedo => [0.8, 0.8, 0.8], Fuzz => 0.05)))));
   World.Vec.Append (new Sphere'(Make
     (Origin => [0.0, -0.3, 0.0],
      Radius => 0.2,
      Mat    => new Metalic'(Make (Albedo => [0.9, 0.2, 0.4], Fuzz => 0.0)))));
   World.Vec.Append (new Sphere'(Make
     (Origin => [-1.0, 0.0, -1.0],
      Radius => 0.5,
      Mat    => new Dielectric'(Refraction_Idx => 1.5))));
   World.Vec.Append (new Sphere'(Make
     (Origin => [0.0, 0.0, -1.0],
      Radius => 0.5,
      Mat    => new Lambertian'(Albedo => [0.9, 0.3, 0.3]))));
   World.Vec.Append (new Sphere'(Make
     (Origin => [0.0, 2.0, 2.0],
      Radius => 0.5,
      Mat    => new Emission'(Color => [1.0, 1.0, 1.0], Power => 100.0))));
   World.Vec.Append (new Sphere'(Make
     (Origin => [0.25, -0.5, -1.0],
      Radius => 0.1,
      Mat    => new Emission'(Color => [1.0, 1.0, 1.0], Power => 100.0))));
   World.Vec.Append (new Sphere'(Make
     (Origin => [-4.0, 0.0, -3.0],
      Radius => 0.5,
      Mat    => new Lambertian'(Albedo => [0.3, 0.3, 0.8]))));
   --  World.Vec.Append (new Sphere'(Make ([0.0, 0.0, -1.0], 0.5)));
   World.Vec.Append (new Sphere'(Make
     (Origin => [0.0, -100.5, -1.0],
      Radius => 100.0,
      Mat    => new Lambertian'(Albedo => [0.8, 0.8, 0.0]))));
   Buffer := new Image_T (1 .. Image_Height, 1 .. Image_Width);

   for I in 1 .. Image_Height loop
      for J in 1 .. Image_Width loop
         if (((I * Image_Width) + J) mod 10000) = 0 then
            Put (ASCII.CR & "                                         "
                 & "                             ");
            Put (ASCII.CR & "Rendering pixel"
                 & Integer'((I * Image_Width) + J)'Image
                 & " of" & Total_Pixels'Image);
            Flush;
         end if;
         Buffer (I, J) := [0.0, 0.0, 0.0];
         for S in 1 .. Samples loop
            U := (Float (J - 1 ) + Random) / FLoat (Image_Width);
            V := (Float (Image_Height - I) + Random) / Float (Image_Height);
            Current_Ray := Get_Ray (Camera, U, V);
            Buffer (I, J) := Buffer (I, J) + Current_Ray.Ray_Color (World);
         end loop;
      end loop;
   end loop;

   --  Put_Line (Buffer.all'Image);

   Output_Buffer ("test.ppm", Buffer, Samples);
end Main;
