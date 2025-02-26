@powershell -NoProfile -ExecutionPolicy Unrestricted "$s = [scriptblock]::create((Get-Content \"%~f0\" | Where-Object {$_.readcount -gt 1}) -join \"`n\"); & $s \"%~dp0 %*\"" & goto:eof

# ����ȍ~�͑S��PowerShell�̃X�N���v�g

<#!
 #  MIT License
 #
 #  Copyright (c) 2025 menndouyukkuri, atolycs, Yu-yu0202
 #
 #  Permission is hereby granted, free of charge, to any person obtaining a copy
 #  of this software and associated documentation files (the "Software"), to deal
 #  in the Software without restriction, including without limitation the rights
 #  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 #  copies of the Software, and to permit persons to whom the Software is
 #  furnished to do so, subject to the following conditions:
 #
 #  The above copyright notice and this permission notice shall be included in all
 #  copies or substantial portions of the Software.
 #
 #  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 #  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 #  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 #  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 #  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 #  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 #  SOFTWARE.
#>

param (
	# �J�����g�f�B���N�g���̃p�X
	[string]$scriptFileRoot = (Get-Location).Path ,

	# AviUtl���C���X�g�[������f�B���N�g���̃p�X
	[string]$Path
)

$Host.UI.RawUI.WindowTitle = "�K�{�v���O�C���E�X�N���v�g���X�V����.cmd"
Write-Host "�K�{�v���O�C�� (patch.aul�EL-SMASH Works�EInputPipePlugin�Ex264guiEx) ����� LuaJIT�Aifheif �̍X�V���J�n���܂��B`r`n`r`n"

# settings �f�B���N�g���̏ꏊ���m�F
if (Test-Path ".\settings") {
	$settingsDirectoryPath = Convert-Path ".\settings"
} elseif (Test-Path "..\settings") {
	$settingsDirectoryPath = Convert-Path "..\settings"
} else {
	Write-Host "���������G���[: settings �t�H���_��������܂���B"
	Pause
	exit
}

# AviUtl Installer Script��zip�t�@�C�����W�J���ꂽ�Ǝv����f�B���N�g���̃p�X��ۑ�
$AisRootDir = Split-Path $settingsDirectoryPath -Parent

Write-Host -NoNewline "������..."

# AviUtl Installer Script��zip�t�@�C�����W�J���ꂽ�Ǝv����f�B���N�g�� ($AisRootDir) ����
# .cmd �t�@�C���� .ps1 �t�@�C���̃u���b�N������ (���s���ɖ��ʂȌx����\�������Ȃ�����)
Get-ChildItem -Path $AisRootDir -Include "*.cmd", "*.ps1" -Recurse | Unblock-File

Start-Sleep -Milliseconds 500

# script_files �f�B���N�g���̃p�X�� $scriptFilesDirectoryPath �Ɋi�[
	# settings �f�B���N�g���Ɠ����e�f�B���N�g���������Ƃ�O��Ƃ��Ă���̂Œ���
$scriptFilesDirectoryPath = Join-Path -Path $AisRootDir -ChildPath script_files

# script_files\ais-shared-function.ps1 ��ǂݍ���
. "${scriptFilesDirectoryPath}\ais-shared-function.ps1"

# script_files\PSConvertFromJsonEditable\ConvertFrom-JsonEditable.ps1 ��ǂݍ���
	# PSConvertFromJsonEditable (Author: ShwIws)
. "${scriptFilesDirectoryPath}\PSConvertFromJsonEditable\ConvertFrom-JsonEditable.ps1"

# ����������O�Ƀ`�F�b�N���A��肪����ꍇ�͏I�����邩���b�Z�[�W��\������ (ais-shared-function.ps1 �̊֐�)
CheckOfEnvironment

Write-Host "����"
Write-Host -NoNewline "`r`nAviUtl���C���X�g�[������Ă���t�H���_���m�F���Ă��܂�..."

Start-Sleep -Milliseconds 500

# aviutl.exe �������Ă���f�B���N�g����T���A$Path �Ƀp�X��ۑ�
if (($null -ne $Path) -and (Test-Path "${Path}\aviutl.exe")) {
	# ���Ƀp�����[�^�Ƃ��� aviutl.exe �������Ă���f�B���N�g�����n����Ă���ꍇ�A���b�Z�[�W�����\��
	Write-Host "����"
} elseif (Test-Path "C:\AviUtl\aviutl.exe") {
	$Path = "C:\AviUtl"
	Write-Host "����"
} elseif (Test-Path "C:\Applications\AviUtl\aviutl.exe") {
	$Path = "C:\Applications\AviUtl"
	Write-Host "����"
} else { # �m�F�ł��Ȃ������ꍇ�A���[�U�[�Ƀp�X����͂�����
	# 1���ڂ̃��b�Z�[�W�̕\���p�� false ��
	$PathIncludingSpace = $false

	# ���[�U�[�Ƀp�X����͂����Aaviutl.exe �������Ă��邱�Ƃ��m�F�����烋�[�v�𔲂���
	do {
		if (!($PathIncludingSpace)) {
			Write-Host "����"
			Write-Host "AviUtl���C���X�g�[������Ă���t�H���_���m�F�ł��܂���ł����B`r`n"
		}

		Write-Host "aviutl.exe �̃p�X�A�܂��� aviutl.exe �������Ă���t�H���_�̃p�X����͂��AEnter �������Ă��������B"
		Write-Host -NoNewline "> "
		$userInputAviutlExePath = $Host.UI.ReadLine()

		# ���͂��ꂽ�p�X�ɃX�y�[�X���܂܂�Ă���ꍇ
		if ($userInputAviutlExePath.Contains(" ")) {
			$PathIncludingSpace = $true

			Write-Host "`r`n�p�X�ɃX�y�[�X���܂܂�Ă���ƁA�s��̌����ɂȂ邽�ߋ�����Ă��܂���B"

			# ���[�U�[�̓��͂����Ƃ� aviutl.exe �̓����Ă���f�B���N�g���̃p�X�� $Path �ɑ��
			if ($userInputAviutlExePath -match "\\aviutl\.exe") {
				$Path = Split-Path $userInputAviutlExePath -Parent
			} else {
				$Path = $userInputAviutlExePath
			}

			# aviutl.exe �̓������t�H���_�̖��O�ɂ����X�y�[�X���Ȃ��̂��A����ȊO�ɂ��X�y�[�X������̂��𔻕ʂ��ă��b�Z�[�W��ς���
			$PathParent = Split-Path $Path -Parent
			if ($PathParent.Contains(" ")) {
				Write-Host "aviutl.exe �������Ă���t�H���_�̏ꏊ��ύX����Ȃǂ��āA�p�X�ɃX�y�[�X���܂܂�Ȃ��悤�ɂ��Ă��������B`r`n"
			} else {
				Write-Host "aviutl.exe �������Ă���t�H���_�̖��O��ύX����Ȃǂ��āA�p�X�ɃX�y�[�X���܂܂�Ȃ��悤�ɂ��Ă��������B`r`n"
			}
		# ���͂��ꂽ�p�X�ɃX�y�[�X���܂܂�Ă��Ȃ��ꍇ
		} else {
			$PathIncludingSpace = $false

			# ���[�U�[�̓��͂����Ƃ� aviutl.exe �̓����Ă���f�B���N�g���̃p�X�� $Path �ɑ��
			if ($userInputAviutlExePath -match "\\aviutl\.exe") {
				$Path = Split-Path $userInputAviutlExePath -Parent
			} else {
				$Path = $userInputAviutlExePath
			}

			Write-Host -NoNewline "`r`nAviUtl���C���X�g�[������Ă���t�H���_���m�F���Ă��܂�..."
		}
	} while (!(Test-Path "${Path}\aviutl.exe") -or $PathIncludingSpace)
	Write-Host "����"
}

Write-Host "${Path} �� aviutl.exe ���m�F���܂����B"
Write-Host -NoNewline "`r`napm.json ���m�F���Ă��܂�..."

# apm.json �����݂���ꍇ�A$apmJsonHash �ɓǂݍ��݁A$apmJsonExist �� true ���i�[
$apmJsonExist = $false
if (Test-Path "${Path}\apm.json") {
	$apmJsonHash = Get-Content "${Path}\apm.json" | ConvertFrom-JsonEditable
	$apmJsonExist = $true

# apm.json �����݂��Ȃ��ꍇ�Aapm.json �̌��ɂȂ�n�b�V���e�[�u����p�ӂ��� $apmJsonHash �ɑ��
} else {
	$apmJsonHash = [ordered]@{
		"dataVersion" = "3"
		"core" = [ordered]@{
			"aviutl" = "1.10"
			"exedit" = "0.92"
		}
		"packages" = [ordered]@{
			"nazono/patch" = [ordered]@{
				"id" = "nazono/patch"
				"version" = "r43_69"
			}
			"MrOjii/LSMASHWorks" = [ordered]@{
				"id" = "MrOjii/LSMASHWorks"
				"version" = "2025/02/18"
			}
			"amate/InputPipePlugin" = [ordered]@{
				"id" = "amate/InputPipePlugin"
				"version" = "v2.0_1"
			}
			"rigaya/x264guiEx" = [ordered]@{
				"id" = "rigaya/x264guiEx"
				"version" = "3.31"
			}
			"amate/MFVideoReader" = [ordered]@{
				"id" = "amate/MFVideoReader"
				"version" = "v1.0"
			}
			"satsuki/satsuki" = [ordered]@{
				"id" = "satsuki/satsuki"
				"version" = "20160828"
			}
			"nagomiku/paracustomobj" = [ordered]@{
				"id" = "nagomiku/paracustomobj"
				"version" = "v2.10"
			}
			"ePi/LuaJIT" = [ordered]@{
				"id" = "ePi/LuaJIT"
				"version" = "2.1.0-beta3"
			}
		}
	}
}

Write-Host "����"
Write-Host -NoNewline "`r`nais.json ���m�F���Ă��܂�..."

# ais.json �����݂���ꍇ�A$aisJsonHash �ɓǂݍ��݁A$aisJsonExist �� true ���i�[
$aisJsonExist = $false
if (Test-Path "${Path}\ais.json") {
	$aisJsonHash = Get-Content "${Path}\ais.json" | ConvertFrom-JsonEditable
	$aisJsonExist = $true

# ais.json �����݂��Ȃ��ꍇ�Aais.json �̌��ɂȂ�n�b�V���e�[�u����p�ӂ��� $aisJsonHash �ɑ��
} else {
	$aisJsonHash = [ordered]@{
		"dataVersion" = "1"
		"packages" = [ordered]@{
			"TORO/iftwebp" = @{
				"version" = "1.1"
			}
			"Mr-Ojii/ifheif" = @{
				"version" = "r62"
			}
			"tikubonn/straightLineObj" = @{
				"version" = "2021/03/07"
			}
			"Per-Terra/LuaJIT" = @{
				"version" = "2025/02/20"
			}
		}
	}
}

Write-Host "����"
Write-Host -NoNewline "`r`n�ꎞ�I�Ƀt�@�C����ۊǂ���t�H���_���쐬���Ă��܂�..."

# AviUtl �f�B���N�g������ plugins, script, license, readme ��4�̃f�B���N�g�����쐬���� (�ҋ@)
$aviutlPluginsDirectory = Join-Path -Path $Path -ChildPath plugins
$aviutlScriptDirectory = Join-Path -Path $Path -ChildPath script
$LicenseDirectoryRoot = Join-Path -Path $Path -ChildPath license
$ReadmeDirectoryRoot = Join-Path -Path $Path -ChildPath readme
Start-Process powershell -ArgumentList "-command New-Item $aviutlPluginsDirectory, $aviutlScriptDirectory, $LicenseDirectoryRoot, $ReadmeDirectoryRoot -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

# tmp �f�B���N�g�����쐬���� (�ҋ@)
Start-Process powershell -ArgumentList "-command New-Item tmp -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location tmp

Write-Host "����"
Write-Host -NoNewline "`r`n�t�H���_�[�I�v�V�������m�F���Ă��܂�..."

