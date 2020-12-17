unit Engine.Dist;

interface

uses
  Classes,
  System.Generics.Collections,
  Engine.Helferlein,
  Engine.Helferlein.Windows,
  Engine.Helferlein.Threads,
  Engine.Serializer,
  System.SysUtils,
  IdHTTP,
  Math,
  IOUtils,
  ShellApi;

type

  /// <summary> Infos about a file that is part of a distribution package.</summary>
  RDistFile = record
    public
      /// <summary>Relative path to file within distribution</summary>
      Filename : string;
      /// <summary>File hash (may be MD5, SHA2, or something else)</summary>
      Hash : string;
      /// <summary>Size of the file in Bytes</summary>
      Size : Int64;
  end;

  {$IFDEF VER240}

  /// <summary> Needed for Serialization in Delphi XE3, because of IDE-Bug. </summary>
  TRttiFix = class
    QC109491 : TMoveArrayManager<TDistFile>;
  end;
  {$ENDIF}

  /// <summary> Listing of distribution files</summary>
  TDistListing = class
    public
      Files : TList<RDistFile>;
      VersionInfo : string;
      DateCreated : string;
      constructor Create();
      destructor Destroy(); override;
  end;

  ProcStatusUpdate = procedure(statusText : string) of object;
  ProcProgressUpdate = procedure(progress : Single) of object;
  ProcProcessFinished = procedure(success : Boolean) of object;
  ProcUpdate = reference to procedure;

  RGuiUpdate = record
    public
      Time : TDateTime;
      Update : ProcUpdate;
      Important : Boolean;
      constructor Create(f : ProcUpdate);
  end;

  EAbort = class(Exception)
    private
      FObjectsToFree : TObjectList<TObject>;
    public
      constructor Create(); overload;
      constructor Create(objectsToFree : array of TObject); overload;
      procedure CleanUp();

  end;

  TLauncherConfig = class
    public
      /// <summary> Base URL for updates. The remote distribution file is expected
      /// at $UpdateURL/dist.xml.</summary>
      UpdateURL : string;
      /// <summary> URL to the file that contains the checksum of the current
      /// version of the Launcher</summmary>
      LauncherUpdateChecksumURL : string;
      /// <summary> URL to the up-to-date version of the Launcher</summary>
      LauncherUpdateDownloadURL : string;
      LauncherAdminUpdateChecksumURL : string;
      LauncherAdminUpdateDownloadURL : string;
      /// <summary> URL to the file that contains the checksum of the current
      /// version of the Launcher</summmary>
      LauncherUpdateConfigChecksumURL : string;
      /// <summary> URL to the up-to-date version of the Launcher</summary>
      LauncherUpdateConfigDownloadURL : string;

      UpdaterUpdateChecksumURL : string;
      UpdaterUpdateDownloadURL : string;

      /// <summary> URL used to check for the status of the login server</summary>
      LoginServerStatusURL : string;
      /// <summary> URL to the featured news item to be displayed</summary>
      FeaturedNewsURL : string;
      /// <summary>URL to general list of news items</summary>
      NewsURL : string;
      /// <summary> Local path to put the downloaded files into. This may be "." for
      /// the current directory. </summary>
      InstallPath : string;
      /// <summary> Local path for all launcher files. </summary>
      LauncherFiles : string;
      /// <summary> Path relative to InstallPath to the executable file that shall
      /// be started when clicking the Play button.</summary>
      LaunchFile : string;
      /// <summary> Determines whether all executable files (EXEs, DLLs, script files)
      /// should be checked against their hashes at startup.</summary>
      SecureExecutables : Boolean;
      /// <summary> Path to local distribution XML file (is created during the update
      /// process by download the current version from the server).</summary>
      LocalDistFile : string;
      /// <summary> Path to local copy of the current remote distribution file, i.e.
      /// where to store the downloaded remote distribution file.</summary>
      LocalTempDistFile : string;
      /// <summary> Path to the local copy of the signature used to verify the
      /// distribution files. Is downloaded during the update process.</summary>
      LocalSignature : string;
      UpdateExeFileName : string;
      LauncherUpdatePath : string;
      /// <summary> URL (relative to UpdateURL) to the remote distribution XML file</summary>
      RemoteDistFile : string;
      /// <summary> URL (relative to UpdateURL) to the remote signature file.</summary>
      RemoteSignature : string;
      /// <summary> Path to public key.</summary>
      PublicKeyFile : string;
      /// <summary> Enables Repair Mode that checks and corrects all files. </summary>
      RepairMode : Boolean;
      /// <summary> Creates the configuration with some reasonable default values. </summary>
      constructor Create();
  end;

  /// <summary> Worker thread that takes care of updating files based on a remote BCDist
  /// distribution file (see TLauncherConfig). </summary>
  TUpdateWorker = class(TThread)
    protected
      FConfig : TLauncherConfig;
      FStatusUpdate : ProcStatusUpdate;
      FProgressUpdate : ProcProgressUpdate;
      FOnFinish : ProcProcessFinished;
      FLocalListing, FRemoteListing : TDistListing;
      FCrypto : TCryptoHelper;
      FInternet : TInternet;
      FRepairMode : Boolean;
      FCriticalFilePattern : string;
      FDownloadStarted : Int64;
      FAbort : Boolean;
      FUpdating : Boolean;
      /// <summary> Gets the local dist.xml distribution listing. The listing file is
      /// verified against the remote signature. If the verification fails
      /// an exception is thrown. If no local listing exists, an empty one
      /// is returned.</summary>
      function GetLocalDist() : TDistListing;
      /// <summary> Gets the remote dist.xml distribution listing. The listing file is
      /// verified against the remote signature. If the verification fails
      /// an exception is thrown. If either the remote dist.xml or the signature
      /// cannot be downloaded, an appropriate exception is thrown. </summary>
      function GetRemoteDist(url : string) : TDistListing;
      /// <summary> Create Installpath If not exists. Raise an exception if creating fails. </summary>
      procedure EnsureInstallPath;
      /// <summary> Prepares the cryptographic library for signing distribution files using
      /// the public key that is expected to be located at "launcher/pub.rsa".</summary>
      procedure PrepareCrypto();
      /// <summary> Compares the local and remote listing and returns a list of which
      /// files need to be downloaded.</summary>
      function ListFilesToUpdate : TList<RDistFile>;
      /// <summary> Sequentially downloads all the given files. Uses status and progress
      /// callbacks to report the download progress. </summary>
      procedure DownloadFiles(Files : TList<RDistFile>);
      /// <summary> Reports the current download progress by updating the percent progress
      /// based on the current number of downloaded bytes and maximum number of
      /// bytes to be downloaded. Also shows the file currently being downloaded. </summary>
      procedure ReportDownloadProgress(curBytes, maxBytes : Int64; Filename : string);
      procedure ReportHashProgress(curBytes, maxBytes : Int64; Filename : string);
      procedure CheckForUpdaterUpdate;
      procedure CheckForLauncherUpdate;
      procedure CheckForLauncherConfigUpdate;
    public
      /// <summary> Creates a new update worker thread based on the given configuration. </summary>
      /// <param name="config">Launcher configuration</param>
      /// <param name="onStatus">Callback for text-based status updates</param>
      /// <param name="onProgress">Callback for numerical progress updates in percent</param>
      /// <param name="onFinish">Callback that is called when the update is finished</param>
      constructor Create(config : TLauncherConfig;
        onStatus : ProcStatusUpdate; onProgress : ProcProgressUpdate; onFinish : ProcProcessFinished);
      destructor Destroy(); override;
      /// <summary> When set to true all files are checked against their hashes to ensure
      /// that there are no damaged files. Default value is false. </summary>
      property RepairMode : Boolean read FRepairMode write FRepairMode;
      /// <summary> Set to true to abort a running update process. The updater will try
      /// to quit gracefully and clean up after himself. </summary>
      property Abort : Boolean read FAbort write FAbort;
      /// <summary> Regex for critical files that always need to be checked against their
      /// hashes for security reasons. By default .exe, .dll and script files
      /// are included. </summary>
      property CriticalFilePattern : string read FCriticalFilePattern write FCriticalFilePattern;
      /// <summary> Performs the update. Progress is reported back through the callbacks
      /// than can be set through the constructor.  </summary>
      procedure Execute(); override;

  end;

  /// <summary> A Game Launcher / Patcher compatible to projects distributed with
  /// BCDist (using a XML-serialized TDistListing to describe the contents). </summary>
  TLauncher = class
    private
      FOnStatusCallback : ProcStatusUpdate;
      FOnProgressCallback : ProcProgressUpdate;
      procedure EnqueueStatusUpdate(text : string);
      procedure EnqueueProgressUpdate(percent : Single);
    protected
      FUpToDate : Boolean;
      FUpdating : Boolean;
      FConfig : TLauncherConfig;
      FUpdater : TUpdateWorker;
      FOnFinishCallback : TProc;
      FGuiUpdates : TThreadSafeQueue<RGuiUpdate>;
      procedure OnUpdateFinished(success : Boolean);
      function LoadConfiguration(configFile : string) : TLauncherConfig;
    public
      /// <summary> Create a new Launcher instance using the configuration from given
      /// file. The file is expected to be the XML serialization of a
      /// TLauncherConfig instance. </summary>
      constructor Create(configFile : string); overload;
      /// <summary> Create a new Launcher using the provided launcher configuration </summary>
      constructor Create(config : TLauncherConfig); overload;
      destructor Destroy(); override;
      /// <summary> Returns true if the project in the installation path is up-to-date.
      /// This value is false by default and should be read after the updating
      /// process has been finished. </summary>
      property IsUpToDate : Boolean read FUpToDate;
      property GuiUpdates : TThreadSafeQueue<RGuiUpdate> read FGuiUpdates;
      /// <summary> Returns true if the Launcher is currently updating (in a background thread). </summary>
      property IsUpdating : Boolean read FUpdating;
      /// <summary> The configuration used to create this launcher. </summary>
      property config : TLauncherConfig read FConfig;
      /// <summary> Starts the update process in a background thread. For reporting
      /// progress the three event callbacks are used. </summary>
      /// <param name="onStatus">Will be called when the current status text changes</param>
      /// <param name="onProgress">Will be called when the overall progress in percent changes</param>
      /// <param name="onFinish">Will be called when the update process is finished.</param>
      procedure StartUpdate(onStatus : ProcStatusUpdate; onProgress : ProcProgressUpdate; onFinish : TProc);
      /// <summary> Aborts the update process at the next possible chance. </summary>
      procedure AbortUpdate(wait : Boolean);
  end;

