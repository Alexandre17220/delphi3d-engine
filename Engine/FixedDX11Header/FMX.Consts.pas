{*******************************************************}
{                                                       }
{              Delphi FireMonkey Platform               }
{                                                       }
{ Copyright(c) 2016 Embarcadero Technologies, Inc.      }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit FMX.Consts;

interface

{$SCOPEDENUMS ON}
uses
  System.Math.Vectors;

const
  StyleDescriptionName = 'Description';        // do not localize
  SMainItemStyle = 'menubaritemstyle';         // do not localize
  SSeparatorStyle = 'menuseparatorstyle';      // do not localize

  SMenuBarDisplayName = 'Menu Bar';            // do not localize
  SMenuAppDisplayName = 'Menu Application';    // do not localize

  SBMPImageExtension = '.bmp';                 // do not localize
  SJPGImageExtension = '.jpg';                 // do not localize
  SJPEGImageExtension = '.jpeg';               // do not localize
  SJP2ImageExtension = '.jp2';
  SPNGImageExtension = '.png';                 // do not localize
  SGIFImageExtension = '.gif';                 // do not localize
  STIFImageExtension = '.tif';                 // do not localize
  STIFFImageExtension = '.tiff';               // do not localize
  SICOImageExtension = '.ico';                 // do not localize
  SHDPImageExtension = '.hdp';                 // do not localize
  SWMPImageExtension = '.wmp';                 // do not localize
  STGAImageExtension = '.tga';                 // do not localize
  SICNSImageExtension = '.icns';               // do not localize

  // Keys for TPlatformServices.GlobalFlags
  GlobalDisableStylusGestures: string = 'GlobalDisableStylusGestures'; // do not localize
  EnableGlassFPSWorkaround: string = 'EnableGlassFPSWorkaround'; // do not localize

  FormUseDefaultPosition: Integer = -1; // same as CW_USEDEFAULT = DWORD($80000000)

type
  TEpsilonHelper = record helper for TEpsilon
  const
    Scale = 1E-4;
    FontSize = 1E-2;
    Position = 1E-3;
    Angle = 1E-4;
  end;

