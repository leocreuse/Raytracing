package body Hittables is

   procedure Set_Normal
     (Hit_Rec : in out Hit_Result; Ray : Ray_T; Outward_Normal : Vec)
   is
      use Point_Vecs;
   begin
      Hit_Rec.Front_Face := Ray.Direction * Outward_Normal < 0.0;
      Hit_Rec.Normal :=
        (if Hit_Rec.Front_Face then Outward_Normal else -Outward_Normal);
   end Set_Normal;

end Hittables;