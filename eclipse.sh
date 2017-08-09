#!/bin/bash

# fixed arguments bug, leftover from .bat conversion by  Oleg Shteynbuk (oleg_shteynbuk@yahoo.com) 22.12.2007
# converted from .bat to bash by Oleg Shteynbuk (oleg_shteynbuk@yahoo.com) 11.2007

# check if external workspace is used
workspace_dir="@home.workspace.dir@"

if [ "$workspace_dir" != "@""home.workspace.dir""@" ]
then
	echo "external workspace dir"
	WORKSPACE="-data ${workspace_dir}"
else
	echo "default workspace dir"
	WORKSPACE=""
fi

# set jvm
javaVM="@custom.javaw@"

if [ "$javaVM" != "@""custom.javaw""@"  ]
then
	echo "custom jvm"
	javaVM="-vm ${javaVM}"
else
	# check if JAVA_HOME exists
	if [ "$JAVA_HOME" != "" ]
	then
		echo "java home jvm"
		javaVM="-vm ${JAVA_HOME}/bin/"
	else
		echo "using default jvm"
		set javaVM=""
	fi
fi

# check if there are vm arguments
vmArgs="@vm.args@"

if [ "$vmArgs" != "@""vm.args""@" ]
then
	echo "vm arguments"
	vmArgs="-vmargs ${vmArgs}"
else
	echo "no vm arguments"
	vmArgs=""
fi

# launch eclipse
echo "launch arguments:"
echo $javaVM
echo ${WORKSPACE}
echo $vmArgs

./eclipse ${javaVM} ${WORKSPACE} ${vmArgs}
# eclipse ${javaVM} ${WORKSPACE} ${vmArgs}