# �t�H���_�[�I�v�V�����́u�o�^����Ă���g���q�͕\�����Ȃ��v���L���̏ꍇ�A�����ɂ���
$ExplorerAdvancedRegKey = Get-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
if ($ExplorerAdvancedRegKey.HideFileExt -ne "0") {
	Write-Host "����"
	Write-Host -NoNewline "�u�o�^����Ă���g���q�͕\�����Ȃ��v�𖳌��ɂ��Ă��܂�..."

	# C:\Applications\AviUtl-Installer-Script �f�B���N�g�����쐬���� (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"C:\Applications\AviUtl-Installer-Script`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion" ���o�b�N�A�b�v (�ҋ@)
	Start-Process powershell -ArgumentList "-command reg export `"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion`" `"C:\Applications\AviUtl-Installer-Script\Backup.reg`"" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" ���Ȃ��ꍇ�A�쐬���� (�ҋ@)
	if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced")) {
		Start-Process powershell -ArgumentList "-command New-Item `"HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced`" -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait
	}

	# ���W�X�g�������������āu�o�^����Ă���g���q�͕\�����Ȃ��v�𖳌���
	Set-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value "0" -Force
}

Write-Host "����"
Write-Host -NoNewline "`r`nAviUtl�{�̂̃o�[�W�������m�F���Ă��܂�..."

# apm.json �����݂���ꍇ�AAviUtl�̃o�[�W�������Q�Ƃ���1.10�łȂ���΍X�V����B�܂��Aapm.json �����݂��Ȃ��ꍇ�A
# aviutl.vfp �𔭌�������1.00�ȑO�̉\�������邽�ߍX�V���� (1.10�ɂ� aviutl.vfp �͕t�����Ȃ�����)
if (($apmJsonExist -and ($apmJsonHash["core"]["aviutl"] -ne "1.10")) -or
	(($apmJsonExist -eq $false) -and (Test-Path "${Path}\aviutl.vfp"))) {
	Write-Host "����"
	Write-Host -NoNewline "AviUtl�{�� (version 1.10) ���_�E�����[�h���Ă��܂�..."

	# AviUtl version 1.10��zip�t�@�C�����_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL http://spring-fragrance.mints.ne.jp/aviutl/aviutl110.zip" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host -NoNewline "AviUtl�{�̂��C���X�g�[�����Ă��܂�..."

	# AviUtl��zip�t�@�C����W�J (�ҋ@)
	Start-Process powershell -ArgumentList "-command Expand-Archive -Path aviutl110.zip -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# �J�����g�f�B���N�g���� aviutl110 �f�B���N�g���ɕύX
	Set-Location aviutl110

	# AviUtl\readme ���� aviutl �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\aviutl`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# AviUtl �f�B���N�g������ aviutl.exe �� aviutl.txt ���ړ�
	Move-Item "aviutl.exe", "aviutl.txt" $Path -Force
	
	# �s�v�� aviutl.vfp ���폜
	Remove-Item "${Path}\aviutl.vfp"

	# VFPlugin�����W�X�g���ɓo�^����Ă��邩�m�F
	if (Test-Path "HKCU:\Software\VFPlugin") {
		# aviutl.vfp �̃��W�X�g���ւ�VFPlugin�o�^���m�F
		$vfpluginRegKey = Get-ItemProperty "HKCU:\Software\VFPlugin"
		if ($null -ne $vfpluginRegKey.AviUtl) {
			# aviutl.vfp �̃��W�X�g���ւ�VFPlugin�o�^���폜
			Remove-ItemProperty -Path "HKCU:\Software\VFPlugin" -Name AviUtl
		}
	}

	# apm.json ��AviUtl�̃o�[�W�������X�V
	$apmJsonHash["core"]["aviutl"] = "1.10"

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location ..

	# AviUtl\readme\aviutl ���� aviutl.txt ���R�s�[
	Copy-Item "${Path}\aviutl.txt" "${ReadmeDirectoryRoot}\aviutl" -Force
}

Write-Host "����"
Write-Host -NoNewline "`r`n�g���ҏWPlugin�̃C���X�g�[������Ă���t�H���_���m�F���Ă��܂�..."

# �g���ҏWPlugin�� plugins �f�B���N�g�����ɂ���ꍇ�AAviUtl �f�B���N�g�����Ɉړ������� (�G���[�̖h�~)
if (Test-Path "${aviutlPluginsDirectory}\exedit.auf") {
	# �J�����g�f�B���N�g���� plugins �f�B���N�g���ɕύX
	Set-Location $aviutlPluginsDirectory

	# �g���ҏWPlugin�̃t�@�C����S�� AviUtl �f�B���N�g�����Ɉړ�
	Move-Item "exedit*" $Path -Force
	Move-Item lua51.dll $Path -Force
	if (Test-Path "${aviutlPluginsDirectory}\lua.txt") {
		Move-Item lua.txt $Path -Force
	}
	if (Test-Path "${aviutlPluginsDirectory}\lua51jit.dll") {
		Move-Item lua51jit.dll $Path -Force
	}

	# script �f�B���N�g���̏ꏊ�������ĕύX
	if (Test-Path "${aviutlPluginsDirectory}\script") {
		Move-Item "${aviutlPluginsDirectory}\script" $Path -Force
	}

	# Susie�v���O�C���̏ꏊ�������ĕύX
	if (Test-Path "${aviutlPluginsDirectory}\*.spi") {
		Move-Item "*.spi" $Path -Force
	}

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location "${scriptFileRoot}\tmp"
}

Write-Host "����"

# �g���ҏWPlugin��������Ȃ��ꍇ�A�g���ҏWPlugin���_�E�����[�h���ē�������
# apm.json �����݂���ꍇ�A�g���ҏWPlugin�̃o�[�W�������Q�Ƃ���0.92�łȂ���Βu��������B�܂��Aapm.json ��
# ���݂��Ȃ��ꍇ�A�g���ҏWPlugin 0.93�e�X�g�łɂ̂ݕt������ lua51jit.dll �𔭌�������0.92�Œu��������
if ((!(Test-Path "${Path}\exedit.auf")) -or
	($apmJsonExist -and ($apmJsonHash["core"]["exedit"] -ne "0.92")) -or
	(($apmJsonExist -eq $false) -and (Test-Path "${Path}\lua51jit.dll"))) {
	Write-Host -NoNewline "`r`n�g���ҏWPlugin version 0.92���_�E�����[�h���Ă��܂�..."

	# �g���ҏWPlugin version 0.92��zip�t�@�C�����_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL http://spring-fragrance.mints.ne.jp/aviutl/exedit92.zip" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host -NoNewline "�g���ҏWPlugin���C���X�g�[�����Ă��܂�..."

	# �g���ҏWPlugin��zip�t�@�C����W�J (�ҋ@)
	Start-Process powershell -ArgumentList "-command Expand-Archive -Path exedit92.zip -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# �J�����g�f�B���N�g���� exedit92 �f�B���N�g���ɕύX
	Set-Location exedit92

	# AviUtl\readme ���� exedit �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\exedit`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# exedit.ini �͎g�p�����A�����̌�̏����Ŏז��ɂȂ�̂ō폜���� (�ҋ@)
	Start-Process powershell -ArgumentList "-command Remove-Item exedit.ini" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# AviUtl �f�B���N�g�����Ƀt�@�C����S�Ĉړ�
	Move-Item * $Path -Force

	# �s�v�� lua51jit.dll ���폜
	if (Test-Path "${Path}\lua51jit.dll") {
		Remove-Item "${Path}\lua51jit.dll"
	}

	# apm.json �̊g���ҏWPlugin�̃o�[�W�������X�V
	$apmJsonHash["core"]["exedit"] = "0.92"

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location ..

	Write-Host "����"

	# AviUtl\readme\exedit ���� exedit.txt, lua.txt ���R�s�[
	Copy-Item "${Path}\exedit.txt", "${Path}\lua.txt" "${ReadmeDirectoryRoot}\exedit" -Force
}

Write-Host -NoNewline "`r`npatch.aul (�䂳���ȃt�H�[�N��) �̍ŐV�ŏ����擾���Ă��܂�..."

# patch.aul (�䂳���ȃt�H�[�N��) �̍ŐV�ł̃_�E�����[�hURL���擾
$patchAulGithubApi = GithubLatestRelease "nazonoSAUNA/patch.aul"
$patchAulUrl = $patchAulGithubApi.assets.browser_download_url

# apm.json ������A���ŐV�ł̏�񂪋L�ڂ���Ă���ꍇ�̓X�L�b�v����
if (!($apmJsonExist -and $apmJsonHash.packages.Contains("nazono/patch") -and
	($apmJsonHash["packages"]["nazono/patch"]["version"] -eq $patchAulGithubApi.tag_name))) {
	Write-Host "����"
	Write-Host -NoNewline "patch.aul (�䂳���ȃt�H�[�N��) ���_�E�����[�h���Ă��܂�..."

	# patch.aul (�䂳���ȃt�H�[�N��) ��zip�t�@�C�����_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL $patchAulUrl" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host -NoNewline "patch.aul (�䂳���ȃt�H�[�N��) ���C���X�g�[�����Ă��܂�..."

	# patch.aul��zip�t�@�C����W�J (�ҋ@)
	Start-Process powershell -ArgumentList "-command Expand-Archive -Path patch.aul_*.zip -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# �J�����g�f�B���N�g����patch.aul��zip�t�@�C����W�J�����f�B���N�g���ɕύX
	Set-Location "patch.aul_*"

	# AviUtl\license ���� patch-aul �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${LicenseDirectoryRoot}\patch-aul`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# patch.aul �� plugins �f�B���N�g�����ɂ���ꍇ�A�폜���� patch.aul.json ���ړ������� (�G���[�̖h�~)
	if (Test-Path "${aviutlPluginsDirectory}\patch.aul") {
		Remove-Item "${aviutlPluginsDirectory}\patch.aul"
		if ((Test-Path "${aviutlPluginsDirectory}\patch.aul.json") -and (!(Test-Path "${Path}\patch.aul.json"))) {
			Move-Item "${aviutlPluginsDirectory}\patch.aul.json" $Path -Force
		} elseif (Test-Path "${aviutlPluginsDirectory}\patch.aul.json") {
			Remove-Item "${aviutlPluginsDirectory}\patch.aul.json"
		}
	}

	# AviUtl �f�B���N�g������ patch.aul �� (�ҋ@) �AAviUtl\license\patch-aul ���ɂ��̑��̃t�@�C�������ꂼ��ړ�
	Start-Process powershell -ArgumentList "-command Move-Item patch.aul $Path -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait
	Move-Item * "${LicenseDirectoryRoot}\patch-aul" -Force

	# apm.json �� ePi/patch ���o�^����Ă���ꍇ�͍폜
	if ($apmJsonHash.packages.Contains("ePi/patch")) {
		$apmJsonHash.packages.Remove("ePi/patch")
	}

	# apm.json �� sets/scrapboxAviUtl ���o�^����Ă���ꍇ�͍폜
	if ($apmJsonHash.packages.Contains("sets/scrapboxAviUtl")) {
		$apmJsonHash.packages.Remove("sets/scrapboxAviUtl")
	}

	# apm.json �� nazono/patch ���o�^����Ă��Ȃ��ꍇ�̓L�[���쐬����id��o�^
	if (!($apmJsonHash.packages.Contains("nazono/patch"))) {
		$apmJsonHash["packages"]["nazono/patch"] = [ordered]@{}
		$apmJsonHash["packages"]["nazono/patch"]["id"] = "nazono/patch"
	}

	# apm.json �� nazono/patch �̃o�[�W�������X�V
	$apmJsonHash["packages"]["nazono/patch"]["version"] = $patchAulGithubApi.tag_name

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location ..
}

Write-Host "����"
Write-Host -NoNewline "`r`npatch.aul (�䂳���ȃt�H�[�N��) �Ƌ�������v���O�C���̗L�����m�F���Ă��܂�..."

# bakusoku.auf ���m�F���A��������폜
if (Test-Path "${Path}\bakusoku.auf") {
	Remove-Item "${Path}\bakusoku.auf"
}
if (Test-Path "${aviutlPluginsDirectory}\bakusoku.auf") {
	Remove-Item "${aviutlPluginsDirectory}\bakusoku.auf"
}
Get-ChildItem -Path $aviutlPluginsDirectory -Directory | ForEach-Object {
	if (Test-Path -Path "${_}\bakusoku.auf") {
		Remove-Item "${_}\bakusoku.auf"
	}
}

# apm.json �� suzune/bakusoku ���o�^����Ă���ꍇ�͍폜
if ($apmJsonHash.packages.Contains("suzune/bakusoku")) {
	$apmJsonHash.packages.Remove("suzune/bakusoku")
}

# Boost.auf ���m�F���A��������폜
if (Test-Path "${Path}\Boost.auf") {
	Remove-Item "${Path}\Boost.auf"
}
if (Test-Path "${aviutlPluginsDirectory}\Boost.auf") {
	Remove-Item "${aviutlPluginsDirectory}\Boost.auf"
}
Get-ChildItem -Path $aviutlPluginsDirectory -Directory | ForEach-Object {
	if (Test-Path -Path "${_}\Boost.auf") {
		Remove-Item "${_}\Boost.auf"
	}
}

