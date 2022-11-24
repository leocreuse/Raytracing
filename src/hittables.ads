with Types; use Types;
with Rays; use Rays;
with Materials;

package Hittables is
   use Point_Vecs;

   type Hit_Result (Hit : Boolean := False) is record
      case Hit is
         when True =>
            T          : Any_Position;
            P          : Point;
            Normal     : Vec3;
            Mat        : Materials.Mat_Acc;
            Front_Face : Boolean;
         when others =>
            null;
      end case;
   end record;

   procedure Set_Normal
     (Hit_Rec : in out Hit_Result; Ray : Ray_T; Outward_Normal : Vec) with
   Pre => Hit_Rec.Hit = True;
   --  Set Front_Face and adjust the normal to always face against the ray
   --  depending on the actual outwards normal.

   type Hittable is abstract tagged null record;

   type Hittable_Acc is access all Hittable'Class;

   function Hit
     (Self         : Hittable;
      Ray          : Ray_T;
      Min_T, Max_T : Any_Position) return Hit_Result is abstract;

end Hittables;