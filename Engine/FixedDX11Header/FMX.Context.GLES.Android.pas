﻿{*******************************************************}
{                                                       }
{              Delphi FireMonkey Platform               }
{                                                       }
{ Copyright(c) 2016 Embarcadero Technologies, Inc.      }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit FMX.Context.GLES.Android;

interface

{$SCOPEDENUMS ON}

uses
  System.Types, System.Classes, Androidapi.Egl, FMX.Types3D, FMX.Context.GLES;

type
  TCustomAndroidContext = class(TCustomContextOpenGL)
  private const
    AndroidMaxLightCount = 1;
  private class var
    SharedMultisamples: Integer;
  protected class var
    FSharedDisplay: EGLDisplay;
    FSharedSurface: EGLSurface;
    FSharedContext: EGLContext;
    FFrozen: Boolean;
    class function GetSharedContext: EGLContext; static;
  protected
    class procedure CreateSharedContext; override;
    class procedure DestroySharedContext; override;
    function GetIndexBufferSupport: TContext3D.TIndexBufferSupport; override;
  public
    class function CreateContextFromActivity(const AWidth, AHeight: Integer; const AMultisample: TMultisample;
      const ADepthStencil: Boolean): TCustomAndroidContext;
    class procedure FreezeSharedContext;
    class procedure UnfreezeSharedContext;
    class procedure RecreateSharedContext;
    class property SharedDisplay: EGLDisplay read FSharedDisplay;
    class property SharedSurface: EGLSurface read FSharedSurface;
    class property SharedContext: EGLContext read GetSharedContext;
    class function IsContextAvailable: Boolean; override;

    class function MaxLightCount: Integer; override;
    class function Style: TContextStyles; override;
  end;

procedure RegisterContextClasses;
procedure UnregisterContextClasses;

implementation

uses
  Androidapi.Gles2, Androidapi.Gles2ext, Androidapi.Eglext, Androidapi.NativeWindow, FMX.Consts, FMX.Types,
  FMX.Materials, FMX.Graphics, FMX.Forms, FMX.Forms3D, FMX.Platform, FMX.Platform.Android, System.SysUtils, 
  System.Messaging;

const
  OES_packed_depth_stencil = 'GL_OES_packed_depth_stencil';
  OES_depth24 = 'GL_OES_depth24';
  NV_depth_nonlinear = 'GL_NV_depth_nonlinear';

{ TCustomAndroidContext }

function TCustomAndroidContext.GetIndexBufferSupport: TContext3D.TIndexBufferSupport;
begin
  // AVD crash workaround: although 32-bit index buffer appears to be supported, using it leads to emulator crash.
  Result := TIndexBufferSupport.Int16;
end;

class procedure TCustomAndroidContext.CreateSharedContext;
const
  ContextAttributes: array[0..2] of EGLint = (EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE);
