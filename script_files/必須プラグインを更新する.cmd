@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

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

# GitHub���|�W�g���̍ŐV�Ń����[�X�̃_�E�����[�hURL���擾����
function GithubLatestReleaseUrl ($repo) {
	# GitHub��API����ŐV�Ń����[�X�̏����擾����
	$api = Invoke-RestMethod "https://api.github.com/repos/$repo/releases/latest"

	# �ŐV�Ń����[�X�̃_�E�����[�hURL�݂̂�Ԃ�
	return($api.assets.browser_download_url)
}

$Host.UI.RawUI.WindowTitle = "�K�{�v���O�C�����X�V����.cmd"

Write-Host "�K�{�v���O�C�� (patch.aul�EL-SMASH Works�EInputPipePlugin�Ex264guiEx) ����� LuaJIT�Aifheif �̍X�V���J�n���܂��B`r`n`r`n"

# �J�����g�f�B���N�g���̃p�X�� $scriptFileRoot �ɕۑ� (�N�����@�̂����� $PSScriptRoot ���g�p�ł��Ȃ�����)
$scriptFileRoot = (Get-Location).Path

Write-Host -NoNewline "AviUtl���C���X�g�[������Ă���t�H���_���m�F���Ă��܂�..."

# aviutl.exe �������Ă���f�B���N�g����T���A$aviutlExeDirectory �Ƀp�X��ۑ�
if (Test-Path "C:\AviUtl\aviutl.exe") {
	Write-Host "����"
	$aviutlExeDirectory = "C:\AviUtl"
} elseif (Test-Path "C:\Applications\AviUtl\aviutl.exe") {
	Write-Host "����"
	$aviutlExeDirectory = "C:\Applications\AviUtl"
} else { # �m�F�ł��Ȃ������ꍇ�A���[�U�[�Ƀp�X����͂�����
	# ���[�U�[�Ƀp�X����͂����Aaviutl.exe �������Ă��邱�Ƃ��m�F�����烋�[�v�𔲂���
	New-Variable checkInputAviutlExePath # ���[�v�𔲂��Ă��g�p���邽�ߐ�ɐ錾
	do {
		Write-Host "����"
		Write-Host "AviUtl���C���X�g�[������Ă���t�H���_���m�F�ł��܂���ł����B`r`n"

		Write-Host "aviutl.exe �̃p�X�A�܂��� aviutl.exe �������Ă���t�H���_�̃p�X����͂��AEnter �������Ă��������B"
		$userInputAviutlExePath = Read-Host

		# ���[�U�[�̓��͂����Ƃ� aviutl.exe �̃p�X�� $checkInputAviutlExePath �ɑ��
		if ($userInputAviutlExePath -match "\\aviutl\.exe") {
			$checkInputAviutlExePath = $userInputAviutlExePath
		} else {
			$checkInputAviutlExePath = Join-Path -Path $userInputAviutlExePath -ChildPath aviutl.exe
		}

		Write-Host -NoNewline "`r`nAviUtl���C���X�g�[������Ă���t�H���_���m�F���Ă��܂�..."
	} while (!(Test-Path $checkInputAviutlExePath))
	Write-Host "����"

	# $checkInputAviutlExePath �̐e�f�B���N�g���� $aviutlExeDirectory �ɕۑ�
	$aviutlExeDirectory = Split-Path $checkInputAviutlExePath -Parent
}

Start-Sleep -Milliseconds 500

Write-Host -NoNewline "`r`n�ꎞ�I�Ƀt�@�C����ۊǂ���t�H���_���쐬���Ă��܂�..."

# AviUtl �f�B���N�g������ plugins, script, license, readme ��4�̃f�B���N�g�����쐬���� (�ҋ@)
$aviutlPluginsDirectory = Join-Path -Path $aviutlExeDirectory -ChildPath plugins
$aviutlScriptDirectory = Join-Path -Path $aviutlExeDirectory -ChildPath script
$LicenseDirectoryRoot = Join-Path -Path $aviutlExeDirectory -ChildPath license
$ReadmeDirectoryRoot = Join-Path -Path $aviutlExeDirectory -ChildPath readme
Start-Process powershell -ArgumentList "-command New-Item $aviutlPluginsDirectory, $aviutlScriptDirectory, $LicenseDirectoryRoot, $ReadmeDirectoryRoot -ItemType Directory -Force" -WindowStyle Hidden -Wait

# tmp �f�B���N�g�����쐬���� (�ҋ@)
Start-Process powershell -ArgumentList "-command New-Item tmp -ItemType Directory -Force" -WindowStyle Hidden -Wait