implementation

uses
  System.RegularExpressions,
  Winapi.Windows,
  IdGlobalProtocols;

{ TDistListing }

constructor TDistListing.Create;
begin
  Files := TList<RDistFile>.Create();
end;

destructor TDistListing.Destroy;
begin
  Files.Free();
  inherited;
end;

{ TLauncher }

constructor TLauncher.Create(configFile : string);
begin
  Create(LoadConfiguration(configFile));
end;

procedure TLauncher.AbortUpdate(wait : Boolean);
begin
  if FUpdater <> nil then
  begin
    FUpdater.Abort := True;
    if wait then
        FUpdater.WaitFor;
  end;

end;

constructor TLauncher.Create(config : TLauncherConfig);
begin
  FUpToDate := False;
  FUpdating := False;
  FConfig := config;
  FGuiUpdates := TThreadSafeQueue<RGuiUpdate>.Create();
end;

destructor TLauncher.Destroy;
begin
  FreeAndNil(FUpdater);
  FreeAndNil(FGuiUpdates);
end;

function TLauncher.LoadConfiguration(configFile : string) : TLauncherConfig;

  function IsPathRelative(path : string) : Boolean;
  begin
    Result := not path.Contains(':');
  end;

var
  config : TLauncherConfig;
begin
  config := HXMLSerializer.CreateAndLoadObjectFromFile<TLauncherConfig>(configFile);

  // Expand relative paths relative to CWD
  if IsPathRelative(config.InstallPath) then
      config.InstallPath := ExpandFileName(config.InstallPath);

  FConfig := config;

  Result := config;