type
  TContextAttributes = array of EGLint;

  function CreateDummyContext: Boolean;
  const
    DummyConfig: array[0..4] of EGLint = (EGL_BUFFER_SIZE, 32, EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT, EGL_NONE);
  var
    Config: EGLConfig;
    NumConfigs: EGLint;
    Format: EGLint;
  begin
    if eglChooseConfig(FSharedDisplay, @DummyConfig[0], @Config, 1, @NumConfigs) = 0 then
      Exit(False);

    eglGetConfigAttrib(FSharedDisplay, Config, EGL_NATIVE_VISUAL_ID, @Format);
    ANativeWindow_setBuffersGeometry(GetAndroidApp^.window, 0, 0, Format);

    FSharedSurface := eglCreateWindowSurface(FSharedDisplay, Config, GetAndroidApp^.window, nil);
    FSharedContext := eglCreateContext(FSharedDisplay, Config, EGL_NO_CONTEXT, @ContextAttributes[0]);

    if eglMakeCurrent(FSharedDisplay, FSharedSurface, FSharedSurface, FSharedContext) = 0 then
      Exit(False);

    Result := True;
  end;

  procedure DestroyDummyContext;
  begin
    eglMakeCurrent(FSharedDisplay, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
    eglDestroyContext(FSharedDisplay, FSharedContext);
    eglDestroySurface(FSharedDisplay, FSharedSurface);
  end;

  function GetDesiredMultisamples: Integer;
  const
    HighQualitySamples = 4;
  begin
    Result := 0;
    if Application.MainForm = nil then
      Exit;

    if (Application.MainForm is TCustomForm) and
      (TCustomForm(Application.MainForm).Quality = TCanvasQuality.HighQuality) then
      Exit(HighQualitySamples);

    if Application.MainForm is TCustomForm3D then
      Result := MultisampleTypeToNumber(TCustomForm3D(Application.MainForm).Multisample);
  end;

  procedure AddAttributes(var ContextAttributes: TContextAttributes; const Attributes: array of EGLint);
  var
    I, Index: Integer;
  begin
    Index := Length(ContextAttributes);
    SetLength(ContextAttributes, Index + Length(Attributes));

    for I := 0 to Length(Attributes) - 1 do
      ContextAttributes[Index + I] := Attributes[I];
  end;

var
  Config: EGLConfig;
  ConfigAttribs: TContextAttributes;
  NumConfigs: EGLint;
  Format: EGLint;
  RenderingSetupService: IFMXRenderingSetupService;
  ColorBits, DepthBits, Multisamples: Integer;
  Stencil: Boolean;
begin
  if (FSharedContext = nil) and not FFrozen and (GetAndroidApp <> nil) and (GetAndroidApp^.window <> nil) then
  begin
    FSharedDisplay := eglGetDisplay(EGL_DEFAULT_DISPLAY);

    if eglInitialize(FSharedDisplay, nil, nil) = 0 then
      RaiseContextExceptionFmt(@SCannotCreateOpenGLContext, ['eglInitialize']);

    // Determine initial number of multisamples based on form quality settings.
    Multisamples := SharedMultisamples;
    if Multisamples < 1 then
      Multisamples := GetDesiredMultisamples;

    // Default rendering configuration.
    ColorBits := 24;
    DepthBits := 24;
    Stencil := True;

    // Request adjustment of rendering configuration.
    if TPlatformServices.Current.SupportsPlatformService(IFMXRenderingSetupService, RenderingSetupService) then
      RenderingSetupService.Invoke(ColorBits, DepthBits, Stencil, Multisamples);

    { Extensions must be obtained prior creating main OpenGL ES context for configuring depth buffer that is higher
      than 16 bits or enabling multisampling. In this case, create a dummy OpenGL ES context and read OpenGL ES
      extensions and renderer information. }
    if (DepthBits > 16) or (Multisamples > 0) then
    begin
      if not CreateDummyContext then
        RaiseContextExceptionFmt(@SCannotCreateOpenGLContext, ['CreateDummyContext']);
      try
        GetExtensions;
      finally
        DestroyDummyContext;
      end;
    end;

    // Prepare final context configuration.
    SetLength(ConfigAttribs, 0);
    AddAttributes(ConfigAttribs, [EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT]);

    // Color Bitdepth.
    if ColorBits > 16 then
      AddAttributes(ConfigAttribs, [EGL_BUFFER_SIZE, 32, EGL_RED_SIZE, 8, EGL_GREEN_SIZE, 8, EGL_BLUE_SIZE, 8])
    else
      AddAttributes(ConfigAttribs, [EGL_BUFFER_SIZE, 16, EGL_RED_SIZE, 5, EGL_GREEN_SIZE, 5, EGL_BLUE_SIZE, 5]);

    // Depth Buffer.
    if DepthBits > 0 then
    begin
      if DepthBits > 16 then
      begin
        if Extensions[OES_depth24] then
          // 24-bit depth buffer is supported.
          AddAttributes(ConfigAttribs, [EGL_DEPTH_SIZE, 24])
        else
        begin // No 24-bit depth support.
          AddAttributes(ConfigAttribs, [EGL_DEPTH_SIZE, 16]);

          // Tegra 3 GPU has extension for improved accuracy of depth buffer.
          if Extensions[NV_depth_nonlinear] then
            AddAttributes(ConfigAttribs, [EGL_DEPTH_ENCODING_NV, EGL_DEPTH_ENCODING_NONLINEAR_NV]);
        end;
      end
      else // 16-bit depth buffer
        AddAttributes(ConfigAttribs, [EGL_DEPTH_SIZE, 16]);
    end;

    // Stencil Buffer.
    if Stencil then
      AddAttributes(ConfigAttribs, [EGL_STENCIL_SIZE, 8]);

    // Multisamples.
    if Multisamples > 0 then
    begin
      // Tegra 3 GPU does not support MSAA (it only does CSAA).
      if not Extensions.Renderer.Contains('TEGRA 3') then
        AddAttributes(ConfigAttribs, [EGL_SAMPLE_BUFFERS, 1, EGL_SAMPLES, Multisamples]);
    end;

    // Close the configuration.
    AddAttributes(ConfigAttribs, [EGL_NONE]);

    if eglChooseConfig(FSharedDisplay, @ConfigAttribs[0], @Config, 1, @NumConfigs) = 0 then
      RaiseContextExceptionFmt(@SCannotCreateOpenGLContext, ['eglChooseConfig']);;

    eglGetConfigAttrib(FSharedDisplay, Config, EGL_NATIVE_VISUAL_ID, @Format);
    ANativeWindow_setBuffersGeometry(GetAndroidApp^.window, 0, 0, Format);

    FSharedSurface := eglCreateWindowSurface(FSharedDisplay, Config, GetAndroidApp^.window, nil);
    FSharedContext := eglCreateContext(FSharedDisplay, Config, EGL_NO_CONTEXT, @ContextAttributes[0]);

    if eglMakeCurrent(FSharedDisplay, FSharedSurface, FSharedSurface, FSharedContext) = 0 then
    begin
      eglDestroyContext(FSharedDisplay, FSharedContext);
      eglDestroySurface(FSharedDisplay, FSharedSurface);
      RaiseContextExceptionFmt(@SCannotCreateOpenGLContext, ['eglMakeCurrent']);
    end;

  end;
end;

class procedure TCustomAndroidContext.DestroySharedContext;
begin
  if FSharedContext <> nil then
  begin
    DestroyPrograms;
    eglDestroySurface(eglGetCurrentDisplay, FSharedSurface);
    eglDestroyContext(eglGetCurrentDisplay, FSharedContext);
    FSharedContext := nil;
  end;
end;

class procedure TCustomAndroidContext.FreezeSharedContext;
begin
  if FSharedContext <> nil then
  begin
    TMessageManager.DefaultManager.SendMessage(nil, TContextBeforeLosingMessage.Create, False);
    TMessageManager.DefaultManager.SendMessage(nil, TContextLostMessage.Create, False);
    DestroySharedContext;
  end;
  eglMakeCurrent(FSharedDisplay, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
  FFrozen := True;
end;

class procedure TCustomAndroidContext.UnfreezeSharedContext;
begin
  FFrozen := False;
  CreateSharedContext;
  ResetStates;
  TMessageManager.DefaultManager.SendMessage(nil, TContextResetMessage.Create, True);
end;

class function TCustomAndroidContext.IsContextAvailable: Boolean;
begin
  Result := (FSharedContext <> nil) and not FFrozen;
end;

class function TCustomAndroidContext.MaxLightCount: Integer;
begin
  Result := AndroidMaxLightCount;
end;

class procedure TCustomAndroidContext.RecreateSharedContext;
begin
  FreezeSharedContext;
  UnfreezeSharedContext;
end;

class function TCustomAndroidContext.Style: TContextStyles;
begin
  Result := [TContextStyle.RenderTargetFlipped, TContextStyle.Fragile];
end;

class function TCustomAndroidContext.GetSharedContext: EGLContext;
begin
  CreateSharedContext;
  Result := FSharedContext;
end;

{ TContextAndroid }

type
  TContextAndroid = class(TCustomAndroidContext)
  private
    HandlesLostResetMessages: Boolean;
    FActivity: Boolean;
    FContextBeforeLosingId: Integer;
    FContextLostId: Integer;
    FContextResetId: Integer;
    FLostBits: Pointer;
    function SupportBuffers: Boolean;
    procedure ContextBeforeLosingHandler(const Sender: TObject; const Msg: TMessage);
    procedure ContextLostHandler(const Sender: TObject; const Msg: TMessage);
    procedure ContextResetHandler(const Sender: TObject; const Msg: TMessage);
    function CreateFrameBuffer(const BufferWidth, BufferHeight: GLint; const TextureHandle: GLuint;
      const DepthStencil: Boolean; out FrameBuf, DepthBuf, StencilBuf: GLuint): Boolean;
  protected
    function GetValid: Boolean; override;
    class function GetShaderArch: TContextShaderArch; override;
    procedure DoSetScissorRect(const ScissorRect: TRect); override;
    { buffer }
    procedure DoCreateBuffer; override;
    procedure DoFreeBuffer; override;
    { constructors }
    constructor CreateFromWindow(const AParent: TWindowHandle; const AWidth, AHeight: Integer;
      const AMultisample: TMultisample; const ADepthStencil: Boolean); override;
    constructor CreateFromTexture(const ATexture: TTexture; const AMultisample: TMultisample;
      const ADepthStencil: Boolean); override;
    constructor CreateFromActivity(const AWidth, AHeight: Integer; const AMultisample: TMultisample;
      const ADepthStencil: Boolean);
  public
    destructor Destroy; override;
  end;

{ TContextAndroid }

constructor TContextAndroid.CreateFromActivity(const AWidth, AHeight: Integer; const AMultisample: TMultisample;
  const ADepthStencil: Boolean);
begin
  FActivity := True;
  inherited CreateFromWindow(nil, AWidth, AHeight, AMultisample, ADepthStencil);
  CreateSharedContext;
  HandlesLostResetMessages := False;
end;

constructor TContextAndroid.CreateFromWindow(const AParent: TWindowHandle; const AWidth, AHeight: Integer;
  const AMultisample: TMultisample; const ADepthStencil: Boolean);
begin
  FSupportMS := False;
  inherited;

  if (FSharedContext = nil) and (SharedMultisamples < 1) then
    SharedMultisamples := MultisampleTypeToNumber(AMultisample);

  CreateSharedContext;

  if SupportBuffers then
  begin
    CreateBuffer;
    FContextBeforeLosingId := TMessageManager.DefaultManager.SubscribeToMessage(TContextBeforeLosingMessage,
      ContextBeforeLosingHandler);
    FContextLostId := TMessageManager.DefaultManager.SubscribeToMessage(TContextLostMessage, ContextLostHandler);
    FContextResetId := TMessageManager.DefaultManager.SubscribeToMessage(TContextResetMessage, ContextResetHandler);
    HandlesLostResetMessages := True;
  end;
end;

constructor TContextAndroid.CreateFromTexture(const ATexture: TTexture; const AMultisample: TMultisample;
  const ADepthStencil: Boolean);
begin
  FSupportMS := False;
  inherited;
  FContextBeforeLosingId := TMessageManager.DefaultManager.SubscribeToMessage(TContextBeforeLosingMessage,
    ContextBeforeLosingHandler);
  FContextLostId := TMessageManager.DefaultManager.SubscribeToMessage(TContextLostMessage, ContextLostHandler);
  FContextResetId := TMessageManager.DefaultManager.SubscribeToMessage(TContextResetMessage, ContextResetHandler);
  HandlesLostResetMessages := True;
end;

destructor TContextAndroid.Destroy;
begin
  if HandlesLostResetMessages then
  begin
    TMessageManager.DefaultManager.Unsubscribe(TContextLostMessage, FContextLostId);
    TMessageManager.DefaultManager.Unsubscribe(TContextResetMessage, FContextResetId);
    TMessageManager.DefaultManager.Unsubscribe(TContextBeforeLosingMessage, FContextBeforeLosingId);
    HandlesLostResetMessages := False;
  end;

  inherited;
end;

function TContextAndroid.SupportBuffers: Boolean;
begin
  Result := (Parent <> nil) and TAndroidWindowHandle(Parent).RequiresComposition;
end;

procedure TContextAndroid.ContextBeforeLosingHandler(const Sender: TObject; const Msg: TMessage);
var
  Pitch: Integer;
  OldFBO: GLuint;
begin
  if (Parent = nil) and (Texture <> nil) then
  begin
    if Texture.Handle = 0 then
      RaiseContextExceptionFmt(@SErrorInContextMethod, ['ContextBeforeLosingHandler']);

    Pitch := Width * Texture.BytesPerPixel;
    GetMem(FLostBits, Height * Pitch);

    glGetIntegerv(GL_FRAMEBUFFER_BINDING, @OldFBO);
    glBindFramebuffer(GL_FRAMEBUFFER, FFrameBuf);
    glReadPixels(0, 0, Width, Height, GL_RGBA, GL_UNSIGNED_BYTE, FLostBits);
    glBindFramebuffer(GL_FRAMEBUFFER, OldFBO);
  end;
end;

procedure TContextAndroid.ContextLostHandler(const Sender: TObject; const Msg: TMessage);
begin
  FreeBuffer;
end;

procedure TContextAndroid.ContextResetHandler(const Sender: TObject; const Msg: TMessage);
var
  OldTexture: GLuint;
begin
  if (Parent = nil) and (Texture <> nil) and (FLostBits <> nil) then
  begin
    if Texture.Handle = 0 then
      Texture.Initialize;

    glGetIntegerv(GL_TEXTURE_BINDING_2D, @OldTexture);
    glBindTexture(GL_TEXTURE_2D, Texture.Handle);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, Texture.Width, Texture.Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, FLostBits);
    glBindTexture(GL_TEXTURE_2D, OldTexture);

    FreeMem(FLostBits);
    FLostBits := nil;
  end;
  CreateBuffer;
end;

function TContextAndroid.CreateFrameBuffer(const BufferWidth, BufferHeight: GLint; const TextureHandle: GLuint;
  const DepthStencil: Boolean; out FrameBuf, DepthBuf, StencilBuf: GLuint): Boolean;
var
  Status: GLint;
begin
  glGenFramebuffers(1, @FrameBuf);
  glBindFramebuffer(GL_FRAMEBUFFER, FrameBuf);

  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, TextureHandle, 0);

  if DepthStencil then
  begin
    if Extensions[OES_packed_depth_stencil] then
    begin // using OES_packed_depth_stencil extension
      glGenRenderbuffers(1, @DepthBuf);
      glBindRenderbuffer(GL_RENDERBUFFER, DepthBuf);
      glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8_OES, BufferWidth, BufferHeight);
      glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, DepthBuf);
      glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, DepthBuf);
      glBindRenderbuffer(GL_RENDERBUFFER, 0);
      StencilBuf := 0;
    end
    else
    begin // attempting more conservative approach
      glGenRenderbuffers(1, @DepthBuf);
      glBindRenderbuffer(GL_RENDERBUFFER, DepthBuf);
      glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, BufferWidth, BufferHeight);
      glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, DepthBuf);

      glGenRenderbuffers(1, @StencilBuf);
      glBindRenderbuffer(GL_RENDERBUFFER, StencilBuf);
      glRenderbufferStorage(GL_RENDERBUFFER, GL_STENCIL_INDEX8, BufferWidth, BufferHeight);
      glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, StencilBuf);
      glBindRenderbuffer(GL_RENDERBUFFER, 0);
    end;
  end;

  Status := glCheckFramebufferStatus(GL_FRAMEBUFFER);
  if (Status <> GL_FRAMEBUFFER_COMPLETE) or GLHasAnyErrors then
  begin
    if StencilBuf <> 0 then
    begin
      glDeleteRenderbuffers(1, @StencilBuf);
      StencilBuf := 0;
    end;

    if DepthBuf <> 0 then
    begin
      glDeleteRenderbuffers(1, @DepthBuf);
      DepthBuf := 0;
    end;

    if FrameBuf <> 0 then
    begin
      glDeleteFramebuffers(1, @FrameBuf);
      FrameBuf := 0;
    end;

    Result := False;
  end
  else
    Result := True;