Write-Host "����"
Write-Host -NoNewline "`r`n�g���ҏWPlugin�̃C���X�g�[������Ă���f�B���N�g�����m�F���Ă��܂�..."

# �g���ҏWPlugin�� plugins �f�B���N�g�����ɂ���ꍇ�AAviUtl �f�B���N�g�����Ɉړ������� (�G���[�̖h�~)
$exeditAufPluginsPath = Join-Path -Path $aviutlPluginsDirectory -ChildPath exedit.auf
if (Test-Path $exeditAufPluginsPath) {
	# �J�����g�f�B���N�g���� plugins �f�B���N�g���ɕύX
	Set-Location $aviutlPluginsDirectory

	# �g���ҏWPlugin�̃t�@�C����S�� AviUtl �f�B���N�g�����Ɉړ�
	Move-Item "exedit*" $aviutlExeDirectory -Force
	Move-Item lua51.dll $aviutlExeDirectory -Force
	if (Test-Path "${aviutlPluginsDirectory}\lua.txt") {
		Move-Item lua.txt $aviutlExeDirectory -Force
	}

	# Susie�v���O�C���̏ꏊ�������ĕύX
	if (Test-Path "${aviutlPluginsDirectory}\*.spi") {
		Move-Item "*.spi" $aviutlExeDirectory -Force
	}

	# �J�����g�f�B���N�g�����X�N���v�g�t�@�C���̂���f�B���N�g���ɕύX
	Set-Location $scriptFileRoot
}

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location tmp

Write-Host "����"
Write-Host -NoNewline "`r`npatch.aul (�䂳���ȃt�H�[�N��) �̍ŐV�ŏ����擾���Ă��܂�..."

# patch.aul (�䂳���ȃt�H�[�N��) �̍ŐV�ł̃_�E�����[�hURL���擾
$patchAulUrl = GithubLatestReleaseUrl "nazonoSAUNA/patch.aul"

Write-Host "����"
Write-Host -NoNewline "patch.aul (�䂳���ȃt�H�[�N��) ���_�E�����[�h���Ă��܂�..."

# patch.aul (�䂳���ȃt�H�[�N��) ��zip�t�@�C�����_�E�����[�h (�ҋ@)
Start-Process -FilePath curl.exe -ArgumentList "-OL $patchAulUrl" -WindowStyle Hidden -Wait

Write-Host "����"
Write-Host -NoNewline "patch.aul (�䂳���ȃt�H�[�N��) ���C���X�g�[�����Ă��܂�..."

# patch.aul��zip�t�@�C����W�J (�ҋ@)
Start-Process powershell -ArgumentList "-command Expand-Archive -Path patch.aul_*.zip -Force" -WindowStyle Hidden -Wait

# �J�����g�f�B���N�g����patch.aul��zip�t�@�C����W�J�����f�B���N�g���ɕύX
Set-Location "patch.aul_*"

# AviUtl\license ���� patch-aul �f�B���N�g�����쐬 (�ҋ@)
$patchAulLicenseDirectory = Join-Path -Path $LicenseDirectoryRoot -ChildPath patch-aul
Start-Process powershell -ArgumentList "-command New-Item $patchAulLicenseDirectory -ItemType Directory -Force" -WindowStyle Hidden -Wait

# patch.aul �� plugins �f�B���N�g�����ɂ���ꍇ�A�폜���� patch.aul.json ���ړ������� (�G���[�̖h�~)
$patchAulPluginsPath = Join-Path -Path $aviutlPluginsDirectory -ChildPath patch.aul
if (Test-Path $patchAulPluginsPath) {
	Remove-Item $patchAulPluginsPath
	$patchAulJsonPath = Join-Path -Path $aviutlExeDirectory -ChildPath patch.aul.json
	$patchAulJsonPluginsPath = Join-Path -Path $aviutlPluginsDirectory -ChildPath patch.aul.json
	if ((Test-Path $patchAulJsonPluginsPath) -and (!(Test-Path $patchAulJsonPath))) {
		Move-Item $patchAulJsonPluginsPath $aviutlExeDirectory -Force
	} elseif (Test-Path $patchAulJsonPluginsPath) {
		Remove-Item $patchAulJsonPluginsPath
	}
}

# AviUtl �f�B���N�g������ patch.aul �� (�ҋ@) �AAviUtl\license\patch-aul ���ɂ��̑��̃t�@�C�������ꂼ��ړ�
Start-Process powershell -ArgumentList "-command Move-Item patch.aul $aviutlExeDirectory -Force" -WindowStyle Hidden -Wait
Move-Item * $patchAulLicenseDirectory -Force

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location ..

