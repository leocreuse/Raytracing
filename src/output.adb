with Ada.Numerics.Elementary_Functions;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions;

with Utils; use Utils;

package body Output is

   ----------------
   -- Test_Image --
   ----------------

   function Test_Image (Height, Width : Positive) return Image_T_Acc is
      Height_F : constant Any_Pixel_Val := Any_Pixel_Val (Height);
      Width_F  : constant Any_Pixel_Val := Any_Pixel_Val (Width);

      Res : Image_T_Acc := new Image_T (1 .. Height, 1 .. Width);
   begin
      for J in 1 .. Height loop
         for K in 1 .. Width loop
            Res (J, K) :=
              (Red   => Any_Pixel_Val (J) / Height_F,
               Green => Any_Pixel_Val (K) / Width_F,
               Blue  => 0.25);
         end loop;
      end loop;
      return Res;
   end Test_Image;

   function Float2Int
     (Val : Any_Pixel_Val; Div : Float) return Any_Int_Pixel_Val;
   --  Simple mapping with gamma 2

   ---------------
   -- Float2Int --
   ---------------

   function Float2Int
     (Val : Any_Pixel_Val; Div : Float) return Any_Int_Pixel_Val
   is
      use Ada.Numerics.Elementary_Functions;
   begin
      return Any_Int_Pixel_Val (Clamp (Sqrt (Val / Div), 0.0, 1.0) * 255.0);
   end Float2Int;


   -------------------
   -- Output_Buffer --
   -------------------

   procedure Output_Buffer
     (Filename : String; Image : Image_T_Acc; Samples_Per_Pixel : Positive)
   is
      File : File_Type;
   begin
      Create (File, Out_File, Filename);
      Put_Line (File, "P3");
      Put (File, Integer'(Image.all'Length(2))'Image);
      Put_Line (File, Integer'(Image.all'Length(1))'Image);
      Put_Line (File, "255");
      for J in Image.all'Range(1) loop
         for K in Image.all'Range (2) loop
            Put
              (File,
               Any_Int_Pixel_Val'
                 (Float2Int (Image (J, K) (Red),
                  Float (Samples_Per_Pixel)))'Image);
            Put
              (File,
               Any_Int_Pixel_Val'
                 (Float2Int (Image (J, K) (Green),
                  Float (Samples_Per_Pixel)))'Image);
            Put
              (File,
               Any_Int_Pixel_Val'
                 (Float2Int (Image (J, K) (Blue),
                  Float (Samples_Per_Pixel)))'Image);
                 end loop;
         New_Line (File);
      end loop;
      Close (File);

   exception
      when Exc : others =>
         Put_Line ("Could not output image : "
                    & Ada.Exceptions.Exception_Information (Exc));
   end Output_Buffer;

end Output;
