@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

#
#   AviUtl Installer Script (Version 0.9.1_2025-01-03)
#
#
#   MIT License
#
#   Copyright (c) 2025 menndouyukkuri
#
#   Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"), to deal
#   in the Software without restriction, including without limitation the rights
#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in all
#   copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#   SOFTWARE.
#

# GitHub���|�W�g���̍ŐV�Ń����[�X�̃_�E�����[�hURL���擾����
function GithubLatestReleaseUrl ($repo) {
    # GitHub��API����ŐV�Ń����[�X�̏����擾����
    $api = Invoke-RestMethod "https://api.github.com/repos/$repo/releases/latest"

    # �ŐV�Ń����[�X�̃_�E�����[�hURL�݂̂�Ԃ�
    return($api.assets.browser_download_url)
}

Write-Host "AviUtl Installer Script (Version 0.9.1_2025-01-03)`r`n`r`n"
Write-Host -NoNewline "AviUtl���C���X�g�[������t�H���_���쐬���Ă��܂�..."

# C:\Applications �f�B���N�g�����쐬����i�ҋ@�j
Start-Process powershell -ArgumentList "-command New-Item C:\Applications -ItemType Directory -Force" -WindowStyle Minimized -Wait

# C:\Applications\AviUtl �f�B���N�g�����쐬����i�ҋ@�j
Start-Process powershell -ArgumentList "-command New-Item C:\Applications\AviUtl -ItemType Directory -Force" -WindowStyle Minimized -Wait

# AviUtl �f�B���N�g������ plugins, script, license, readme ��4�̃f�B���N�g�����쐬����i�ҋ@�j
Start-Process powershell -ArgumentList "-command New-Item C:\Applications\AviUtl\plugins, C:\Applications\AviUtl\script, C:\Applications\AviUtl\license, C:\Applications\AviUtl\readme -ItemType Directory -Force" -WindowStyle Minimized -Wait

# tmp �f�B���N�g�����쐬����i�ҋ@�j
Start-Process powershell -ArgumentList "-command New-Item tmp -ItemType Directory -Force" -WindowStyle Minimized -Wait

Write-Host "����"
Write-Host -NoNewline "`r`n�ꎞ�I�Ƀt�@�C����ۊǂ���t�H���_���쐬���Ă��܂�..."

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location tmp

Write-Host "����"
Write-Host -NoNewline "`r`nAviUtl�{�́iversion1.10�j���_�E�����[�h���Ă��܂�..."

# AviUtl 1.10��zip�t�@�C�����_�E�����[�h�i�ҋ@�j
Start-Process curl.exe -ArgumentList "-OL http://spring-fragrance.mints.ne.jp/aviutl/aviutl110.zip" -WindowStyle Minimized -Wait

Write-Host "����"
Write-Host -NoNewline "AviUtl�{�̂��C���X�g�[�����Ă��܂�..."

# AviUtl��zip�t�@�C����W�J�i�ҋ@�j
Start-Process powershell -ArgumentList "-command Expand-Archive -Path aviutl110.zip -Force" -WindowStyle Minimized -Wait

# �J�����g�f�B���N�g���� aviutl110 �f�B���N�g���ɕύX
Set-Location aviutl110

# AviUtl\readme ���� aviutl �f�B���N�g�����쐬�i�ҋ@�j
Start-Process powershell -ArgumentList "-command New-Item C:\Applications\AviUtl\readme\aviutl -ItemType Directory -Force" -WindowStyle Minimized -Wait

# AviUtl �f�B���N�g������ aviutl.exe ���AAviUtl\readme\aviutl ���� aviutl.txt �����ꂼ��ړ�
Move-Item aviutl.exe C:\Applications\AviUtl -Force
Move-Item aviutl.txt C:\Applications\AviUtl\readme\aviutl -Force

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location ..

Write-Host "����"
Write-Host -NoNewline "`r`n�g���ҏWPlugin version0.92���_�E�����[�h���Ă��܂�..."

# �g���ҏWPlugin 0.92��zip�t�@�C�����_�E�����[�h�i�ҋ@�j
Start-Process curl.exe -ArgumentList "-OL http://spring-fragrance.mints.ne.jp/aviutl/exedit92.zip" -WindowStyle Minimized -Wait

Write-Host "����"
Write-Host -NoNewline "�g���ҏWPlugin���C���X�g�[�����Ă��܂�..."

# �g���ҏWPlugin��zip�t�@�C����W�J�i�ҋ@�j
Start-Process powershell -ArgumentList "-command Expand-Archive -Path exedit92.zip -Force" -WindowStyle Minimized -Wait