resourcestring

  { Error Strings }
  SInvalidPrinterOp       = 'Operation auf ausgewähltem Drucker nicht verfügbar';
  SInvalidPrinter         = 'Ausgewählter Drucker ist ungültig';
  SPrinterIndexError      = 'Druckerindex außerhalb des zulässigen Bereichs';
  SDeviceOnPort           = '%s an %s';
  SNoDefaultPrinter       = 'Aktuell ist kein Standarddrucker ausgewählt';
  SNotPrinting            = 'Der Drucker druckt aktuell nicht';
  SPrinting               = 'Druckvorgang läuft';
  SInvalidPrinterSettings = 'Ungültige Einstellungen für Druckauftrag';
  SInvalidPageFormat      = 'Ungültige Einstellungen für Seitenformat';
  SCantStartPrintJob      = 'Druckauftrag kann nicht gestartet werden';
  SCantEndPrintJob        = 'Druckauftrag kann nicht beendet werden';
  SCantPrintNewPage       = 'Seite kann nicht zum Drucken hinzugefügt werden';
  SCantSetNumCopies       = 'Anzahl der Dokumentkopien kann nicht geändert werden';
  StrCannotFocus          = 'Fokus kann nicht auf dieses Steuerelement gesetzt werden';
  SResultCanNotBeNil      = 'Die Funktion '#39'%s'#39' darf keinen nil-Wert zurückgeben';
  SKeyAcceleratorConflict = 'Eib Zugriffstasten-Konflikt ist aufgetreten';

  SInvalidStyleForPlatform = 'Der ausgewählte Stil steht für die aktuell ausgewählte Zielplattform nicht zur Verfügung. Sie können einen benutzerdefinierten Stil auswählen oder das Stilbuch entfernen, damit FireMonkey den nativen Stil zur Laufzeit automatisch laden kann';
  SCannotLoadStyleFromStream = 'Stil kann nicht aus Stream geladen werden';
  SCannotLoadStyleFromRes = 'Stil kann nicht aus Ressource geladen werden';
  SCannotLoadStyleFromFile = 'Stil kann nicht aus Datei %s geladen werden';
  SCannotChangeInLiveBinding = 'Diese Eigenschaft kann bei der Verwendung von LiveBindings nicht geändert werden';

  SInvalidPrinterClass    = 'Ungültige Druckerklasse: %s';
  SPromptArrayTooShort    = 'Länge des Werte-Arrays muss >= der Länge des Prompt-Arrays sein';
  SPromptArrayEmpty       = 'Prompt-Array darf nicht leer sein';
  SUnsupportedInputQuery  = 'Nicht unterstützte InputQuery-Felder';
  SInvalidColorString     = 'Ungültiger Farb-String';

  SInvalidFmxHandle = 'Ungültiges FMX-Handle: %s%.*x';
  SInvalidFmxHandleClass = 'Ungültiges Handle. [%s] muss Instanz von [%s] sein';
  SDelayRelease = 'Zurzeit können Sie das Fenster-Handle nicht ändern';
  SMediaGlobalError  = 'Mediensteuerelement kann nicht erstellt werden';
  SMediaFileNotSupported  = 'Nicht unterstützte Mediendatei %s%';
  SUnsupportedPlatformService = 'Nicht unterstützter Plattformdienst: %s';
  SServiceAlreadyRegistered = 'Dienst %s bereits registriert';
  SUnsupportedOSVersion = 'Nicht unterstützte Betriebssystemversion: %s';
  SUnsupportedMultiInstance = 'Eine Instanz von "%s" ist bereits vorhanden. Mehrere Instanzen werden nicht unterstützt';
  SNotInstance = 'Instanz von "%s" wurde nicht erstellt';
  SFlasherNotRegistered = 'Klasse des Blink-Steuerelements ist nicht registriert';
  SUnsupportedInterface = 'Klasse %0:s unterstützt Interface %1:s nicht';
  SNullException = 'Behandelte Null-Exception';
  SCannotGetDeviceIDForTestAds = 'Abrufen der Geräte-ID nicht möglich. Verwenden Sie SetTestModeDeviceID.';

  SErrorShortCut = 'Eine unbekannte Tastenkombination %s';
  SEUseHeirs = 'Sie können nur die Erben der Klasse "%s" verwenden';

  SUnavailableMenuId = 'Menü-ID kann nicht erstellt werden. Alle IDs sind bereits zugewiesen';

  SInvalidGestureID = 'Ungültige Gesten-ID (%d)';
  SInvalidStreamFormat = 'Ungültiges Stream-Format';
  SDuplicateGestureName = 'Doppelter Gestenname: %s';
  SDuplicateRecordedGestureName = 'Eine aufgezeichnete Geste mit der Bezeichnung %s ist bereits vorhanden';
  SControlNotFound = 'Steuerelement nicht gefunden';
  SRegisteredGestureNotFound = 'Die folgenden registrierten Gesten wurden nicht gefunden:'#13#10#13#10'%s';
  SErrorLoadingFile = 'Fehler beim Laden der zuvor gespeicherten Einstellungsdatei: %s'#13#10'Soll sie gelöscht werden?';
  STooManyRegisteredGestures = 'Zu viele registrierte Gesten';
  SDuplicateRegisteredGestureName = 'Eine registrierte Geste mit der Bezeichnung %s ist bereits vorhanden';
  SUnableToSaveSettings = 'Einstellungen konnten nicht gespeichert werden';
  SInvalidGestureName = 'Ungültiger Gestenname (%s)';
  SOutOfRange = 'Wert muss zwischen %d und %d liegen';

  SAddIStylusAsyncPluginError = 'IStylusAsyncPlugin kann nicht hinzugefügt werden: %s';
  SAddIStylusSyncPluginError = 'IStylusSyncPlugin kann nicht hinzugefügt werden: %s';
  SRemoveIStylusAsyncPluginError = 'IStylusAsyncPlugin kann nicht entfernt werden: %s';
  SRemoveIStylusSyncPluginError = 'IStylusSyncPlugin kann nicht entfernt werden: %s';
  SStylusHandleError = 'Fenster-Handle kann nicht ermittelt oder gesetzt werden: %s';
  SStylusEnableError = 'IRealTimeStylus kann nicht aktiviert oder deaktiviert werden: %s';
  SEnableRecognizerError = 'IGestureRecognizer kann nicht aktiviert oder deaktiviert werden: %s';
  SInitialGesturePointError = 'Startpunkt für Geste kann nicht ermittelt werden';
  SSetStylusGestureError = 'Gesten für Eingabestift können nicht gesetzt werden: %s';
  StrESingleMainMenu = 'Das Hauptmenü darf nur eine einzelne Instanz sein';
  SMainMenuSupportsOnlyTMenuItems = 'Ein Hauptmenü unterstützt nur untergeordnete Elemente von TMenuItem';

  SNoImplementation = 'Keine %s-Implementierung gefunden';
  SNotImplementedOnPlatform = '%s ist auf dieser Plattform nicht implementiert';
  {$IFDEF ANDROID}
  SInputQueryAndroidOverloads = 'Auf der Android-Plattform werden nur Überladungen mit TInputCloseBoxProc oder TInputCloseBoxEvent unterstützt';
  {$ENDIF}

  SBitmapSizeNotEqual = 'Bitmap-Größe muss in Kopieroperation gleich sein';

  SBlockingDialogs = 'Dialogfelder werden blockiert';

  SCannotCreateScrollContent = '%s kann nicht erstellt werden, weil |CreateScrollContent| kein nil-Objekt zurückgeben darf';
  SContentCannotBeNil = 'Darstellung erhielt nil-Inhalt von TPresentedControl. Inhalt darf nicht nil sein.';

  SPointInTextLayoutError = 'Punkt nicht im Layout';
  SCaretLineIncorrect = 'TCaretPosition.Line hat falschen Wert';
  SCaretPosIncorrect = 'TCaretPosition.Pos hat falschen Wert';

  SInvalidSceneUpdatingPairCall = 'Ungültiges Aufrufpaar IScene.DisableUpdating/IScene.EnableUpdating';

  SNoPlatformStyle = 'Kein Plattformstil gefunden'; // happens when there are no platform styles at all
  SInvalidPlatformStyle = 'Kein Plattformstil für die aktuelle Plattform gefunden'; // happens when there are platform styles, just not the right ones
  SNoIDeviceBehaviorBehavior = 'Erforderliches IDeviceBehavior ist nicht registriert';
  SStyleResourceDoesNotExist = 'Stilressource ist nicht vorhanden';

  SDialogMustBeRunInUIThread = 'Meldungen müssen im Haupt-UI-Thread angezeigt werden.';

  { Dialog Strings }
  SMsgDlgWarning = 'Warnung';
  SMsgDlgError = 'Fehler';
  SMsgDlgInformation = 'Informationen';
  SMsgDlgConfirm = 'Bestätigen';
  SMsgDlgYes = 'Ja';
  SMsgDlgNo = 'Nein';
  SMsgDlgOK = 'OK';
  SMsgDlgCancel = 'Abbrechen';
  SMsgDlgHelp = 'Hilfe';
  SMsgDlgHelpNone = 'Keine Hilfe verfügbar';
  SMsgDlgHelpHelp = 'Hilfe';
  SMsgDlgAbort = 'Abbrechen';
  SMsgDlgRetry = 'Wiederholen';
  SMsgDlgIgnore = 'Ignorieren';
  SMsgDlgAll = 'Alle';
  SMsgDlgNoToAll = 'Alle Nein';
  SMsgDlgYesToAll = 'A&lle Ja';
  SMsgDlgClose = 'Schließen';

  SWindowsVistaRequired = 'Für %s ist Windows Vista oder höher erforderlich';

  SUsername = '&Benutzername';
  SPassword = '&Passwort';
  SDomain = '&Domäne';
  SLogin = 'Anmelden';

  { Menus }
  SMenuAppQuit = '%s beenden';
  SMenuCloseWindow = 'Fenster schließen';
  SMenuAppHide = '%s verbergen';
  SMenuAppHideOthers = 'Andere verbergen';
  SAppDesign = '<Anwendung.Titel>';
  SAppDefault = 'Anwendung';
  SGotoTab = 'Zu %s';
  SGotoNilTab = 'Zu <Registerkarte> wechseln';
  SMediaPlayerStart = 'Wiedergeben';
  SMediaPlayerPause = 'Unterbrechen';
  SMediaPlayerStop = 'Stoppen';
  SMediaPlayerVolume = '%3.0F %%';
  
  SMsgGooglePlayServicesNeedUpdating = 'Google Play Services muss aktualisiert werden. Bitte aktualisieren Sie Google Play Services im Play Store, und starten Sie dann die Anwendung neu';