Write-Host "����"
Write-Host -NoNewline "`r`npatch.aul (�䂳���ȃt�H�[�N��) �Ƌ�������v���O�C���̗L�����m�F���Ă��܂�..."

# bakusoku.auf ���m�F���A��������폜
if (Test-Path "${aviutlExeDirectory}\bakusoku.auf") {
	Remove-Item "${aviutlExeDirectory}\bakusoku.auf"
}
if (Test-Path "${aviutlPluginsDirectory}\bakusoku.auf") {
	Remove-Item "${aviutlPluginsDirectory}\bakusoku.auf"
}

# Boost.auf ���m�F���A��������폜
if (Test-Path "${aviutlExeDirectory}\Boost.auf") {
	Remove-Item "${aviutlExeDirectory}\Boost.auf"
}
if (Test-Path "${aviutlPluginsDirectory}\Boost.auf") {
	Remove-Item "${aviutlPluginsDirectory}\Boost.auf"
}

Write-Host "����"
Write-Host -NoNewline "`r`nL-SMASH Works (Mr-Ojii��) �̍ŐV�ŏ����擾���Ă��܂�..."

# L-SMASH Works (Mr-Ojii��) �̍ŐV�ł̃_�E�����[�hURL���擾
$lSmashWorksAllUrl = GithubLatestReleaseUrl "Mr-Ojii/L-SMASH-Works-Auto-Builds"

# �������钆����AviUtl�p�̂��̂̂ݎc��
$lSmashWorksUrl = $lSmashWorksAllUrl | Where-Object {$_ -like "*Mr-Ojii_vimeo*"}

Write-Host "����"
Write-Host -NoNewline "L-SMASH Works (Mr-Ojii��) ���_�E�����[�h���Ă��܂�..."

# L-SMASH Works (Mr-Ojii��) ��zip�t�@�C�����_�E�����[�h (�ҋ@)
Start-Process -FilePath curl.exe -ArgumentList "-OL $lSmashWorksUrl" -WindowStyle Hidden -Wait

Write-Host "����"
Write-Host -NoNewline "L-SMASH Works (Mr-Ojii��) ���C���X�g�[�����Ă��܂�..."

# AviUtl\license\l-smash_works ���� Licenses �f�B���N�g��������΍폜���� (�G���[�̖h�~)
$lSmashWorksLicenseDirectoryLicenses = Join-Path -Path $LicenseDirectoryRoot -ChildPath l-smash_works\Licenses
if (Test-Path $lSmashWorksLicenseDirectoryLicenses) {
	Remove-Item $lSmashWorksLicenseDirectoryLicenses -Recurse
}

# AviUtl �f�B���N�g���� plugins �f�B���N�g������ lwi �f�B���N�g��������Β��� .lwi �t�@�C�����폜���� (�G���[�̖h�~)
$aviutlExelwiDirectory = Join-Path -Path $aviutlExeDirectory -ChildPath lwi
if (Test-Path $aviutlExelwiDirectory) {
	Set-Location $aviutlExelwiDirectory
	if (Test-Path "*.lwi") {
		Remove-Item "*.lwi"
	}

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location $scriptFileRoot
	Set-Location tmp
}
$aviutlPluginslwiDirectory = Join-Path -Path $aviutlPluginsDirectory -ChildPath lwi
if (Test-Path $aviutlPluginslwiDirectory) {
	Set-Location $aviutlPluginslwiDirectory
	if (Test-Path "*.lwi") {
		Remove-Item "*.lwi"
	}

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location $scriptFileRoot
	Set-Location tmp
}

# L-SMASH Works��zip�t�@�C����W�J (�ҋ@)
Start-Process powershell -ArgumentList "-command Expand-Archive -Path L-SMASH-Works_*.zip -Force" -WindowStyle Hidden -Wait

# �J�����g�f�B���N�g����L-SMASH Works��zip�t�@�C����W�J�����f�B���N�g���ɕύX
Set-Location "L-SMASH-Works_*"

# AviUtl\readme, AviUtl\license ���� l-smash_works �f�B���N�g�����쐬 (�ҋ@)
$lSmashWorksReadmeDirectory = Join-Path -Path $ReadmeDirectoryRoot -ChildPath l-smash_works
$lSmashWorksLicenseDirectory = Join-Path -Path $LicenseDirectoryRoot -ChildPath l-smash_works
Start-Process powershell -ArgumentList "-command New-Item $lSmashWorksReadmeDirectory, $lSmashWorksLicenseDirectory -ItemType Directory -Force" -WindowStyle Hidden -Wait

