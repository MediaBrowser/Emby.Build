#!/bin/bash

if ! git status 2>&1 > /dev/null ; then
    echo "not on a git directory";
    exit 1;
fi

if ! git status -b -s | grep debian/ 2>&1 > /dev/null ; then
    echo "not on a debian branch";
    exit 1;
fi

DEB_UPSTREAM_MAJOR_VERSION=6
UPSTREAMBRANCH="ImageMagick-$DEB_UPSTREAM_MAJOR_VERSION"

DEHS_STATUS=`uscan --report --dehs`;
if echo $DEHS_STATUS | grep "<status>Newer version available</status>" > /dev/null ; then
    DOWNLOAD_NAME=`echo "$DEHS_STATUS" | grep "<upstream-url>" | sed "s/^<upstream-url>ftp\:\/\/\(.*\)<\/upstream-url>$/\1/g" | sed "s/.*\/\(.*\)/\1/g"`
    if test ! -f ../`echo $DOWNLOAD_NAME`; then
	echo "download new version"
	uscan  --download  --destdir .. --verbose || (echo "fail to download" && exit 77)
    fi;
else
    echo "download up to date"
fi;



DEB_UPSTREAM_VERSION=`echo "$DEHS_STATUS" | grep "<upstream-version>" | sed "s/<upstream-version>\(.*\)<\/upstream-version>/\1/g"`
DEB_UPSTREAM_VERSION_CHANGELOG=`echo $DEB_UPSTREAM_VERSION | sed "s/\(.*\)\(\.\)\([:digit:]*\)/\1-\3/g"`
DEB_VERSION=`dpkg-parsechangelog | egrep '^Version:' | cut -f 2 -d ' '`
DEB_NOEPOCH_VERSION=`echo $DEB_VERSION | cut -d: -f2-`
NEW_DEBIAN_VERSION=$DEB_UPSTREAM_VERSION-1

if git checkout "debian-patches/$NEW_DEBIAN_VERSION" 2>&1 > /dev/null; then
    echo "Debian version for $DEB_UPSTREAM VERSION already commited";
    exit 1;
fi


#retrieve recent svn commit
git svn fetch || exit 2
git checkout "origin/$UPSTREAMBRANCH" || exit 2
SVN_REV=`grep "New version $DEB_UPSTREAM_VERSION_CHANGELOG" ChangeLog | sed "s/.*SVN revision \([0-9]*\).*/\1/g"`
if test "z$SVN_REV" = "z"; then
    echo "Could not found revision";
    exit 3;
fi

echo "find git rev for svn r$SVN_REV:"
GIT_SVN_REV=`git svn find-rev r$SVN_REV`
echo "is $GIT_SVN_REV"
git checkout $GIT_SVN_REV || exit 5
# git revision for svn commit 
git checkout -b upstream/$DEB_UPSTREAM_VERSION
# remove all exept git
find ./*  -path './.git' -prune -o -exec rm -rf '{}' +
tar --strip 1 -xaf ../imagemagick_$DEB_UPSTREAM_VERSION.orig.tar.bz2 # extract origin
git add . #add everything
git commit -a -m "add upstream tar.bz2" # commit new upstream
pristine-tar commit ../imagemagick_$DEB_UPSTREAM_VERSION.orig.tar.bz2 upstream/$DEB_UPSTREAM_VERSION # pristine tar
git checkout debian/$DEB_NOEPOCH_VERSION # checkout old debian
git checkout -b  debian/$DEB_UPSTREAM_VERSION-1 # create new version
# emulate git their
git merge  --no-commit upstream/$DEB_UPSTREAM_VERSION # merge without commit
find ./* -path './debian' -prune -o -path './.git' -prune -o -exec rm -rf '{}' + # remove all except debian and git
tar --strip 1 -xaf ../imagemagick_$DEB_UPSTREAM_VERSION.orig.tar.bz2 # use upstream
git add .
git commit -a -m 'merge with upstream' # emulate git theirs but safer
git checkout upstream/$DEB_UPSTREAM_VERSION
git checkout -b debian-patches/$DEB_UPSTREAM_VERSION-1