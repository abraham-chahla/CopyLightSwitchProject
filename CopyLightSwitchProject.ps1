# =================================================================
# Script to copy and rename a LsCoreProject file
# Should also work for any other LS Project with a few minor edits
# =================================================================

# Source solution location
$sourceLocation = "c:\temp\LsCoreProject-master\LsCoreProject"

# Target solution location
$targetLocation = 'c:\Users\Dale\Documents\Visual Studio 2013\Projects\LsCore'

# What is the original solution name
$origSolutionName = "LsCoreProject"

# What is the new solution name
$newSolutionName = Read-Host -Prompt "New Solution Name?"
$newSolutionFolder = $targetLocation + "\" + $newSolutionName

# Copy the Source to the Target folder
Copy-Item $sourceLocation $newSolutionFolder -Recurse

# Make sure we don't move forward until the folder has been created
while (!(Test-Path $newSolutionFolder))
     {
     Start-Sleep -s 1
     }

# Change to the target location
cd $newSolutionFolder

# Get all the files that match our orig solution name
$files = Get-ChildItem $(get-location) -filter *$origSolutionName* -Recurse

# Change the folder and filenames to the new solution name
$files |
    Sort-Object -Descending -Property { $_.FullName } |
    Rename-Item -newname { $_.name -replace $origSolutionName, $newSolutionName } -force

# Get all the files that has our original name in its body
$files = Get-ChildItem -recurse | Select-String -pattern $origSolutionName | group path | select name

# Loop over all the matching files, replace original with new
foreach($file in $files) 
{ 
	# Replace all the name occurances, save back to original file
	((Get-Content $file.Name) -creplace $origSolutionName, $newSolutionName) | set-content $file.Name 
}

# Acknowledge to the user that we're done
read-host -prompt "Done! Press any key to close."

