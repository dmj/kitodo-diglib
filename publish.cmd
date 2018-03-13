@echo off

REM Veröffentlicht die als Parameter übergebene METS-Datei
REM
REM Timestamp: <2018-03-13 11:32:46 maus>
REM Autor: David Maus <maus@hab.de>
REM

set CALABASH=java -Xmx1024m -cp %~dp0lib\calabash\xmlcalabash-1.1.16-97.jar com.xmlcalabash.drivers.Main
set TARGET=S:

echo Strukturdatendokument in digitaler Bibliothek publizieren

set input=%1
set /p signatur="Normalisierte Signatur: "

set TARGET=%TARGET%\%signatur:/=\%

if not exist %TARGET% (
  echo Zielverzeichnis %TARGET% existiert nicht!
  pause
  exit 1
)

set TARGET=%TARGET%\meta\mets.xml

if exist %TARGET% (
  del /p %TARGET%
)

%CALABASH% -i file:/%input:\=/% src/xproc/publish.xpl objectId=%signatur% targetUri=file:/%TARGET:\=/%

if not errorlevel (
  echo Okay!
)

pause