# L-SMASH Works�̓����Ă���f�B���N�g����T���A$lwinputAuiDirectory �Ƀp�X��ۑ�
# $inputPipePluginDeleteCheckDirectory �� $lwinputAuiDirectory �̋t�A��Ɏg�p
$lwinputAuiTestPath = Join-Path -Path $aviutlExeDirectory -ChildPath lwinput.aui
New-Variable lwinputAuiDirectory
New-Variable inputPipePluginDeleteCheckDirectory
if (Test-Path $lwinputAuiTestPath) {
	$lwinputAuiDirectory = $aviutlExeDirectory
	$inputPipePluginDeleteCheckDirectory = $aviutlPluginsDirectory
} else {
	$lwinputAuiDirectory = $aviutlPluginsDirectory
	$inputPipePluginDeleteCheckDirectory = $aviutlExeDirectory
}

Start-Sleep -Milliseconds 500

# AviUtl\plugins �f�B���N�g������ lw*.au* ���AAviUtl\readme\l-smash_works ���� READM* �� (�ҋ@) �A
# AviUtl\license\l-smash_works ���ɂ��̑��̃t�@�C�������ꂼ��ړ�
Start-Process powershell -ArgumentList "-command Move-Item lw*.au* $lwinputAuiDirectory -Force; Move-Item READM* $lSmashWorksReadmeDirectory -Force" -WindowStyle Hidden -Wait
Move-Item * $lSmashWorksLicenseDirectory -Force

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location ..

Write-Host "����"
Write-Host -NoNewline "`r`nInputPipePlugin�̍ŐV�ŏ����擾���Ă��܂�..."

# InputPipePlugin�̍ŐV�ł̃_�E�����[�hURL���擾
$InputPipePluginUrl = GithubLatestReleaseUrl "amate/InputPipePlugin"

Write-Host "����"
Write-Host -NoNewline "InputPipePlugin���_�E�����[�h���Ă��܂�..."

# InputPipePlugin��zip�t�@�C�����_�E�����[�h (�ҋ@)
Start-Process -FilePath curl.exe -ArgumentList "-OL $InputPipePluginUrl" -WindowStyle Hidden -Wait

Write-Host "����"
Write-Host -NoNewline "InputPipePlugin���C���X�g�[�����Ă��܂�..."

# InputPipePlugin��zip�t�@�C����W�J (�ҋ@)
Start-Process powershell -ArgumentList "-command Expand-Archive -Path InputPipePlugin_*.zip -Force" -WindowStyle Hidden -Wait

# �J�����g�f�B���N�g����InputPipePlugin��zip�t�@�C����W�J�����f�B���N�g���ɕύX
Set-Location "InputPipePlugin_*\InputPipePlugin"

# AviUtl\readme, AviUtl\license ���� inputPipePlugin �f�B���N�g�����쐬 (�ҋ@)
$inputPipePluginReadmeDirectory = Join-Path -Path $ReadmeDirectoryRoot -ChildPath inputPipePlugin
$inputPipePluginLicenseDirectory = Join-Path -Path $LicenseDirectoryRoot -ChildPath inputPipePlugin
Start-Process powershell -ArgumentList "-command New-Item $inputPipePluginReadmeDirectory, $inputPipePluginLicenseDirectory -ItemType Directory -Force" -WindowStyle Hidden -Wait

# AviUtl\license\inputPipePlugin ���� LICENSE ���AAviUtl\readme\inputPipePlugin ���� Readme.md �� (�ҋ@) �A
# AviUtl\plugins �f�B���N�g�����ɂ��̑��̃t�@�C�������ꂼ��ړ�
Start-Process powershell -ArgumentList "-command Move-Item LICENSE $inputPipePluginLicenseDirectory -Force; Move-Item Readme.md $inputPipePluginReadmeDirectory -Force" -WindowStyle Hidden -Wait
Move-Item * $lwinputAuiDirectory -Force

# �g���u���̌����ɂȂ�t�@�C���̏���
Set-Location $inputPipePluginDeleteCheckDirectory
if (Test-Path "InputPipe*") {
	Remove-Item "InputPipe*"
}
Set-Location $scriptFileRoot

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location tmp

Write-Host "����"
Write-Host -NoNewline "`r`nx264guiEx�̍ŐV�ŏ����擾���Ă��܂�..."

# x264guiEx�̍ŐV�ł̃_�E�����[�hURL���擾
$x264guiExUrl = GithubLatestReleaseUrl "rigaya/x264guiEx"

Write-Host "����"
Write-Host -NoNewline "x264guiEx���_�E�����[�h���Ă��܂�..."

# x264guiEx��zip�t�@�C�����_�E�����[�h (�ҋ@)
Start-Process -FilePath curl.exe -ArgumentList "-OL $x264guiExUrl" -WindowStyle Hidden -Wait