# �J�����g�f�B���N�g���� exedit92 �f�B���N�g���ɕύX
Set-Location exedit92

# AviUtl\readme ���� exedit �f�B���N�g�����쐬�i�ҋ@�j
Start-Process powershell -ArgumentList "-command New-Item C:\Applications\AviUtl\readme\exedit -ItemType Directory -Force" -WindowStyle Minimized -Wait

# exedit.ini �͎g�p�����A�����̌�̏����Ŏז��ɂȂ�̂ō폜����i�ҋ@�j
Start-Process powershell -ArgumentList "-command Remove-Item exedit.ini" -WindowStyle Minimized -Wait

# AviUtl\readme\exedit ���� exedit.txt, lua.txt ���i�ҋ@�j�AAviUtl �f�B���N�g�����ɂ��̑��̃t�@�C�������ꂼ��ړ�
Start-Process powershell -ArgumentList "-command Move-Item *.txt C:\Applications\AviUtl\readme\exedit -Force" -WindowStyle Minimized -Wait
Move-Item * C:\Applications\AviUtl -Force

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location ..

Write-Host "����"
Write-Host -NoNewline "`r`npatch.aul�i�䂳���ȃt�H�[�N�Łj�̍ŐV�ŏ����擾���Ă��܂�..."

# patch.aul�i�䂳���ȃt�H�[�N�Łj�̍ŐV�ł̃_�E�����[�hURL���擾
$patchAulUrl = GithubLatestReleaseUrl "nazonoSAUNA/patch.aul"

Write-Host "����"
Write-Host -NoNewline "patch.aul�i�䂳���ȃt�H�[�N�Łj���_�E�����[�h���Ă��܂�..."

# patch.aul�i�䂳���ȃt�H�[�N�Łj��zip�t�@�C�����_�E�����[�h�i�ҋ@�j
Start-Process curl.exe -ArgumentList "-OL $patchAulUrl" -WindowStyle Minimized -Wait

Write-Host "����"
Write-Host -NoNewline "patch.aul�i�䂳���ȃt�H�[�N�Łj���C���X�g�[�����Ă��܂�..."

# patch.aul��zip�t�@�C����W�J�i�ҋ@�j
Start-Process powershell -ArgumentList "-command Expand-Archive -Path patch.aul_*.zip -Force" -WindowStyle Minimized -Wait

# �J�����g�f�B���N�g����patch.aul��zip�t�@�C����W�J�����f�B���N�g���ɕύX
Set-Location "patch.aul_*"

# AviUtl\license ���� patch-aul �f�B���N�g�����쐬�i�ҋ@�j
Start-Process powershell -ArgumentList "-command New-Item C:\Applications\AviUtl\license\patch-aul -ItemType Directory -Force" -WindowStyle Minimized -Wait

# AviUtl �f�B���N�g������ patch.aul ���i�ҋ@�j�AAviUtl\license\patch-aul ���ɂ��̑��̃t�@�C�������ꂼ��ړ�
Start-Process powershell -ArgumentList "-command Move-Item patch.aul C:\Applications\AviUtl -Force" -WindowStyle Minimized -Wait
Move-Item * C:\Applications\AviUtl\license\patch-aul -Force

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location ..

Write-Host "����"
Write-Host -NoNewline "`r`nL-SMASH Works�iMr-Ojii�Łj�̍ŐV�ŏ����擾���Ă��܂�..."

# L-SMASH Works�iMr-Ojii�Łj�̍ŐV�ł̃_�E�����[�hURL���擾
$lSmashWorksAllUrl = GithubLatestReleaseUrl "Mr-Ojii/L-SMASH-Works-Auto-Builds"

# �������钆����AviUtl�p�̂��̂̂ݎc��
$lSmashWorksUrl = $lSmashWorksAllUrl | Where-Object {$_ -like "*Mr-Ojii_vimeo*"}

Write-Host "����"
Write-Host -NoNewline "L-SMASH Works�iMr-Ojii�Łj���_�E�����[�h���Ă��܂�..."

# L-SMASH Works�iMr-Ojii�Łj��zip�t�@�C�����_�E�����[�h�i�ҋ@�j
Start-Process curl.exe -ArgumentList "-OL $lSmashWorksUrl" -WindowStyle Minimized -Wait

Write-Host "����"
Write-Host -NoNewline "L-SMASH Works�iMr-Ojii�Łj���C���X�g�[�����Ă��܂�..."

# L-SMASH Works��zip�t�@�C����W�J�i�ҋ@�j
Start-Process powershell -ArgumentList "-command Expand-Archive -Path L-SMASH-Works_*.zip -Force" -WindowStyle Minimized -Wait