# apm.json �� suzune/bakusoku ���o�^����Ă���ꍇ�͍폜
if ($apmJsonHash.packages.Contains("yanagi/Boost")) {
	$apmJsonHash.packages.Remove("yanagi/Boost")
}

Write-Host "����"
Write-Host -NoNewline "`r`nL-SMASH Works (Mr-Ojii��) �̍ŐV�ŏ����擾���Ă��܂�..."

# L-SMASH Works�̓����Ă���f�B���N�g����T���A$lwinputAuiDirectory �Ƀp�X��ۑ�
# $inputPipePluginDeleteCheckDirectory �� $lwinputAuiDirectory �̋t�A��Ɏg�p
if (Test-Path "${Path}\lwinput.aui") {
	$lwinputAuiDirectory = $Path
	$inputPipePluginDeleteCheckDirectory = $aviutlPluginsDirectory
} else {
	$lwinputAuiDirectory = $aviutlPluginsDirectory
	$inputPipePluginDeleteCheckDirectory = $Path
}

# L-SMASH Works (Mr-Ojii��) �̍ŐV�ł̃_�E�����[�hURL���擾
$lSmashWorksGithubApi = GithubLatestRelease "Mr-Ojii/L-SMASH-Works-Auto-Builds"
$lSmashWorksAllUrl = $lSmashWorksGithubApi.assets.browser_download_url

# �������钆����AviUtl�p�̂��̂̂ݎc��
$lSmashWorksUrl = $lSmashWorksAllUrl | Where-Object {$_ -like "*Mr-Ojii_vimeo*"}

# apm.json �p�Ƀ^�O�����擾���ăr���h���������o�� yyyy/mm/dd �ɐ��`
$lSmashWorksTagNameSplitArray = ($lSmashWorksGithubApi.tag_name) -split "-"
$lSmashWorksBuildDate = $lSmashWorksTagNameSplitArray[1] + "/" + $lSmashWorksTagNameSplitArray[2] + "/" + $lSmashWorksTagNameSplitArray[3]

# apm.json ��L-SMASH Works�̃o�[�W������ / �ŕ������� $apmJsonLSmashWorksVersionArray �Ɋi�[
if ($apmJsonExist -and $apmJsonHash.packages.Contains("MrOjii/LSMASHWorks")) {
	$apmJsonLSmashWorksVersionArray = $apmJsonHash["packages"]["MrOjii/LSMASHWorks"]["version"] -split "/"
} else {
	$apmJsonLSmashWorksVersionArray = 0, 0, 0
}

# $lSmashWorksUpdate ��L-SMASH Works���X�V���邩�ǂ������i�[
$lSmashWorksUpdate = $true

# apm.json �̔N > �擾�����r���h���̔N
if ($apmJsonLSmashWorksVersionArray[0] -gt $lSmashWorksTagNameSplitArray[1]) {
	$lSmashWorksUpdate = $false

# apm.json �̔N < �擾�����r���h���̔N
} elseif ($apmJsonLSmashWorksVersionArray[0] -lt $lSmashWorksTagNameSplitArray[1]) {
	# if���𗣒E�A�����艺�̏����� apm.json �̔N = �擾�����r���h���̔N

# apm.json �̌� > �擾�����r���h���̌�
} elseif ($apmJsonLSmashWorksVersionArray[1] -gt $lSmashWorksTagNameSplitArray[2]) {
	$lSmashWorksUpdate = $false

# apm.json �̌� < �擾�����r���h���̌�
} elseif ($apmJsonLSmashWorksVersionArray[1] -lt $lSmashWorksTagNameSplitArray[2]) {
	# if���𗣒E�A�����艺�̏����� apm.json �̌� = �擾�����r���h���̌�

# apm.json �̓� >= �擾�����r���h���̓�
} elseif ($apmJsonLSmashWorksVersionArray[2] -ge $lSmashWorksTagNameSplitArray[3]) {
	$lSmashWorksUpdate = $false
}