end;

procedure TLauncher.OnUpdateFinished(success : Boolean);
begin
  FUpdating := False;
  FUpToDate := success;
  FOnFinishCallback();
end;

procedure TLauncher.EnqueueStatusUpdate(text : string);
var
  callback : ProcStatusUpdate;
  Update : RGuiUpdate;
begin
  callback := FOnStatusCallback;
  Update := RGuiUpdate.Create(
    procedure()
    begin
      callback(text)
    end);
  if text.StartsWith('#') then Update.Important := True;
  FGuiUpdates.Enqueue(Update);
end;

procedure TLauncher.EnqueueProgressUpdate(percent : Single);
var
  callback : ProcProgressUpdate;
  Update : RGuiUpdate;
begin
  callback := FOnProgressCallback;
  Update := RGuiUpdate.Create(
    procedure()
    begin
      callback(percent)
    end);
  if (percent = 0) or (percent = 100) then Update.Important := True;
  FGuiUpdates.Enqueue(Update);
end;

procedure TLauncher.StartUpdate(onStatus : ProcStatusUpdate;
onProgress : ProcProgressUpdate; onFinish : TProc);
begin
  if FUpdating then Exit();

  FOnFinishCallback := onFinish;
  FOnStatusCallback := onStatus;
  FOnProgressCallback := onProgress;
  FUpdating := True;
  FUpdater := TUpdateWorker.Create(FConfig, EnqueueStatusUpdate, EnqueueProgressUpdate, OnUpdateFinished);
  FUpdater.Start();
end;

{ TUpdateWorker }