# �J�����g�f�B���N�g����L-SMASH Works��zip�t�@�C����W�J�����f�B���N�g���ɕύX
Set-Location "L-SMASH-Works_*"

# AviUtl\readme, AviUtl\license ���� l-smash_works �f�B���N�g�����쐬�i�ҋ@�j
Start-Process powershell -ArgumentList "-command New-Item C:\Applications\AviUtl\readme\l-smash_works, C:\Applications\AviUtl\license\l-smash_works -ItemType Directory -Force" -WindowStyle Minimized -Wait

# AviUtl\plugins �f�B���N�g������ lw*.au* ���AAviUtl\readme\l-smash_works ���� READM* ���i�ҋ@�j�A
# AviUtl\license\l-smash_works ���ɂ��̑��̃t�@�C�������ꂼ��ړ�
Start-Process powershell -ArgumentList "-command Move-Item lw*.au* C:\Applications\AviUtl\plugins -Force; Move-Item READM* C:\Applications\AviUtl\readme\l-smash_works -Force" -WindowStyle Minimized -Wait
Move-Item * C:\Applications\AviUtl\license\l-smash_works -Force

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location ..

Write-Host "����"
Write-Host -NoNewline "`r`nInputPipePlugin�̍ŐV�ŏ����擾���Ă��܂�..."

# InputPipePlugin�̍ŐV�ł̃_�E�����[�hURL���擾
$InputPipePluginUrl = GithubLatestReleaseUrl "amate/InputPipePlugin"

Write-Host "����"
Write-Host -NoNewline "InputPipePlugin���_�E�����[�h���Ă��܂�..."

# InputPipePlugin��zip�t�@�C�����_�E�����[�h�i�ҋ@�j
Start-Process curl.exe -ArgumentList "-OL $InputPipePluginUrl" -WindowStyle Minimized -Wait

Write-Host "����"
Write-Host -NoNewline "InputPipePlugin���C���X�g�[�����Ă��܂�..."

# InputPipePlugin��zip�t�@�C����W�J�i�ҋ@�j
Start-Process powershell -ArgumentList "-command Expand-Archive -Path InputPipePlugin_*.zip -Force" -WindowStyle Minimized -Wait

# �J�����g�f�B���N�g����InputPipePlugin��zip�t�@�C����W�J�����f�B���N�g���ɕύX
Set-Location "InputPipePlugin_*\InputPipePlugin"

# AviUtl\readme, AviUtl\license ���� inputPipePlugin �f�B���N�g�����쐬�i�ҋ@�j
Start-Process powershell -ArgumentList "-command New-Item C:\Applications\AviUtl\readme\inputPipePlugin, C:\Applications\AviUtl\license\inputPipePlugin -ItemType Directory -Force" -WindowStyle Minimized -Wait

# AviUtl\license\inputPipePlugin ���� LICENSE ���AAviUtl\readme\inputPipePlugin ���� Readme.md ���i�ҋ@�j�A
# AviUtl\plugins �f�B���N�g�����ɂ��̑��̃t�@�C�������ꂼ��ړ�
Start-Process powershell -ArgumentList "-command Move-Item LICENSE C:\Applications\AviUtl\license\inputPipePlugin -Force; Move-Item Readme.md C:\Applications\AviUtl\readme\inputPipePlugin -Force" -WindowStyle Minimized -Wait
Move-Item * C:\Applications\AviUtl\plugins -Force

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location ..\..

Write-Host "����"
Write-Host -NoNewline "`r`nx264guiEx�̍ŐV�ŏ����擾���Ă��܂�..."

# x264guiEx�̍ŐV�ł̃_�E�����[�hURL���擾
$x264guiExUrl = GithubLatestReleaseUrl "rigaya/x264guiEx"

Write-Host "����"
Write-Host -NoNewline "x264guiEx���_�E�����[�h���Ă��܂�..."

# x264guiEx��zip�t�@�C�����_�E�����[�h�i�ҋ@�j
Start-Process curl.exe -ArgumentList "-OL $x264guiExUrl" -WindowStyle Minimized -Wait

Write-Host "����"
Write-Host -NoNewline "x264guiEx���C���X�g�[�����Ă��܂�..."

# x264guiEx��zip�t�@�C����W�J�i�ҋ@�j
Start-Process powershell -ArgumentList "-command Expand-Archive -Path x264guiEx_*.zip -Force" -WindowStyle Minimized -Wait

# �J�����g�f�B���N�g����x264guiEx��zip�t�@�C����W�J�����f�B���N�g���ɕύX
Set-Location "x264guiEx_*\x264guiEx_*"

