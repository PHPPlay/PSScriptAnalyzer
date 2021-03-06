﻿Import-Module PSScriptAnalyzer
$violationMessage = "Function ’Set-MyObject’ has verb that could change system state. Therefore, the function has to support 'ShouldProcess'"
$violationName = "PSUseShouldProcessForStateChangingFunctions"
$directory = Split-Path -Parent $MyInvocation.MyCommand.Path
$violations = Invoke-ScriptAnalyzer $directory\UseShouldProcessForStateChangingFunctions.ps1 | Where-Object {$_.RuleName -eq $violationName}
$noViolations = Invoke-ScriptAnalyzer $directory\UseShouldProcessForStateChangingFunctionsNoViolations.ps1 | Where-Object {$_.RuleName -eq $violationName}

Describe "It checks UseShouldProcess is enabled when there are state changing verbs in the function names" {
    Context "When there are violations" {
    	$numViolations = 5
        It ("has {0} violations where ShouldProcess is not supported" -f $numViolations) {
            $violations.Count | Should Be $numViolations
        }

        It "has the correct description message" {
            $violations[0].Message | Should Match $violationMessage
        }

	It "has the correct extent" {
	   $violations[0].Extent.Text | Should Be "Set-MyObject"
	}
    }

    Context "When there are no violations" {
        It "returns no violations" {
            $noViolations.Count | Should Be 0
        }
    }
}