constructor TUpdateWorker.Create(config : TLauncherConfig;
onStatus : ProcStatusUpdate; onProgress : ProcProgressUpdate; onFinish : ProcProcessFinished);
begin
  inherited Create(True);

  FUpdating := False;
  FAbort := False;
  FConfig := config;
  FStatusUpdate := onStatus;
  FProgressUpdate := onProgress;
  FOnFinish := onFinish;
  FRepairMode := config.RepairMode;
  FCriticalFilePattern := '(exe|ets|script|dll|dws)$';

  FCrypto := TCryptoHelper.Create();

  FInternet := TInternet.Create();
end;

procedure TUpdateWorker.CheckForLauncherConfigUpdate;
var
  http : TInternet;
  config_file, local_checksum, remote_checksum : string;
begin
  // this checks requires the respective configuration settings
  if (FConfig.LauncherUpdateConfigChecksumURL = '') or (FConfig.LauncherUpdateConfigDownloadURL = '') then
      Exit;

  FStatusUpdate('Checking for new launcher config version...');

  http := TInternet.Create();

  config_file := FConfig.LauncherFiles + 'Config.xml';
  if HFilepathManager.FileExists(config_file) then
  begin
    local_checksum := HFileIO.FileToMD5Hash(AbsolutePath(config_file))
  end
  else local_checksum := '!';

  remote_checksum := http.DownloadString(FConfig.LauncherUpdateConfigChecksumURL);

  if remote_checksum = '' then
  begin
    raise Exception.Create('Could not check for new launcher config version (no checksum file on server)');
  end;

  if local_checksum <> remote_checksum then
  begin
    http.DownloadFile(FConfig.LauncherUpdateConfigDownloadURL, config_file);

    // apply the updated config by restart launcher
    ShellExecute(0, 'open', PChar(ParamStr(0)), '', nil, SW_NORMAL);

    // Exit this now outdated version of the launcher
    FStatusUpdate('\\EXIT');
    raise EAbort.Create([]);
  end;

  http.Free;
end;

procedure TUpdateWorker.CheckForLauncherUpdate();
var
  http : TInternet;
  localChecksum, remoteChecksum : string;
  updaterFile : string;
  launcherFileName, adminLauncherFileName : string;
  launcherUpdateFileName, adminLauncherUpdateFileName : string;
  totalSize : Int64;
  progress : Single;
  onProgress : TProgressEvent;
  launcherNewVersionFound : Boolean;
begin
  http := TInternet.Create();
  launcherNewVersionFound := False;

  updaterFile := HFilepathManager.RelativeToAbsolute(FConfig.UpdateExeFileName);
  // as this position we don't now if the admin or non privileged version of ther launcher is started
  // so we need to build a appname indepentent launcher filename
  // build the filenames within the updatefolder, because the updater will copy any file from this location
  launcherFileName := HFilepathManager.RelativeToAbsolute(ExtractFileName(ParamStr(0).Replace('.admin', '')));
  launcherUpdateFileName := HFilepathManager.RelativeToAbsolute(IncludeTrailingBackslash(FConfig.LauncherUpdatePath) + ExtractFileName(launcherFileName));
  adminLauncherFileName := ChangeFileExt(launcherFileName, '.admin.exe');
  adminLauncherUpdateFileName := HFilepathManager.RelativeToAbsolute(IncludeTrailingBackslash(FConfig.LauncherUpdatePath) + ExtractFileName(adminLauncherFileName));
  // first load update for non privileged launcher
  // this checks requires the respective configuration settings
  if (FConfig.LauncherUpdateChecksumURL = '') or (FConfig.LauncherUpdateDownloadURL = '') or
    (FConfig.LauncherAdminUpdateChecksumURL = '') or (FConfig.LauncherAdminUpdateDownloadURL = '') then
      Exit;
  FStatusUpdate('Checking for new launcher version...');
  // Get MD5 of this launcher
  // FileSetAttr(backupFile, faHidden);
  if FileExists(launcherFileName) then
      localChecksum := HFileIO.FileToMD5Hash(launcherFileName)
  else
      localChecksum := '!';
  // Compare with the MD5 of the up-to-date version online
  remoteChecksum := http.DownloadString(FConfig.LauncherUpdateChecksumURL);

  if remoteChecksum = '' then
  begin
    raise Exception.Create('Could not check for new launcher version (no checksum file on server)');
  end;

  if remoteChecksum <> localChecksum then
  begin
    // Download the new file
    FStatusUpdate('Downloading new launcher...');
    FProgressUpdate(0);
    // Callback that determines the total file size of the new launcher
    http.OnTotalSize :=
        procedure(numBytes : Int64)
      begin
        totalSize := numBytes;
      end;
    // Callback for download progress
    onProgress :=
        procedure(numBytes : Int64)
      begin
        progress := numBytes / totalSize * 100.0;
        FProgressUpdate(progress);
      end;
    // Download the new executable
    try
      http.DownloadFile(FConfig.LauncherUpdateDownloadURL, launcherUpdateFileName, onProgress);
    except
      raise Exception.Create('Download failed. Please download new launcher from "' +
        FConfig.LauncherUpdateDownloadURL + '"');
      Exit;
    end;
    launcherNewVersionFound := True;
  end;

  // as second load update for privileged launcher

  // Get MD5 of this launcher
  if FileExists(adminLauncherFileName) then
      localChecksum := HFileIO.FileToMD5Hash(adminLauncherFileName)
  else
      localChecksum := '!';
  // Compare with the MD5 of the up-to-date version online
  remoteChecksum := http.DownloadString(FConfig.LauncherAdminUpdateChecksumURL);

  if remoteChecksum = '' then
  begin
    raise Exception.Create('Could not check for new admin-launcher version (no checksum file on server)');
  end;

  if remoteChecksum <> localChecksum then
  begin
    // Download the new file
    FStatusUpdate('Downloading new launcher...');
    FProgressUpdate(0);
    // Callback that determines the total file size of the new launcher
    http.OnTotalSize :=
        procedure(numBytes : Int64)
      begin
        totalSize := numBytes;
      end;
    // Callback for download progress
    onProgress :=
        procedure(numBytes : Int64)
      begin
        progress := numBytes / totalSize * 100.0;
        FProgressUpdate(progress);
      end;
    // Download the new executable
    try
      http.DownloadFile(FConfig.LauncherAdminUpdateDownloadURL, adminLauncherUpdateFileName, onProgress);
    except
      raise Exception.Create('Download failed. Please download new launcher from "' +
        FConfig.LauncherAdminUpdateDownloadURL + '"');
      Exit;
    end;
    launcherNewVersionFound := True;
  end;

  if launcherNewVersionFound then
  begin
    FStatusUpdate('Patching launcher...');
    if FAbort then
        raise EAbort.Create([]);
    // Launch the updated file with options
    ShellExecute(0, 'open', PChar(updaterFile), PChar('"' + ParamStr(0) + '"'), nil, SW_HIDE);
    // Exit this now outdated version of the launcher
    FStatusUpdate('\\EXIT');
    raise EAbort.Create([]);
  end;
  http.Free();
