<#!
 #  MIT License
 #
 #  Copyright (c) 2025 menndouyukkuri
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

# ����������O�Ƀ`�F�b�N���A��肪����ꍇ�͏I�����邩���b�Z�[�W��\������
function CheckOfEnvironment {
	# PowerShell�̃o�[�W�������m�F���A���s�ł��Ȃ��ꍇ�͂����\������
	if ((((Get-Host).Version) -split "\.")[0] -ne "5") {
		Write-Host "For this script to work, PowerShell 5.x needs to launch when `"powershell`" command is executed in Command Prompt."
		Write-Host "���̃X�N���v�g�����삷��ɂ� �R�}���h �v�����v�g �� `"powershell`" �R�}���h�����s�����ۂɁAPowerShell 5.x ���N������K�v������܂��B`r`n"
		Pause
		exit
	}

	# Windows�̃o�[�W�������m�F���A���s�ł��Ȃ��ꍇ�͂����\������
	$WindowsNtCurrentVersion = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
	if ($WindowsNtCurrentVersion.CurrentBuild -lt 17134) {
		Write-Host "���̃X�N���v�g�� Windows 10 April 2018 Update (�o�[�W���� 1803) �ȍ~�ł̂ݓ��삵�܂��B`r`n"

		# �T�|�[�g���I�����Ă���o�[�W������Windows���g�p���Ă��邽�ߌx�����o��
		Write-Host "�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@                    `r`n�@�@�x��: ���̃o�[�W������ Windows �� Microsoft �ɂ��T�|�[�g���I�����Ă��܂��B�@�@�@�@�@�@�@�@�@�@�@`r`n�@�@�@�@  �T�|�[�g���I������ Windows ���g�p��������ƁA�}���E�F�A�Ɋ�������Ȃǂ̔�Q���󂯂�         `r`n�@�@�@�@  �\��������܂��B���₩�ɃT�|�[�g���̃o�[�W�����ւ̍X�V���s���Ă��������B                  `r`n�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@                    `r`n" -BackgroundColor Yellow -ForegroundColor Black
		Pause
		exit

	# �X�N���v�g�͎��s�\�����A�����[�X���_�ŃT�|�[�g���I�����Ă���o�[�W������Windows���g�p���Ă���ꍇ�Ɍx�����o��
	} elseif (($WindowsNtCurrentVersion.CurrentBuild -lt 19045) -or (($WindowsNtCurrentVersion.CurrentBuild -ge 22000) -and ($WindowsNtCurrentVersion.CurrentBuild -lt 22630))) {
		Write-Host "�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@                    `r`n�@�@�x��: ���̃o�[�W������ Windows �� Microsoft �ɂ��T�|�[�g���I�����Ă��܂��B�@�@�@�@�@�@�@�@�@�@�@`r`n�@�@�@�@  �T�|�[�g���I������ Windows ���g�p��������ƁA�}���E�F�A�Ɋ�������Ȃǂ̔�Q���󂯂�         `r`n�@�@�@�@  �\��������܂��B���₩�ɃT�|�[�g���̃o�[�W�����ւ̍X�V���s���Ă��������B                  `r`n�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@                    `r`n" -BackgroundColor Yellow -ForegroundColor Black
	}
}

# GitHub���|�W�g���̍ŐV�Ń����[�X�̏����擾����
function GithubLatestRelease ($repo) {
	# try-catch �� Invoke-RestMethod �̃G���[�𑨂�����悤�ɂ���
	$ErrorActionPreference = "Stop"

	try {
		# GitHub��API����ŐV�Ń����[�X�̏����擾����
		$api = Invoke-RestMethod "https://api.github.com/repos/$repo/releases/latest"
	} catch {
		# $Error[0] �� JSON �`���Ȃ̂� PSObject �ɕϊ�����
		$ErrorJsonObject = ConvertFrom-Json $Error[0]

		# �G���[�\���̋��ʕ�����\��
		Write-Host "`r`n`r`n�G���[: GitHub API����̃f�[�^�̎擾�Ɏ��s���܂����B"

		# API rate limit �Ƃ���ȊO�ɕ�����
		if ($ErrorJsonObject.message.Contains("API rate limit")){
			# API rate limit �̃G���[���b�Z�[�W����IP�A�h���X�����o��
			$ApiRateLimitMessageIpAddress = ((($ErrorJsonObject.message) -split " ")[5]).Trim(".")

			# API rate limit �̃G���[���b�Z�[�W����{��ɒ��������̂�\��
			Write-Host "���e�@: $ApiRateLimitMessageIpAddress �ɑ΂���API���[�g�����𒴂��܂��� (�������ǂ��j���[�X������܂�: �F�؂��ꂽ���N�G�X�g�ɂ͂�荂�����[�g�������K�p����܂��B�ڍׂɂ��Ă̓h�L�������g��������������) �B"
			Write-Host "�@�@�@  Ctrl �L�[�������Ȃ���N���b�N����ƃ����N�悪�\���ł��܂��B`r`n�@�@�@  https://docs.github.com/rest/using-the-rest-api/rate-limits-for-the-rest-api`r`n"

			# ���[�U�[�Ɍ����đΏ��@��\��
			Write-Host "�Ώ��@: GitHub API�ł͓���IP����̃A�N�Z�X��1���Ԃ�����60��܂łɐ�������Ă��܂��B`r`n�@�@�@  ���΂炭���Ԃ��󂯂čēx���s����΁A���Ȃ����s�ł��܂��B`r`n"

		} else {
			# �G���[���b�Z�[�W�̕\��
			Write-Host "���e�@: $($ErrorJsonObject.message)"

			# �h�L�������g��URL������ꍇ�A������\������
			if ($ErrorJsonObject.PSObject.Properties["documentation_url"]) {
				Write-Host "�@�@�@  �ڍׂ͉��L�̃h�L�������g���������������BCtrl �L�[�������Ȃ���N���b�N����ƃ����N�悪�\���ł��܂��B`r`n�@�@�@  $($ErrorJsonObject.documentation_url)"
			}

			Write-Host ""
		}

		# ���[�U�[�̔�����҂��ďI��
		Pause
		exit 1
	}

	# �ŐV�Ń����[�X�̏���Ԃ�
	return($api)
}
