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

# GitHub���|�W�g���̍ŐV�Ń����[�X�̏����擾����
function GithubLatestRelease ($repo) {
	# GitHub��API����ŐV�Ń����[�X�̏����擾����
	$api = Invoke-RestMethod "https://api.github.com/repos/$repo/releases/latest"

	if ($api -eq $null) {
		# null �̏ꍇ�A���b�Z�[�W��\�����ďI��
		Write-Host "`r`n`r`n�G���[: GitHub API����̃f�[�^�̎擾�Ɏ��s���܂����B`r`n`r`nGitHub API�ł͓���IP����̃A�N�Z�X��1���Ԃ�����60��܂łɐ�������Ă��܂��B���΂炭���Ԃ��󂯂čēx���������������B`r`n����ł����s����ꍇ�́A�X�N���v�g�Ƀo�O�����邩�AGitHub�ɉ��炩�̏�Q���������Ă���\��������܂��B`r`n`r`n"
		Pause
		exit
	} else {
		# �ŐV�Ń����[�X�̏���Ԃ�
		return($api)
	}
}
