param(
    [string]$OutputDir = "_bmad-output/test-artifacts/template-e2e",
    [switch]$FailOnCritical
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$outputPath = Join-Path $repoRoot $OutputDir
$specDir = Join-Path $repoRoot "tests/template-e2e"

New-Item -ItemType Directory -Force -Path $outputPath | Out-Null

function New-Result {
    param(
        [string]$Id,
        [string]$Name,
        [string]$Severity,
        [bool]$Pass,
        [string]$Message,
        [string[]]$Evidence
    )
    [ordered]@{
        id            = $Id
        name          = $Name
        severity      = $Severity
        status        = if ($Pass) { "PASS" } else { "FAIL" }
        message       = $Message
        evidence_path = $Evidence
    }
}

function Has-Pattern {
    param(
        [string]$Path,
        [string]$Pattern
    )
    if (-not (Test-Path $Path)) { return $false }
    return [bool](Select-String -Path $Path -Pattern $Pattern -SimpleMatch -Quiet)
}

$results = @()

# Scenario spec presence check (bootstrap guard)
$requiredSpecs = @(
    "dispatch-loop.spec.md",
    "agent-contracts.spec.md",
    "sdd-gates.spec.md",
    "recovery-fallback.spec.md",
    "docs-integrity.spec.md"
) | ForEach-Object { Join-Path $specDir $_ }

$missingSpecs = @($requiredSpecs | Where-Object { -not (Test-Path $_) })
$specMessage = if ($missingSpecs.Count -eq 0) { "All scenario spec files are present." } else { "Missing scenario specs: $($missingSpecs -join ', ')" }
$results += New-Result `
    -Id "E2E-TPL-000" `
    -Name "Scenario Specs Present" `
    -Severity "Critical" `
    -Pass ($missingSpecs.Count -eq 0) `
    -Message $specMessage `
    -Evidence @($specDir)

# E2E-TPL-001 Dispatch loop invariants
$claudePath = Join-Path $repoRoot "CLAUDE.md"
$dispatchChecks = @(
    "### 1. Read Current State",
    "### 2. Select Next Task",
    "### 3. Match Agent",
    "### 4. Classify Complexity & Select Model",
    "### 5. Dispatch",
    "### 6. Process Result",
    "NEEDS_RESPEC"
)
$missingDispatch = @($dispatchChecks | Where-Object { -not (Has-Pattern -Path $claudePath -Pattern $_) })
$dispatchMessage = if ((Test-Path $claudePath) -and $missingDispatch.Count -eq 0) { "Dispatch loop invariants present." } else { "Missing dispatch invariants: $($missingDispatch -join '; ')" }
$results += New-Result `
    -Id "E2E-TPL-001" `
    -Name "Dispatch Loop Invariants" `
    -Severity "Critical" `
    -Pass ((Test-Path $claudePath) -and $missingDispatch.Count -eq 0) `
    -Message $dispatchMessage `
    -Evidence @($claudePath)

# E2E-TPL-002 Agent contracts
$requiredAgents = @(
    "researcher.md",
    "planner.md",
    "architect.md",
    "implementer.md",
    "reviewer.md",
    "tester.md"
) | ForEach-Object { Join-Path $repoRoot ".claude/agents/$_" }

$missingAgents = @($requiredAgents | Where-Object { -not (Test-Path $_) })
$frontmatterGaps = @()
foreach ($agent in $requiredAgents) {
    if (-not (Test-Path $agent)) { continue }
    $content = Get-Content -Path $agent -Raw
    foreach ($field in @("name:", "model:", "description:", "tools:")) {
        if ($content -notmatch [regex]::Escape($field)) {
            $frontmatterGaps += "$agent missing '$field'"
        }
    }
}
$agentMessage = if ($missingAgents.Count -eq 0 -and $frontmatterGaps.Count -eq 0) { "Required agents and frontmatter keys are present." } else { "Agent contract issues: $($missingAgents + $frontmatterGaps -join '; ')" }
$results += New-Result `
    -Id "E2E-TPL-002" `
    -Name "Agent Contract Integrity" `
    -Severity "Critical" `
    -Pass ($missingAgents.Count -eq 0 -and $frontmatterGaps.Count -eq 0) `
    -Message $agentMessage `
    -Evidence @((Join-Path $repoRoot ".claude/agents"))

# E2E-TPL-003 SDD governance and gate signals
$specProtocolPath = Join-Path $repoRoot ".claude/skills/spec-protocol.md"
$sddMissing = @()
foreach ($needle in @("Controlled Vocabulary", "Assertion Quality Gate")) {
    if (-not (Has-Pattern -Path $specProtocolPath -Pattern $needle)) {
        $sddMissing += "spec-protocol missing '$needle'"
    }
}
foreach ($needle in @("spec-protocol.md", "spec_tier")) {
    if (-not (Has-Pattern -Path $claudePath -Pattern $needle)) {
        $sddMissing += "CLAUDE.md missing '$needle'"
    }
}
$sddMessage = if ((Test-Path $specProtocolPath) -and $sddMissing.Count -eq 0) { "SDD governance signals are present." } else { "SDD signal gaps: $($sddMissing -join '; ')" }
$results += New-Result `
    -Id "E2E-TPL-003" `
    -Name "SDD Governance and Gate Signals" `
    -Severity "High" `
    -Pass ((Test-Path $specProtocolPath) -and $sddMissing.Count -eq 0) `
    -Message $sddMessage `
    -Evidence @($specProtocolPath, $claudePath)

# E2E-TPL-004 Recovery and fallback signals
$recoveryMissing = @()
foreach ($needle in @("mark BLOCKED", "NEEDS_RESPEC")) {
    if (-not (Has-Pattern -Path $claudePath -Pattern $needle)) {
        $recoveryMissing += "CLAUDE.md missing '$needle'"
    }
}
foreach ($needle in @("fails to parse", "Git recovery", "feature-tracker.json")) {
    if (-not (Has-Pattern -Path $specProtocolPath -Pattern $needle)) {
        $recoveryMissing += "spec-protocol missing '$needle'"
    }
}
$recoveryMessage = if ($recoveryMissing.Count -eq 0) { "Recovery and fallback guidance is present." } else { "Recovery signal gaps: $($recoveryMissing -join '; ')" }
$results += New-Result `
    -Id "E2E-TPL-004" `
    -Name "Recovery and Fallback Signals" `
    -Severity "High" `
    -Pass ($recoveryMissing.Count -eq 0) `
    -Message $recoveryMessage `
    -Evidence @($claudePath, $specProtocolPath)

# E2E-TPL-005 Docs integrity (Path A)
$docsReadme = Join-Path $repoRoot "docs/e2e/README.md"
$pathAChecklist = Join-Path $repoRoot "docs/e2e/path-a-bootstrap-checklist.md"
$docsMissing = @()
if (-not (Has-Pattern -Path $docsReadme -Pattern "Selected approach: Path A")) {
    $docsMissing += "docs/e2e/README.md missing Path A marker"
}
foreach ($doc in @(
    "docs/e2e/sut-definition.md",
    "docs/e2e/test-environments.md",
    "docs/e2e/traceability-matrix.md",
    "docs/e2e/selector-strategy.md",
    "docs/e2e/api-assertion-catalog.md",
    "docs/e2e/test-data-lifecycle.md",
    "docs/e2e/ci-quality-gates.md",
    "docs/e2e/flakiness-policy.md",
    "docs/e2e/failure-observability.md",
    "docs/e2e/parallelization-runtime-budget.md",
    "docs/e2e/path-a-bootstrap-checklist.md"
)) {
    $path = Join-Path $repoRoot $doc
    if (-not (Test-Path $path)) {
        $docsMissing += "Missing $doc"
    }
}
$docsMessage = if ($docsMissing.Count -eq 0) { "Path A docs are present and linked." } else { "Docs integrity gaps: $($docsMissing -join '; ')" }
$results += New-Result `
    -Id "E2E-TPL-005" `
    -Name "Documentation Integrity (Path A)" `
    -Severity "Medium" `
    -Pass ((Test-Path $docsReadme) -and (Test-Path $pathAChecklist) -and $docsMissing.Count -eq 0) `
    -Message $docsMessage `
    -Evidence @($docsReadme, $pathAChecklist)

$total = $results.Count
$passed = @($results | Where-Object { $_.status -eq "PASS" }).Count
$failed = $total - $passed
$criticalFailed = @($results | Where-Object { $_.severity -eq "Critical" -and $_.status -eq "FAIL" }).Count

$report = [ordered]@{
    suite        = "template-e2e"
    generated_at = (Get-Date).ToString("s")
    summary      = [ordered]@{
        total            = $total
        passed           = $passed
        failed           = $failed
        critical_failed  = $criticalFailed
    }
    cases        = $results
}

$jsonPath = Join-Path $outputPath "template-e2e-report.json"
$mdPath = Join-Path $outputPath "template-e2e-report.md"

$report | ConvertTo-Json -Depth 8 | Set-Content -Path $jsonPath -Encoding UTF8

$md = @(
    "# Template E2E Report",
    "",
    "- Generated: $($report.generated_at)",
    "- Total: $total",
    "- Passed: $passed",
    "- Failed: $failed",
    "- Critical Failed: $criticalFailed",
    "",
    "| ID | Name | Severity | Status | Message |",
    "| --- | --- | --- | --- | --- |"
)
foreach ($r in $results) {
    $md += "| $($r.id) | $($r.name) | $($r.severity) | $($r.status) | $($r.message) |"
}
$md += ""
$md += "Machine-readable report: $jsonPath"
$md | Set-Content -Path $mdPath -Encoding UTF8

Write-Host "Template E2E report written:"
Write-Host "- $jsonPath"
Write-Host "- $mdPath"

if ($FailOnCritical -and $criticalFailed -gt 0) {
    Write-Error "Critical template E2E checks failed: $criticalFailed"
    exit 1
}

exit 0
