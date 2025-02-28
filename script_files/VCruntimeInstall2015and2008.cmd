@powershell -NoProfile -ExecutionPolicy Unrestricted "$s = [scriptblock]::create((Get-Content \"%~f0\" | Where-Object { $_.readcount -gt 1 }) -join \"`n\"); & $s %~dp0 %*" & goto :eof

# ����ȍ~�͑S��PowerShell�̃X�N���v�g

# Visual C++ 2015-20xx Redistributable (x86) �� Visual C++ 2008 Redistributable - x86 ��
# �C���X�g�[���[�����ԂɎ��s���Ă��������̃X�N���v�g�ł�
# ���̃X�N���v�g����Ǘ��Ҍ����ŌĂяo����邱�Ƃ��z�肳��Ă��܂�

<#!
 #  MIT License
 #
 #  Copyright (c) 2025 menndouyukkuri, atolycs
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
	# �ȉ���1�s�ڂ̏����ɂ���Ď����Œǉ����ꂽ�p�����[�^�[

	# �X�N���v�g�̃t�@�C�������݂���f�B���N�g���̃p�X
	[parameter(mandatory=$true)][string]$scriptFileRoot ,


	# �ȉ��̓o�b�`�t�@�C�����s���ɓn���ꂽ����

	# �Ăяo�����̃X�N���v�g������f�B���N�g���̃p�X (�K�{)
	[parameter(mandatory=$true)][string]$callingScriptRoot
)

# ${callingScriptRoot}\tmp �f�B���N�g�����J�����g�f�B���N�g���Ƃ���
Set-Location "${callingScriptRoot}\tmp"

# Visual C++ 2015-20xx Redistributable (x86) �̃C���X�g�[���[�����s (�ҋ@)
	# �����C���X�g�[���I�v�V������ǉ� by Atolycs (20250106)
Start-Process -FilePath vc_redist.x86.exe -ArgumentList "/install /passive" -WorkingDirectory (Get-Location).Path -Wait

# Visual C++ 2008 Redistributable - x86 �̃C���X�g�[���[�����s (�ҋ@)
	# �����C���X�g�[���I�v�V������ǉ� by Atolycs (20250106)
Start-Process -FilePath vcredist_x86.exe -ArgumentList "/qb" -WorkingDirectory (Get-Location).Path -Wait
