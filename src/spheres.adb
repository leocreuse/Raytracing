with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

package body Spheres is

   ----------
   -- Make --
   ----------

   function Make
     (Origin : Point;
      Radius : Any_Position;
      Mat    : Materials.Mat_Acc) return Sphere is
     (Origin => Origin, Radius => Radius, Mat => Mat);

   ---------
   -- Hit --
   ---------

   overriding function Hit
     (Self         : Sphere;
      Ray          : Ray_T;
      T_Min, T_Max : Any_Position) return Hit_Result
   is
      A : constant Float := Length_Squared (Ray.Direction);
      Half_B : constant Float := Ray.Direction * (Ray.Origin - Self.Origin);
      C : constant Float :=
        Length_Squared (Ray.Origin - Self.Origin) - Self.Radius * Self.Radius;
      Discr : Constant Float := Half_B * Half_B - A * C;
      P : Point;
   begin
      if Discr < 0.0 then
         return (Hit => False);
      end if;
      declare
         T : Any_Position := (-Half_B - Sqrt (Discr)) / A;
      begin
         if T > T_Max or else T < T_Min then
            T := (-Half_B + Sqrt (Discr)) / A;
         end if;
         if T > T_Max or else T < T_Min then
            return (Hit => False);
         end if;
         P := Ray.P (T);
         return Res : Hit_Result (Hit => True) do
            Res.T := T;
            Res.P := P;
            Res.Mat := Self.Mat;
            Set_Normal (Res, Ray,  (P - Self.Origin) / Self.Radius);
         end return;
      end;
   end Hit;

end Spheres;