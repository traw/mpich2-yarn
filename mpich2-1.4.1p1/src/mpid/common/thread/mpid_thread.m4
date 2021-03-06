if test "$MPICH_THREAD_LEVEL" = "MPI_THREAD_SINGLE" -o "$MPICH_THREAD_LEVEL" = "MPI_THREAD_FUNNELED" ; then
    MPID_THREAD_TYPEDEFS="/dev/null"
    MPID_THREAD_FUNCS="/dev/null"
    MPI_THREAD_SOURCE_FILES=""
    MPI_THREAD_OUTPUT_FILES=""
else
    MPID_THREAD_IMPL_SRCDIR="${MPID_THREAD_IMPL_SRCDIR:-$srcdir/$MPID_THREAD_SRCDIR}"
    MPID_THREAD_IMPL_PACKAGE="${MPID_THREAD_IMPL_PACKAGE:-mpe}"

    dnl
    dnl Have configure add typedefs and routine macro defintitions to mpid_thread.h
    dnl
    MPID_THREAD_TYPEDEFS="$MPID_THREAD_IMPL_SRCDIR/${MPID_THREAD_IMPL_PACKAGE}_types.i"
    MPID_THREAD_FUNCS="$MPID_THREAD_IMPL_SRCDIR/${MPID_THREAD_IMPL_PACKAGE}_funcs.i"

    dnl
    dnl List of files to copy into the source directory (format is dest:source ...)
    dnl
    MPID_THREAD_SOURCE_FILES="mpid_thread.c:$MPID_THREAD_IMPL_SRCDIR/mpid_thread_${MPID_THREAD_IMPL_PACKAGE}.c"

    dnl
    dnl List of files to remove when "make distclean" is run
    dnl
    MPID_THREAD_DISTCLEAN_FILES="include/mpid_thread.h src/mpid_thread.c"

    dnl
    dnl List of files to be generated by configure
    dnl    
    MPID_THREAD_OUTPUT_FILES="include/mpid_thread.h:$MPID_THREAD_SRCDIR/mpid_thread.h.in"
fi

dnl
dnl Substitutions to be performed by config.status
dnl
AC_SUBST(MPID_THREAD_SOURCES)
AC_SUBST(MPID_THREAD_DISTCLEAN)
AC_SUBST_FILE(MPID_THREAD_TYPEDEFS)
AC_SUBST_FILE(MPID_THREAD_FUNCS)

dnl
dnl Generate list of source files to be built by the device
dnl
for entry in $MPID_THREAD_SOURCE_FILES ; do
    destfile=`echo $entry | sed -e 's/:.*$//'`
    MPID_THREAD_SOURCES="$MPID_THREAD_SOURCES $destfile"
done

dnl
dnl Cause source files into the device's source directory when config.status is run
dnl
AC_OUTPUT_COMMANDS([
    for entry in $MPID_THREAD_SOURCE_FILES ; do
        destfile="src/`echo $entry | sed -e 's/:.*$//'`"
        srcfile="`echo $entry | sed -e 's/^.*://'`"
	echo "copying $srcfile to $destfile"
        rm -f $destfile
        cat >$destfile <<END
/*
 * WARNING: DO NOT EDIT!  This file is a copy of $srcfile.
 */

END
        cat $srcfile >>$destfile
        chmod 444 $destfile
    done
],[
    MPID_THREAD_SOURCE_FILES=$MPID_THREAD_SOURCE_FILES
])