# apm.json �̃o�[�W�������擾�����r���h���̕����V�����ꍇ�͍X�V����
if ($lSmashWorksUpdate) {
	Write-Host "����"
	Write-Host -NoNewline "L-SMASH Works (Mr-Ojii��) ���_�E�����[�h���Ă��܂�..."

	# L-SMASH Works (Mr-Ojii��) ��zip�t�@�C�����_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL $lSmashWorksUrl" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host -NoNewline "L-SMASH Works (Mr-Ojii��) ���C���X�g�[�����Ă��܂�..."

	# AviUtl\license\l-smash_works ���� Licenses �f�B���N�g��������΍폜���� (�G���[�̖h�~)
	if (Test-Path "${LicenseDirectoryRoot}\l-smash_works\Licenses") {
		Remove-Item "${LicenseDirectoryRoot}\l-smash_works\Licenses" -Recurse
	}

	# AviUtl �f�B���N�g���₻�̃T�u�f�B���N�g������ .lwi �t�@�C�����폜���� (�G���[�̖h�~)
	if (Test-Path "*.lwi") {
		Remove-Item "*.lwi"
	}
	Get-ChildItem -Path $Path -Directory -Recurse | ForEach-Object {
		if (Test-Path -Path "${_}\*.lwi") {
			Remove-Item "${_}\*.lwi"
		}
	}

	# L-SMASH Works��zip�t�@�C����W�J (�ҋ@)
	Start-Process powershell -ArgumentList "-command Expand-Archive -Path L-SMASH-Works_*.zip -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# �J�����g�f�B���N�g����L-SMASH Works��zip�t�@�C����W�J�����f�B���N�g���ɕύX
	Set-Location "L-SMASH-Works_*"

	# AviUtl\readme, AviUtl\license ���� l-smash_works �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\l-smash_works`", `"${LicenseDirectoryRoot}\l-smash_works`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# $lwinputAuiDirectory �f�B���N�g������ lw*.au* ���AAviUtl\readme\l-smash_works ���� READM* �� (�ҋ@) �A
	# AviUtl\license\l-smash_works ���ɂ��̑��̃t�@�C�������ꂼ��ړ�
	Start-Process powershell -ArgumentList "-command Move-Item lw*.au* $lwinputAuiDirectory -Force; Move-Item READM* `"${ReadmeDirectoryRoot}\l-smash_works`" -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait
	Move-Item * "${LicenseDirectoryRoot}\l-smash_works" -Force

	# apm.json �� pop4bit/LSMASHWorks ���o�^����Ă���ꍇ�͍폜
	if ($apmJsonHash.packages.Contains("pop4bit/LSMASHWorks")) {
		$apmJsonHash.packages.Remove("pop4bit/LSMASHWorks")
	}

	# apm.json �� VFRmaniac/LSMASHWorks ���o�^����Ă���ꍇ�͍폜
	if ($apmJsonHash.packages.Contains("VFRmaniac/LSMASHWorks")) {
		$apmJsonHash.packages.Remove("VFRmaniac/LSMASHWorks")
	}

	# apm.json �� HolyWu/LSMASHWorks ���o�^����Ă���ꍇ�͍폜
	if ($apmJsonHash.packages.Contains("HolyWu/LSMASHWorks")) {
		$apmJsonHash.packages.Remove("HolyWu/LSMASHWorks")
	}

	# apm.json �� MrOjii/LSMASHWorks ���o�^����Ă��Ȃ��ꍇ�̓L�[���쐬����id��o�^
	if (!($apmJsonHash.packages.Contains("MrOjii/LSMASHWorks"))) {
		$apmJsonHash["packages"]["MrOjii/LSMASHWorks"] = [ordered]@{}
		$apmJsonHash["packages"]["MrOjii/LSMASHWorks"]["id"] = "MrOjii/LSMASHWorks"
	}

	# apm.json �� MrOjii/LSMASHWorks �̃o�[�W�������X�V
	$apmJsonHash["packages"]["MrOjii/LSMASHWorks"]["version"] = $lSmashWorksBuildDate

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location ..
}

# L-SMASH Works�̐ݒ�t�@�C����������Ȃ��ꍇ�̂݁A�ȉ��̏��������s
if (!(Test-Path "${lwinputAuiDirectory}\lsmash.ini")) {
	Copy-Item "${settingsDirectoryPath}\lsmash.ini" $lwinputAuiDirectory
}

Write-Host "����"
Write-Host -NoNewline "`r`nInputPipePlugin�̍ŐV�ŏ����擾���Ă��܂�..."

# InputPipePlugin�̍ŐV�ł̃_�E�����[�hURL���擾
$InputPipePluginGithubApi = GithubLatestRelease "amate/InputPipePlugin"
$InputPipePluginUrl = $InputPipePluginGithubApi.assets.browser_download_url

# GitHub����擾�����������ƂɁAapm.json �ɋL�ڂ���Ă���o�[�W�������r���邽�߂Ɍ`�������킹���o�[�W��������
# $InputPipePluginLatestApmFormat �Ɋi�[����
	# ��{�I�ɂ͎擾�����^�O�������̂܂܊i�[����΂悢�B
	# �������AAviUtl Package Manager �� L-SMASH Works �� InputPipePlugin �̃l�C�e�B�u64bit�Ή���
	# �t�@�C�����C���X�g�[�����Ȃ�������� (Issue: https://github.com/team-apm/apm/issues/1666 etc.)
	# �̏C���ɂ��A��ʂ̂��� apm.json �ɂ� InputPipePlugin �̃o�[�W����2.0�� v2.0_1 �ƋL�ڂ����悤��
	# �Ȃ��Ă���͗l�B���̂��߁Av2.0 �̏ꍇ�͂��̂܂ܓo�^����̂ł͂Ȃ� v2.0_1 �Ƃ���B
	# �Q�l: https://github.com/team-apm/apm-data/commit/240a170cc0b121f9b9d1edbe20f19f89146f03aa
if ($InputPipePluginGithubApi.tag_name -eq "v2.0") {
	$InputPipePluginLatestApmFormat = "v2.0_1"
} else {
	$InputPipePluginLatestApmFormat = $InputPipePluginGithubApi.tag_name
}

# apm.json ������A���ŐV�ł̏�񂪋L�ڂ���Ă���ꍇ�̓X�L�b�v����
if (!($apmJsonExist -and $apmJsonHash.packages.Contains("amate/InputPipePlugin") -and
	($apmJsonHash["packages"]["amate/InputPipePlugin"]["version"] -eq $InputPipePluginLatestApmFormat))) {
	Write-Host "����"
	Write-Host -NoNewline "InputPipePlugin���_�E�����[�h���Ă��܂�..."

	# InputPipePlugin��zip�t�@�C�����_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL $InputPipePluginUrl" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host -NoNewline "InputPipePlugin���C���X�g�[�����Ă��܂�..."

	# InputPipePlugin��zip�t�@�C����W�J (�ҋ@)
	Start-Process powershell -ArgumentList "-command Expand-Archive -Path InputPipePlugin_*.zip -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# �J�����g�f�B���N�g����InputPipePlugin��zip�t�@�C����W�J�����f�B���N�g���ɕύX
	Set-Location "InputPipePlugin_*\InputPipePlugin"

	# AviUtl\readme, AviUtl\license ���� inputPipePlugin �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\inputPipePlugin`", `"${LicenseDirectoryRoot}\inputPipePlugin`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# AviUtl\license\inputPipePlugin ���� LICENSE ���AAviUtl\readme\inputPipePlugin ���� Readme.md �� (�ҋ@) �A
	# $lwinputAuiDirectory �f�B���N�g�����ɂ��̑��̃t�@�C�������ꂼ��ړ�
	Start-Process powershell -ArgumentList "-command Move-Item LICENSE `"${LicenseDirectoryRoot}\inputPipePlugin`" -Force; Move-Item Readme.md `"${ReadmeDirectoryRoot}\inputPipePlugin`" -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait
	Move-Item * $lwinputAuiDirectory -Force

	# �g���u���̌����ɂȂ�t�@�C���̏���
	Set-Location $inputPipePluginDeleteCheckDirectory
	if (Test-Path "InputPipe*") {
		Remove-Item "InputPipe*"
	}
	Set-Location $scriptFileRoot

	# apm.json �� amate/InputPipePlugin ���o�^����Ă��Ȃ��ꍇ�̓L�[���쐬����id��o�^
	if (!($apmJsonHash.packages.Contains("amate/InputPipePlugin"))) {
		$apmJsonHash["packages"]["amate/InputPipePlugin"] = [ordered]@{}
		$apmJsonHash["packages"]["amate/InputPipePlugin"]["id"] = "amate/InputPipePlugin"
	}

	# apm.json �� amate/InputPipePlugin �̃o�[�W�������X�V
	if ($InputPipePluginGithubApi.tag_name -eq "v2.0") {
		$apmJsonHash["packages"]["amate/InputPipePlugin"]["version"] = "v2.0_1"
	} else {
		$apmJsonHash["packages"]["amate/InputPipePlugin"]["version"] = $InputPipePluginGithubApi.tag_name
	}

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location tmp
}

Write-Host "����"
Write-Host -NoNewline "`r`nx264guiEx�̍ŐV�ŏ����擾���Ă��܂�..."

# x264guiEx�̍ŐV�ł̃_�E�����[�hURL���擾
$x264guiExGithubApi = GithubLatestRelease "rigaya/x264guiEx"
$x264guiExUrl = $x264guiExGithubApi.assets.browser_download_url

# apm.json ������A���ŐV�ł̏�񂪋L�ڂ���Ă���ꍇ�̓X�L�b�v����
if (!($apmJsonExist -and $apmJsonHash.packages.Contains("rigaya/x264guiEx") -and
	($apmJsonHash["packages"]["rigaya/x264guiEx"]["version"] -eq $x264guiExGithubApi.tag_name))) {
	Write-Host "����"
	Write-Host -NoNewline "x264guiEx���_�E�����[�h���Ă��܂�..."

	# x264guiEx��zip�t�@�C�����_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL $x264guiExUrl" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# x264guiEx��zip�t�@�C����W�J (�ҋ@)
	Start-Process powershell -ArgumentList "-command Expand-Archive -Path x264guiEx_*.zip -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# �J�����g�f�B���N�g����x264guiEx��zip�t�@�C����W�J�����f�B���N�g���ɕύX
	Set-Location "x264guiEx_*\x264guiEx_*"

	# �J�����g�f�B���N�g����x264guiEx��zip�t�@�C����W�J�����f�B���N�g������ plugins �f�B���N�g���ɕύX
	Set-Location plugins

	Write-Host "����"

	# AviUtl\plugins ���� x264guiEx_stg �f�B���N�g��������Έȉ��̏��������s
	if (Test-Path "${aviutlPluginsDirectory}\x264guiEx_stg") {
		# �v���t�@�C�����㏑�����邩�ǂ������[�U�[�Ɋm�F���� (����� �㏑�����Ȃ�)

		# �I����������

		$x264guiExChoiceTitle = "x264guiEx�̃v���t�@�C�����㏑�����܂����H"
		$x264guiExChoiceMessage = "�v���t�@�C���͍X�V�ŐV�����Ȃ��Ă���\��������܂����A�㏑�������s����ƒǉ������v���t�@�C����v���t�@�C���ւ̕ύX���폜����܂��B"

		$x264guiExTChoiceDescription = "System.Management.Automation.Host.ChoiceDescription"
		$x264guiExChoiceOptions = @(
			New-Object $x264guiExTChoiceDescription ("�͂�(&Y)",  "�㏑�������s���܂��B")
			New-Object $x264guiExTChoiceDescription ("������(&N)", "�㏑���������A�X�L�b�v���Ď��̏����ɐi�݂܂��B")
		)

		$x264guiExChoiceResult = $host.ui.PromptForChoice($x264guiExChoiceTitle, $x264guiExChoiceMessage, $x264guiExChoiceOptions, 1)
		switch ($x264guiExChoiceResult) {
			0 {
				Write-Host -NoNewline "�v���t�@�C�����㏑�����܂�..."

				# AviUtl\plugins ���� x264guiEx_stg �f�B���N�g�����폜���� (�ҋ@)
				Start-Process powershell -ArgumentList "-command Remove-Item `"${aviutlPluginsDirectory}\x264guiEx_stg`" -Recurse" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

				# AviUtl\plugins ���� x264guiEx_stg �f�B���N�g�����ړ�
				Move-Item x264guiEx_stg $aviutlPluginsDirectory -Force

				Write-Host "����`r`n"
				break
			}
			1 {
				# ��Ŏז��ɂȂ�̂ō폜
				Remove-Item x264guiEx_stg -Recurse

				Write-Host "�v���t�@�C���̏㏑�����X�L�b�v���܂����B`r`n"
				break
			}
		}

		# �I�������܂�
	}

	Write-Host -NoNewline "x264guiEx���C���X�g�[�����Ă��܂�..."

	Start-Sleep -Milliseconds 500

	# AviUtl\plugins ���Ɍ��݂̃f�B���N�g���̃t�@�C����S�Ĉړ�
	Move-Item * $aviutlPluginsDirectory -Force

	# �J�����g�f�B���N�g����x264guiEx��zip�t�@�C����W�J�����f�B���N�g������ exe_files �f�B���N�g���ɕύX
	Set-Location ..\exe_files

	# AviUtl �f�B���N�g������ exe_files �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${Path}\exe_files`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# AviUtl\exe_files ���� x264_*.exe ������΍폜 (�ҋ@)
	Start-Process powershell -ArgumentList "-command if (Test-Path `"${Path}\exe_files\x264_*.exe`") { Remove-Item `"${Path}\exe_files\x264_*.exe`" }" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# AviUtl\exe_files ���Ɍ��݂̃f�B���N�g���̃t�@�C����S�Ĉړ�
	Move-Item * "${Path}\exe_files" -Force

	# �J�����g�f�B���N�g����x264guiEx��zip�t�@�C����W�J�����f�B���N�g���ɕύX
	Set-Location ..

	# AviUtl\readme ���� x264guiEx �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\x264guiEx`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# AviUtl\readme\x264guiEx ���� x264guiEx_readme.txt ���ړ�
	Move-Item x264guiEx_readme.txt "${ReadmeDirectoryRoot}\x264guiEx" -Force

	# apm.json �� rigaya/x264guiEx ���o�^����Ă��Ȃ��ꍇ�̓L�[���쐬����id��o�^
	if (!($apmJsonHash.packages.Contains("rigaya/x264guiEx"))) {
		$apmJsonHash["packages"]["rigaya/x264guiEx"] = [ordered]@{}
		$apmJsonHash["packages"]["rigaya/x264guiEx"]["id"] = "rigaya/x264guiEx"
	}

	# apm.json �� rigaya/x264guiEx �̃o�[�W�������X�V
	$apmJsonHash["packages"]["rigaya/x264guiEx"]["version"] = $x264guiExGithubApi.tag_name

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location ..\..
}

Write-Host "����"
Write-Host -NoNewline "`r`nMFVideoReader�̍ŐV�ŏ����擾���Ă��܂�..."

# MFVideoReader�̓����Ă���f�B���N�g����T���A$MFVideoReaderAuiDirectory �Ƀp�X��ۑ�
if (Test-Path "${Path}\MFVideoReaderPlugin.aui") {
	$MFVideoReaderAuiDirectory = $Path
} else {
	$MFVideoReaderAuiDirectory = $aviutlPluginsDirectory
}

# MFVideoReader�̍ŐV�ł̃_�E�����[�hURL���擾
$MFVideoReaderGithubApi = GithubLatestRelease "amate/MFVideoReader"
$MFVideoReaderUrl = $MFVideoReaderGithubApi.assets.browser_download_url

# apm.json ������A���ŐV�ł̏�񂪋L�ڂ���Ă���ꍇ�̓X�L�b�v����
if (!($apmJsonExist -and $apmJsonHash.packages.Contains("amate/MFVideoReader") -and
	($apmJsonHash["packages"]["amate/MFVideoReader"]["version"] -eq $MFVideoReaderGithubApi.tag_name))) {
	Write-Host "����"
	Write-Host -NoNewline "MFVideoReader���_�E�����[�h���Ă��܂�..."

	# MFVideoReader��zip�t�@�C�����_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL $MFVideoReaderUrl" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host -NoNewline "MFVideoReader���C���X�g�[�����Ă��܂�..."

	# MFVideoReader��zip�t�@�C����W�J (�ҋ@)
	Start-Process powershell -ArgumentList "-command Expand-Archive -Path MFVideoReader_*.zip -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# �J�����g�f�B���N�g����MFVideoReader��zip�t�@�C����W�J�����f�B���N�g���ɕύX
	Set-Location "MFVideoReader_*\MFVideoReader"

	# AviUtl\readme, AviUtl\license ���� MFVideoReader �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\MFVideoReader`", `"${LicenseDirectoryRoot}\MFVideoReader`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# AviUtl\license\MFVideoReader ���� LICENSE ���AAviUtl\readme\MFVideoReader ���� Readme.md �� (�ҋ@) �A
	# $MFVideoReaderAuiDirectory �f�B���N�g�����ɂ��̑��̃t�@�C�������ꂼ��ړ�
	Start-Process powershell -ArgumentList "-command Move-Item LICENSE `"${LicenseDirectoryRoot}\MFVideoReader`" -Force; Move-Item Readme.md `"${ReadmeDirectoryRoot}\MFVideoReader`" -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait
	Move-Item * $MFVideoReaderAuiDirectory -Force

	# apm.json �� amate/MFVideoReader ���o�^����Ă��Ȃ��ꍇ�̓L�[���쐬����id��o�^
	if (!($apmJsonHash.packages.Contains("amate/MFVideoReader"))) {
		$apmJsonHash["packages"]["amate/MFVideoReader"] = [ordered]@{}
		$apmJsonHash["packages"]["amate/MFVideoReader"]["id"] = "amate/MFVideoReader"
	}

	# apm.json �� amate/MFVideoReader �̃o�[�W�������X�V
	$apmJsonHash["packages"]["amate/MFVideoReader"]["version"] = $MFVideoReaderGithubApi.tag_name

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location ..\..
}

# MFVideoReader�̐ݒ�t�@�C����������Ȃ��ꍇ�̂݁A�ȉ��̏��������s
if (!(Test-Path "${MFVideoReaderAuiDirectory}\MFVideoReaderConfig.ini")) {
	Copy-Item "${settingsDirectoryPath}\MFVideoReaderConfig.ini" $MFVideoReaderAuiDirectory
}

Write-Host "����"
Write-Host -NoNewline "`r`nWebP Susie Plug-in���m�F���Ă��܂�..."

# ais.json ������A���� TORO/iftwebp ���L�ڂ���Ă���ꍇ�̓X�L�b�v����
if (!($aisJsonExist -and $aisJsonHash.packages.Contains("TORO/iftwebp") -and
	($aisJsonHash["packages"]["TORO/iftwebp"]["version"] -eq "1.1"))) {
	Write-Host "����"
	Write-Host -NoNewline "WebP Susie Plug-in���_�E�����[�h���Ă��܂�..."

	# WebP Susie Plug-in��zip�t�@�C�����_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL https://toroidj.github.io/plugin/iftwebp11.zip" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host -NoNewline "WebP Susie Plug-in���C���X�g�[�����Ă��܂�..."

	# WebP Susie Plug-in��zip�t�@�C����W�J (�ҋ@)
	Start-Process powershell -ArgumentList "-command Expand-Archive -Path iftwebp11.zip -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# �J�����g�f�B���N�g���� iftwebp11 �f�B���N�g���ɕύX
	Set-Location iftwebp11

	# AviUtl\readme ���� iftwebp �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\iftwebp`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# AviUtl �f�B���N�g������ iftwebp.spi ���AAviUtl\readme\iftwebp ���� iftwebp.txt �����ꂼ��ړ�
	Move-Item iftwebp.spi $Path -Force
	Move-Item iftwebp.txt "${ReadmeDirectoryRoot}\iftwebp" -Force

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location ..
}

Write-Host "����"
Write-Host -NoNewline "`r`nifheif�̍ŐV�ŏ����擾���Ă��܂�..."

# ifheif�̍ŐV�ł̃_�E�����[�hURL���擾
$ifheifGithubApi = GithubLatestRelease "Mr-Ojii/ifheif"
$ifheifUrl = $ifheifGithubApi.assets.browser_download_url

# ais.json ������A���ŐV�ł̏�񂪋L�ڂ���Ă���ꍇ�̓X�L�b�v����
if (!($aisJsonExist -and $aisJsonHash.packages.Contains("Mr-Ojii/ifheif") -and
	($aisJsonHash["packages"]["Mr-Ojii/ifheif"]["version"] -eq $ifheifGithubApi.tag_name))) {
	Write-Host "����"
	Write-Host -NoNewline "ifheif���_�E�����[�h���Ă��܂�..."

	# ifheif��zip�t�@�C�����_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL $ifheifUrl" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host -NoNewline "ifheif���C���X�g�[�����Ă��܂�..."

	# AviUtl\license\ifheif ���� Licenses �f�B���N�g��������΍폜���� (�G���[�̖h�~)
	if (Test-Path "${LicenseDirectoryRoot}\ifheif\Licenses") {
		Remove-Item "${LicenseDirectoryRoot}\ifheif\Licenses" -Recurse
	}

	# ifheif��zip�t�@�C����W�J (�ҋ@)
	Start-Process powershell -ArgumentList "-command Expand-Archive -Path ifheif.zip -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# �J�����g�f�B���N�g����ifheif��zip�t�@�C����W�J�����f�B���N�g���ɕύX
	Set-Location "ifheif"

	# AviUtl\readme, AviUtl\license ���� ifheif �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\ifheif`", `"${LicenseDirectoryRoot}\ifheif`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# AviUtl �f�B���N�g������ ifheif.spi ���AAviUtl\license\ifheif ���� LICENSE �� Licenses �f�B���N�g�����A
	# AviUtl\readme\ifheif ���� Readme.md �����ꂼ��ړ�
	Move-Item ifheif.spi $Path -Force
	Move-Item "LICENS*" "${LicenseDirectoryRoot}\ifheif" -Force
	Move-Item Readme.md "${ReadmeDirectoryRoot}\ifheif" -Force

	# ais.json �� Mr-Ojii/ifheif �̃o�[�W�������X�V
	$aisJsonHash["packages"]["Mr-Ojii/ifheif"]["version"] = $ifheifGithubApi.tag_name

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location ..
}

Write-Host "����"
Write-Host -NoNewline "`r`n�uAviUtl�X�N���v�g�ꎮ�v���m�F���Ă��܂�..."

# script �f�B���N�g���A�܂��͂��̃T�u�f�B���N�g���� @ANM1.anm �����邩�m�F���A����ꍇ�� $CheckAviUtlScriptSet ��
# true �Ƃ��A$AviUtlScriptSetDirectory �Ƀf�B���N�g���̃p�X���L�^����
$CheckAviUtlScriptSet = $false
if (Test-Path "${aviutlScriptDirectory}\@ANM1.anm") {
	$CheckAviUtlScriptSet = $true
	$AviUtlScriptSetDirectory = $aviutlScriptDirectory
} else {
	Get-ChildItem -Path $aviutlScriptDirectory -Directory | ForEach-Object {
		if (Test-Path -Path "${_}\@ANM1.anm") {
			$CheckAviUtlScriptSet = $true
			$AviUtlScriptSetDirectory = $_
		}
	}
}

Start-Sleep -Milliseconds 500

# @ANM1.anm �𔭌��ł��Ȃ������ꍇ�A$AviUtlScriptSetDirectory �� AviUtl\script\���� ���L�^����
# �܂��AAviUtl\script ���� ���� �f�B���N�g�����쐬����
if (!($CheckAviUtlScriptSet)) {
	$AviUtlScriptSetDirectory = "${aviutlScriptDirectory}\����"
	Start-Process powershell -ArgumentList "-command New-Item `"${aviutlScriptDirectory}\����`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait
}

# script �f�B���N�g���A�܂��͂��̃T�u�f�B���N�g���� �k����_�A��.anm �����邩�m�F���A����ꍇ�� $CheckAnmSsd ��
# true �Ƃ��A$anmSsdDirectory �Ƀf�B���N�g���̃p�X���L�^����
$CheckAnmSsd = $false
if (Test-Path "${aviutlScriptDirectory}\�k����_�A��.anm") {
	$CheckAnmSsd = $true
	$anmSsdDirectory = $aviutlScriptDirectory
} else {
	Get-ChildItem -Path $aviutlScriptDirectory -Directory | ForEach-Object {
		if (Test-Path -Path "${_}\�k����_�A��.anm") {
			$CheckAnmSsd = $true
			$anmSsdDirectory = $_
		}
	}
}

Start-Sleep -Milliseconds 500

# �k����_�A��.anm �𔭌��ł��Ȃ������ꍇ�A$anmSsdDirectory �� AviUtl\script\ANM_ssd ���L�^����
# �܂��AAviUtl\script ���� ANM_ssd �f�B���N�g�����쐬����
if (!($CheckAnmSsd)) {
	$anmSsdDirectory = "${aviutlScriptDirectory}\ANM_ssd"
	Start-Process powershell -ArgumentList "-command New-Item `"${aviutlScriptDirectory}\ANM_ssd`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait
}

# script �f�B���N�g���A�܂��͂��̃T�u�f�B���N�g���� TA�ʒu�����ňړ�.anm �����邩�m�F���A����ꍇ�� $CheckTaSsd ��
# true �Ƃ��A$taSsdDirectory �Ƀf�B���N�g���̃p�X���L�^����
$CheckTaSsd = $false
if (Test-Path "${aviutlScriptDirectory}\TA�ʒu�����ňړ�.anm") {
	$CheckTaSsd = $true
	$taSsdDirectory = $aviutlScriptDirectory
} else {
	Get-ChildItem -Path $aviutlScriptDirectory -Directory | ForEach-Object {
		if (Test-Path -Path "${_}\TA�ʒu�����ňړ�.anm") {
			$CheckTaSsd = $true
			$taSsdDirectory = $_
		}
	}
}

Start-Sleep -Milliseconds 500

# TA�ʒu�����ňړ�.anm �𔭌��ł��Ȃ������ꍇ�A$taSsdDirectory �� AviUtl\script\TA_ssd ���L�^����
# �܂��AAviUtl\script ���� TA_ssd �f�B���N�g�����쐬����
if (!($CheckTaSsd)) {
	$taSsdDirectory = "${aviutlScriptDirectory}\TA_ssd"
	Start-Process powershell -ArgumentList "-command New-Item `"${aviutlScriptDirectory}\TA_ssd`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait
}

# apm.json ������A���ŐV�ł̏�񂪋L�ڂ���Ă���ꍇ�̓X�L�b�v����
if (!($apmJsonExist -and $apmJsonHash.packages.Contains("satsuki/satsuki") -and
	($apmJsonHash["packages"]["satsuki/satsuki"]["version"] -eq "20160828"))) {

	# $AviUtlScriptSetDirectory ���� �폜�ς� �f�B���N�g��������΍폜���� (�G���[�̖h�~)
	if (Test-Path "${AviUtlScriptSetDirectory}\�폜�ς�") {
		Remove-Item "${AviUtlScriptSetDirectory}\�폜�ς�" -Recurse
	}

	Write-Host "����"
	Write-Host -NoNewline "�uAviUtl�X�N���v�g�ꎮ�v���_�E�����[�h���Ă��܂�..."

	# �uAviUtl�X�N���v�g�ꎮ�v��zip�t�@�C�����_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL https://ss1.xrea.com/menkuri.s270.xrea.com/aviutl-installer-script/scripts/script_20160828.zip" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host -NoNewline "�uAviUtl�X�N���v�g�ꎮ�v���C���X�g�[�����Ă��܂�..."

	# �uAviUtl�X�N���v�g�ꎮ�v��zip�t�@�C����W�J (�ҋ@)
	Start-Process powershell -ArgumentList "-command Expand-Archive -Path script_20160828.zip -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# �J�����g�f�B���N�g���� script_20160828\script_20160828 �f�B���N�g���ɕύX
	Set-Location script_20160828\script_20160828

	# AviUtl\readme ���� AviUtl�X�N���v�g�ꎮ �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\AviUtl�X�N���v�g�ꎮ`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# $anmSsdDirectory ���� ANM_ssd �̒��g���A$taSsdDirectory ���� TA_ssd �̒��g�� (�ҋ@) �A
	# AviUtl\readme\AviUtl�X�N���v�g�ꎮ ���� readme.txt �� �g����.txt �� (�ҋ@) �A
	# $AviUtlScriptSetDirectory ���ɂ��̑��̃t�@�C�������ꂼ��ړ�
	Start-Process powershell -ArgumentList "-command Move-Item `"ANM_ssd\*`" $anmSsdDirectory -Force; Move-Item `"TA_ssd\*`" $taSsdDirectory -Force; Move-Item *.txt `"${ReadmeDirectoryRoot}\AviUtl�X�N���v�g�ꎮ`" -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait
	Move-Item * $AviUtlScriptSetDirectory -Force

	# apm.json �� satsuki/satsuki ���o�^����Ă��Ȃ��ꍇ�̓L�[���쐬����id��o�^
	if (!($apmJsonHash.packages.Contains("satsuki/satsuki"))) {
		$apmJsonHash["packages"]["satsuki/satsuki"] = [ordered]@{}
		$apmJsonHash["packages"]["satsuki/satsuki"]["id"] = "satsuki/satsuki"
	}

	# apm.json �� satsuki/satsuki �̃o�[�W�������X�V
	$apmJsonHash["packages"]["satsuki/satsuki"]["version"] = "20160828"

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location ..\..
}

Write-Host "����"
Write-Host -NoNewline "`r`n�u�l�Ő}�`�v���m�F���Ă��܂�..."

# script �f�B���N�g���A�܂��͂��̃T�u�f�B���N�g���� �l�Ő}�`.obj �����邩�m�F���A����ꍇ�� $CheckShapeWithValuesObj ��
# true �Ƃ��A$shapeWithValuesObjDirectory �Ƀf�B���N�g���̃p�X���L�^����
$CheckShapeWithValuesObj = $false
if (Test-Path "${aviutlScriptDirectory}\�l�Ő}�`.obj") {
	$CheckShapeWithValuesObj = $true
	$shapeWithValuesObjDirectory = $aviutlScriptDirectory
} else {
	Get-ChildItem -Path $aviutlScriptDirectory -Directory | ForEach-Object {
		if (Test-Path -Path "${_}\�l�Ő}�`.obj") {
			$CheckShapeWithValuesObj = $true
			$shapeWithValuesObjDirectory = $_
		}
	}
}

Start-Sleep -Milliseconds 500

# �l�Ő}�`.obj �𔭌��ł��Ȃ������ꍇ�A$shapeWithValuesObjDirectory �� AviUtl\script\Nagomiku ���L�^����
# �܂��AAviUtl\script ���� Nagomiku �f�B���N�g�����쐬����
if (!($CheckShapeWithValuesObj)) {
	$shapeWithValuesObjDirectory = "${aviutlScriptDirectory}\Nagomiku"
	Start-Process powershell -ArgumentList "-command New-Item `"${aviutlScriptDirectory}\Nagomiku`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait
}

# apm.json ������A���ŐV�ł̏�񂪋L�ڂ���Ă���ꍇ�̓X�L�b�v����
if (!($apmJsonExist -and $apmJsonHash.packages.Contains("nagomiku/paracustomobj") -and
	($apmJsonHash["packages"]["nagomiku/paracustomobj"]["version"] -eq "v2.10"))) {
	Write-Host "����"
	Write-Host -NoNewline "�u�l�Ő}�`�v���_�E�����[�h���Ă��܂�..."

	# �l�Ő}�`.obj ���_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL `"https://ss1.xrea.com/menkuri.s270.xrea.com/aviutl-installer-script/scripts/�l�Ő}�`.obj`"" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host -NoNewline "�u�l�Ő}�`�v���C���X�g�[�����Ă��܂�..."

	# AviUtl\script ���� �l�Ő}�`.obj ���ړ�
	Move-Item "�l�Ő}�`.obj" $aviutlScriptDirectory -Force

	# apm.json �� nagomiku/paracustomobj ���o�^����Ă��Ȃ��ꍇ�̓L�[���쐬����id��o�^
	if (!($apmJsonHash.packages.Contains("nagomiku/paracustomobj"))) {
		$apmJsonHash["packages"]["nagomiku/paracustomobj"] = [ordered]@{}
		$apmJsonHash["packages"]["nagomiku/paracustomobj"]["id"] = "nagomiku/paracustomobj"
	}

	# apm.json �� nagomiku/paracustomobj �̃o�[�W�������X�V
	$apmJsonHash["packages"]["nagomiku/paracustomobj"]["version"] = "v2.10"
}

Write-Host "����"
Write-Host -NoNewline "`r`n�����X�N���v�g���m�F���Ă��܂�..."

# script �f�B���N�g���A�܂��͂��̃T�u�f�B���N�g���� ����.obj �����邩�m�F���A����ꍇ�� $CheckStraightLineObj ��
# true �Ƃ��A$straightLineObjDirectory �Ƀf�B���N�g���̃p�X���L�^����
$CheckStraightLineObj = $false
if (Test-Path "${aviutlScriptDirectory}\����.obj") {
	$CheckStraightLineObj = $true
	$straightLineObjDirectory = $aviutlScriptDirectory
} else {
	Get-ChildItem -Path $aviutlScriptDirectory -Directory | ForEach-Object {
		if (Test-Path -Path "${_}\����.obj") {
			$CheckStraightLineObj = $true
			$straightLineObjDirectory = $_
		}
	}
}

Start-Sleep -Milliseconds 500

# ����.obj �𔭌��ł��Ȃ������ꍇ�A$taSsdDirectory �� AviUtl\script\�����ڂ� ���L�^����
# �܂��AAviUtl\script ���� �����ڂ� �f�B���N�g�����쐬���� (�ҋ@)
if (!($CheckStraightLineObj)) {
	$straightLineObjDirectory = "${aviutlScriptDirectory}\�����ڂ�"
	Start-Process powershell -ArgumentList "-command New-Item `"${aviutlScriptDirectory}\�����ڂ�`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait
}

Write-Host "����"

# ais.json ������A���ŐV�ł̏�񂪋L�ڂ���Ă���ꍇ�̓X�L�b�v����
if (!($aisJsonExist -and $aisJsonHash.packages.Contains("tikubonn/straightLineObj") -and
	($aisJsonHash["packages"]["tikubonn/straightLineObj"]["version"] -eq "2021/03/07"))) {
	Write-Host -NoNewline "�����X�N���v�g���_�E�����[�h���Ă��܂�..."

	# �����X�N���v�g��zip�t�@�C�����_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL `"https://ss1.xrea.com/menkuri.s270.xrea.com/aviutl-installer-script/scripts/�����X�N���v�g.zip`"" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host -NoNewline "�����X�N���v�g���C���X�g�[�����Ă��܂�..."

	# �����X�N���v�g��zip�t�@�C����W�J (�ҋ@)
	Start-Process powershell -ArgumentList "-command Expand-Archive -Path `"�����X�N���v�g.zip`" -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# �J�����g�f�B���N�g���� �����X�N���v�g �f�B���N�g���ɕύX
	Set-Location "�����X�N���v�g"

	# AviUtl\readme, AviUtl\license ���� �����X�N���v�g �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\�����X�N���v�g`", `"${LicenseDirectoryRoot}\�����X�N���v�g`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# AviUtl\script ���� ����.obj ���AAviUtl\license\�����X�N���v�g ���� LICENSE.txt �� (�ҋ@) �A
	# AviUtl\readme\�����X�N���v�g ���ɂ��̑��̃t�@�C�������ꂼ��ړ�
	Start-Process powershell -ArgumentList "-command Move-Item `"����.obj`" $aviutlScriptDirectory -Force; Move-Item LICENSE.txt `"${LicenseDirectoryRoot}\�����X�N���v�g`" -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait
	Move-Item * "${ReadmeDirectoryRoot}\�����X�N���v�g" -Force

	# ais.json �� tikubonn/straightLineObj �̃o�[�W�������X�V
	$aisJsonHash["packages"]["tikubonn/straightLineObj"]["version"] = "2021/03/07"

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location ..

	Write-Host "����"
}


# LuaJIT�̍X�V by Yu-yu0202 (20250109)
	# �s�������Ȃ��������ߍĎ��� by menndouyukkuri (20250110)
Write-Host -NoNewline "`r`nLuaJIT�̍ŐV�ŏ����擾���Ă��܂�..."

# LuaJIT�̍ŐV�ł̃_�E�����[�hURL���擾
$luaJitGithubApi = GithubLatestRelease "Per-Terra/LuaJIT-Auto-Builds"
$luaJitAllUrl = $luaJitGithubApi.assets.browser_download_url

# �������钆����AviUtl�p�̂��̂̂ݎc��
$luaJitUrl = $luaJitAllUrl | Where-Object {$_ -like "*LuaJIT_2.1_Win_x86.zip"}

# ais.json �p�Ƀ^�O�����擾���ăr���h���������o�� yyyy/mm/dd �ɐ��`
$luaJitTagNameSplitArray = ($luaJitGithubApi.tag_name) -split "-"
$luaJitBuildDate = $luaJitTagNameSplitArray[1] + "/" + $luaJitTagNameSplitArray[2] + "/" + $luaJitTagNameSplitArray[3]

# ais.json ��LuaJIT�̃o�[�W������ / �ŕ������� $aisJsonluaJitVersionArray �Ɋi�[
if ($aisJsonExist -and $aisJsonHash.packages.Contains("Per-Terra/LuaJIT")) {
	$aisJsonluaJitVersionArray = $aisJsonHash["packages"]["Per-Terra/LuaJIT"]["version"] -split "/"
} else {
	$aisJsonluaJitVersionArray = 0, 0, 0
}

# $luaJitUpdate ��LuaJIT���X�V���邩�ǂ������i�[
$luaJitUpdate = $true

# ais.json �̔N > �擾�����r���h���̔N
if ($aisJsonluaJitVersionArray[0] -gt $luaJitTagNameSplitArray[1]) {
	$luaJitUpdate = $false

# ais.json �̔N < �擾�����r���h���̔N
} elseif ($aisJsonluaJitVersionArray[0] -lt $luaJitTagNameSplitArray[1]) {
	# if���𗣒E�A�����艺�̏����� ais.json �̔N = �擾�����r���h���̔N

# ais.json �̌� > �擾�����r���h���̌�
} elseif ($aisJsonluaJitVersionArray[1] -gt $luaJitTagNameSplitArray[2]) {
	$luaJitUpdate = $false

# ais.json �̌� < �擾�����r���h���̌�
} elseif ($aisJsonluaJitVersionArray[1] -lt $luaJitTagNameSplitArray[2]) {
	# if���𗣒E�A�����艺�̏����� ais.json �̌� = �擾�����r���h���̌�

# ais.json �̓� >= �擾�����r���h���̓�
} elseif ($aisJsonluaJitVersionArray[2] -ge $luaJitTagNameSplitArray[3]) {
	$luaJitUpdate = $false
}

# ais.json �̃o�[�W�������擾�����r���h���̕����V�����ꍇ�͍X�V����
if ($luaJitUpdate) {
	Write-Host "����"
	Write-Host -NoNewline "LuaJIT���_�E�����[�h���Ă��܂�..."

	# LuaJIT��zip�t�@�C�����_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL $luaJitUrl" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host -NoNewline "LuaJIT���C���X�g�[�����Ă��܂�..."

	# AviUtl �f�B���N�g������ exedit_lua51.dll �� old_lua51.dll ���Ȃ��ꍇ�A���ɂ��� lua51.dll �����l�[�����ăo�b�N�A�b�v����
	if (!(Test-Path "${Path}\exedit_lua51.dll") -and !(Test-Path "${Path}\old_lua51.dll")) {
		Rename-Item "${Path}\lua51.dll" "old_lua51.dll" -Force
	}

	# AviUtl\readme\LuaJIT ���� doc �f�B���N�g��������΍폜���� (�G���[�̖h�~)
	if (Test-Path "${ReadmeDirectoryRoot}\LuaJIT\doc") {
		Remove-Item "${ReadmeDirectoryRoot}\LuaJIT\doc" -Recurse
	}

	# LuaJIT��zip�t�@�C����W�J (�ҋ@)
	Start-Process powershell -ArgumentList "-command Expand-Archive -Path `"LuaJIT_2.1_Win_x86.zip`" -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# �J�����g�f�B���N�g����LuaJIT��zip�t�@�C����W�J�����f�B���N�g���ɕύX
	Set-Location "LuaJIT_2.1_Win_x86"

	# AviUtl\readme, AviUtl\license ���� LuaJIT �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\LuaJIT`", `"${LicenseDirectoryRoot}\LuaJIT`" -ItemType Directory -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	# AviUtl �f�B���N�g������ lua51.dll ���AAviUtl\readme\LuaJIT ���� README �� doc ���AAviUtl\license\LuaJIT ����
	# COPYRIGHT �� About-This-Build.txt �����ꂼ��ړ�
	Move-Item "lua51.dll" $Path -Force
	Move-Item README "${ReadmeDirectoryRoot}\LuaJIT" -Force
	Move-Item doc "${ReadmeDirectoryRoot}\LuaJIT" -Force
	Move-Item COPYRIGHT "${LicenseDirectoryRoot}\LuaJIT" -Force
	Move-Item "About-This-Build.txt" "${LicenseDirectoryRoot}\LuaJIT" -Force

	# apm.json �� ePi/LuaJIT ���o�^����Ă��Ȃ��ꍇ�̓L�[���쐬����id��version��o�^
	if (!($apmJsonHash.packages.Contains("ePi/LuaJIT"))) {
		$apmJsonHash["packages"]["ePi/LuaJIT"] = [ordered]@{}
		$apmJsonHash["packages"]["ePi/LuaJIT"]["id"] = "ePi/LuaJIT"
		$apmJsonHash["packages"]["ePi/LuaJIT"]["version"] = "2.1.0-beta3"
	}

	# ais.json �� Per-Terra/LuaJIT �̃o�[�W�������X�V
	$aisJsonHash["packages"]["Per-Terra/LuaJIT"]["version"] = $luaJitBuildDate

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location ..
}

Write-Host "����"


Write-Host "`r`n�n�[�h�E�F�A�G���R�[�h�̏o�̓v���O�C�� (NVEnc / QSVEnc / VCEEnc) ���m�F���Ă��܂��B"

$hwEncoders = [ordered]@{
	"NVEnc"  = "NVEncC.exe"
	"QSVEnc" = "QSVEncC.exe"
	"VCEEnc" = "VCEEncC.exe"
}

# �n�[�h�E�F�A�G���R�[�h�̏o�̓v���O�C�����폜�������ɋL�^����n�b�V���e�[�u����p��
$hwEncodersRemove = @{
	"NVEnc" = $false
	"QSVEnc" = $false
	"VCEEnc" = $false
}

# �n�[�h�E�F�A�G���R�[�h�̏o�̓v���O�C���̃C���X�g�[���`�F�b�N�p�̕ϐ���p��
$CheckHwEncoder = $false

foreach ($hwEncoder in $hwEncoders.GetEnumerator()) {
	# �����̗L�����`�F�b�N
	if (Test-Path "${aviutlPluginsDirectory}\$($hwEncoder.Key).auo") {
		Write-Host -NoNewline "`r`n$($hwEncoder.Key)���g�p�ł��邩�`�F�b�N���܂�..."

		# �n�[�h�E�F�A�G���R�[�h�ł��邩�`�F�b�N
		$process = Start-Process -FilePath "${Path}\exe_files\$($hwEncoder.Key)C\x86\$($hwEncoder.Value)" -ArgumentList "--check-hw" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait -PassThru

		Write-Host "����"

		# ExitCode��0 (�g�p�\) �̏ꍇ�͍X�V�m�F�A����ȊO�Ȃ�폜 (�G���[�̖h�~)
		if ($process.ExitCode -eq 0) {
			# �n�[�h�E�F�A�G���R�[�h�̏o�̓v���O�C���̃C���X�g�[���`�F�b�N�p�̕ϐ��� true ��
			$CheckHwEncoder = $true

			Write-Host -NoNewline "$($hwEncoder.Key)�̍ŐV�ŏ����擾���Ă��܂�..."

			# �ŐV�ł̃_�E�����[�hURL���擾
			$hwEncoderGithubApi = GithubLatestRelease "rigaya/$($hwEncoder.Key)"
			$downloadAllUrl = $hwEncoderGithubApi.assets.browser_download_url

			# �������钆����AviUtl�p�̂��̂̂ݎc��
			$downloadUrl = $downloadAllUrl | Where-Object {$_ -like "*Aviutl*"}

			# apm.json ������A���ŐV�ł̏�񂪋L�ڂ���Ă���ꍇ�̓X�L�b�v����
			if (!($apmJsonExist -and $apmJsonHash.packages.Contains("rigaya/$($hwEncoder.Key)") -and
				($apmJsonHash["packages"]["rigaya/$($hwEncoder.Key)"]["version"] -eq $hwEncoderGithubApi.tag_name))) {
				Write-Host "����"
				Write-Host -NoNewline "$($hwEncoder.Key)���X�V���܂��B�_�E�����[�h���Ă��܂�..."

				# zip�t�@�C�����_�E�����[�h (�ҋ@)
				Start-Process -FilePath curl.exe -ArgumentList "-OL $downloadUrl" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

				# zip�t�@�C����W�J (�ҋ@)
				Start-Process powershell -ArgumentList "-command Expand-Archive -Path Aviutl_$($hwEncoder.Key)_*.zip -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

				# �W�J���ꂽ�f�B���N�g���̃p�X���i�[
				Set-Location "Aviutl_$($hwEncoder.Key)_*"
				$extdir = $scriptFileRoot
				Set-Location ..

				Write-Host "����"

				# AviUtl\plugins ���� (NVEnc/QSVEnc/VCEEnc)_stg �f�B���N�g��������Έȉ��̏��������s
				if (Test-Path "${aviutlPluginsDirectory}\$($hwEncoder.Key)_stg") {
					# �v���t�@�C�����㏑�����邩�ǂ������[�U�[�Ɋm�F���� (����� �㏑�����Ȃ�)

					# �I����������

					$hwEncoderChoiceTitle = "$($hwEncoder.Key)�̃v���t�@�C�����㏑�����܂����H"
					$hwEncoderChoiceMessage = "�v���t�@�C���͍X�V�ŐV�����Ȃ��Ă���\��������܂����A�㏑�������s����ƒǉ������v���t�@�C����v���t�@�C���ւ̕ύX���폜����܂��B"

					$hwEncoderTChoiceDescription = "System.Management.Automation.Host.ChoiceDescription"
					$hwEncoderChoiceOptions = @(
						New-Object $hwEncoderTChoiceDescription ("�͂�(&Y)",  "�㏑�������s���܂��B")
						New-Object $hwEncoderTChoiceDescription ("������(&N)", "�㏑���������A�X�L�b�v���Ď��̏����ɐi�݂܂��B")
					)

					$hwEncoderChoiceResult = $host.ui.PromptForChoice($hwEncoderChoiceTitle, $hwEncoderChoiceMessage, $hwEncoderChoiceOptions, 1)
					switch ($hwEncoderChoiceResult) {
						0 {
							Write-Host -NoNewline "�v���t�@�C�����㏑�����܂�..."

							# AviUtl\plugins ���� (NVEnc/QSVEnc/VCEEnc)_stg �f�B���N�g�����폜���� (�ҋ@)
							Start-Process powershell -ArgumentList "-command Remove-Item `"${aviutlPluginsDirectory}\$($hwEncoder.Key)_stg`" -Recurse" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

							# �_�E�����[�h���ēW�J���� (NVEnc/QSVEnc/VCEEnc)_stg �� AviUtl\plugins ���Ɉړ�
							Move-Item "$extdir\plugins\$($hwEncoder.Key)_stg" $aviutlPluginsDirectory -Force

							Write-Host "����`r`n"
							break
						}
						1 {
							# ��Ŏז��ɂȂ�̂ō폜
							Remove-Item "$extdir\plugins\$($hwEncoder.Key)_stg" -Recurse

							Write-Host "�v���t�@�C���̏㏑�����X�L�b�v���܂����B`r`n"
							break
						}
					}

					# �I�������܂�
				}

				Write-Host -NoNewline "$($hwEncoder.Key)���C���X�g�[�����Ă��܂�..."

				# AviUtl\exe_files\(NVEnc/QSVEnc/VCEEnc)C ����Ŏז��ɂȂ�̂ō폜
				Remove-Item "${Path}\exe_files\$($hwEncoder.Key)C" -Recurse

				# readme �f�B���N�g�����쐬
				New-Item -ItemType Directory -Path "${ReadmeDirectoryRoot}\$($hwEncoder.Key)" -Force | Out-Null

				# �W�J��̂��ꂼ��̃t�@�C�����ړ�
				Move-Item -Path "$extdir\*.bat" -Destination $Path -Force
				Move-Item -Path "$extdir\plugins\*" -Destination $aviutlPluginsDirectory -Force
				Move-Item -Path "$extdir\exe_files\*" -Destination "${Path}\exe_files" -Force
				Move-Item -Path "$extdir\*_readme.txt" -Destination "${ReadmeDirectoryRoot}\$($hwEncoder.Key)" -Force

				# apm.json �� rigaya/$($hwEncoder.Key) ���o�^����Ă��Ȃ��ꍇ�̓L�[���쐬����id��o�^
				if (!($apmJsonHash.packages.Contains("rigaya/$($hwEncoder.Key)"))) {
					$apmJsonHash["packages"]["rigaya/$($hwEncoder.Key)"] = [ordered]@{}
					$apmJsonHash["packages"]["rigaya/$($hwEncoder.Key)"]["id"] = "rigaya/$($hwEncoder.Key)"
				}

				# apm.json �� rigaya/$($hwEncoder.Key) �̃o�[�W�������X�V
				$apmJsonHash["packages"]["rigaya/$($hwEncoder.Key)"]["version"] = $hwEncoderGithubApi.tag_name
			}

			Write-Host "����"

		} else {
			Write-Host -NoNewline "$($hwEncoder.Key)�͎g�p�ł��܂���B�폜���Ă��܂�..."

			# �t�@�C�����폜
			Remove-Item "${Path}\exe_files\$($hwEncoder.Key)C" -Recurse
			Remove-Item "${aviutlPluginsDirectory}\$($hwEncoder.Key)*" -Recurse
			if (Test-Path "${ReadmeDirectoryRoot}\$($hwEncoder.Key)") {
				Remove-Item "${ReadmeDirectoryRoot}\$($hwEncoder.Key)" -Recurse
			}

			# apm.json �� rigaya/$($hwEncoder.Key) ���o�^����Ă���ꍇ�͍폜
			if ($apmJsonHash.packages.Contains("rigaya/$($hwEncoder.Key)")) {
				$apmJsonHash.packages.Remove("rigaya/$($hwEncoder.Key)")
			}

			# $hwEncodersRemove.$($hwEncoder.Key) �� $true ����
			$hwEncodersRemove.$($hwEncoder.Key) = $true

			Write-Host "����"
		}
	} else {
		# apm.json �� rigaya/$($hwEncoder.Key) ���o�^����Ă���ꍇ�͍폜
		if ($apmJsonHash.packages.Contains("rigaya/$($hwEncoder.Key)")) {
			$apmJsonHash.packages.Remove("rigaya/$($hwEncoder.Key)")
		}
	}
}

Write-Host "`r`n�n�[�h�E�F�A�G���R�[�h�̏o�̓v���O�C���̊m�F���������܂����B"

# �n�[�h�E�F�A�G���R�[�h�̏o�̓v���O�C����1�������Ă��Ȃ� (��̏����ō폜���ꂽ�ꍇ�܂�) �ꍇ�ɃC���X�g�[���`�F�b�N����
# �������A��̏����őS�Ẵv���O�C�����폜����Ă���ꍇ�̓C���X�g�[���`�F�b�N������Ӗ����Ȃ��̂ŃX�L�b�v����
if ((!($CheckHwEncoder)) -and
	(!($hwEncodersRemove.NVEnc -and $hwEncodersRemove.QSVEnc -and $hwEncodersRemove.VCEEnc))) {


	# HW�G���R�[�f�B���O�̎g�p�ۂ��`�F�b�N���A�\�ł���Ώo�̓v���O�C�����C���X�g�[�� by Yu-yu0202 (20250107)

	Write-Host "`r`n�n�[�h�E�F�A�G���R�[�h (NVEnc / QSVEnc / VCEEnc) ���g�p�ł��邩�`�F�b�N���܂��B"
	Write-Host -NoNewline "�K�v�ȃt�@�C�����_�E�����[�h���Ă��܂� (����������ꍇ������܂�) "

	# apm.json �����p�Ƀ^�O����ۑ�����n�b�V���e�[�u�����쐬
	$hwEncodersTagName = @{
		"NVEnc"  = "xxx"
		"QSVEnc" = "xxx"
		"VCEEnc" = "xxx"
	}

	$hwEncoderRepos = @("rigaya/NVEnc", "rigaya/QSVEnc", "rigaya/VCEEnc")
	foreach ($hwRepo in $hwEncoderRepos) {
		# ���ƂŎg���̂Ń��|�W�g����������Ă���
		$repoName = ($hwRepo -split "/")[-1]

		# �ŐV�ł̃_�E�����[�hURL���擾
		$hwEncoderGithubApi = GithubLatestRelease $hwRepo
		$downloadAllUrl = $hwEncoderGithubApi.assets.browser_download_url

		# �������钆����AviUtl�p�̂��̂̂ݎc��
		$downloadUrl = $downloadAllUrl | Where-Object {$_ -like "*Aviutl*"}

		# apm.json �����p�� $hwEncodersTagName �Ƀ^�O����ۑ�
		$hwEncodersTagName.$repoName = $hwEncoderGithubApi.tag_name

		Write-Host -NoNewline "."

		# zip�t�@�C�����_�E�����[�h (�ҋ@)
		Start-Process -FilePath curl.exe -ArgumentList "-OL $downloadUrl" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

		Write-Host -NoNewline "."

		# zip�t�@�C����W�J (�ҋ@)
		Start-Process powershell -ArgumentList "-command Expand-Archive -Path Aviutl_${repoName}_*.zip -Force" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait
	}

	Write-Host " ����"
	Write-Host "�G���R�[�_�[�̃`�F�b�N�A����юg�p�\�ȏo�̓v���O�C���̃C���X�g�[�����s���܂��B"

	# �掿�̂悢NVEnc���珇��QSVEnc�AVCEEnc�ƃ`�F�b�N���Ă����A�ŏ��Ɏg�p�\�Ȃ��̂��m�F�������_�ł���𓱓�����foreach�𗣒E
	foreach ($hwEncoder in $hwEncoders.GetEnumerator()) {
		# �G���R�[�_�[�̎��s�t�@�C���̃p�X���i�[
		Set-Location "Aviutl_$($hwEncoder.Key)_*"
		$extdir = $scriptFileRoot
		$encoderPath = Join-Path -Path $extdir -ChildPath "exe_files\$($hwEncoder.Key)C\x86\$($hwEncoder.Value)"
		Set-Location ..

		# �G���R�[�_�[�̎��s�t�@�C���̗L�����m�F
		if (Test-Path $encoderPath) {
			# �n�[�h�E�F�A�G���R�[�h�ł��邩�`�F�b�N
			$process = Start-Process -FilePath $encoderPath -ArgumentList "--check-hw" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait -PassThru

			# ExitCode��0�̏ꍇ�̓C���X�g�[��
			if ($process.ExitCode -eq 0) {
				# AviUtl\exe_files ���� $($hwEncoder.Key)C �f�B���N�g��������΍폜���� (�G���[�̖h�~)
				if (Test-Path "${Path}\exe_files\$($hwEncoder.Key)C") {
					Remove-Item "${Path}\exe_files\$($hwEncoder.Key)C" -Recurse
				}

				# AviUtl\plugins ���� $($hwEncoder.Key)_stg �f�B���N�g��������΍폜���� (�G���[�̖h�~)
				if (Test-Path "${aviutlPluginsDirectory}\$($hwEncoder.Key)_stg") {
					Remove-Item "${aviutlPluginsDirectory}\$($hwEncoder.Key)_stg" -Recurse
				}

				Write-Host -NoNewline "$($hwEncoder.Key)���g�p�\�ł��B$($hwEncoder.Key)���C���X�g�[�����Ă��܂�..."

				# readme �f�B���N�g�����쐬
				New-Item -ItemType Directory -Path "${ReadmeDirectoryRoot}\$($hwEncoder.Key)" -Force | Out-Null

				# �W�J��̂��ꂼ��̃t�@�C�����ړ�
				Move-Item -Path "$extdir\exe_files\*" -Destination "${Path}\exe_files" -Force
				Move-Item -Path "$extdir\plugins\*" -Destination $aviutlPluginsDirectory -Force
				Move-Item -Path "$extdir\*.bat" -Destination $Path -Force
				Move-Item -Path "$extdir\*_readme.txt" -Destination "${ReadmeDirectoryRoot}\$($hwEncoder.Key)" -Force

				# apm.json �� rigaya/$($hwEncoder.Key) ���o�^����Ă��Ȃ��ꍇ�̓L�[���쐬����id��o�^
				if (!($apmJsonHash.packages.Contains("rigaya/$($hwEncoder.Key)"))) {
					$apmJsonHash["packages"]["rigaya/$($hwEncoder.Key)"] = [ordered]@{}
					$apmJsonHash["packages"]["rigaya/$($hwEncoder.Key)"]["id"] = "rigaya/$($hwEncoder.Key)"
				}

				# apm.json �� rigaya/$($hwEncoder.Key) �̃o�[�W�������X�V
				$apmJsonHash["packages"]["rigaya/$($hwEncoder.Key)"]["version"] = $hwEncodersTagName.$($hwEncoder.Key)

				Write-Host "����"

				# �ꉞ�A�o�̓v���O�C�����������Ȃ��悤break��foreach�𔲂���
				break

			# �Ō��VCEEnc���g�p�s�������ꍇ�A�n�[�h�E�F�A�G���R�[�h���g�p�ł��Ȃ��|�̃��b�Z�[�W��\��
			} elseif ($($hwEncoder.Key) -eq "VCEEnc") {
				Write-Host "���̊��ł̓n�[�h�E�F�A�G���R�[�h�͎g�p�ł��܂���B"
			}

		# �G���R�[�_�[�̎��s�t�@�C�����m�F�ł��Ȃ��ꍇ�A�G���[���b�Z�[�W��\������
		} else {
			Write-Host "���������G���[: �G���R�[�_�[�̃`�F�b�N�Ɏ��s���܂����B`r`n�G���[�̌����@: $($hwEncoder.Key)�̎��s�t�@�C�����m�F�ł��܂���B"
		}
	}
}


Write-Host -NoNewline "`r`nVisual C++ �ĔЕz�\�p�b�P�[�W���m�F���Ă��܂�..."

# ���W�X�g������f�X�N�g�b�v�A�v���̈ꗗ���擾����
$installedApps = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
								  "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
								  "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue |
Where-Object { $_.DisplayName -and $_.UninstallString -and -not $_.SystemComponent -and ($_.ReleaseType -notin "Update","Hotfix") -and -not $_.ParentKeyName } |
Select-Object DisplayName

# Microsoft Visual C++ 2015-20xx Redistributable (x86) ���C���X�g�[������Ă��邩�m�F����
	# Visual C++ �ĔЕz�\�p�b�P�[�W��2020��2021�͂Ȃ��̂ŁA20[2-9][0-9] �Ƃ��Ă�����2022�ȍ~���w��ł���
$Vc2015App = $installedApps.DisplayName -match "Microsoft Visual C\+\+ 2015-20[2-9][0-9] Redistributable \(x86\)"

# Microsoft Visual C++ 2008 Redistributable - x86 ���C���X�g�[������Ă��邩�m�F����
$Vc2008App = $installedApps.DisplayName -match "Microsoft Visual C\+\+ 2008 Redistributable - x86"

Write-Host "����"

# $Vc2015App �� $Vc2008App �̌��ʂŏ����𕪊򂷂�

# �����C���X�g�[������Ă���ꍇ�A���b�Z�[�W�����\��
if ($Vc2015App -and $Vc2008App) {
	Write-Host "Microsoft Visual C++ 2015-20xx Redistributable (x86) �̓C���X�g�[���ς݂ł��B"
	Write-Host "Microsoft Visual C++ 2008 Redistributable - x86 �̓C���X�g�[���ς݂ł��B"

# 2008�̂݃C���X�g�[������Ă���ꍇ�A2015�������C���X�g�[��
} elseif ($Vc2008App) {
	Write-Host "Microsoft Visual C++ 2015-20xx Redistributable (x86) �̓C���X�g�[������Ă��܂���B"
	Write-Host "���̃p�b�P�[�W�� patch.aul �ȂǏd�v�ȃv���O�C���̓���ɕK�v�ł��B�C���X�g�[���ɂ͊Ǘ��Ҍ������K�v�ł��B`r`n"
	Write-Host -NoNewline "Microsoft Visual C++ 2015-20xx Redistributable (x86) �̃C���X�g�[���[���_�E�����[�h���Ă��܂�..."

	# Visual C++ 2015-20xx Redistributable (x86) �̃C���X�g�[���[���_�E�����[�h (�ҋ@)
	Start-Process curl.exe -ArgumentList "-OL https://aka.ms/vs/17/release/vc_redist.x86.exe" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host "Microsoft Visual C++ 2015-20xx Redistributable (x86) �̃C���X�g�[�����s���܂��B"
	Write-Host "�f�o�C�X�ւ̕ύX���K�v�ɂȂ�܂��B���[�U�[�A�J�E���g����̃|�b�v�A�b�v���o���� [�͂�] �������ċ����Ă��������B`r`n"

	# Visual C++ 2015-20xx Redistributable (x86) �̃C���X�g�[���[�����s (�ҋ@)
		# �����C���X�g�[���I�v�V������ǉ� by Atolycs (20250106)
	Start-Process -FilePath vc_redist.x86.exe -ArgumentList "/install /passive" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "�C���X�g�[���[���I�����܂����B"
	Write-Host "`r`nMicrosoft Visual C++ 2008 Redistributable - x86 �̓C���X�g�[���ς݂ł��B"

# 2015�̂݃C���X�g�[������Ă���ꍇ�A2008�̃C���X�g�[�������[�U�[�ɑI��������
} elseif ($Vc2015App) {
	Write-Host "Microsoft Visual C++ 2008 Redistributable - x86 �̓C���X�g�[������Ă��܂���B"

	# �I����������

	$choiceTitle = "Microsoft Visual C++ 2008 Redistributable - x86 ���C���X�g�[�����܂����H"
	$choiceMessage = "���̃p�b�P�[�W�͈ꕔ�̃X�N���v�g�̓���ɕK�v�ł��B�C���X�g�[���ɂ͊Ǘ��Ҍ������K�v�ł��B"

	$tChoiceDescription = "System.Management.Automation.Host.ChoiceDescription"
	$choiceOptions = @(
		New-Object $tChoiceDescription ("�͂�(&Y)", "�C���X�g�[�������s���܂��B")
		New-Object $tChoiceDescription ("������(&N)", "�C���X�g�[���������A�X�L�b�v���Ď��̏����ɐi�݂܂��B")
	)

	$result = $host.ui.PromptForChoice($choiceTitle, $choiceMessage, $choiceOptions, 0)
	switch ($result) {
		0 {
			Write-Host -NoNewline "`r`nMicrosoft Visual C++ 2008 Redistributable - x86 �̃C���X�g�[���[���_�E�����[�h���Ă��܂�..."

			# Visual C++ 2008 Redistributable - x86 �̃C���X�g�[���[���_�E�����[�h (�ҋ@)
			Start-Process curl.exe -ArgumentList "-OL https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

			Write-Host "����"
			Write-Host "Microsoft Visual C++ 2008 Redistributable - x86 �̃C���X�g�[�����s���܂��B"
			Write-Host "�f�o�C�X�ւ̕ύX���K�v�ɂȂ�܂��B���[�U�[�A�J�E���g����̃|�b�v�A�b�v���o���� [�͂�] �������ċ����Ă��������B`r`n"

			# Visual C++ 2008 Redistributable - x86 �̃C���X�g�[���[�����s (�ҋ@)
				# �����C���X�g�[���I�v�V������ǉ� by Atolycs (20250106)
			Start-Process -FilePath vcredist_x86.exe -ArgumentList "/qb" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

			Write-Host "�C���X�g�[���[���I�����܂����B"
			break
		}
		1 {
			Write-Host "`r`nMicrosoft Visual C++ 2008 Redistributable - x86 �̃C���X�g�[�����X�L�b�v���܂����B"
			break
		}
	}

	# �I�������܂�

# �����C���X�g�[������Ă��Ȃ��ꍇ�A2008�̃C���X�g�[�������[�U�[�ɑI�������A2008���C���X�g�[������ꍇ�͗����C���X�g�[�����A
# 2008���C���X�g�[�����Ȃ��ꍇ��2015�̂ݎ����C���X�g�[��
} else  {
	Write-Host "Microsoft Visual C++ 2015-20xx Redistributable (x86) �̓C���X�g�[������Ă��܂���B"
	Write-Host "���̃p�b�P�[�W�� patch.aul �ȂǏd�v�ȃv���O�C���̓���ɕK�v�ł��B�C���X�g�[���ɂ͊Ǘ��Ҍ������K�v�ł��B`r`n"
	Write-Host -NoNewline "Microsoft Visual C++ 2015-20xx Redistributable (x86) �̃C���X�g�[���[���_�E�����[�h���Ă��܂�..."

	# Visual C++ 2015-20xx Redistributable (x86) �̃C���X�g�[���[���_�E�����[�h (�ҋ@)
	Start-Process curl.exe -ArgumentList "-OL https://aka.ms/vs/17/release/vc_redist.x86.exe" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host "`r`nMicrosoft Visual C++ 2008 Redistributable - x86 �̓C���X�g�[������Ă��܂���B"

	# �I����������

	$choiceTitle = "Microsoft Visual C++ 2008 Redistributable - x86 ���C���X�g�[�����܂����H"
	$choiceMessage = "���̃p�b�P�[�W�͈ꕔ�̃X�N���v�g�̓���ɕK�v�ł��B�C���X�g�[���ɂ͊Ǘ��Ҍ������K�v�ł��B"

	$tChoiceDescription = "System.Management.Automation.Host.ChoiceDescription"
	$choiceOptions = @(
		New-Object $tChoiceDescription ("�͂�(&Y)",  "�C���X�g�[�������s���܂��B")
		New-Object $tChoiceDescription ("������(&N)", "�C���X�g�[���������A�X�L�b�v���Ď��̏����ɐi�݂܂��B")
	)

	$result = $host.ui.PromptForChoice($choiceTitle, $choiceMessage, $choiceOptions, 0)
	switch ($result) {
		0 {
			Write-Host -NoNewline "`r`nMicrosoft Visual C++ 2008 Redistributable - x86 �̃C���X�g�[���[���_�E�����[�h���Ă��܂�..."

			# Visual C++ 2008 Redistributable - x86 �̃C���X�g�[���[���_�E�����[�h (�ҋ@)
			Start-Process curl.exe -ArgumentList "-OL https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

			Write-Host "����"
			Write-Host "`r`nMicrosoft Visual C++ 2015-20xx Redistributable (x86) ��`r`nMicrosoft Visual C++ 2008 Redistributable - x86 �̃C���X�g�[�����s���܂��B"
			Write-Host "�f�o�C�X�ւ̕ύX���K�v�ɂȂ�܂��B���[�U�[�A�J�E���g����̃|�b�v�A�b�v���o���� [�͂�] �������ċ����Ă��������B`r`n"

			# VCruntimeInstall2015and2008.cmd ���Ǘ��Ҍ����Ŏ��s (�ҋ@)
			Start-Process -FilePath cmd.exe -ArgumentList "/C cd $scriptFilesDirectoryPath & call VCruntimeInstall2015and2008.cmd & exit" -Verb RunAs -WindowStyle Hidden -Wait

			Write-Host "�C���X�g�[���[���I�����܂����B"
			break
		}
		1 {
			Write-Host "Microsoft Visual C++ 2015-20xx Redistributable (x86) �̃C���X�g�[�����s���܂��B"
			Write-Host "�f�o�C�X�ւ̕ύX���K�v�ɂȂ�܂��B���[�U�[�A�J�E���g����̃|�b�v�A�b�v���o���� [�͂�] �������ċ����Ă��������B`r`n"

			# Visual C++ 2015-20xx Redistributable (x86) �̃C���X�g�[���[�����s (�ҋ@)
				# �����C���X�g�[���I�v�V������ǉ� by Atolycs (20250106)
			Start-Process -FilePath vc_redist.x86.exe -ArgumentList "/install /passive" -WorkingDirectory $scriptFileRoot -WindowStyle Hidden -Wait

			Write-Host "�C���X�g�[���[���I�����܂����B"
			Write-Host "`r`nMicrosoft Visual C++ 2008 Redistributable - x86 �̃C���X�g�[�����X�L�b�v���܂����B"
			break
		}
	}

	# �I�������܂�
}

# AviUtl �f�B���N�g�����̑S�t�@�C���̃u���b�N������ (�Z�L�����e�B�@�\�̕s�v�Ȕ������\�Ȕ͈͂Ŗh������)
Get-ChildItem -Path $Path -Recurse | Unblock-File

Write-Host -NoNewline "`r`napm.json ���쐬���Ă��܂�..."

# $apmJsonHash ��JSON�`���ɕϊ����Aapm.json �Ƃ��ďo�͂���
ConvertTo-Json $apmJsonHash -Depth 8 -Compress | ForEach-Object { $_ + "`n" } | ForEach-Object { [Text.Encoding]::UTF8.GetBytes($_) } | Set-Content -Encoding Byte -Path "${Path}\apm.json"

Write-Host "����"
Write-Host -NoNewline "`r`nais.json ���쐬���Ă��܂�..."

# $aisJsonHash ��JSON�`���ɕϊ����Aais.json �Ƃ��ďo�͂���
ConvertTo-Json $aisJsonHash -Depth 8 -Compress | ForEach-Object { $_ + "`n" } | ForEach-Object { [Text.Encoding]::UTF8.GetBytes($_) } | Set-Content -Encoding Byte -Path "${Path}\ais.json"

Write-Host "����"
Write-Host -NoNewline "`r`n�X�V�Ɏg�p�����s�v�ȃt�@�C�����폜���Ă��܂�..."

# �J�����g�f�B���N�g�����X�N���v�g�t�@�C���̂���f�B���N�g���ɕύX
Set-Location ..

# tmp �f�B���N�g�����폜
Remove-Item tmp -Recurse

Write-Host "����"

# ���[�U�[�̑����҂��ďI��
Write-Host -NoNewline "`r`n`r`n`r`n�X�V���������܂����I`r`n`r`n`r`nreadme �t�H���_���J����"
Pause

# �I������ readme �f�B���N�g����\��
Invoke-Item $ReadmeDirectoryRoot