end;

procedure TUpdateWorker.CheckForUpdaterUpdate;
var
  http : TInternet;
  updater_file, local_checksum, remote_checksum : string;
begin
  // this checks requires the respective configuration settings
  if (FConfig.UpdaterUpdateChecksumURL = '') or (FConfig.UpdaterUpdateDownloadURL = '') then
      Exit;

  FStatusUpdate('Checking for new Updater version...');

  http := TInternet.Create();

  updater_file := HFilepathManager.RelativeToAbsolute(FConfig.UpdateExeFileName);
  if HFilepathManager.FileExists(updater_file) then
  begin
    local_checksum := HFileIO.FileToMD5Hash(updater_file)
  end
  else local_checksum := '!';

  remote_checksum := http.DownloadString(FConfig.UpdaterUpdateChecksumURL);

  if remote_checksum = '' then
  begin
    raise Exception.Create('Could not check for new Updater version (no checksum file on server)');
  end;

  if local_checksum <> remote_checksum then
  begin
    http.DownloadFile(FConfig.UpdaterUpdateDownloadURL, updater_file);
  end;

  http.Free;
end;

function TUpdateWorker.ListFilesToUpdate() : TList<RDistFile>;
var
  local, remote : TDistListing;
  localDict : TDictionary<string, RDistFile>;
  f : RDistFile;
  i : Integer;
  progress : Single;
  regex : TRegEx;
  Hash : string;
  fileKnown, fileExist, fileHashEqual, fileCritical : Boolean;
  filesToHash : TList<RDistFile>;
  bytesToHash, bytesHashed : Int64;
