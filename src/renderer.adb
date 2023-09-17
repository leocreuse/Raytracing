with Ada.Numerics.Elementary_Functions;
with Ada.Text_IO; use Ada.Text_IO;

with Rays;  use Rays;
with Types; use Types;
with Utils; use Utils;

package body Renderer is

   -----------
   -- Setup --
   -----------

   procedure Setup
     (Self                : in out Renderer_T;
      Camera              : Camera_T;
      World               : not null Hittable_Acc;
      Image_Height        : Positive;
      Image_Width         : Positive;
      Samples             : Positive;
      Patch_Size_Limit    : Positive := 16#1_0000#; -- 1Mb
      Threads             : Positive :=
        Positive (System.Multiprocessors.Number_Of_CPUs);
      Report_Txt          : Boolean := True;
      Sample_Report_Count : Natural := 50;
      In_Progress_Preview : Preview_Callback := null)
   is
      AR : constant Float := Float (Image_Width) / Float (Image_Height);

      Patch_Width_Max  : constant Positive :=
        Positive
          (Ada.Numerics.Elementary_Functions.Sqrt
             (Float (8 * Patch_Size_Limit / RGB_Color'Size) * AR)) /
        2;
      Patch_Height_Max : constant Positive :=
        Positive
          (Ada.Numerics.Elementary_Functions.Sqrt
             (Float (8 * Patch_Size_Limit / RGB_Color'Size) / AR)) /
        2;
   begin
      Self.IW      := Image_Width;
      Self.IH      := Image_Height;
      Self.Camera  := Camera;
      Self.World   := World;
      Self.Samples := Samples;
      Self.Preview := In_Progress_Preview;
      Self.Preview_Buff :=
        new Image_T (0 .. Image_Height - 1, 0 .. Image_Width - 1);
      Make_Checker (Self.Preview_Buff);

      Self.PW := Natural'Min (Patch_Width_Max, Self.IW / 2);
      while Self.IW mod Self.PW /= 0 loop
         Self.PW := Self.PW - 1;
      end loop;
      if Self.PW <= 10 then
         raise Constraint_Error with "Image width only has too small divisors";
      end if;
      Self.PH := Natural'Min (Patch_Height_Max, Self.IH / 2);
      while Self.IH mod Self.PH /= 0 loop
         Self.PH := Self.PH - 1;
      end loop;
      if Self.PH <= 10 then
         raise Constraint_Error
           with "Image Height only has too small divisors";
      end if;
      Self.NW      := Self.IW / Self.PW;
      Self.NH      := Self.IH / Self.PH;
      if Report_Txt then
         Self.Txt_Reporter := new Text_Reporter
           (Image_Width * Image_Height * Sample_Report_Count,
            Image_Width * Image_Height * Samples);
      end if;
      Self.Patches := new Image_Arr (0 .. Threads - 1);
      for Patch in Self.Patches'Range loop
         Self.Patches (Patch) :=
           new Image_T (0 .. Self.PH - 1, 0 .. Self.PW - 1);
      end loop;
      Self.Dispatcher := new Dispatcher_T (Self'Unchecked_Access);
      Self.Renderers  := new Patch_Arr (0 .. Threads - 1);
      for J in Self.Renderers'Range loop
         Self.Renderers (J) := new Patch_Renderer_T (J, Self'Unchecked_Access);
      end loop;
   end Setup;

   function Render (Self : Renderer_T) return Image_T_Acc is
   begin
      Self.Dispatcher.Start_Render;
      Self.Dispatcher.Wait_Completion;
      return Self.Preview_Buff;
   end Render;

   protected body Text_Reporter is

      procedure Report_New_Samples (Count : Positive) is
      begin
         Reminder := Reminder + Count;
         if Reminder > Threshold then
            Put (ASCII.CR & "                                         ");
            Put
              (ASCII.CR & Integer'(Quotient * Threshold + Reminder)'Image &
               " /" & Total_Samples'Image);
            Flush;
            Quotient := Quotient + (Reminder mod Threshold);
            Reminder := Reminder / Threshold;
         end if;
      end Report_New_Samples;
   end Text_Reporter;

   task body Dispatcher_T is
      Next_Id : Natural := 0;
   begin
      accept Start_Render;

      for P_Line in 0 .. Renderer.NH - 1 loop
         for P_Col in 0 .. Renderer.NW - 1 loop
            accept Signal_Ready (Id : Positive) do
               Next_Id := Id;
            end Signal_Ready;
            Renderer.Renderers (Next_Id).Render_Patch (P_Line, P_Col);
         end loop;
      end loop;
      for I in Renderer.Renderers'Range loop
         accept Signal_Ready (Id : Positive);
      end loop;
      for I in Renderer.Renderers'Range loop
         Renderer.Renderers (I).Shut_Down;
      end loop;

      accept Wait_Completion;
   end Dispatcher_T;

   task body Patch_Renderer_T is
      use RGB_Vecs;

      Buff : Image_T_Acc := Renderer.Patches (Id);

      IH : constant Positive := Buff'Length (1);
      IW : constant Positive := Buff'Length (2);

      LO   : Natural;
      CO   : Natural;
      Run  : Boolean := True;

      Current_Ray : Ray_T;
      PX_Per_Rep  : Positive;
      U, V        : Float;
   begin
      loop
         Renderer.Dispatcher.Signal_Ready (Id);
         select
            accept Render_Patch
              (Patch_Line, Patch_Col : Natural)
            do
               LO := Renderer.PH * Patch_Line;
               CO := Renderer.PW * Patch_Col;
            end Render_Patch;
         or
            accept Shut_Down do
               Run := False;
            end Shut_Down;
         end select;

         exit when not Run;

         PX_Per_Rep := Buff'Length (1) * Buff'Length (2);
         for I in 0 .. IH - 1 loop
            for J in 0 .. IW - 1 loop
               Buff (I, J) := [0.0, 0.0, 0.0];
            end loop;
         end loop;
         for I in 0 .. IH - 1 loop
            for J in 0 .. IW - 1 loop
               for S in 1 .. Renderer.Samples loop
                  U           :=
                    (Float (CO + J - 1) + Random) / Float (Renderer.IW);
                  V           :=
                    (Float (Renderer.IH - I - LO) + Random) / Float (Renderer.IH);
                  Current_Ray := Get_Ray (Renderer.Camera, U, V);
                  Buff (I, J) :=
                    Buff (I, J) + Current_Ray.Ray_Color (Renderer.World.all);
               end loop;
            end loop;
         end loop;
         for Line in Buff'Range (1) loop
            for Col in Buff'Range (2) loop
               Renderer.Preview_Buff (Line + LO, Col + CO)
                 := Buff (Line, Col);
            end loop;
         end loop;
      end loop;
   end Patch_Renderer_T;

end Renderer;