end;

procedure TContextAndroid.DoCreateBuffer;
var
  OldFBO: GLuint;
  WindowTexture: TTexture;
begin
  if IsContextAvailable and SupportBuffers and (Width > 0) and (Height > 0) then
  begin
    WindowHandleToPlatform(Parent).CreateTexture;
    WindowTexture := WindowHandleToPlatform(Parent).Texture;

    glGetIntegerv(GL_FRAMEBUFFER_BINDING, @OldFBO);
    try
      if (not CreateFrameBuffer(WindowTexture.Width, WindowTexture.Height, WindowTexture.Handle,
        DepthStencil, FFrameBuf, FDepthBuf, FStencilBuf)) and DepthStencil then
      begin
        if not CreateFrameBuffer(WindowTexture.Width, WindowTexture.Height, WindowTexture.Handle,
          False, FFrameBuf, FDepthBuf, FStencilBuf) then
          RaiseContextExceptionFmt(@SCannotCreateRenderBuffers, [ClassName]);
      end;
    finally
      glBindFramebuffer(GL_FRAMEBUFFER, OldFBO);
    end;
  end;

  if IsContextAvailable and (Texture <> nil) then
  begin
    if Texture.Handle = 0 then
      Texture.Initialize;

    glGetIntegerv(GL_FRAMEBUFFER_BINDING, @OldFBO);
    try
      if (not CreateFrameBuffer(Width, Height, Texture.Handle, DepthStencil, FFrameBuf, FDepthBuf, FStencilBuf)) and
        DepthStencil then
      begin
        if not CreateFrameBuffer(Width, Height, Texture.Handle, False, FFrameBuf, FDepthBuf, FStencilBuf) then
          RaiseContextExceptionFmt(@SCannotCreateRenderBuffers, [ClassName]);
      end;
    finally
      glBindFramebuffer(GL_FRAMEBUFFER, OldFBO);
    end;
  end;