const
  SChrHorizontalEllipsis = Chr($2026);
{$IFDEF MACOS}
  SmkcBkSp = Chr($232B); // (NSBackspaceCharacter);
  SmkcTab = Chr($21E5); // (NSTabCharacter);
  SmkcEsc = Chr($238B);
  SmkcEnter = Chr($21A9); // (NSCarriageReturnCharacter);
  SmkcPgUp = Chr($21DE); // (NSPageUpFunctionKey);
  SmkcPgDn = Chr($21DF); // (NSPageDownFunctionKey);
  SmkcEnd = Chr($2198); // (NSEndFunctionKey);
  SmkcDel = Chr($2326); // (NSDeleteCharacter);
  SmkcHome = Chr($2196); // (NSHomeFunctionKey);
  SmkcLeft = Chr($2190); // (NSLeftArrowFunctionKey);
  SmkcUp = Chr($2191); // (NSUpArrowFunctionKey);
  SmkcRight = Chr($2192); // (NSRightArrowFunctionKey);
  SmkcDown = Chr($2193); // (NSDownArrowFunctionKey);
  SmkcNumLock = Chr($2327);
  SmkcPara = Chr($00A7);
  SmkcShift = Chr($21E7);
  SmkcCtrl = Chr($2303);
  SmkcAlt = Chr($2325);
  SmkcCmd = Chr($2318);
  // Specific keys for OSX
  SmkcBacktab= Chr($21E4);
  SmkcIbLeft= Chr($21E0);
  SmkcIbUp= Chr($21E1);
  SmkcIbRight= Chr($21E2);
  SmkcIbDown= Chr($21E3);
  SmkcIbEnter= Chr($2305);
  SmkcIbHelp= Chr($225F);
{$ELSE}
  SmkcBkSp = 'BkSp';
  SmkcTab = 'Tab';
  SmkcEsc = 'Esc';
  SmkcEnter = 'Enter';
  SmkcPgUp = 'PgUp';
  SmkcPgDn = 'PgDn';
  SmkcEnd = 'End';
  SmkcDel = 'Del';
  SmkcHome = 'Home';
  SmkcLeft = 'Left';
  SmkcUp = 'Up';
  SmkcRight = 'Right';
  SmkcDown = 'Down';
  SmkcNumLock = 'Num Lock';
  SmkcPara = 'Paragraph';
  SmkcShift = 'Shift+';
  SmkcCtrl = 'Ctrl+';
  SmkcAlt = 'Alt+';
  SmkcCmd = 'Cmd+';

  SmkcLWin = 'Left Win';
  SmkcRWin = 'Right Win';
  SmkcApps = 'Application';
  SmkcClear = 'Clear';
  SmkcScroll = 'Scroll Lock';
  SmkcCancel = 'Break';
  SmkcLShift = 'Left Shift';
  SmkcRShift = 'Right Shift';
  SmkcLControl = 'Left Ctrl';
  SmkcRControl = 'Right Ctrl';
  SmkcLMenu = 'Left Alt';
  SmkcRMenu = 'Right Alt';
  SmkcCapital = 'Caps Lock';
{$ENDIF}
  SmkcOem102 = 'Oem \';
  SmkcSpace = 'Space';
  SmkcNext = 'Next';
  SmkcBack = 'Back';
  SmkcIns = 'Ins';
  SmkcPause = 'Pause';
  SmkcCamera = 'Camera';
  SmkcBrowserBack= 'BrowserBack';
  SmkcHardwareBack= 'HardwareBack';
  SmkcNum = 'Num %s';

