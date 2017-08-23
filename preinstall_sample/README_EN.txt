* README_EN.txt
* 2017.08.24
* preinstall_sample

1. DESCRIPTION
2. REPOSITORIES
3. SETUP CATALOG CONTENT DESCRIPTION
4. AUTHOR EMAIL

-------------------------------------------------------------------------------
1. DESCRIPTION
-------------------------------------------------------------------------------
Initial sample of setup catalog with the preinstall tools. The catalog is a
result of a build set of related projects including main setup project, where
all projects linked to the NsisSetupLib libraries.

The latest version is here: sf.net/p/nsisplus

WARNING:
  Use the SVN access to find out new functionality and bug fixes:
    https://svn.code.sf.net/p/nsisplus/NsisSetupSamples/trunk

-------------------------------------------------------------------------------
2. REPOSITORIES
-------------------------------------------------------------------------------
Primary:
  * https://svn.code.sf.net/p/nsisplus/NsisSetupSamples/trunk
Secondary:
  * https://github.com/andry81/nsisplus--NsisSetupSamples.git

-------------------------------------------------------------------------------
3. SETUP CATALOG CONTENT DESCRIPTION
-------------------------------------------------------------------------------
<root>
 |
 +- "ApplicationA" - The ApplicationA (main application) setup files, platform
 |   |               "independent".
 |   |
 |   +- "ApplicationA.7z" - The application files extracted to separate archive
 |   |               and stored as is.
 |   |
 |   +- "SetupApplicationA.exe.dat" - The generated setup for the ApplicationX.
 |   |               The file renamed into the .dat extension to block a
 |   |               direct execution until the preinstall that will rename it.
 |   |
 |   +- "setup.ini" - Setup configuration for the ApplicationA generated setup
 |                   to store selected by the preinstall values for the
 |                   TARGET_NAME and APP_TARGET_NAME variables.
 |                   The TARGET_NAME basically stores a name of logical target,
 |                   where several targets can point one physical target or not
 |                   point anything at all (default target).
 |                   The APP_TARGET_NAME basically stores a name of physical
 |                   target which must be associated to the binaries in the
 |                   file system or can be absent (default target).
 |
 +- "ApplicationX_v5" - The ApplicationX setup files of version 5 for
 |   |               predefined set of platforms built for these platforms
 |   |               in the time matter.
 |   |
 |   +- "ApplicationX_v5_PlatformA.7z" - The application files of version 5 for
 |   |               the PlatformA extracted to separate archive and stored as
 |   |               is.
 |   |
 |   +- "SetupApplicationX_v5_PlatformA.exe.dat" - The generated setup for the
 |   |               ApplicationX of version 5 for the PlatformA.
 |   |               The file renamed into the .dat extension to block a
 |   |               direct execution until the preinstall that will rename it.
 |   |
 |   etc
 |
 +- "ApplicationX_v6" - The ApplicationX setup files of version 6 for
 |   |               predefined set of platforms built for these platforms
 |   |               in the time matter.
 |   |
 |   etc
 |
 +- "preinstall.bat" - The preinstall script to preinstall the setup catalog
 |                   before send it to a customer. Basically use the Tools
 |                   subdirectory to call external tools and asks a user for
 |                   questions to accomplish the preinstall tasks.
 |
 etc

preinstall.bat:

Must be run from local direcotory w/o any arguments

Usually the script asks these set of questions:
1. Select to preinstall a logical target.
2. Select a preinstall scenario to handle.
3. Asks to delete files and folders not related to the selected logical
   target (files related to other logical targets).
4. Asks to delete files and folders not related to the selected scenario to
   handle.
5. Asks to select for delete files and folders from predefined set by groups.
6. Asks to confirm the setup catalog for modifications
   (the operation can be reverted, see the `-revert` flag below).
7. Removes files and folders not related to the selected logical target.
8. Removes files and folders not related to the selected scenario to handle.
9. Removes files and folders from predefined set by groups.
10. Processes all remained "setup.ini" files for change and "*.exe.dat" files
   for the rename.
11. Deletes itself after successful accomplish.

The script can consume these set of flags to change its behaviour.
* -u - only makes the script to update the setup catalog, avoids the script
   self delete.
* -open-temps - opens in Windows Explorer the preinstall revert temporary
   storage there files has been copied in previous preinstalls.
* -remove-all-temps - removes the preinstall revert all teporary storages.
* -revert - calls the preinstall to revert. The preinstall revert temporary
   storage must exist and not be empty, otherwise the script prints an error
   message and exits immediately. You have to select the directory with date
   and time in it's name representing the time when the preinstall has been
   executed.

The script must run on a clean system without any preinstalled components and
libraries.

-------------------------------------------------------------------------------
4. AUTHOR EMAIL
-------------------------------------------------------------------------------
Andrey Dibrov (andry at inbox dot ru)
