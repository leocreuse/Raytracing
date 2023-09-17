with Ada.Finalization;

with System.Multiprocessors;

with Cameras; use Cameras;
with Hittables; use Hittables;
with Types; use Types;

package Renderer is

   type Renderer_T is new Ada.Finalization.Limited_Controlled with private;

   type Preview_Callback is access procedure (Image : Image_T_Acc);

   procedure Setup
     (Self                : in out Renderer_T;
      Camera              : Camera_T;
      World               : not null Hittable_Acc;
      Image_Height        : Positive;
      Image_Width         : Positive;
      Samples             : Positive;
      Patch_Size_Limit    : Positive := 16#10000#; -- 1Mb
      Threads             : Positive :=
        Positive (System.Multiprocessors.Number_Of_CPUs);
      Report_Txt          : Boolean := True;
      Sample_Report_Count : Natural := 50;
      In_Progress_Preview : Preview_Callback := null);
   --  Create a renderer that will render the scene in World through Camera
   --  into Buffer, using Samples samples per pixel.
   --
   --  If Report_Txt is True, output the progress every time a patch has
   --  processed Sample_Report_Count samples.
   --  to standard output.
   --
   --  If In_Progress_Preview is not null, it is called every time a patch has
   --  processed Sample_Report_Count samples with an in-progress view of the
   --  render.

   function Render (Self : Renderer_T) return Image_T_Acc;
   --  Render the image and return it as a pointer. It is the responsibility
   --  of the caller to free the resulting image.

   type Renderer_Acc is access all Renderer_T;

private

   protected type Text_Reporter
     (Threshold : Positive; Total_Samples : Positive)
   is
      procedure Report_New_Samples (Count : Positive);
   private
      Quotient, Reminder : Natural := 0;
   end Text_Reporter;

   task type Dispatcher_T (Renderer : Renderer_Acc) is
      entry Signal_Ready (Id : Positive);
      entry Start_Render;
      entry Wait_Completion;
   end Dispatcher_T;

   type Dispatcher_Acc is access all Dispatcher_T;

   type Text_Reporter_Acc is access all Text_Reporter;

   task type Patch_Renderer_T (Id : Natural; Renderer : Renderer_Acc) is
      entry Render_Patch (Patch_Line, Patch_Col : Natural);
      entry Shut_Down;
   end Patch_Renderer_T;
   --  Render the patch in Buff, considering an image of total dimensions
   --  Image_Width x Image_Height, the patch being offset from the top left
   --  corner by Line_Offset, Col_Offset.
   --
   --  Buff is supposed to be already allocated.

   type Patch_Acc is access Patch_Renderer_T;

   type Patch_Arr is array (Natural range <>) of Patch_Acc;

   type Patch_Arr_Acc is access Patch_Arr;

   type Renderer_T is new Ada.Finalization.Limited_Controlled with record
      Camera           : Camera_T;
      Preview_Buff     : Image_T_Acc;
      Patches          : Image_Arr_Acc;
      IW, IH           : Positive;     --  Image Height, Image Width
      PW, PH           : Positive;     --  Patch Height, Patch Width
      NW, NH           : Positive;
      Samples          : Positive;
      Txt_Reporter     : Text_Reporter_Acc;
      World            : Hittable_Acc;
      Preview          : Preview_Callback;
      Rep_Count        : Positive;
      Renderers        : Patch_Arr_Acc;
      Dispatcher       : Dispatcher_Acc;
   end record;

end Renderer;