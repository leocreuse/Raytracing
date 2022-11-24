with Types; use Types;

package Output is

   function Test_Image (Height, Width : Positive) return Image_T_Acc;

   procedure Output_Buffer
     (Filename : String; Image : Image_T_Acc; Samples_Per_Pixel : Positive);
   --  Output Image to Filename as PPM format. Image is normalized by
   --  Samples_Per_Pixel.

end Output;