Write-Host "����"
Write-Host -NoNewline "x264guiEx���C���X�g�[�����Ă��܂��B`r`n"

# x264guiEx��zip�t�@�C����W�J (�ҋ@)
Start-Process powershell -ArgumentList "-command Expand-Archive -Path x264guiEx_*.zip -Force" -WindowStyle Hidden -Wait

# �J�����g�f�B���N�g����x264guiEx��zip�t�@�C����W�J�����f�B���N�g���ɕύX
Set-Location "x264guiEx_*\x264guiEx_*"

# �J�����g�f�B���N�g����x264guiEx��zip�t�@�C����W�J�����f�B���N�g������ plugins �f�B���N�g���ɕύX
Set-Location plugins

# AviUtl\plugins ���Ɍ��݂̃f�B���N�g���̃t�@�C�����v���t�@�C���ȊO�S�Ĉړ�
Move-Item "x264guiEx.*" $aviutlPluginsDirectory -Force
Move-Item auo_setup.auf -Force

# �v���t�@�C�����㏑�����邩�ǂ������[�U�[�Ɋm�F���� (����� �㏑�����Ȃ�)
# �I����������

$x264guiExChoiceTitle = "x264guiEx�̃v���t�@�C�����㏑�����܂����H"
$x264guiExChoiceMessage = "�v���t�@�C���͍X�V�ŐV�����Ȃ��Ă���\��������܂����A�㏑�������s����ƒǉ������v���t�@�C����v���t�@�C���ւ̕ύX���폜����܂��B"

$x264guiExTChoiceDescription = "System.Management.Automation.Host.ChoiceDescription"
$x264guiExChoiceOptions = @(
	New-Object $x264guiExTChoiceDescription ("�͂�(&Y)",	   "�㏑�������s���܂��B")
	New-Object $x264guiExTChoiceDescription ("������(&N)",	 "�㏑���������A�X�L�b�v���Ď��̏����ɐi�݂܂��B")
)

$x264guiExChoiceResult = $host.ui.PromptForChoice($x264guiExChoiceTitle, $x264guiExChoiceMessage, $x264guiExChoiceOptions, 1)
switch ($x264guiExChoiceResult) {
	0 {
		Write-Host -NoNewline "`r`nx264guiEx�̃v���t�@�C�����㏑�����܂�..."

		# AviUtl\plugins ���� x264guiEx_stg �f�B���N�g��������΍폜����
		$x264guiExStgDirectory = Join-Path -Path $aviutlPluginsDirectory -ChildPath x264guiEx_stg
		if (Test-Path $x264guiExStgDirectory) {
			Remove-Item $x264guiExStgDirectory -Recurse
		}

		# AviUtl\plugins ���Ɍ��݂̃f�B���N�g���̃t�@�C����S�Ĉړ�
		Move-Item * $aviutlPluginsDirectory -Force

		Write-Host "����"
		break
	}
	1 {
		Write-Host "`r`nx264guiEx�̃v���t�@�C���̏㏑�����X�L�b�v���܂����B"
		break
	}
}

# �I�������܂�

# �J�����g�f�B���N�g����x264guiEx��zip�t�@�C����W�J�����f�B���N�g������ exe_files �f�B���N�g���ɕύX
Set-Location ..\exe_files

# AviUtl �f�B���N�g������ exe_files �f�B���N�g�����쐬 (�ҋ@)
$exeFilesDirectory = Join-Path -Path $aviutlExeDirectory -ChildPath exe_files
Start-Process powershell -ArgumentList "-command New-Item $exeFilesDirectory -ItemType Directory -Force" -WindowStyle Hidden -Wait

# AviUtl\exe_files ���� x264_*.exe ������΍폜 (�ҋ@)
Set-Location $exeFilesDirectory
Start-Process powershell -ArgumentList "-command if (Test-Path x264_*.exe) { Remove-Item x264_*.exe }" -WindowStyle Hidden -Wait
Set-Location $scriptFileRoot
Set-Location "tmp\x264guiEx_*\x264guiEx_*\exe_files"

# AviUtl\exe_files ���Ɍ��݂̃f�B���N�g���̃t�@�C����S�Ĉړ�
Move-Item * $exeFilesDirectory -Force

# �J�����g�f�B���N�g����x264guiEx��zip�t�@�C����W�J�����f�B���N�g���ɕύX
Set-Location ..

# AviUtl\readme ���� x264guiEx �f�B���N�g�����쐬 (�ҋ@)
$x264guiExReadmeDirectory = Join-Path -Path $ReadmeDirectoryRoot -ChildPath x264guiEx
Start-Process powershell -ArgumentList "-command New-Item $x264guiExReadmeDirectory -ItemType Directory -Force" -WindowStyle Hidden -Wait

