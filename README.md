# Ant Script to Update/Install Eclipse

## Contents


- [Introduction](#introduction)
- [Quick Start](#quick-start)
- [How to Use](#how-to-use)
- [Directory Structure](#directory-structure)
- [What is the Right Way to Update?](#what-is-the-right-way-to-update)
	- [Introduction](#introduction)
	- [Preserving preferences, projects, and plugins](#preserving-preferences-projects-and-plugins)
	- [external-plugin-directory](#external-plugin-directory)
	- [final-thoughts](#final-thoughts)
- [optional-properties](#optional-properties)
- [checkdir-ant-task](#checkdir-ant-task)
	- [Parameters](#parameters)
- [ToDo](#todo)
- [Acknowledgments](#acknowledgments)
- [Introduction](#introduction)


## Introduction
This script started as an effort to simplify updates to a new Eclipse build and, over time, evolved to incorporate some other related activities. The script has seven main targets and eighteen helper targets; the properties file has thirteen properties. All targets and properties are discussed in the following chapters. One feature of the script that I would like to highlight is the ability to restore the previous Eclipse installation; if something gets wrong during an update, your data are not corrupted and your workspace is backed up.
The script requires Apache Ant (version 1.5.1 or later). This script might not work with older versions of Ant as problems were reported with Ant 1.4.1.

Chapters Overview:

The Quick Start is for the users who want to look at the code first and figure it out themselves; code comments could be of some help.
The Directory Structure describes how to organize Eclipse environment.

The What is the Right Way to Update? contains information assembled from different sources related to Eclipse installation and update; there is also a discussion on different approaches to installation and update.

Other chapters have rather descriptive names.



## Quick Start
The build file is conventionally named build.xml; it has seven main targets for users to execute, eighteen helper targets that main targets depend upon, and a default target.

Main targets:

install-eclipse
install-plugins
uninstall-eclipse
uninstall-plugins
backup-workspace
generate-startup-script
uninstall-old-version
The default target is  usage

To restore the previous Eclipse installation execute the install-eclipse target that will update a previous installation if there was one, and create a new installation if there was none; the uninstall-eclipse target will restore previous installation if there was one.

The installUpdate.properties file has seven main properties. In addition to main properties, the file has six optional properties. The script comes with optional properties commented out. For more details on optional properties see Optional Properties.

The build.xml file has seven properties and four condition properties, and hopefully you will never need to change them; the environment property in the build.xml file is not used currently and is commented out.

## How to Use
NOTE:  the value of the downloadBuild.file property should be set to the name of the Eclipse build file. To avoid modifying the downloadBuild.file property after new Eclipse build is downloaded, you could rename the downloaded file to the name that is set as the downloadBuild.file property value; the name current.zip is used in the examples below. However, if you want to keep the name of the downloaded Eclipse build intact there is an experimental feature that uses the downloadBuild.dir property; see Optional Properties.

Below are the recommended steps; all directory names are specified in properties except for the eclipseHome directory that is created by the user.

Download installUpdate.zip file from http://shteynbuk.com/
Create a new directory named eclipseHome.
Unzip the installUpdate.zip file into eclipseHome directory. A directory named eclipseHome /installUpdate is created.
Start command prompt.
cd to eclipseHome /installUpdate directory; there should be the installUpdate.properties file, the build.xml file and eclipse startup files.
Open the installUpdate.properties file. Property names should be self-explanatory, and the file has usage instructions. You might need to change some property values.  For more details see Quick Start.
To install a new Eclipse build, say 2.1 M3, execute command: ant install-eclipse. A new directory current with the startup scripts is created. See NOTE.
To install plugins execute command: ant install-plugins. A new directory eclipseHome\extPlugins is created as a product extension and linked to the build installed in the p.7 above. All files with .zip extension in the directory (including subdirectories) specified by the property download.plugin.dir are extracted into the proper subdirectories of the eclipseHome\extPlugins directory; and the user don't have to examine any of the .zip files to decide how they should be extracted. It gives the user the ability to organize plugins in different subdirectories.
To update the 2.1 M3 build to 2.1 M4 build execute command: ant install-eclipse, see NOTE. The 2.1 M4 build is installed into the current directory and the 2.1 M3 build is moved into the was_current directory. All necessary links to the external plugin directory are created and the internal workspace is copied from the 2.1 M3 build. For the external workspace a backup is made. A marker file in the external plugin directory is updated.
To uninstall the 2.1 M4 build execute: ant uninstall-eclipse. The 2.1 M3 build is restored into the current directory and the was_current directory is removed.
To uninstall the 2.1 M3 build execute: ant uninstall-eclipse. The directory current is deleted.
To uninstall external plugins execute: ant uninstall-plugins. The directory extPlugins is deleted.
To backup the workspace execute:  ant backup-workspace.
To sync the eclipse.bat file with the changes in installUpdate.properties file execute ant generate-startup-script, for more details see Quick Start.
To recompile the checkdir Ant task - cd to the  eclipseHome /installUpdate/installUpdateAntUtil directory and execute ant, compile is the default target; other targets are - javadoc and clean.
To uninstall the previous Eclipse installation executes ant uninstall-old-version, the directory was_current is removed. If you do not want to keep the old installation, use optional property old.version, see Optional Properties.

## Directory Structure
This chapter should be read after How to Use chapter.

C:\eclipseHome\      - root for all installations.

C:\eclipseHome\installUpdate\      - unzipped download with this documentation

C:\eclipseHome\extPlugins\      - external plugins directory

C:\eclipseHome\extPlugins\eclipse\

C:\eclipseHome\extPlugins\eclipse\features

C:\eclipseHome\extPlugins\eclipse\plugins

C:\eclipseHome\current\      - current build install

C:\eclipseHome\current\eclipse\

C:\eclipseHome\was_current\      - previous  build  install

C:\eclipseHome\was_current\eclipse\

c:\eclipseHome\extWorkspace     - if you use external workspace

F:/javaDownloads/eclipse/current.zip     - downloaded current Eclipse build

F:/javaDownloads/eclipse/plugins/installed      - plugins downloads that you want to install

F:/tmp/eclipse          -  backup directory

The following rules are used to extract .zip files: if the plugin directory structure in .zip file starts with the eclipse directory then it is unzipped into the external plugin directory; if it starts with the plugins directory or the features directory then it is unzipped into the eclipse directory of the external plugin directory; otherwise it is treated as if it starts with a package name and is unzipped into the eclipse/plugins directory of the external plugin directory.

## What is the Right Way to Update?

### Introduction

The 2.1 M3 build was my first Eclipse installation, and when the 2.1 M4 build was released I tried to use the Update Manager, but without much success. My first impulse was to reinstall everything from scratch, but I did not want to loose my preferences, projects, and plugins.

### Preserving preferences, projects, and plugins

To preserve the existing installation a new directory was created, and a new build was installed into this new directory instead of overriding the existing installation. This new directory became the Eclipse installation directory and was renamed accordingly; and the existing installation directory was renamed into the previous installation that was kept as a backup in case builds were not backward compatible.

The workspace directory from the previous installation was copied into the new installation directory and that solved the preferences and projects issue. What was left were the plugins that did not come with the Eclipse installation and were installed separately. Handling of these plugins turned out to be more complicated than anticipated.

The solution was to install these plugins into a separate directory that was named the external plugin directory. There were several reasons for the external plugin directory: first, a compatibility issue between these extra plugins and a new Eclipse build; second, the ability to share the external plugin directory between different Eclipse installations and even between developers; and third, the external plugin directory made it much easier to experiment with a new plugin.

### External plugin directory

In order for this directory to be recognized by Eclipse it should be created as a Product Extension. How to create a Product Extension is described in Eclipse documentation but this description is not easy to interpret. The following paragraphs of this chapter contain information assembled from different sources related to Eclipse installation and describe how the script handles the external plugin directory.

First, the external plugin directory structure: it should have the .eclipseextension marker file and the eclipse subdirectory with the eclipse\features and the eclipse\plugins  subdirectories, see Directory Structure chapter.

Second, the Eclipse installation: it should have a link directory with a link file. The link file is a java.io.Properties format file, which defines the path to the external plugin directory. There are rules for the link file names in the docs; and if I understood them correctly you might need different link files for different plugins, but I followed swiki recommendations to use the name .link and it was sufficient; maybe different link files are needed when you have more than one external plugin directory, but I never had more than one.

Third, the external plugin directory should be linked to the Eclipse installation. It could be linked manually or using the Update Manager. To link using the Update Manager: in the Update Manager go to the "Feature Updates" view; navigate to the external plugin directory; and if a marker file is present, there will be an extension icon; right-click on it, on pop-up menu click Link Product Extension; after this you might need to restart Eclipse. To link manually, you probably don't need the link directory; but if you have the link directory you can get away without a marker file, but docs says that you need both. This script creates the external plugin directory as a product extension with a marker file and creates a link directory too.

Forth, when updating to a new build, you also need to update the marker file in the external plugin directory and create the eclipse start up scripts: eclipse.bat and eclipse.sh.

### Final thoughts

Unfortunately, different plugin writers use different directory structure conventions; for example, not all plugins have the plugins directory, no pun intended. If a plugin has the features directory then it has the plugins directory too. But if a plugin doesn't have the features directory it is still a good idea to have the plugins directory in .zip file even if it is obvious that the installation should go into the plugins directory, because it forces the user to examine a .zip file before each plugin installation. For above mentioned reasons, the install-plugins target is rather complicated.

It is probably a good idea to execute the backup-workspace target before experimenting with any new plugin. The workspace is also backed up by the uninstall-eclipse target. When installing Eclipse over an existing installation: the install-eclipse target backups the external workspace, the internal workspace is copied from the previous installation.

What drives me crazy is to remember all these small bookkeeping details and that was the main motivation behind writing this script. And this script can be used as an update manual by the users who prefer manual updates.

## Optional Properties

The installUpdate.properties file has five optional properties.  Three properties: home.workspace.dir, custom.javaw  and vm.args, are used to generate the startup scripts. When the home.workspace.dir  property is set, the external workspace is used. The custom.javaw property, as the name suggests, is needed to specify the jvm to launch eclipse with, and the vm.args property is used to pass arguments to the jvm.

If you change any of the optional properties after installation, you need to synchronize the startup scripts with these changes; as the startup scripts are generated by the install-eclipse target, see comments in the installUpdate.properties file. To do this you need to run the generate-startup-script target. The following rule is used in the startup scripts to select the jvm to start eclipse with: first the custom.javaw property is checked, if this property is not defined then the JAVA_HOME environment variable is used, and if this variable is not defined then the eclipse installation default jvm is used.

Two properties: the downloadBuild.dir and the old.version are not used in startup scripts. The  downloadBuild.dir property was introduced to specify the name of the directory where a suitable eclipse build could be found instead of specifying the build file name. This is an experimental feature that was requested by some users who did not like having the downloaded build file to be renamed and wanted to keep the original file name. However, the user has to be aware that there should be only one suitable build file in this directory. In order to enforce this rule, the checkdir Ant task was created; and if there is more than one suitable build file then the install-eclipse target will fail with the message: "check installUpdate.properties file". The downloadBuild.dir property will be used only if the downloadBuild.file property is not set, see comments in installUpdate.properties file. The old.version property is set if the user does not want to keep the previous installation; the user can also delete the previous installation manually by executing the target uninstall-old-version instead of using this option.

The script comes with optional properties commented out.

## Checkdir Ant Task

This Ant task sets a property if a suitable eclipse build is available in the download directory. Currently it checks that only one file with .zip extension exists in this directory. This task may also be used as a condition by the Ant condition task. This task is similar to Ant Available task.

### Parameters

Attribute
Description
Required
property
The name of the property to set.
Yes
value
The value to set the property to. Defaults to "true".
No
dir
directory to check
Yes
I was also experimenting with using regular expressions instead of hardcoded .zip extension; or using nested filesets or patternsets elements, but decided against these features. Regular expressions usually are not used to specify file names, and using filesets and patternsets looked like overkill. It was also not clear if there was enough interest in this task to justify all this complexity.

The Checkdir task is in the installUpdateAntUtil directory, and the build.xml file in this directory has three targets: compile, clean and javadoc; compile is the default target. Make sure that CheckDir.class is in the classpath. Having "." in the classpath is one way of doing it, because the script will most likely be executed from the eclipseHome /installUpdate directory.

## ToDo

A GUI front end could be added to the script with a file selection dialog.
The script probably could be changed to have the download of a new build and the update of the previous build to be in one target, then the user do not need to download the build manually and the property for the downloaded file is not needed either.
Question: should such functionality be part of the Update Manager or should it be a standalone program, sort of installation program that most windows programs have?

## Acknowledgments
This script started after the discussion thread on news://www.eclipse.org/eclipse.tools "how to upgrade", where main tips came from Christophe Elek and Marcus Malcom. Christophe Elek's post was actually a starting point for me.  For a short time that I have been on eclipse.tools newsgroup this question has popped up several times.  Different pieces of information also came from swiki , and Eclipse docs. To have it all in one place and simplify the update process was the main motivation for this exercise.

After the release of this script, I received valuable feedback from Shmuel Siegel, Sascha Freitag, Stephane Ruchet and Mike McGowan. The backup-workspace target and the external workspace handling are based on the code contributed by Sascha Freitag. Sascha also added the properties file to the script and the eclipse.bat file filtering using the properties file. The eclipse.bat is based on the code contributed by Stephane Ruchet. Stephane also requested the ability to install eclipse using a directory name instead of a file name and contributed the first draft of the code for an experimental feature, see Optional Properties.