begin
  local := FLocalListing;
  remote := FRemoteListing;
  Result := TList<RDistFile>.Create();
  regex := TRegEx.Create(FCriticalFilePattern, [roIgnoreCase]);
  FProgressUpdate(0);
  FStatusUpdate('Scanning local files...');
  filesToHash := TList<RDistFile>.Create();
  bytesToHash := 0;
  bytesHashed := 0;

  // Dictionary for local entries to speed up comparison
  localDict := TDictionary<string, RDistFile>.Create();
  i := 0;
  for f in local.Files do
  begin
    localDict.AddOrSetValue(f.Filename, f);

    i := i + 1;
    progress := (i / local.Files.Count) * 100;
    FProgressUpdate(progress);

    if FAbort then raise EAbort.Create([Result, filesToHash, localDict]);
  end;

  // Check all the remote files
  FProgressUpdate(0);
  for i := 0 to remote.Files.Count - 1 do
  begin
    f := remote.Files[i];
    progress := (i / remote.Files.Count) * 100;
    FProgressUpdate(progress);
    FStatusUpdate(Format('Checking files (%.2f %%) - "%s"', [progress, f.Filename]));

    // What we know and assume about the file
    fileKnown := localDict.ContainsKey(f.Filename);
    fileExist := FileExists(FConfig.InstallPath + '\' + f.Filename);
    // if file is unknow hash can't be equal, else compare local vs remote hash
    fileHashEqual := fileKnown and (localDict[f.Filename].Hash = f.Hash);
    fileCritical := regex.IsMatch(ExtractFileExt(f.Filename));

    // Existing but unknown or security relevant files need to be hashed
    if (fileExist) and ((not fileKnown) or fileCritical or FRepairMode) then
    begin
      filesToHash.Add(f);
      bytesToHash := bytesToHash + f.Size;
      Continue;
    end;

    // If the file hashes are not the same the file needs to be downloaded
    if (not fileHashEqual) then Result.Add(f);
    if FAbort then raise EAbort.Create([Result, localDict, filesToHash]);
  end;

  FProgressUpdate(0);
  i := 0;
  FDownloadStarted := TTimeManager.GetTimestamp;

  for f in filesToHash do
  begin
    if FAbort then raise EAbort.Create([Result, localDict, filesToHash]);

    progress := (i / remote.Files.Count) * 100;
    FProgressUpdate(progress);
    ReportHashProgress(bytesHashed, bytesToHash, f.Filename);

    if True then
    begin
      FCrypto.onProgress :=
          procedure(bytes : Int64)
        begin
          if (bytes mod (1024 * 1024) = 0) then
              ReportHashProgress(bytesHashed + bytes, bytesToHash, f.Filename);
        end;
    end;

    fileCritical := regex.IsMatch(ExtractFileExt(f.Filename));
    if fileCritical then
        Hash := FCrypto.FileSHA2(FConfig.InstallPath + '\' + f.Filename)
    else
        Hash := FCrypto.FileMD5(FConfig.InstallPath + '\' + f.Filename);
    fileHashEqual := f.Hash.Equals(Hash);

    if (not fileHashEqual) then
        Result.Add(f);

    bytesHashed := bytesHashed + f.Size;
  end;

  localDict.Free;
  filesToHash.Free();
end;

procedure TUpdateWorker.ReportHashProgress(curBytes : Int64; maxBytes : Int64; Filename : string);
var
  percent : Single;
  curMB, maxMB : Single;
  elapsedSeconds : Single;
  speed : Single;
begin
  percent := (curBytes / maxBytes) * 100;
  FProgressUpdate(percent);

  curMB := curBytes / (1024 * 1024);
  maxMB := maxBytes / (1024 * 1024);

  // calculate processing speed
  elapsedSeconds := (TTimeManager.GetTimestamp - FDownloadStarted) / 1000;
  if elapsedSeconds > 0 then speed := curMB / elapsedSeconds// MB/s
  else speed := 0;

  FStatusUpdate(Format('Comparing Files (%.2f %%, %.1f / %.1f MB; %.2f MB/s) - "%s"',
    [percent, curMB, maxMB, speed, Filename]));
end;

procedure TUpdateWorker.ReportDownloadProgress(curBytes : Int64; maxBytes : Int64; Filename : string);
var
  percent : Single;
  curMB, maxMB : Single;
  elapsedSeconds : Single;
  speed : Single;
begin
  percent := (curBytes / maxBytes) * 100;
  FProgressUpdate(percent);

  curMB := curBytes / (1024 * 1024);
  maxMB := maxBytes / (1024 * 1024);

  // calculate download speed
  elapsedSeconds := (TTimeManager.GetTimestamp - FDownloadStarted) / 1000.0;
  if elapsedSeconds > 0 then speed := curMB / elapsedSeconds// MB/s
  else speed := 0;

  FStatusUpdate(Format('Downloading Files (%.2f %%, %.1f / %.1f MB; %.2f MB/s) - "%s"',
    [percent, curMB, maxMB, speed, Filename]));
end;

procedure TUpdateWorker.DownloadFiles(Files : TList<RDistFile>);
var
  f : RDistFile;
  remoteUrl, localPath : string;
  downloadedBytes, numBytes : Int64;
begin
  FStatusUpdate('Computing download size...');
  FProgressUpdate(0);

  // compute download size
  numBytes := 0;
  downloadedBytes := 0;
  for f in Files do numBytes := numBytes + f.Size;

  // download the files
  FStatusUpdate('Downloading Files...');
  FDownloadStarted := TTimeManager.GetTimestamp;

  for f in Files do
  begin
    if FAbort then raise EAbort.Create([Files]);
    ReportDownloadProgress(downloadedBytes, numBytes, f.Filename);

    remoteUrl := FConfig.UpdateURL + '/' + f.Filename;
    localPath := FConfig.InstallPath + '\' + f.Filename;

    FInternet.onProgress :=
        procedure(bytes : Int64)
      begin
        ReportDownloadProgress(downloadedBytes + bytes, numBytes, f.Filename);
      end;

    try
      FInternet.DownloadFile(remoteUrl, localPath);
    except
      on e : Exception do
      begin
        // check if the file was downloaded partially
        if (FileExists(localPath)) and (FileSizeByName(localPath) <> f.Size) then
        begin
          // delete the local incomplete file
          DeleteFile(PChar(localPath));
        end;

        raise e;
      end;
    end;

    downloadedBytes := downloadedBytes + f.Size;
  end;
end;

procedure TUpdateWorker.Execute;
var
  filesToDownload : TList<RDistFile>;
begin
  FUpdating := True;

  try
    // Step 1: Preparations and checking for update on the remote server
    PrepareCrypto();
    EnsureInstallPath();
    // {$IFNDEF DEBUG}
    CheckForUpdaterUpdate();
    // {$ENDIF}
    // {$IFNDEF DEBUG}
    CheckForLauncherUpdate();
    // {$ENDIF}
    FProgressUpdate(25);
    if FAbort then raise EAbort.Create();

    {$IFNDEF DEBUG}
    CheckForLauncherConfigUpdate();
    {$ENDIF}
    FProgressUpdate(30);
    if FAbort then raise EAbort.Create();

    FLocalListing := GetLocalDist();
    FProgressUpdate(50);
    if FAbort then raise EAbort.Create();

    FStatusUpdate('Checking server version...');
    FRemoteListing := GetRemoteDist(FConfig.UpdateURL);
    FProgressUpdate(75);
    if FAbort then raise EAbort.Create();

    // Step 1 completed
    FStatusUpdate('#1');

    if not FConfig.SecureExecutables then
    begin
      // If security check is disabled we can fast forward once one can assume
      // that the local files are up to date
      if (FileExists(FConfig.LocalDistFile)) and
        (FCrypto.FileMD5(FConfig.LocalDistFile)
        .Equals(FCrypto.FileMD5(FConfig.LocalTempDistFile))) then
      begin
        FStatusUpdate('#2');
        FStatusUpdate('#3');
        FStatusUpdate('#4');
        FStatusUpdate('Game is up-to-date.');
        FProgressUpdate(100);
        FOnFinish(True);
        Exit();
      end;
    end;

    // What files need to be downloaded?
    filesToDownload := ListFilesToUpdate();
    FStatusUpdate('#2');

    // Step 3: Download the required files
    DownloadFiles(filesToDownload);
    filesToDownload.Free();
    FStatusUpdate('#3');

    if FAbort then raise EAbort.Create();
    // Step 3b: Save the remote dist.xml to represent the current local state
    CopyFile(PChar(FConfig.LocalTempDistFile), PChar(FConfig.LocalDistFile), False);

  except
    on aborted : EAbort do
    begin
      aborted.CleanUp();
      FOnFinish(False);
      Exit();
    end;
    on e : Exception do
    begin
      FStatusUpdate(e.Message);
      FOnFinish(False);
      Exit();
    end;
  end;

  FProgressUpdate(100);
  FStatusUpdate('Update completed.');
  FOnFinish(True);
end;

destructor TUpdateWorker.Destroy;
begin
  FCrypto.Free();
  FInternet.Free();
  if FRemoteListing <> nil then FreeAndNil(FRemoteListing);
  if FLocalListing <> nil then FreeAndNil(FLocalListing);

  FConfig.Free;

  inherited;
end;

procedure TUpdateWorker.EnsureInstallPath;
var
  path : string;
begin
  // Make sure there's a directory to install into
  path := HFilepathManager.RelativeToAbsolute(FConfig.InstallPath);
  if not ForceDirectories(path) then
  begin
    raise Exception.Create('Install dir could not be created');
  end;
end;

function TUpdateWorker.GetLocalDist() : TDistListing;
var
  listing : TDistListing;
  distPath, sigPath : string;
begin
  // Check the current installation state
  distPath := FConfig.LocalDistFile;
  if not FileExists(distPath) then
  begin
    // create a dummy dist listing so the rest of the code doesn't have to care
    listing := TDistListing.Create;
  end
  else
  begin
    // Look for the signature
    sigPath := FConfig.LocalSignature;
    if not FileExists(sigPath) then
        raise Exception.Create('No signature for local distribution file found');

    // Verify the distribution file
    if not FCrypto.VerifyFile(distPath, sigPath) then
        raise Exception.Create('Verification of local distribution file failed');

    // Deserialize it
    DoSynchronized(
      procedure()
      begin
        listing := HXMLSerializer.CreateAndLoadObjectFromFile<TDistListing>(distPath);
      end);
  end;

  Result := listing;
end;

function TUpdateWorker.GetRemoteDist(url : string) : TDistListing;
var
  distUrl, sigUrl : string;
  distPath, sigPath : string;
  listing : TDistListing;
begin
  distUrl := url + '/' + FConfig.RemoteDistFile;
  sigUrl := url + '/' + FConfig.RemoteSignature;
  distPath := FConfig.LocalTempDistFile;
  sigPath := FConfig.LocalSignature;

  // Download remote dist
  try
    FInternet.DownloadFile(distUrl, distPath);
  except
    raise Exception.Create('Download of remote distribution file has failed');
  end;

  // Download remote signature
  try
    FInternet.DownloadFile(sigUrl, sigPath);
  except
    raise Exception.Create('Download of remote distribution file signature failed');
  end;

  FStatusUpdate('Verifying distribution file...');

  // Verify the distribution file
  if not FCrypto.VerifyFile(distPath, sigPath) then
      raise Exception.Create('Verification of remote distribution file failed');

  // Load the listing
  try
    DoSynchronized(
      procedure()
      begin
        listing := HXMLSerializer.CreateAndLoadObjectFromFile<TDistListing>(distPath);
      end);
  except
    raise Exception.Create('Distribution file could not be loaded.');
  end;

  Result := listing;
end;

procedure TUpdateWorker.PrepareCrypto;
var
  publicKeyPath : string;
begin
  publicKeyPath := FConfig.PublicKeyFile;
  if not FileExists(publicKeyPath) then
  begin
    FStatusUpdate('Public key ''' + publicKeyPath + ''' was not found');
    raise Exception.Create('Public key ''' + publicKeyPath + ''' was not found');
  end;

  if not FCrypto.LoadPublicKey(publicKeyPath) then
  begin
    FStatusUpdate('Loading Public Key has failed');
    raise Exception.Create('Loading Public Key has failed');
  end;
end;

{ TLauncherConfig }

constructor TLauncherConfig.Create;
begin
  UpdateURL := 'http://download.baseconflict.de/Client/';
  LauncherUpdateChecksumURL := 'http://download.baseconflict.de/BCLauncher.exe.md5';
  LauncherUpdateDownloadURL := 'http://download.baseconflict.de/BCLauncher.exe';
  LauncherUpdateConfigChecksumURL := 'http://download.baseconflict.de/config.xml.md5';
  LauncherUpdateConfigDownloadURL := 'http://download.baseconflict.de/config.xml';

  LoginServerStatusURL := 'http://login.baseconflict.de/api/v1/status/loginserver/';
  FeaturedNewsURL := 'http://pixelsummoners.de/BaseConflict/Featured.html';
  NewsURL := 'http://alpha.gameloop.io/api/v1/baseconflict/updates/';

  // Where to store downloaded game files
  InstallPath := 'Game';

  // The file to execute when clicking Play button
  LaunchFile := 'BaseConflict.exe';

  // Set true to always check executable files against their hashes
  SecureExecutables := True;

  LauncherFiles := 'launcher/';

  // Path to local distribution listing file (will be downloaded at first run)
  LocalDistFile := 'launcher/dist.xml';
  LocalTempDistFile := 'launcher/dist.tmp';

  // Path to the distribution signature (will be downloaded at first run)
  LocalSignature := 'launcher/dist.sig';

  // URL relative to UpdateURL of remote distribution listing file
  RemoteDistFile := 'dist.xml';

  // URL relative to UpdateURL of remote distribution signature file
  RemoteSignature := 'dist.sig';

  // Path to public key file
  PublicKeyFile := 'launcher/pub.rsa';

  RepairMode := False;
end;

{ EAbort }

constructor EAbort.Create;
begin
  inherited Create('abort');
  FObjectsToFree := nil;
end;

procedure EAbort.CleanUp;
begin
  if FObjectsToFree = nil then Exit();

  // free all objects and the list itself
  FreeAndNil(FObjectsToFree);
end;

constructor EAbort.Create(objectsToFree : array of TObject);
var
  o : TObject;
begin
  inherited Create('abort');
  FObjectsToFree := TObjectList<TObject>.Create();
  for o in objectsToFree do
  begin
    FObjectsToFree.Add(o);
  end;
end;

{ TGuiUpdate }

constructor RGuiUpdate.Create(f : ProcUpdate);
begin
  Time := Now();
  Update := f;
  Important := False;
end;

end.
