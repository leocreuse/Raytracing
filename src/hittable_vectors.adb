package body Hittable_Vectors is

   ---------
   -- Hit --
   ---------

   overriding function Hit
     (Self         : Hittable_Vec;
      Ray          : Ray_T;
      Min_T, Max_T : Any_Position) return Hit_Result
   is
      Has_Hit : Boolean := False;
      Closest_Hit : Hit_Result :=  (Hit => True, T => Max_T, others => <>);
   begin
      for Elem of Self.Vec loop
         declare
            Hit_Res : Hit_Result := Elem.Hit (Ray, Min_T, Max_T);
         begin
            if Hit_Res.Hit
              and then (not Has_Hit or else Hit_Res.T < Closest_Hit.T)
            then
               Has_Hit := True;
               Closest_Hit := Hit_Res;
            end if;
         end;
      end loop;
      if Has_Hit then
         return Closest_Hit;
      else
         return (Hit => False);
      end if;
   end Hit;


end Hittable_Vectors;