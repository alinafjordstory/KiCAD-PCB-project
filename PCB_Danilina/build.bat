@echo off
REM ==========================================
REM KiCad script
REM ==========================================

REM Script folder
cd /d "%~dp0"

set PROJECT=PCB_Danilina
set OUTPUT_DIR=output_files

REM Result folder
if not exist %OUTPUT_DIR% mkdir %OUTPUT_DIR%

echo.
echo ==========================================
echo 1. ERC (Electrical Rules Check)
echo ==========================================
"D:\KiCAD\bin\kicad-cli.exe" sch erc --output %OUTPUT_DIR%\erc_report.rpt --exit-code-violations %PROJECT%.kicad_sch
if %errorlevel% neq 0 (
    echo [Warning] ERC errors, check %OUTPUT_DIR%\erc_report.rpt
) else (
    echo ERC successfully completed.
)

echo.
echo ==========================================
echo 2. DRC (Design Rules Check)
echo ==========================================
"D:\KiCAD\bin\kicad-cli.exe" pcb drc --output %OUTPUT_DIR%\drc_report.rpt --exit-code-violations %PROJECT%.kicad_pcb
if %errorlevel% neq 0 (
    echo [Warning] DRC errors, check %OUTPUT_DIR%\drc_report.rpt
) else (
    echo DRCsuccessfully completed.
)

echo.
echo ==========================================
echo 3. Gerber-files
echo ==========================================
if not exist %OUTPUT_DIR%\gerbers mkdir %OUTPUT_DIR%\gerbers
"D:\KiCAD\bin\kicad-cli.exe" pcb export gerbers --output %OUTPUT_DIR%\gerbers\ %PROJECT%.kicad_pcb
echo Gerber-files saved to %OUTPUT_DIR%\gerbers\

echo.
echo ==========================================
echo 4. BOM (Bill of Materials)
echo ==========================================
"D:\KiCAD\bin\kicad-cli.exe" sch export bom --output %OUTPUT_DIR%\bom.csv --fields "Reference,Value,Footprint,Manufacturer_Part_Number" %PROJECT%.kicad_sch
echo BOM saved to %OUTPUT_DIR%\bom.csv

echo.
echo ==========================================
echo 5. Scheme PDF-files
echo ==========================================
"D:\KiCAD\bin\kicad-cli.exe" sch export pdf --output %OUTPUT_DIR%\Danilina_schematic.pdf %PROJECT%.kicad_sch
echo PDF scheme saved to %OUTPUT_DIR%\Danilina_schematic.pdf

echo.
echo ==========================================
echo Done, all the results are in the folder.%OUTPUT_DIR%
echo ==========================================
pause