end;

procedure TContextAndroid.DoFreeBuffer;
begin
  if IsContextAvailable and SupportBuffers and (Parent <> nil) then
    WindowHandleToPlatform(Parent).DestroyTexture;
  inherited;
end;

class function TContextAndroid.GetShaderArch: TContextShaderArch;
begin
  Result := TContextShaderArch.Android;
end;

function TContextAndroid.GetValid: Boolean;
begin
  Result := IsContextAvailable;
  if Result then
  begin
    if eglGetCurrentContext <> FSharedContext then
    begin
      eglMakeCurrent(eglGetCurrentDisplay, FSharedSurface, FSharedSurface, FSharedContext);
      if GLHasAnyErrors then
        RaiseContextExceptionFmt(@SErrorInContextMethod, ['GetValid']);
    end;
  end;
end;

procedure TContextAndroid.DoSetScissorRect(const ScissorRect: TRect);
var
  R: TRect;
begin
  R := Rect(Round(ScissorRect.Left * Scale), Round(ScissorRect.Top * Scale),
    Round(ScissorRect.Right * Scale), Round(ScissorRect.Bottom * Scale));

  if Texture <> nil then
    glScissor(R.Left, Height - R.Bottom, R.Width, R.Height)
  else
    glScissor(R.Left, Round(Height * Scale) - R.Bottom, R.Width, R.Height);

  if (GLHasAnyErrors()) then
    RaiseContextExceptionFmt(@SErrorInContextMethod, ['DoSetScissorRect']);
end;

class function TCustomAndroidContext.CreateContextFromActivity(const AWidth, AHeight: Integer;
  const AMultisample: TMultisample; const ADepthStencil: Boolean): TCustomAndroidContext;
begin
  Result := TContextAndroid.CreateFromActivity(AWidth, AHeight, AMultisample, ADepthStencil);
end;

procedure RegisterContextClasses;
begin
  TContextManager.RegisterContext(TContextAndroid, True);
end;

procedure UnregisterContextClasses;
begin
  TContextAndroid.DestroySharedContext;
end;

end.
