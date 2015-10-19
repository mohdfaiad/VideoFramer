unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls,
  LUX.Vision.OpenCV, LUX.Vision.OpenCV.Capture;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Memo1: TMemo;
    ScrollBar1: TScrollBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
  private
    { private 宣言 }
  public
    { public 宣言 }
    _Video :TocvVideo;
    _Image :TocvBitmap4;
    ///// メソッド
    procedure ShowInfo;
    procedure ShowFrame;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.ShowInfo;
begin
     with Memo1.Lines do
     begin
          Clear;

          with _Video do
          begin
               Add( '・PosMsec     = ' + PosMsec    .ToString );
               Add( '・PosFrames   = ' + PosFrames  .ToString );
               Add( '・PosAviRatio = ' + PosAviRatio.ToString );
               Add( '・FrameWidth  = ' + FrameWidth .ToString );
               Add( '・FrameHeight = ' + FrameHeight.ToString );
               Add( '・FPS         = ' + FPS        .ToString );
               Add( '・FourCC      = ' + FourCC               );
               Add( '・FrameCount  = ' + FrameCount .ToString );
          end;
     end;
end;

procedure TForm1.ShowFrame;
begin
     with _Video do
     begin
          QueryFrame;

          Frame.CopyTo( _Image );
     end;

     _Image.CopyTo( Image1.Bitmap );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _Video := TocvVideo.Create( '..\..\_DATA\Movie.mp4' );

     with _Video do
     begin
          _Image := TocvBitmap4.Create( FrameWidth, FrameHeight );

          Image1.Bitmap.SetSize( FrameWidth, FrameHeight );

          ScrollBar1.Max := FrameCount - 1;
     end;

     ShowInfo;
     ShowFrame;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Video.Free;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
     _Video.PosFrames := Round( ScrollBar1.Value );

     ShowInfo;
     ShowFrame;
end;

end. //######################################################################### ■
