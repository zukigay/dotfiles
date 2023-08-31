if glxinfo -B | grep "NVIDIA GeForce"
then
	echo "nvidia"
	exec picom
else
	echo "non nvidia"
	exec picom --vsync
fi
