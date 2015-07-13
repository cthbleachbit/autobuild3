export SRCDIR="$PWD"
export PKGDIR="$PWD/abdist"

# Autobuild settings
recsr $AB/etc/autobuild/defaults/*

abrequire arch

arch_loaddef || abdie "arch_loaddef returned a non-zero value: $?." 

if bool "$32SUBSYSBUILD" || [[ "$PKGNAME" == *+32 && ARCH == amd64 ]]
then
	abinfo "Detected 32subsys build."
	CROSS=i386
fi

arch_initcross
# PKGREL Parameter, pkg and rpm friendly
# Test used for those who wants to override.
# TODO foreport verlint
# TODO verlint backwriting when ((!PROGDEFINE)).
# TODO automate $PKG* namespace and remove abbs `spec`
if [ ! "$PKGREL" ]; then
	PKGVER=$(echo $PKGVER| rev | cut -d - -f 2- | rev)
	PKGREL=$(echo $PKGVER | rev | cut -d - -f 1 | rev)
	if [ "$PKGREL" == "$PKGVER" ] || [ ! "$PKGREL" ]; then PKGREL=0; fi;
fi

# Programmable modules should be put here.
arch_loadfile functions

# TODO validate variable existance
for i in `cat $AB/params/*`; do
	export $i
done

export PYTHON=/usr/bin/python2