resourcestring
  SEditUndo = 'Rückgängig';
  SEditCopy = 'Kopieren';
  SEditCut = 'Ausschneiden';
  SEditPaste = 'Einfügen';
  SEditDelete = 'Löschen';
  SEditSelectAll = 'Alles markieren';

  SAseLexerTokenError = 'FEHLER in Zeile %d. %s erwartet, aber Token %s gefunden.';
  SAseLexerCharError = 'FEHLER in Zeile %d. '#39'%s'#39' erwartet, aber Zeichen '#39'%s'#39' gefunden.';
  SAseLexerFileCorruption = 'Datei ist beschädigt.';

  SAseParserWrongMaterialsNumError = 'Falsche Materialenanzahl';
  SAseParserWrongVertexNumError = 'Falsche Vertexanzahl';
  SAseParserWrongNormalNumError = 'Falsche Normalanzahl';
  SAseParserWrongTexCoordNumError = 'Falsche Texturkoordinatenanzahl';
  SAseParserWrongVertexIdxError = 'Falscher Vertexindex';
  SAseParserWrongFacesNumError = 'Falsche Flächenanzahl';
  SAseParserWrongFacesIdxError = 'Falscher Flächenindex';
  SAseParserWrongTriangleMeshNumError = 'Falsche Dreiecks-Mesh-Anzahl';
  SAseParserWrongTriangleMeshIdxError = 'Falscher Dreiecks-Mesh-Index';
  SAseParserWrongTexCoordIdxError = 'Falscher Texturkoordinatenindex';
  SAseParserUnexpectedKyWordError = 'Unerwartetes Schlüsselwort';

  SIndexDataNotFoundError = 'Indexdaten nicht gefunden. Datei ist beschädigt.';
  SEffectIdNotFoundError = 'Effekt-ID %s nicht gefunden. Datei ist beschädigt.';
  SMeshIdNotFoundError = 'Mesh-ID %s nicht gefunden. Datei ist beschädigt.';
  SControllerIdNotFoundError = 'Controller-ID %s nicht gefunden. Datei ist beschädigt.';

  SCannotCreateCircularDependence = 'Zirkuläre Abhängigkeit zwischen Komponenten kann nicht erstellt werden';
  SPropertyOutOfRange = 'Eigenschaft %s außerhalb des zulässigen Bereichs';

  SPrinterDPIChangeError = 'DPI des aktiven Druckers kann während des Druckens nicht geändert werden';
  SPrinterSettingsReadError = 'Fehler beim Lesen der Druckereinstellungen: %s';
  SPrinterSettingsWriteError = 'Fehler beim Schreiben der Druckereinstellungen: %s';

  SVAllFiles = 'Alle Dateien';
  SVBitmaps = 'Bitmaps';
  SVIcons = 'Symbole';
  SVTIFFImages = 'TIFF-Bilder'; 
  SVJPGImages = 'JPEG-Bilder';
  SVPNGImages = 'PNG-Bilder';
  SVGIFImages = 'GIF-Bilder';
  SVJP2Images = 'Jpeg 2000-Bilder';
  SVTGAImages = 'TGA-Bilder';
  SWMPImages = 'WMP-Bilder';

  SVAviFiles = 'AVI-Dateien';
  SVWMVFiles = 'WMV-Dateien';
  SVMP4Files = 'Mpeg4-Dateien';
  SVMOVFiles = 'QuickTime-Dateien';
  SVM4VFiles = 'M4V-Dateien';

  SVWMAFiles = 'Windows Media Audio-Dateien';
  SVMP3Files = 'Mpeg Layer 3-Dateien';
  SVWAVFiles = 'WAV-Dateien';
  SVCAFFiles = 'Apple Core-Audioformatdateien';
  SV3GPFiles = '3GP-Audiodateien';
  SVM4AFiles = 'M4A-Dateien';

  SAllFilesExt = '.*';
  SDefault = 'Alle Dateien';

  StrEChangeFixed  = '"%s" kann nicht geändert werden (Fixed = True)';
  StrEDupScale     = 'Doppelter Skalierungswert %s';
  StrOther         = 'Andere Skalierung';
  StrScale1        = 'Normal';
  StrScale2        = 'Hochauflösend';

  { Media }

  SNoFlashError = 'Auf diesem Gerät ist kein Blitz vorhanden';
  SNoTorchError = 'Auf diesem Gerät ist kein Blitz vorhanden';

  { Pickers }
  SPickerCancel = 'Abbrechen';
  SPickerDone   = 'Fertig';
  SEditorDone   = 'Fertig';
  SListPickerIsNotFound = 'Diese Version von Android verfügt über keine Implementierung für Listenauswahlfelder';
  SDateTimePickerIsNotFound = 'Diese Version von Android verfügt über keine Implementierung für Datum/Uhrzeit-Auswahlfelder';

  { Notification Center }
  SNotificationCancel = 'Abbrechen';
  SNotificationCenterTitleIsNotSupported = 'NotificationCenter: Titel wird in iOS nicht unterstützt';
  SNotificationCenterActionIsNotSupported = 'NotificationCenter: Aktion wird in Android nicht unterstützt';

  { Media Library }
  STakePhotoFromCamera = 'Foto aufnehmen';
  STakePhotoFromLibarary = 'Fotobibliothek';
  SOpenStandartServices = 'Öffnen in';
  SSavedPhotoAlbum = 'Gespeicherte Fotos';
  SImageSaved = 'Bild gespeichert';

  { Canvas helpers / 2D and 3D engine / GPU }
  SBitmapIncorrectSize = 'Falsche Größe von Bitmap-Parameter(n).';
  SBitmapLoadingFailed = 'Laden des Bitmaps fehlgeschlagen.';
  SBitmapLoadingFailedNamed = 'Laden des Bitmaps fehlgeschlagen (%s).';
  SBitmapSizeTooBig = 'Bitmap zu groß.';
  SInvalidCanvasParameter = 'Ungültiger Aufruf von GetParameter.';
  SThumbnailLoadingFailed = 'Laden der Miniaturansicht fehlgeschlagen.';
  SThumbnailLoadingFailedNamed = 'Laden der Miniaturansicht fehlgeschlagen (%s).';
  SBitmapSavingFailed = 'Speichern des Bitmaps fehlgeschlagen.';
  SBitmapSavingFailedNamed = 'Speichern des Bitmaps fehlgeschlagen (%s).';
  SBitmapFormatUnsupported = 'Das angegebene Bitmap-Format wird nicht unterstützt.';
  SRetrieveSurfaceDescription = 'Oberflächenbeschreibung konnte nicht abgerufen werden.';
  SRetrieveSurfaceContents = 'Oberflächeninhalt konnte nicht abgerufen werden.';
  SAcquireBitmapAccess = 'Zugriff auf Bitmap fehlgeschlagen.';
  SVideoCaptureFault = 'Fehler beim Erfassen des Videobeitrags.';
  SNoCaptureDeviceManager = 'Keine CaptureDeviceManager-Implementierung gefunden';
  SInvalidCallingConditions = 'Ungültige Aufrufbedingungen für '#39'%s'#39'.';
  SInvalidRenderingConditions = 'Ungültige Render-Bedingungen für '#39'%s'#39'.';
  STextureSizeTooSmall = 'Textur für '#39'%s'#39' kann nicht erstellt werden, weil die Größe zu klein ist.';
  SCannotAcquireBitmapAccess = 'Bitmap-Zugriff für '#39'%s'#39' kann nicht zugeteilt werden.';
  SCannotFindSuitablePixelFormat = 'Passendes Pixel-Format für '#39'%s'#39' nicht gefunden.';
  SCannotFindSuitableShader = 'Passenden Schattierer für '#39'%s'#39' nicht gefunden.';
  SCannotDetermineDirect3DLevel = 'Direct3D-Unterstützungsstufe kann nicht ermittelt werden.';
  SCannotCreateDirect3D = 'Direct3D-Objekt für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotCreateD2DFactory = 'Direct2D Factory-Objekt für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotCreateDWriteFactory = 'DirectWrite Factory-Objekt für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotCreateWICImagingFactory = 'WIC Imaging Factory-Objekt für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotCreateRenderTarget = 'Render-Ziel für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotCreateD3DDevice = 'Direct3D-Gerät für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotAcquireDXGIFactory = 'DXGI-Generator von Direct3D-Gerät für '#39'%s'#39' kann nicht zugeteilt werden.';
  SCannotResizeBuffers = 'Größe der Puffer für '#39'%s'#39' kann nicht geändert werden.';
  SCannotAssociateWindowHandle = 'Fenster-Handle für '#39'%s'#39' kann nicht zugeordnet werden.';
  SCannotRetrieveDisplayMode = 'Anzeigemodus für '#39'%s'#39' kann nicht ermittelt werden.';
  SCannotRetrieveBufferDesc = 'Pufferbeschreibung für '#39'%s'#39' kann nicht abgerufen werden.';
  SCannotCreateSamplerState = 'Sampler-Status für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotRetrieveSurface = 'Oberfläche für '#39'%s'#39' kann nicht ermittelt werden.';
  SCannotCreateTexture = 'Textur für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotUploadTexture = 'Pixel-Daten können nicht für '#39'%s'#39' zu Textur hochgeladen werden.';
  SCannotActivateTexture = 'Textur für '#39'%s'#39' kann nicht aktiviert werden.';
  SCannotAcquireTextureAccess = 'Textur-Zugriff für '#39'%s'#39' kann nicht zugeteilt werden.';
  SCannotCopyTextureResource = 'Texturressource '#39'%s'#39' kann nicht kopiert werden.';
  SCannotCreateRenderTargetView = 'Render-Zielansicht für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotActivateFrameBuffers = 'Frame-Puffer für '#39'%s'#39' können nicht aktiviert werden.';
  SCannotCreateRenderBuffers = 'Render-Puffer für '#39'%s'#39' können nicht erstellt werden.';
  SCannotRetrieveRenderBuffers = 'Geräte-Render-Puffer für '#39'%s'#39' können nicht abgerufen werden.';
  SCannotActivateRenderBuffers = 'Render-Puffer für '#39'%s'#39' können nicht aktiviert werden.';
  SCannotBeginRenderingScene = 'Rendern der Szene für '#39'%s'#39' kann nicht begonnen werden.';
  SCannotSyncDeviceBuffers = 'Gerätepuffer für '#39'%s'#39' können nicht synchronisiert werden.';
  SCannotUploadDeviceBuffers = 'Gerätepuffer für '#39'%s'#39' können nicht aktualisiert werden.';
  SCannotCreateDepthStencil = 'Tiefen-/Schablonenpuffer für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotRetrieveDepthStencil = 'Tiefen-/Schablonenpuffer für '#39'%s'#39' kann nicht abgerufen werden.';
  SCannotActivateDepthStencil = 'Tiefen-/Schablonenpuffer für '#39'%s'#39' kann nicht aktiviert werden.';
  SCannotCreateSwapChain = 'Swapchain für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotResizeSwapChain = 'Größe der Swapchain für '#39'%s'#39' kann nicht geändert werden.';
  SCannotActivateSwapChain = 'Swapchain für '#39'%s'#39' kann nicht aktiviert werden.';
  SCannotCreateVertexShader = 'Vertex-Schattierer für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotCreatePixelShader = 'Pixel-Schattierer für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotCreateVertexLayout = 'Vertex-Layout für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotCreateVertexDeclaration = 'Vertexdeklaration für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotCreateVertexBuffer = 'Vertexpuffer für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotCreateIndexBuffer = 'Indexpuffer für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotCreateShader = 'Schattierer für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotFindShaderVariable = 'Schattierervariable "%s" nicht gefunden.';
  SCannotActivateShaderProgram = 'Schattiererprogramm für '#39'%s'#39' kann nicht aktiviert werden.';
  SCannotCreateOpenGLContext = 'OpenGL-Kontext für '#39'%s'#39' kann nicht erstellt werden.';
  SCannotUpdateOpenGLContext = 'OpenGL-Kontext für '#39'%s'#39' kann nicht aktualisiert werden.';
  SCannotDrawMeshObject = 'Netzobjekt für '#39'%s'#39' kann nicht gezeichnet werden.';
  SErrorInContextMethod = 'Fehler in der Kontextmethode "%s".';
  SFeatureNotSupported = 'Dieses Feature wird in '#39'%s'#39' nicht unterstützt.';
  SErrorCompressingStream = 'Fehler beim Komprimieren des Streams.';
  SErrorDecompressingStream = 'Fehler beim Dekomprimieren des Streams.';
  SErrorUnpackingShaderCode = 'Fehler beim Entpacken des Schattierercodes.';

  SCannotAddFixedSize = 'Spalten oder Zeilen können nicht hinzugefügt werden, wenn ExpandStyle TExpandStyle.FixedSize ist';
  SInvalidSpan = #39'%d'#39' ist keine gültige Spanne';
  SInvalidRowIndex = 'Zeilenindex, %d, außerhalb des gültigen Bereichs';
  SInvalidColumnIndex = 'Spaltenindex, %d, außerhalb des gültigen Bereichs';
  SInvalidControlItem = 'ControlItem.Control darf nicht auf besitzendes GridPanel gesetzt werden';
  SCannotDeleteColumn = 'Eine Spalte, die Steuerelemente enthält, kann nicht gelöscht werden';
  SCannotDeleteDefColumn = 'Eine Spalte kann nicht standardmäßig gelöscht werden';
  SCannotDeleteRow = 'Eine Zeile, die Steuerelemente enthält, kann nicht gelöscht werden';
  SCellMember = 'Member';
  SCellSizeType = 'Größentyp';
  SCellValue = 'Wert';
  SCellAutoSize = 'Auto';
  SCellPercentSize = 'Prozent';
  SCellAbsoluteSize = 'Absolut';
  SCellColumn = 'Spalte%d';
  SCellRow = 'Zeile%d';

  SDateTimeMax = 'Das Datum überschreitet das Maximum von "%s"';
  SDateTimeMin = 'Das Datum unterschreitet das Minimum von "%s"';

  SDateTimePickerShowModeNotSupported = 'DateTime-Auswahlfeld unterstützt psmDateTime auf der aktuellen Plattform nicht';

  SMediaLibraryOpenImageWith = 'Bild senden mit:';
  SMediaLibraryOpenTextWith = 'Text senden mit:';
  SMediaLibraryOpenTextAndImageWith = 'Text/Bild senden mit:';

  SNativePresentation = '%s (nativ)';

  { In-App Purchase }
  SIAPNotSetup = 'Komponente für In-App-Kauf ist nicht konfiguriert';
  SIAPNoLicenseKey = 'Komponente für In-App-Kauf hat keinen Lizenzschlüssel';
  SIAPPayloadVerificationFailed = 'Verifizierung der Transaktionsnutzlast fehlgeschlagen';
  SIAPAlreadyPurchased = 'Artikel wurde bereits gekauft';
  SIAPNotAlreadyPurchased = 'Nicht gekaufter Artikel kann nicht verwendet werden';
  SIAPSetupProblem = 'Problem beim Konfigurieren der In-App-Abrechnung';
  SIAPIllegalArguments = 'Argumentproblem in IAP-API';
  SITunesConnectionError = 'Verbindung zu iTunes Store kann nicht hergestellt werden';
  SProductsRequestInProgress = 'Produktanforderung wird bereits ausgeführt';

  { Advertising }
  SAdFailedToLoadError = 'Anzeige konnte nicht geladen werden: %d';

  { TMultiView }
  SCannotCreatePresentation = 'Darstellung kann ohne MultiView nicht erstellt werden';
  SDrawer = 'Schublade';
  SOverlapDrawer = 'Überlappende Schublade';
  SDockedPanel = 'Angedockter Bereich';
  SPopover = 'Popover';
  SNavigationPane = 'Navigationsbereich';
  SObjectCannotBeChild = '"%s" kann "%s" nicht untergeordnet sein';

  { Presentations }
  SWrongModelClassType = 'Modell ist keine gültige Klasse. [%s] erwartet, aber [%s] erhalten';
  SWrongParameter = '[%]-Parameter darf nicht nil sein';
  SControlWithoutPresentation = '[%s] ohne Darstellung';
  SControlClassIsNil = 'AControlClass darf nicht nil sein. Generator kann Darstellungsname nicht generieren.';
  SPresentationProxyCreateError = 'Darstellungs-Proxy mit nil-Modell oder PresentedControl kann nicht erstellt werden. Verwenden Sie die überladene Version des Konstruktors mit Parametern, und übergeben Sie korrekte Werte.';
  SPresentationProxyClassNotFound = 'Darstellungs-Proxy-Klasse für Darstellungsname [%s] nicht gefunden';
  SPresentationProxyClassIsNil = 'APresentationProxyClass ist nil. Generator kann Darstellung mit einer Darstellungs-Proxy-Klasse "nil" nicht registrieren.';
  SPresentationProxyNameIsEmpty = 'APresentationName ist leer. Generator kann Darstellung mit einem leeren Darstellungsnamen nicht registrieren';
  SPresentationAlreadyRegistered = 'Darstellungs-Proxy-Klasse [%s] für diesen Darstellungsnamen [%s] wurde bereits registriert.';
  SPresentationTitleInDesignTime = '%s (%s)';
  SProxyIsNotRegisteredWarning = 'Für Klasse %s wurde kein TStyledPresentationProxy-Nachkomme registriert.'#13#10'Eventuell muss das %s Modul in den uses-Abschnitt eingefügt werden';
  { TScrollBox }
  SScrollBoxOwnerWrong = '|AOwner| muss eine Instanz von TCustomPresentedScrollBox sein';
  SScrollBoxAniCalculations = 'Mit Stilen versehene Darstellung konnte nicht erstellt werden, weil CreateAniCalculations nil zurückgab.';

  { Data Model }
  SDataModelKeyEmpty = 'Schlüssel darf nicht leer sein. Datenmodell kann keine Daten über einen Schlüssel mit leerem Namen festlegen oder abrufen.';

  { Analytics }
  SInvalidActivityTrackingAppID = 'Ungültige Anwendungs-ID';
  SAppAnalyticsDefaultPrivacyMessage = 'Datenschutzhinweis:'#13#10#13#10'Diese Anwendung verfolgt anonym Ihre Programmnutzung und sendet die Daten zur Auswertung an uns. Anhand dieser Auswertung verbessern wir die Software für Sie.'#13#10#13#10'Diese Verfolgung ist vollständig anonym. Es werden keine personenbezog'+
