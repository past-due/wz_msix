Param
(
  [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
  [string]
  $IdentityName,
  [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
  [string]
  $IdentityPublisher,
  [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
  [string]
  $PackageDisplayName,
  [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
  [string]
  $PackagePublisherDisplayName
)

############################

function Get-ScriptDirectory
{
	$ScriptRoot = ""

	Try
	{
		$commandPath = Get-Variable -Name PSCommandPath -ValueOnly -ErrorAction Stop
		$ScriptRoot = Split-Path -Parent $commandPath
	}
	Catch
	{
		$scriptInvocation = (Get-Variable MyInvocation -Scope 1).Value
		$ScriptRoot = Split-Path $scriptInvocation.MyCommand.Path
	}

	return $ScriptRoot
}

$ScriptRoot = Get-ScriptDirectory;
Write-Output "ScriptRoot=$($ScriptRoot)"

############################

# Get path to the AppxManifest.xml.in file

$appxmanifest_template_path = $(Join-Path "$($ScriptRoot)" "AppxManifest.xml.in")
If ( -not (Test-Path "$appxmanifest_template_path" ) )
{
	Write-Error "Did not find expected template file: $appxmanifest_template_path"
}
$appxmanifest_output_path = $(Join-Path "$($ScriptRoot)" "AppxManifest.xml")

############################

$appxmanifest_template_content = $(Get-Content "$appxmanifest_template_path")

# Replace the identity name with desired value
$appxmanifest_template_content = $appxmanifest_template_content -replace '@IDENTITY_NAME@', "$IdentityName"

# Replace the identity publisher with desired value
$appxmanifest_template_content = $appxmanifest_template_content -replace '@IDENTITY_PUBLISHER@', "$IdentityPublisher"

# Replace the package displayname with desired value
$appxmanifest_template_content = $appxmanifest_template_content -replace '@PACKAGE_DISPLAYNAME@', "$PackageDisplayName"

# Replace the package publisher displayname with desired value
$appxmanifest_template_content = $appxmanifest_template_content -replace '@PACKAGE_PUBLISHERDISPLAYNAME@', "$PackagePublisherDisplayName"

$appxmanifest_template_content | Set-Content "$appxmanifest_output_path"

Write-Output "AppxManifest.xml created"