# AviUtl\readme\x264guiEx ���� x264guiEx_readme.txt ���ړ�
Move-Item x264guiEx_readme.txt $x264guiExReadmeDirectory -Force

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location ..\..

Write-Host "`r`nx264guiEx�̃C���X�g�[�����������܂����B"


# LuaJIT�̍X�V by Yu-yu0202 (20250109)
	# �s�������Ȃ��������ߍĎ��� by menndouyukkuri (20250110)

# AviUtl �f�B���N�g������ old_lua51.dll ������΍폜����
if (Test-Path "${aviutlExeDirectory}\old_lua51.dll") {
	Remove-Item "${aviutlExeDirectory}\old_lua51.dll"
}

Write-Host -NoNewline "`r`nLuaJIT�̍ŐV�ŏ����擾���Ă��܂�..."

# LuaJIT�̍ŐV�ł̃_�E�����[�hURL���擾
$luaJitAllUrl = GithubLatestReleaseUrl "Per-Terra/LuaJIT-Auto-Builds"

# �������钆����AviUtl�p�̂��̂̂ݎc��
$luaJitUrl = $luaJitAllUrl | Where-Object {$_ -like "*LuaJIT_2.1_Win_x86.zip"}

Write-Host "����"
Write-Host -NoNewline "LuaJIT���_�E�����[�h���Ă��܂�..."

# LuaJIT��zip�t�@�C�����_�E�����[�h (�ҋ@)
Start-Process -FilePath curl.exe -ArgumentList "-OL $luaJitUrl" -WindowStyle Hidden -Wait

Write-Host "����"
Write-Host -NoNewline "LuaJIT���C���X�g�[�����Ă��܂�..."

# AviUtl �f�B���N�g������ exedit_lua51.dll ���Ȃ��ꍇ�A���ɂ��� lua51.dll �����l�[�����ăo�b�N�A�b�v����
if (!(Test-Path "${aviutlExeDirectory}\exedit_lua51.dll")) {
	Rename-Item "${aviutlExeDirectory}\lua51.dll" "old_lua51.dll" -Force
}

# AviUtl\readme\LuaJIT ���� doc �f�B���N�g��������΍폜���� (�G���[�̖h�~)
if (Test-Path "${ReadmeDirectoryRoot}\LuaJIT\doc") {
	Remove-Item "${ReadmeDirectoryRoot}\LuaJIT\doc" -Recurse
}

# LuaJIT��zip�t�@�C����W�J (�ҋ@)
Start-Process powershell -ArgumentList "-command Expand-Archive -Path 'LuaJIT_2.1_Win_x86.zip' -Force" -WindowStyle Hidden -Wait

# �J�����g�f�B���N�g����LuaJIT��zip�t�@�C����W�J�����f�B���N�g���ɕύX
Set-Location "LuaJIT_2.1_Win_x86"

# AviUtl\readme, AviUtl\license ���� LuaJIT �f�B���N�g�����쐬 (�ҋ@)
Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\LuaJIT`", `"${LicenseDirectoryRoot}\LuaJIT`" -ItemType Directory -Force" -WindowStyle Hidden -Wait

# AviUtl �f�B���N�g������ lua51.dll ���AAviUtl\readme\LuaJIT ���� README �� doc ���AAviUtl\license\LuaJIT ����
# COPYRIGHT �� About-This-Build.txt �����ꂼ��ړ�
Move-Item "lua51.dll" $aviutlExeDirectory -Force
Move-Item README "${ReadmeDirectoryRoot}\LuaJIT" -Force
Move-Item doc "${ReadmeDirectoryRoot}\LuaJIT" -Force
Move-Item COPYRIGHT "${LicenseDirectoryRoot}\LuaJIT" -Force
Move-Item "About-This-Build.txt" "${LicenseDirectoryRoot}\LuaJIT" -Force

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location ..

Write-Host "����"


Write-Host -NoNewline "`r`nWebP Susie Plug-in���m�F���Ă��܂�..."