'enen Daten aufgezeichnet, und Ihre Nutzungsdaten können nicht zu Ihnen zurückverfolgt werden.'#13#10#13#10'Bitte klicken Sie auf "Ja", um uns bei der Verbesserung dieser Software zu unterstützen. Vielen Dank!';
  SCustomAnalyticsCategoryMissing = 'Fehler in benutzerdefiniertem AppAnalytics-Ereignis: Kategorie muss angegeben werden.';

  { Clipboard }
  SFormatNameCannotBeEmpty = 'Parameter AFormat darf nicht leer sein';
  SStreamCannotBeNil = 'AStream-Parameter darf nicht Nil sein';
  SFormatAlreadyRegistered = 'Benutzerdefiniertes Zwischenablagenformat "%s" ist bereits registriert';
  SFormatWasNotRegistered = 'Benutzerdefiniertes Zwischenablagenformat "%s" ist nicht registriert';
  SDoesnotSupportCustomData = '%s unterstützt benutzerdefinierte Daten nicht';

  { Helpers }

  SCannotConvertDelphiArrayToJStringArray = 'Delphi-Quell-Array kann nicht in Java-JString-Array konvertiert werden. [%d] ist kein unterstützter Typ';

  { Address Book }

  // Permission
  SCannotPerformOperation = 'Operation kann nicht durchgeführt werden. Sie müssen die Berechtigung mit AddressBook.RequestPermission anfordern';
  SCannotPerformOperationRejectedAccess = 'Operation kann nicht durchgeführt werden. Benutzer hat den Zugriff auf AddressBook verweigert';
  SRequiredPermissionsAreAbsent = 'Erforderliche Berechtigungen [%s] sind in der Manifest-Datei nicht vorhanden.';
  SPermissionCannotChangeDataInAddressBook = 'Schreibberechtigung [WRITE_CONTACTS] ist in Manifest-Datei nicht vorhanden. Daher können Sie keine Änderungen am AddressBook vornehmen';
  SPermissionCannotGetDataFromAddressBook = 'Leseberechtigung [READ_CONTACTS] ist in Manifest-Datei nicht vorhanden. Daher können Sie keine Daten aus dem AddressBook abrufen';
  SUserRejectedAddressBookPermission = 'Benutzer hat Berechtigung verweigert';
  // Common
  SCannotSaveAddressBookChanges = 'Änderungen können nicht in AddressBook gespeichert werden. %s';
  SFieldTypeIsNotSupportedOnCurrentPlatform = 'Angegebener Feldtyp [%s] wird auf der aktuellen Plattform nicht unterstützt';
  SCannotSaveFieldValue = '[%s] kann nicht gespeichert werden. %s';
  SCannotGetDisplayName = 'Anzeigename kann nicht abgerufen werden. %s';
  SCannotCheckExisitingDataRecord = 'Vorhandener Datensatz kann nicht geprüft werden. %s';
  SCannotExtractContactID = 'ID des neuen Kontakts kann nicht extrahiert werden';
  SCannotCheckExistingDataRecord = 'Vorhandener Datensatz kann nicht geprüft werden. %s';
  SCannotExtractAddresses = 'Adressen können nicht extrahiert werden. %s';
  SCannotExtractMessagingServices = 'Infos für Messaging-Dienst können nicht abgerufen werden. %s';
  SCannotExtractDates = 'Datumsangaben können nicht abgerufen werden. %s';
  SCannotExtractMultipleStringValue = 'Mehrere Stringwerte können nicht extrahiert werden. %s';
  SCannotExtractStringValue = 'Stringwert kann nicht extrahiert werden. %s';
  SSocialProfilesAreNotSupported = 'Soziale Profile werden auf dieser Plattform nicht unterstützt.';
  SCannotConvertTBitmapToJBitmap = 'Kontaktfoto kann nicht gespeichert werden. TBitmap kann nicht in JBitmap konvertiert werden.';
  SCannotBeginNewProcessing = 'Neuer Prozess kann erst begonnen werden, wenn der vorherige abgeschlossen ist';
  // Sources
  SCannotFetchAllSourcesNilArg = 'Quellen können nicht abgerufen werden. [%s] darf nicht nil sein.';
  SCannotCreateSource = 'Kontakt kann nicht erstellt werden, verwenden Sie AddressBook.Sources zum Abrufen aller verfügbaren Quellen auf Ihrem Gerät.';
  SCannotCreateSourceNilArg = 'Instanz der Quelle kann nicht erstellt werden. [%s] darf nicht nil sein.';
  SCannotGetSourceNameSourceRefRefNil = 'Quellenname kann nicht abgerufen werden. [SourceRef] ist nil';
  SCannotGetSourceTypeSourceRefRefNil = 'Quellentyp kann nicht abgerufen werden. [SourceRef] ist nil';
  // Contacts
  SCannotFetchContacts = 'Kontakte können nicht abgerufen werden. %s';
  SCannotFetchAllContactsWrongClassArg = 'Kontakte können nicht abgerufen werden. [%s] muss Instanz der Klasse [%s] sein.';
  SCannotFetchAllContactNilArg = 'Kontakte können nicht abgerufen werden. [%s] darf nicht nil sein.';
  SCannotCreateContact = 'Kontakt kann nicht erstellt werden.';
  SCannotCreateContactNilArg = 'Instanz von Kontakt kann nicht erstellt werden. [%s] darf nicht nil sein.';
  SCannotCreateContactWrongClassArg = 'Instanz von Kontakt kann nicht erstellt werden. [%s] muss Instanz der Klasse [%s] sein.';
  SCannotCreateContactUseFactoryMethod = 'Kontakt kann nicht erstellt werden, verwenden Sie stattdessen AddressBook.CreateContact.';
  SCannotSaveContact = 'Kontakt kann nicht gespeichert werden. %s';
  SCannotSaveContactNilArg = 'Kontakt kann nicht gespeichert werden. [%s] darf nicht nil sein.';
  SCannotSaveContactWrongClassArg = 'Kontakt kann nicht gespeichert werden. [%s] muss Instanz der Klasse [%s] sein.';
  SCannotSaveNotModifiedContact = 'Kontakt kann nicht gespeichert werden, wenn der Kontakt nicht geändert wurde';
  SCannotRemoveContact = 'Kontakt kann nicht entfernt werden. %s';
  SCannotRemoveContactNilArg = 'Kontakt kann nicht entfernt werden. [%s] darf nicht nil sein.';
  SCannotRemoveContactWrongClassArg = 'Kontakt kann nicht entfernt werden. [%s] muss Instanz der Klasse [%s] sein.';
  // Groups
  SCannotFetchGroups = 'Gruppen können nicht abgerufen werden. %s';
  SCannotFetchAllGroupsWrongClassArg = 'Gruppen können nicht abgerufen werden. [%s] muss Instanz der Klasse [%s] sein.';
  SCannotFetchAllGroupsNilArg = 'Gruppen können nicht abgerufen werden. [%s] darf nicht nil sein.';
  SCannotCreateGroup = 'Instanz von Gruppe kann nicht erstellt werden.';
  SCannotCreateGroupNilArg = 'Instanz von Gruppe kann nicht erstellt werden. [%s] darf nicht nil sein';
  SCannotCreateGroupWrongClassArg = 'Instanz von Gruppe kann nicht erstellt werden. [%s] muss Instanz der Klasse [%s] sein.';
  SCannotCreateGroupUseFactoryMethod = 'Gruppe kann nicht erstellt werden, verwenden Sie stattdessen AddressBook.CreateGroup.';
  SCannotSaveGroup = 'Gruppe kann nicht gespeichert werden. %s';
  SCannotSaveGroupNilArg = 'Gruppe kann nicht gespeichert werden. [%s] darf nicht nil sein.';
  SCannotSaveGroupWrongClassArg = 'Gruppe kann nicht gespeichert werden. [%s] muss Instanz der Klasse [%s] sein.';
  SCannotRemoveGroup = 'Gruppe kann nicht entfernt werden. %s';
  SCannotRemoveGroupNilArg = 'Gruppe kann nicht entfernt werden. [%s] darf nicht nil sein.';
  SCannotRemoveGroupWrongClassArg = 'Gruppe kann nicht entfernt werden. [%s] muss Instanz der Klasse [%s] sein.';
  SCannotGetGroupNameGroupRefNil = 'Gruppenname kann nicht abgerufen werden. GroupRef ist nil';
  SCannotSetGroupName = 'Gruppenname kann nicht festgelegt werden. %s';
  SCannotSetGroupNameGroupRefNil = 'Gruppenname kann nicht festgelegt werden. GroupRef ist nil';
  // Contacts in Group
  SCannotAddContactIntoGroup = 'Kontakt kann nicht zu Gruppe hinzugefügt werden. %s';
  SCannotAddContactIntoGroupNilArg = 'Kontakt kann nicht zu Gruppe hinzugefügt werden. [%s] darf nicht nil sein.';
  SCannotAddContactIntoGroupWrongClassArg = 'Kontakt kann nicht zu Gruppe hinzugefügt werden. [%s] muss Instanz der Klasse [%s] sein.';
  SCannotAddContactIntoGroupContactIsNotInAddressBook = 'Kontakt kann nicht zu Gruppe hinzugefügt werden. Kontakt ist noch in keinem AddressBook enthalten.';
  SCannotAddContactIntoGroupGroupIsNotInAddressBook = 'Kontakt kann nicht zu Gruppe hinzugefügt werden. Gruppe ist noch in keinem AddressBook enthalten.';
  SCannotRemoveContactFromGroup = 'Kontakt kann nicht aus Gruppe entfernt werden. %s';
  SCannotRemoveContactFromGroupNilArg = 'Kontakt kann nicht aus Gruppe entfernt werden. [%s] darf nicht nil sein.';
  SCannotRemoveContactFromGroupWrongClassArg = 'Kontakt kann nicht aus Gruppe entfernt werden. [%s] muss Instanz der Klasse [%s] sein.';
  SCannotFetchContactInGroup = 'Kontakte in Gruppe mit ID = [%d] können nicht abgerufen werden. %s';
  SCannotFetchContactsInGroupNilArg = 'Liste mit Kontakten kann nicht abgerufen werden. [%s] darf nicht nil sein.';

  { Address fields kinds }

  SFirstName = 'Vorname';
  SLastName = 'Nachname';
  SMiddleName = 'Zweiter Vorname';
  SPrefix = 'Präfix';
  SSuffix = 'Suffix';
  SNickName = 'Spitzname';
  SFirstNamePhonetic = 'Vorname (phonetisch)';
  SLastNamePhonetic = 'Nachname (phonetisch)';
  SMiddleNamePhonetic = 'Zweiter Vorname (phonetisch)';
  SOrganization = 'Organisation';
  SJobTitle = 'Stellenbezeichnung';
  SDepartment = 'Abteilung';
  SPhoto = 'Foto';
  SPhotoThumbnail = 'Foto-Miniaturansicht';
  SNote = 'Hinweis';
  SURLs = 'URLs';
  SEMails = 'E-Mails';
  SAddresses = 'Adressen';
  SPhones = 'Telefone';
  SDates = 'Datumsangaben';
  SRelatedNames = 'Verwandte Namen';
  SMessagingServices = 'Messaging-Dienste';
  SBirthday = 'Geburtstag';
  SCreationDate = 'Erstellungsdatum';
  SModificationDate = 'Änderungsdatum';
  SSocialProfiles = 'Soziale Profile';
  SUnknowType = 'Unbekannter Typwert';

  { Sources }

  SSourceLocal = 'Lokale Quelle';
  SSourceExchange = 'Exchange ';
  SSourceExchangeGAL = 'Exchange Globale Adressliste (GAL)';
  SSourceMobileMe = 'MobileMe';
  SSourceLDAP = 'LDAP';
  SSourceCardDAV = 'CardDAV';
  SSourceCardDAVSearch = 'Suchbares CardDAV';

  { Label types }

  SAddressBookHomeLabel = 'Start';
  SAddressBookWorkLabel = 'Ausführen';
  SAddressBookOtherLabel = 'Weitere';

  { Phones types }

  SPhoneMain = 'Hauptnummer';
  SPhoneHome = 'Zuhause';
  SPhoneMobile = 'Mobil';
  SPhoneWork = 'Arbeit';
  SPhoneFaxWork = 'Fax Arbeit';
  SPhoneFaxHome = 'Fax Zuhause';
  SPhoneFaxOther = 'Weiteres Fax';
  SPhonePager = 'Pager';
  SPhoneOther = 'Sonstige';
  SPhoneCallback = 'Rückruf';
  SPhoneCar = 'Auto';
  SPhoneCompanyMain = 'Firma (Hauptnummer)';
  SPhoneISDN = 'ISDN';
  SPhoneRadio = 'Radio';
  SPhoneTelex = 'Telex';
  SPhoneTTYTDD = 'TTY TDD';
  SPhoneWorkMobile = 'Arbeit mobil';
  SPhoneWorkPager = 'Arbeit Pager';
  SPhoneAssistant = 'Assistent';
  SPhoneIPhone = 'iPhone';

  { Dates types }

  SDateAnniversary = 'Jahrestag';
  SDateBirthday = 'Geburtstag';
  SDateOther = 'Sonstige';

  { EMails types }

  SEmailsMobile = 'Mobil';

  { Urls }

  SURLHomePage = 'Homepage';
  SURLBlog = 'Blog';
  SURLProfile = 'Profil';
  SURLFTP = 'FTP';

  { Related names }

  SRelationAssistant = 'Assistent';
  SRelationBrother = 'Bruder';
  SRelationChild = 'Kind';
  SRelationDomesticPartner = 'Lebenspartner';
  SRelationFather = 'Vater';
  SRelationFriend = 'Freund';
  SRelationManager = 'Manager';
  SRelationMother = 'Mutter';
  SRelationParent = 'Elternteil';
  SRelationPartner = 'Partner';
  SRelationReferredBy = 'RefferedBy';
  SRelationRelative = 'Verwandter';
  SRelationSister = 'Schwester';
  SRelationSpouse = 'Ehepartner';

  { IM Protocol names }

  SProtocolAIM = 'AIM';
  SProtocolMSN = 'MSN';
  SProtocolYahoo = 'Yahoo';
  SProtocolSkype = 'Skype';
  SProtocolQQ = 'QQ';
  SProtocolGoogleTalk = 'Google Talk';
  SProtocolICQ = 'ICQ';
  SProtocolJabber = 'Jabber';
  SProtocolNetMeeting = 'NetMeeting';
  SProtocolFacebook = 'Facebook';
  SProtocolGaduGadu = 'Gadu Gadu';

  { Social profile }

  SSocialProfileTwitter = 'Twitter';
  SSocialProfileGameCenter = 'Game Center';
  SSocialProfileSinaWeibo = 'Sina Weibo';
  SSocialProfileFacebook = 'Facebook';
  SSocialProfileMySpace = 'MySpace';
  SSocialProfileLinkedIn = 'LinkedIn';
  SSocialProfileFlickr = 'Flickr';

  { TListView }
  SUseItemsPropertyToSetAdapter = 'Verwenden Sie die Eigenschaft Items, um den TAppearanceListView-Adapter festzulegen';

implementation

end.

