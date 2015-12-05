%global VERSION  6.9.2
%global Patchlevel  8

Name:           embymagick
Version:        %{VERSION}
Release:        %{Patchlevel}
Summary:        Use ImageMagick to convert, edit, or compose bitmap images in a variety of formats.  In addition resize, rotate, shear, distort and transform images.
Group:          Applications/Multimedia
License:        http://www.imagemagick.org/script/license.php
Url:            http://www.imagemagick.org/
Source0:        embymagick_%{VERSION}.orig.tar.gz
#BuildRoot:      %{_tmppath}/imagemagick-%{version}-root-%(%{__id_u} -n)
%if 0%{?suse_version} >= 1315
BuildRequires: libbz2-devel, libjasper-devel, liblcms2-devel
%else
BuildRequires: bzip2-devel, jasper-devel, lcms2-devel
%endif
BuildRequires:  freetype-devel, libjpeg-devel, libpng-devel
BuildRequires:  libtiff-devel, giflib-devel, zlib-devel
BuildRequires:  ghostscript-devel
BuildRequires:  libwmf-devel, libtool-ltdl-devel
BuildRequires:  libXext-devel, libXt-devel
BuildRequires:  libxml2-devel, librsvg2-devel
BuildRequires:  fftw-devel, libwebp-devel

%description
ImageMagick is a software suite to create, edit, and compose bitmap images. It
can read, convert and write images in a variety of formats (about 100)
including DPX, GIF, JPEG, JPEG-2000, PDF, PhotoCD, PNG, Postscript, SVG,
and TIFF. Use ImageMagick to translate, flip, mirror, rotate, scale, shear
and transform images, adjust image colors, apply various special effects,
or draw text, lines, polygons, ellipses and Bézier curves.

The functionality of ImageMagick is typically utilized from the command line
or you can use the features from programs written in your favorite programming
language. Choose from these interfaces: G2F (Ada), MagickCore (C), MagickWand
(C), ChMagick (Ch), Magick++ (C++), JMagick (Java), L-Magick (Lisp), nMagick
(Neko/haXe), PascalMagick (Pascal), PerlMagick (Perl), MagickWand for PHP
(PHP), PythonMagick (Python), RMagick (Ruby), or TclMagick (Tcl/TK). With a
language interface, use ImageMagick to modify or create images automagically
and dynamically.

ImageMagick is free software delivered as a ready-to-run binary distribution
or as source code that you may freely use, copy, modify, and distribute in
both open and proprietary applications. It is distributed under an Apache
2.0-style license, approved by the OSI.

The ImageMagick development process ensures a stable API and ABI. Before
each ImageMagick release, we perform a comprehensive security assessment that
includes memory and thread error detection to help prevent exploits.ImageMagick
is free software delivered as a ready-to-run binary distribution or as source
code that you may freely use, copy, modify, and distribute in both open and
proprietary applications. It is distributed under an Apache 2.0-style license,
approved by the OSI.


%package libembymagickcore-6.q8-2
Summary: ImageMagick libraries to link with
Group: Applications/Multimedia

%description libembymagickcore-6.q8-2
The MagickCore API is a low-level interface between the C programming language
and the ImageMagick image processing libraries and is recommended for
wizard-level programmers only. Unlike the MagickWand C API which uses only a
few opaque types and accessors, with MagickCore you almost exclusively access
the structure members directly.
This package contains the C libraries needed to run executables that make
use of MagickCore.
This version of libmagickcore is compiled for quantum depth of 8 bits
and specifically for the emby project.

%package libembymagickwand-6.q8-2
Summary: ImageMagick libraries to link with
Group: Applications/Multimedia
Requires: libembymagickcore-6.q8-2

%description libembymagickwand-6.q8-2
The MagickWand API is the recommended interface between the C programming language
and the ImageMagick image processing libraries. Unlike the MagickCore C API,
MagickWand uses only a few opaque types. Accessors are available to set or get
important wand properties.
This package contains the C libraries needed to run executables that make use of
MagickWand.
This version of libmagickwand is compiled for quantum depth of 8 bits and
specifically for the emby project.


%prep
#%setup -q -n imagemagick-%{VERSION}
%setup -q
sed -i 's/libltdl.la/libltdl.so/g' configure
#iconv -f ISO-8859-1 -t UTF-8 README.txt > README.txt.tmp
#touch -r README.txt README.txt.tmp
#mv README.txt.tmp README.txt


%build
%configure --prefix=/usr \
	--libdir=/usr/lib64 \
	--sysconfdir=/etc \
	--with-includearch-dir=/usr/include \
	--with-modules \
	--with-gs-font-dir=/usr/share/fonts/type1/gsfonts \
	--with-djvu=no \
	--without-wmf \
	--without-gvc \
	--enable-shared \
	--without-dps \
	--without-fpx \
	--with-rsvg=no \
	--with-tiff=yes \
	--with-webp=yes \
	--with-jpeg=yes \
	--with-png=yes \
	--with-xml=yes \
	--with-x=no \
	--enable-hdri=no \
	--with-magick-plus-plus=no \
	--with-gslib=no \
    --without-perl \
	--disable-openmp \
	--with-fontconfig=yes \
	--with-gvc=no \
	--with-openexr=no \
    --disable-silent-rules \
	--with-quantum-depth=8 \
    --without-gcc-arch

# Disable rpath
#sed -i 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' libtool
#sed -i 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' libtool
# Do *NOT* use %%{?_smp_mflags}, this causes PerlMagick to be silently misbuild
make


%install
rm -rf %{buildroot}

make %{?_smp_mflags} install DESTDIR=%{buildroot} INSTALL="install -p"
cp -a www/source %{buildroot}%{_datadir}/doc/%{name}-%{VERSION}
rm %{buildroot}%{_libdir}/*.la
echo "********************_____________________******************________________**************"
ls -lR %{_builddir}


%check
export LD_LIBRARY_PATH=%{buildroot}/%{_libdir}
make %{?_smp_mflags} check

%clean
rm -rf %{builddir}

%post libembymagickcore-6.q8-2 -p /sbin/ldconfig

%post libembymagickwand-6.q8-2 -p /sbin/ldconfig

%postun libembymagickcore-6.q8-2 -p /sbin/ldconfig

%postun libembymagickwand-6.q8-2 -p /sbin/ldconfig



%files
#%doc README.txt LICENSE NOTICE AUTHORS.txt NEWS.txt ChangeLog Platforms.txt
%{_bindir}/Magick*
%{_bindir}/Wand*
##
%{_bindir}/*
###
%{_includedir}/ImageMagick-6
%{_mandir}/man1/ImageMagick.*
##
%{_mandir}/man1/*
###
%{_libdir}/ImageMagick-%{VERSION}
%{_libdir}/pkgconfig/*.pc
##
%{_libdir}/*
###
%{_datadir}/ImageMagick-6
%{_docdir}/ImageMagick*
##
%{_docdir}/embymagick-6.9.2/*
###
%{_sysconfdir}/ImageMagick-6

%files libembymagickcore-6.q8-2
%defattr(-,root,root,-)
%{_libdir}/ImageMagick-*/config-*/*
%{_libdir}/ImageMagick-*/modules-*/coders/*.la
%{_libdir}/ImageMagick-*/modules-*/coders/*.so
%{_libdir}/ImageMagick-*/modules-*/filters/*.la
%{_libdir}/ImageMagick-*/modules-*/filters/*.so
%{_libdir}/libMagickCore*.so*


%files libembymagickwand-6.q8-2
%defattr(-,root,root,-)
%{_libdir}/libMagickWand*.so*


%changelog
