@echo on

:: Determine Qt Major verion (4 or 5)
set QT_MAJOR_VER=5

@echo Building for Qt%QT_MAJOR_VER%

:: Set QMAKESPEC to the appropriate MSVC compiler
:: Not really necessary in windows
:: set QMAKESPEC=%LIBRARY_PREFIX%\mkspecs\win32-msvc-default

@echo ====================================================
@echo Building Qscintilla2
@echo ====================================================
:: Go to the source folder and enter the Qt4Qt5 dir
cd %SRC_DIR%\Qt4Qt5
:: Use qmake to generate a make file
%LIBRARY_BIN%\qmake qscintilla.pro
if errorlevel 1 exit 1

@echo Compiling
:: Build and install
nmake
if errorlevel 1 exit 1
@echo Installing (copying)
@echo ====================================================
@echo PATH = %PATH%
@echo ====================================================
nmake install
if errorlevel 1 exit 1

@echo ====================================================
@echo Building Python bindings
@echo ====================================================
:: Python bindings
:: Go into the Python folder
cd %SRC_DIR%\Python
:: Use configure.py to generate a MAKEFILE
@echo Configuring with python
%PYTHON% configure.py --pyqt=PyQt%QT_MAJOR_VER%
if errorlevel 1 exit 1
:: Build and install
@echo Compiling python modules
nmake
if errorlevel 1 exit 1
@echo Installing python modules
nmake install
if errorlevel 1 exit 1
:: The qscintilla2.dll ends up in Anaconda's lib dir, where Python
:: can't find it for import. Copy it to the bin dir
:: (as indicated at http://pyqt.sourceforge.net/Docs/QScintilla2/)
copy %LIBRARY_LIB%\qscintilla2.dll %LIBRARY_BIN%
if errorlevel 1 exit 1
@echo finished