# WebP Susie Plug-in����������Ă��Ȃ��ꍇ�݈̂ȉ��̏��������s
if (!(Test-Path "${aviutlExeDirectory}\iftwebp.spi")) {
	Write-Host "����"
	Write-Host -NoNewline "`r`nWebP Susie Plug-in���_�E�����[�h���Ă��܂�..."

	# WebP Susie Plug-in��zip�t�@�C�����_�E�����[�h (�ҋ@)
	Start-Process -FilePath curl.exe -ArgumentList "-OL https://toroidj.github.io/plugin/iftwebp11.zip" -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host -NoNewline "WebP Susie Plug-in���C���X�g�[�����Ă��܂�..."

	# WebP Susie Plug-in��zip�t�@�C����W�J (�ҋ@)
	Start-Process powershell -ArgumentList "-command Expand-Archive -Path iftwebp11.zip -Force" -WindowStyle Hidden -Wait

	# �J�����g�f�B���N�g���� iftwebp11 �f�B���N�g���ɕύX
	Set-Location iftwebp11

	# AviUtl\readme ���� iftwebp �f�B���N�g�����쐬 (�ҋ@)
	Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\iftwebp`" -ItemType Directory -Force" -WindowStyle Hidden -Wait

	# AviUtl �f�B���N�g������ iftwebp.spi ���AAviUtl\readme\iftwebp ���� iftwebp.txt �����ꂼ��ړ�
	Move-Item iftwebp.spi $aviutlExeDirectory -Force
	Move-Item iftwebp.txt "${ReadmeDirectoryRoot}\iftwebp" -Force

	# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
	Set-Location ..
}

Write-Host "����"
Write-Host -NoNewline "`r`nifheif�̍ŐV�ŏ����擾���Ă��܂�..."

# ifheif�̍ŐV�ł̃_�E�����[�hURL���擾
$ifheifUrl = GithubLatestReleaseUrl "Mr-Ojii/ifheif"

Write-Host "����"
Write-Host -NoNewline "ifheif���_�E�����[�h���Ă��܂�..."

# ifheif��zip�t�@�C�����_�E�����[�h (�ҋ@)
Start-Process -FilePath curl.exe -ArgumentList "-OL $ifheifUrl" -WindowStyle Hidden -Wait

Write-Host "����"
Write-Host -NoNewline "ifheif���C���X�g�[�����Ă��܂�..."

# AviUtl\license\ifheif ���� Licenses �f�B���N�g��������΍폜���� (�G���[�̖h�~)
if (Test-Path "${LicenseDirectoryRoot}\ifheif\Licenses") {
	Remove-Item "${LicenseDirectoryRoot}\ifheif\Licenses" -Recurse
}

# ifheif��zip�t�@�C����W�J (�ҋ@)
Start-Process powershell -ArgumentList "-command Expand-Archive -Path ifheif.zip -Force" -WindowStyle Hidden -Wait

# �J�����g�f�B���N�g����ifheif��zip�t�@�C����W�J�����f�B���N�g���ɕύX
Set-Location "ifheif"

# AviUtl\readme, AviUtl\license ���� ifheif �f�B���N�g�����쐬 (�ҋ@)
Start-Process powershell -ArgumentList "-command New-Item `"${ReadmeDirectoryRoot}\ifheif`", `"${LicenseDirectoryRoot}\ifheif`" -ItemType Directory -Force" -WindowStyle Hidden -Wait

# AviUtl �f�B���N�g������ ifheif.spi ���AAviUtl\license\ifheif ���� LICENSE �� Licenses �f�B���N�g�����A
# AviUtl\readme\ifheif ���� Readme.md �����ꂼ��ړ�
Move-Item ifheif.spi $aviutlExeDirectory -Force
Move-Item "LICENS*" "${LicenseDirectoryRoot}\ifheif" -Force
Move-Item Readme.md "${ReadmeDirectoryRoot}\ifheif" -Force

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location ..

Write-Host "����"
Write-Host -NoNewline "`r`nVisual C++ �ĔЕz�\�p�b�P�[�W���m�F���Ă��܂�..."

# ���W�X�g������f�X�N�g�b�v�A�v���̈ꗗ���擾����
$installedApps = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
								  'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
								  'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue |
Where-Object { $_.DisplayName -and $_.UninstallString -and -not $_.SystemComponent -and ($_.ReleaseType -notin 'Update','Hotfix') -and -not $_.ParentKeyName } |
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
	Start-Process curl.exe -ArgumentList "-OL https://aka.ms/vs/17/release/vc_redist.x86.exe" -WindowStyle Hidden -Wait

	Write-Host "����"
	Write-Host "Microsoft Visual C++ 2015-20xx Redistributable (x86) �̃C���X�g�[�����s���܂��B"
	Write-Host "�f�o�C�X�ւ̕ύX���K�v�ɂȂ�܂��B���[�U�[�A�J�E���g����̃|�b�v�A�b�v���o���� [�͂�] �������ċ����Ă��������B`r`n"

	# Visual C++ 2015-20xx Redistributable (x86) �̃C���X�g�[���[�����s (�ҋ@)
		# �����C���X�g�[���I�v�V������ǉ� by Atolycs (20250106)
	Start-Process -FilePath vc_redist.x86.exe -ArgumentList "/install /passive" -WindowStyle Hidden -Wait

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
			Start-Process curl.exe -ArgumentList "-OL https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe" -WindowStyle Hidden -Wait

			Write-Host "����"
			Write-Host "Microsoft Visual C++ 2008 Redistributable - x86 �̃C���X�g�[�����s���܂��B"
			Write-Host "�f�o�C�X�ւ̕ύX���K�v�ɂȂ�܂��B���[�U�[�A�J�E���g����̃|�b�v�A�b�v���o���� [�͂�] �������ċ����Ă��������B`r`n"

			# Visual C++ 2008 Redistributable - x86 �̃C���X�g�[���[�����s (�ҋ@)
				# �����C���X�g�[���I�v�V������ǉ� by Atolycs (20250106)
			Start-Process -FilePath vcredist_x86.exe -ArgumentList "/qb" -WindowStyle Hidden -Wait

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
	Start-Process curl.exe -ArgumentList "-OL https://aka.ms/vs/17/release/vc_redist.x86.exe" -WindowStyle Hidden -Wait

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
			Start-Process curl.exe -ArgumentList "-OL https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe" -WindowStyle Hidden -Wait

			Write-Host "����"
			Write-Host "`r`nMicrosoft Visual C++ 2015-20xx Redistributable (x86) ��`r`nMicrosoft Visual C++ 2008 Redistributable - x86 �̃C���X�g�[�����s���܂��B"
			Write-Host "�f�o�C�X�ւ̕ύX���K�v�ɂȂ�܂��B���[�U�[�A�J�E���g����̃|�b�v�A�b�v���o���� [�͂�] �������ċ����Ă��������B`r`n"

			# VCruntimeInstall2015and2008.cmd �̑��݂���f�B���N�g�����m�F
				# VCruntimeInstall2015and2008.cmd �� Visual C++ 2015-20xx Redistributable (x86) ��
				# Visual C++ 2008 Redistributable - x86 �̃C���X�g�[���[�����ԂɎ��s���Ă��������̃X�N���v�g
			$VCruntimeInstallCmdDirectory = Join-Path -Path $scriptFileRoot -ChildPath script_files
			$VCruntimeInstallCmdPath = Join-Path -Path $VCruntimeInstallCmdDirectory -ChildPath 'VCruntimeInstall2015and2008.cmd'
			if (!(Test-Path $VCruntimeInstallCmdPath)) {
				$VCruntimeInstallCmdDirectory = $scriptFileRoot
			}

			Start-Sleep -Milliseconds 500

			# VCruntimeInstall2015and2008.cmd ���Ǘ��Ҍ����Ŏ��s (�ҋ@)
			Start-Process -FilePath cmd.exe -ArgumentList "/C cd $VCruntimeInstallCmdDirectory & call VCruntimeInstall2015and2008.cmd & exit" -Verb RunAs -WindowStyle Hidden -Wait

			Write-Host "�C���X�g�[���[���I�����܂����B"
			break
		}
		1 {
			Write-Host "Microsoft Visual C++ 2015-20xx Redistributable (x86) �̃C���X�g�[�����s���܂��B"
			Write-Host "�f�o�C�X�ւ̕ύX���K�v�ɂȂ�܂��B���[�U�[�A�J�E���g����̃|�b�v�A�b�v���o���� [�͂�] �������ċ����Ă��������B`r`n"

			# Visual C++ 2015-20xx Redistributable (x86) �̃C���X�g�[���[�����s (�ҋ@)
				# �����C���X�g�[���I�v�V������ǉ� by Atolycs (20250106)
			Start-Process -FilePath vc_redist.x86.exe -ArgumentList "/install /passive" -WindowStyle Hidden -Wait

			Write-Host "�C���X�g�[���[���I�����܂����B"
			Write-Host "`r`nMicrosoft Visual C++ 2008 Redistributable - x86 �̃C���X�g�[�����X�L�b�v���܂����B"
			break
		}
	}

	# �I�������܂�
}

Write-Host -NoNewline "`r`n�X�V�Ɏg�p�����s�v�ȃt�@�C�����폜���Ă��܂�..."

# �J�����g�f�B���N�g�����X�N���v�g�t�@�C���̂���f�B���N�g���ɕύX
Set-Location ..

# tmp �f�B���N�g�����폜
Remove-Item tmp -Recurse

Write-Host "����"

# ���[�U�[�̑����҂��ďI��
Write-Host -NoNewline "`r`n`r`n`r`n�X�V���������܂����I`r`n`r`n`r`nreadme�t�H���_���J����"
Pause

# �I������readme�t�H���_��\��
Invoke-Item $ReadmeDirectoryRoot