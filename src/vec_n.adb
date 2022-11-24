package body Vec_N is

   ---------
   -- "+" --
   ---------

   function "+" (Right : Vec) return Vec is
     (Right);

   function "+" (Left, Right : Vec) return Vec is
      (for I in Left'Range => Left (I) + Right (I));

   ---------
   -- "-" --
   ---------

   function "-" (Right : Vec) return Vec is
     (for I in Right'Range => - Right (I));

   function "-" (Left, Right : Vec) return Vec is
     (for I in Left'Range => Left (I) - Right (I));

   ---------
   -- "*" --
   ---------

   function "*" (Left, Right : Vec) return Element_Type'Base is
   begin
      return Res : Element_type'Base := 0.0 do
         for I in Left'Range loop
            Res := @ + Left (I) * Right(I);
         end loop;
      end return;
   end "*";

   function "*" (Left : Element_Type'Base; Right : Vec) return Vec is
     (for I in Right'Range => Right (I) * Left);

   function "*" (Left : Vec; Right : Element_Type'Base) return Vec is
     (Right * Left);

   --------------------
   -- Component_Mult --
   --------------------

   function Component_Mult (Left, Right : Vec) return Vec is
     (for I in Left'Range => Left (I) * Right (I));


   ---------
   -- "/" --
   ---------

   function "/" (Left : Vec; Right : Element_Type'Base) return Vec is
     (for I in Left'Range => Left (I) / Right);

   --------------------
   -- Length_Squared --
   --------------------

   function Length_Squared (Right : Vec) return Element_Type'Base is
     (Right * Right);

   ----------
   -- Norm --
   ----------

   function Norm (Right : Vec) return Element_Type'Base is
     (Sqrt (Length_Squared (Right)));

   -----------------
   -- Unit_Vector --
   -----------------

   function Unit_Vector (Right : Vec) return Vec is
     (Right / Norm (Right));

   ---------------
   -- Near_Zero --
   ---------------

   function Near_Zero (Right : Vec) return Boolean is
     (for all I in Right'Range => Right (I) < 1.0E-8);

   -------------
   -- Reflect --
   -------------

   function Reflect (Left : Vec; Normal : Vec) return Vec is
     (Left - 2.0 * (Left * Normal) * Normal);

   -------------
   -- Refract --
   -------------

   function Refract
     (Unit_Vec : Vec; Normal : Vec; Etai_Over_Etat : Element_Type) return Vec
   is
      Cos_Theta       : constant Element_Type :=
        Element_Type'Min ((-Unit_Vec) * Normal, 1.0);
      R_Perpendicular : constant Vec :=
        Etai_Over_Etat * (Unit_Vec + (Cos_Theta * Normal));
      R_Parallel      : constant Vec :=
        -Sqrt (abs (1.0 - Length_Squared (R_Perpendicular))) * Normal;
   begin
      return R_Parallel + R_Perpendicular;
   end Refract;


   -----------
   -- Image --
   -----------

   function Image (Right : Vec) return String is
      function Img_Internal (E : Vec; Last : Index_Type) return String is
      begin
         return (if Last /= Index_Type'First
                 then Img_Internal (E, Index_Type'Pred (Last))
                 else "")
           & " " & E (Last)'Image & ",";
      end Img_Internal;
      Res : String := Img_Internal (Right, Right'Last);
   begin
      Res (1) := '[';
      Res (Res'Last) := ']';
      return Res;
   end Image;

end Vec_N;