# AviUtl\readme ���� x264guiEx �f�B���N�g�����쐬�i�ҋ@�j
Start-Process powershell -ArgumentList "-command New-Item C:\Applications\AviUtl\readme\x264guiEx -ItemType Directory -Force" -WindowStyle Minimized -Wait

# �J�����g�f�B���N�g����x264guiEx��zip�t�@�C����W�J�����f�B���N�g������ plugins �f�B���N�g���ɕύX
Set-Location plugins

# AviUtl\plugins ���Ɍ��݂̃f�B���N�g���̃t�@�C����S�Ĉړ��i�ҋ@�j
Start-Process powershell -ArgumentList "-command Move-Item * C:\Applications\AviUtl\plugins -Force" -WindowStyle Minimized -Wait

# �J�����g�f�B���N�g����x264guiEx��zip�t�@�C����W�J�����f�B���N�g���ɕύX
Set-Location ..

# x264guiEx��zip�t�@�C����W�J�����f�B���N�g�����̋�ɂȂ��� plugins �f�B���N�g���͂��̌�̏����Ŏז��ɂȂ�̂ō폜����i�ҋ@�j
Start-Process powershell -ArgumentList "-command Remove-Item plugins -Recurse" -WindowStyle Minimized -Wait

# AviUtl\readme\x264guiEx ���� x264guiEx_readme.txt ���i�ҋ@�j�AAviUtl �f�B���N�g�����ɂ��̑��̃t�@�C�������ꂼ��ړ�
Start-Process powershell -ArgumentList "-command Move-Item x264guiEx_readme.txt C:\Applications\AviUtl\readme\x264guiEx -Force" -WindowStyle Minimized -Wait
Move-Item * C:\Applications\AviUtl -Force

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location ..\..

Write-Host "����"
Write-Host -NoNewline "`r`n�ݒ�t�@�C�����R�s�[���Ă��܂�..."

# �J�����g�f�B���N�g���� settings �f�B���N�g���ɕύX
Set-Location ..\settings

# AviUtl\plugins ���� lsmash.ini ���AAviUtl ���ɂ��̑��̃t�@�C�����R�s�[
Copy-Item lsmash.ini C:\Applications\AviUtl\plugins
Copy-Item aviutl.ini C:\Applications\AviUtl
Copy-Item exedit.ini C:\Applications\AviUtl
Copy-Item �f�t�H���g.cfg C:\Applications\AviUtl

# �J�����g�f�B���N�g���� tmp �f�B���N�g���ɕύX
Set-Location ..\tmp

Write-Host "����"
Write-Host -NoNewline "`r`n�f�X�N�g�b�v�ɃV���[�g�J�b�g�t�@�C�����쐬���Ă��܂�..."

# WSH��p���ăf�X�N�g�b�v��AviUtl�̃V���[�g�J�b�g���쐬����
$ShortcutFolder = [Environment]::GetFolderPath("Desktop")
$ShortcutFile = Join-Path -Path $ShortcutFolder -ChildPath "AviUtl.lnk"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = "C:\Applications\AviUtl\aviutl.exe"
$Shortcut.IconLocation = "C:\Applications\AviUtl\aviutl.exe,0"
$Shortcut.WorkingDirectory = "."
$Shortcut.Save()

Write-Host "����"
Write-Host -NoNewline "�X�^�[�g���j���[�ɃV���[�g�J�b�g�t�@�C�����쐬���Ă��܂�..."

# WSH��p���ăX�^�[�g���j���[��AviUtl�̃V���[�g�J�b�g���쐬����
$ShortcutFolder = [Environment]::GetFolderPath("Programs")
$ShortcutFile = Join-Path -Path $ShortcutFolder -ChildPath "AviUtl.lnk"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = "C:\Applications\AviUtl\aviutl.exe"
$Shortcut.IconLocation = "C:\Applications\AviUtl\aviutl.exe,0"
$Shortcut.WorkingDirectory = "."
$Shortcut.Save()

Write-Host "����"
Write-Host -NoNewline "`r`n�C���X�g�[���Ɏg�p�����s�v�ȃt�@�C�����폜���Ă��܂�..."

# �J�����g�f�B���N�g�����X�N���v�g�t�@�C���̂���f�B���N�g���ɕύX
Set-Location ..

# tmp �f�B���N�g�����폜
Remove-Item tmp -Recurse

Write-Host "����"

# ���[�U�[�̑����҂��ďI��
Write-Host -NoNewline "`r`n`r`n`r`n�C���X�g�[�����������܂����I`r`n`r`n`r`nreadme�t�H���_���J����"
Pause

# �I������readme�t�H���_��\��
Invoke-Item "C:\Applications\AviUtl\readme"